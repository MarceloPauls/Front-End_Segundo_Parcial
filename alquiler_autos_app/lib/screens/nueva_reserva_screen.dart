import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../models/reserva.dart';
import '../models/cliente.dart';
import '../models/vehiculo.dart';
import '../services/cliente_service.dart';
import '../services/vehiculo_service.dart';
import '../services/reserva_service.dart';

class NuevaReservaScreen extends StatefulWidget {
  const NuevaReservaScreen({super.key});

  @override
  State<NuevaReservaScreen> createState() => _NuevaReservaScreenState();
}

class _NuevaReservaScreenState extends State<NuevaReservaScreen> {
  final _formKey = GlobalKey<FormState>();

  // Variables para guardar la selección del formulario
  Cliente? _selectedCliente;
  Vehiculo? _selectedVehiculo;
  DateTime? _fechaInicio;
  DateTime? _fechaFin;

  // Controladores para los campos de fecha
  final TextEditingController _fechaInicioController = TextEditingController();
  final TextEditingController _fechaFinController = TextEditingController();

  @override
  void dispose() {
    _fechaInicioController.dispose();
    _fechaFinController.dispose();
    super.dispose();
  }

  // --- Lógica para mostrar el DatePicker ---
  Future<void> _selectFecha(BuildContext context, bool esFechaInicio) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), // No se pueden reservar fechas pasadas
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        final formattedDate = DateFormat('dd/MM/yyyy').format(picked);
        if (esFechaInicio) {
          _fechaInicio = picked;
          _fechaInicioController.text = formattedDate;
        } else {
          _fechaFin = picked;
          _fechaFinController.text = formattedDate;
        }
      });
    }
  }

  // --- Lógica para guardar la reserva ---
  void _guardarReserva() {
    // Validar que todo esté seleccionado
    if (_formKey.currentState!.validate() &&
        _selectedCliente != null &&
        _selectedVehiculo != null && 
        _fechaInicio != null &&
        _fechaFin != null) {
      
      // Validar que fecha fin sea después de fecha inicio
      if (_fechaFin!.isBefore(_fechaInicio!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error: La fecha de fin no puede ser anterior a la fecha de inicio.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Obtener los servicios (con context.read) 
      final reservaService = context.read<ReservaService>();
      final vehiculoService = context.read<VehiculoService>();

      // Crear el objeto Reserva
      final nuevaReserva = Reserva(
        idReserva: DateTime.now().millisecondsSinceEpoch.toString(), // ID simple
        idCliente: _selectedCliente!.idCliente,
        idVehiculo: _selectedVehiculo!.idVehiculo,
        fechaInicio: _fechaInicio!,
        fechaFin: _fechaFin!,
      );

      // Llamar al método del servicio
      reservaService.agregarReserva(nuevaReserva, vehiculoService);

      // Mostrar confirmación y volver
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Reserva registrada con éxito!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop();

    } else {
      // Mostrar error si falta algo
      ScaffoldMessenger.of(context).showSnackBar( 
        const SnackBar(
          content: Text('Por favor, complete todos los campos.'),
          backgroundColor: Colors.red, 
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Obtenemos los servicios para llenar los Dropdowns
    final clienteService = context.watch<ClienteService>();
    final vehiculoService = context.watch<VehiculoService>();

    // REQUISITO: Solo mostrar vehículos disponibles 
    final vehiculosDisponibles = vehiculoService.vehiculos
        .where((v) => v.disponible == 'Sí')
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Nueva Reserva'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // --- Dropdown de Clientes ---
                DropdownButtonFormField<Cliente>(
                  value: _selectedCliente,
                  decoration: const InputDecoration(labelText: 'Cliente'),
                  hint: const Text('Seleccione un cliente'),
                  items: clienteService.clientes.map((Cliente cliente) {
                    return DropdownMenuItem<Cliente>(
                      value: cliente,
                      child: Text('${cliente.nombre} ${cliente.apellido}'),
                    );
                  }).toList(),
                  onChanged: (Cliente? newValue) {
                    setState(() {
                      _selectedCliente = newValue;
                    });
                  },
                  validator: (value) => value == null ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 16),

                // --- Dropdown de Vehículos (SOLO DISPONIBLES) ---
                DropdownButtonFormField<Vehiculo>(
                  value: _selectedVehiculo,
                  decoration: const InputDecoration(labelText: 'Vehículo'),
                  hint: const Text('Seleccione un vehículo disponible'),
                  items: vehiculosDisponibles.map((Vehiculo vehiculo) {
                    return DropdownMenuItem<Vehiculo>(
                      value: vehiculo,
                      child: Text('${vehiculo.marca} ${vehiculo.modelo} (${vehiculo.anio})'),
                    );
                  }).toList(),
                  onChanged: (Vehiculo? newValue) {
                    setState(() {
                      _selectedVehiculo = newValue;
                    });
                  },
                  validator: (value) => value == null ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 16),

                // --- Campo Fecha Inicio ---
                TextFormField(
                  controller: _fechaInicioController,
                  decoration: const InputDecoration(
                    labelText: 'Fecha de Inicio',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true, // Evita que el usuario escriba
                  onTap: () => _selectFecha(context, true), // Muestra el picker
                  validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 16),

                // --- Campo Fecha Fin ---
                TextFormField(
                  controller: _fechaFinController,
                  decoration: const InputDecoration(
                    labelText: 'Fecha de Fin',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () => _selectFecha(context, false),
                  validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 32),

                // --- Botón Guardar ---
                ElevatedButton(
                  onPressed: _guardarReserva,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Confirmar Reserva'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}