import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cliente.dart';
import '../services/cliente_service.dart';

class ClienteFormScreen extends StatefulWidget {
  // Si 'cliente' es null, creamos. Si no, editamos.
  final Cliente? cliente;

  const ClienteFormScreen({super.key, required this.cliente});

  @override
  State<ClienteFormScreen> createState() => _ClienteFormScreenState();
}

class _ClienteFormScreenState extends State<ClienteFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores para los campos
  late TextEditingController _nombreController;
  late TextEditingController _apellidoController;
  late TextEditingController _documentoController;

  bool _esModoEdicion = false;

  @override
  void initState() {
    super.initState();

    _esModoEdicion = widget.cliente != null;

    // Inicializamos los controladores con los datos del cliente (si existe)
    _nombreController = TextEditingController(text: _esModoEdicion ? widget.cliente!.nombre : '');
    _apellidoController = TextEditingController(text: _esModoEdicion ? widget.cliente!.apellido : '');
    _documentoController = TextEditingController(text: _esModoEdicion ? widget.cliente!.documento : '');
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _documentoController.dispose();
    super.dispose();
  }

  void _guardarFormulario() {
    if (_formKey.currentState!.validate()) {
      final clienteService = context.read<ClienteService>();

      final cliente = Cliente(
        // Usamos ID existente o creamos uno nuevo
        idCliente: _esModoEdicion ? widget.cliente!.idCliente : DateTime.now().millisecondsSinceEpoch.toString(),
        nombre: _nombreController.text, 
        apellido: _apellidoController.text, 
        documento: _documentoController.text,
      );

      if (_esModoEdicion) {
        clienteService.modificarCliente(cliente); 
      } else {
        clienteService.agregarCliente(cliente);
      }

      Navigator.of(context).pop(); // Volver a la lista
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_esModoEdicion ? 'Editar Cliente' : 'Nuevo Cliente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // --- CAMPO NOMBRE ---
                TextFormField(
                  controller: _nombreController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese un nombre';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // --- CAMPO APELLIDO ---
                TextFormField(
                  controller: _apellidoController,
                  decoration: const InputDecoration(labelText: 'Apellido'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese un apellido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // --- CAMPO DOCUMENTO ---
                TextFormField(
                  controller: _documentoController,
                  decoration: const InputDecoration(labelText: 'Nº de Documento o Identificación'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese un documento';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // --- BOTÓN GUARDAR ---
                ElevatedButton(
                  onPressed: _guardarFormulario,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
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