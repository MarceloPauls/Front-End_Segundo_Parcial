import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/vehiculo.dart';
import '../services/vehiculo_service.dart';

class VehiculoFormScreen extends StatefulWidget {
  // El formulario recibe un vehículo.
  // Si es 'null', estamos creando uno nuevo.
  // Si no es 'null', estamos editando uno existente.
  final Vehiculo? vehiculo;

  const VehiculoFormScreen({super.key, required this.vehiculo});

  @override
  State<VehiculoFormScreen> createState() => _VehiculoFormScreenState();
}

class _VehiculoFormScreenState extends State<VehiculoFormScreen> {
  // Clave para validar el formulario
  final _formKey = GlobalKey<FormState>();

  // Controladores para los campos de texto
  late TextEditingController _marcaController;
  late TextEditingController _modeloController;
  late TextEditingController _anioController;

  // Variable para el Dropdown
  String _disponible = 'Sí';

  bool _esModoEdicion = false;

  @override
  void initState() {
    super.initState();

    _esModoEdicion = widget.vehiculo != null;

    // Inicializamos los controladores
    _marcaController = TextEditingController(text: _esModoEdicion ? widget.vehiculo!.marca : '');
    _modeloController = TextEditingController(text: _esModoEdicion ? widget.vehiculo!.modelo : '');
    _anioController = TextEditingController(text: _esModoEdicion ? widget.vehiculo!.anio.toString() : '');
    
    if (_esModoEdicion) {
      _disponible = widget.vehiculo!.disponible;
    }
  }

  @override
  void dispose() {
    // Limpiamos los controladores
    _marcaController.dispose();
    _modeloController.dispose();
    _anioController.dispose();
    super.dispose();
  }

  void _guardarFormulario() {
    // Validamos el formulario
    if (_formKey.currentState!.validate()) {
      // Usamos context.read para *llamar* al servicio
      final vehiculoService = context.read<VehiculoService>();

      // Creamos el objeto Vehiculo con los datos
      final vehiculo = Vehiculo(
        // Si editamos, usamos el ID existente. Si es nuevo, creamos un ID único (simple).
        idVehiculo: _esModoEdicion ? widget.vehiculo!.idVehiculo : DateTime.now().millisecondsSinceEpoch.toString(),
        marca: _marcaController.text,
        modelo: _modeloController.text,
        anio: int.tryParse(_anioController.text) ?? 2000,
        disponible: _disponible,
      );

      if (_esModoEdicion) {
        vehiculoService.modificarVehiculo(vehiculo);
      } else {
        vehiculoService.agregarVehiculo(vehiculo);
      }

      // Regresamos a la pantalla anterior (la lista)
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_esModoEdicion ? 'Editar Vehículo' : 'Nuevo Vehículo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView( // Para evitar overflow si el teclado aparece
            child: Column(
              children: [
                // --- CAMPO MARCA ---
                TextFormField(
                  controller: _marcaController,
                  decoration: const InputDecoration(labelText: 'Marca'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese una marca';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // --- CAMPO MODELO ---
                TextFormField(
                  controller: _modeloController,
                  decoration: const InputDecoration(labelText: 'Modelo'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese un modelo';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // --- CAMPO AÑO ---
                TextFormField(
                  controller: _anioController,
                  decoration: const InputDecoration(labelText: 'Año'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese un año';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Por favor, ingrese un número válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // --- CAMPO DISPONIBLE ---
                DropdownButtonFormField<String>(
                  value: _disponible,
                  decoration: const InputDecoration(labelText: 'Disponible'),
                  items: ['Sí', 'No'].map((String valor) {
                    return DropdownMenuItem<String>(
                      value: valor,
                      child: Text(valor),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _disponible = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 32),

                // --- BOTÓN GUARDAR ---
                ElevatedButton(
                  onPressed: _guardarFormulario,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50), // Botón grande
                  ),
                  child: const Text('Guardar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}