import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../models/entrega.dart';
import '../models/reserva.dart';
import '../services/entrega_service.dart';
import '../services/reserva_service.dart';
import '../services/vehiculo_service.dart';
import '../services/cliente_service.dart';

class EntregasScreen extends StatefulWidget {
  const EntregasScreen({super.key});

  @override
  State<EntregasScreen> createState() => _EntregasScreenState();
}

class _EntregasScreenState extends State<EntregasScreen> {
  final _formKey = GlobalKey<FormState>();

  // Variables para el formulario
  Reserva? _selectedReserva;
  DateTime? _fechaEntrega;
  final TextEditingController _fechaEntregaController = TextEditingController();
  final TextEditingController _observacionesController = TextEditingController();

  @override
  void dispose() {
    _fechaEntregaController.dispose();
    _observacionesController.dispose();
    super.dispose();
  }

  // --- Lógica para mostrar el DatePicker ---
  Future<void> _selectFecha(BuildContext context) async {
    // Validar que se haya seleccionado una reserva primero
    if (_selectedReserva == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, seleccione una reserva primero.'),
          backgroundColor: Colors.orangeAccent,
        ),
      );
      return; // No abrir el calendario si no hay reserva
    }

    // Usar la fecha de inicio de la reserva como la primera fecha permitida
    final DateTime primeraFechaPermitida = _selectedReserva!.fechaInicio;

    final DateTime? picked = await showDatePicker(
      context: context,
      // Iniciar el calendario en la fecha de inicio de la reserva
      initialDate: primeraFechaPermitida.isAfter(DateTime.now())
          ? primeraFechaPermitida
          : DateTime.now(),
      firstDate: primeraFechaPermitida, 
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        _fechaEntrega = picked;
        _fechaEntregaController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  // --- Lógica para guardar la entrega ---
  void _guardarEntrega() {
    if (_formKey.currentState!.validate() &&
        _selectedReserva != null &&
        _fechaEntrega != null) {
      
      // Obtener los servicios (con context.read)
      final entregaService = context.read<EntregaService>();
      final reservaService = context.read<ReservaService>();
      final vehiculoService = context.read<VehiculoService>();

      // Crear el objeto Entrega
      final nuevaEntrega = Entrega(
        idReserva: _selectedReserva!.idReserva,
        fechaEntregaReal: _fechaEntrega!,
        observaciones: _observacionesController.text.isEmpty
            ? null
            : _observacionesController.text,
      );

      // Llamar al servicio para agregar la entrega
      entregaService.agregarEntrega(
        entrega: nuevaEntrega,
        reservaService: reservaService,
        vehiculoService: vehiculoService,
      );

      // Mostrar confirmación y volver
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Entrega registrada con éxito! Vehículo liberado.'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop();

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, seleccione una reserva y una fecha.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Leemos los servicios para el Dropdown
    final reservaService = context.watch<ReservaService>();
    final clienteService = context.watch<ClienteService>();
    final vehiculoService = context.watch<VehiculoService>();

    final reservasActivas = reservaService.reservas;
    final bool isSelectedReservaValid = _selectedReserva != null &&
              reservasActivas.any((r) => r.idReserva == _selectedReserva!.idReserva);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Entrega'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // --- Dropdown de Reservas Activas ---
                DropdownButtonFormField<Reserva>(
                  value: isSelectedReservaValid ? _selectedReserva : null,
                  decoration: const InputDecoration(labelText: 'Reserva Activa'),
                  hint: const Text('Seleccione una reserva a finalizar'),
                  // Si no hay reservas, el dropdown estará deshabilitado
                  items: reservasActivas.isEmpty
                      ? []
                      : reservasActivas.map((Reserva reserva) {
                          // Buscamos los nombres para que el dropdown sea legible
                          final cliente = clienteService.getClientePorId(reserva.idCliente);
                          final vehiculo = vehiculoService.getVehiculoPorId(reserva.idVehiculo);

                          // Creamos cadenas de texto más descriptivas
                          final String textoCliente = '${cliente?.nombre ?? ''} ${cliente?.apellido ?? ''}';
                          final String textoVehiculo = '${vehiculo?.marca ?? ''} ${vehiculo?.modelo ?? ''}';

                          return DropdownMenuItem<Reserva>(
                            value: reserva,
                            child: Text(
                              '$textoCliente - ($textoVehiculo)', // Formato: "Nombre Apellido - (Marca Modelo)"
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                  onChanged: (Reserva? newValue) {
                    setState(() {
                      _selectedReserva = newValue;
                    });
                  },
                  validator: (value) => value == null ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 16),

                // --- Campo Fecha Entrega Real ---
                TextFormField(
                  controller: _fechaEntregaController,
                  decoration: const InputDecoration(
                    labelText: 'Fecha de Entrega Real',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  enabled: _selectedReserva != null, // Deshabilitado si no hay reserva
                  onTap: () => _selectFecha(context),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 16),

                // --- Campo Opcional: Observaciones ---
                TextFormField(
                  controller: _observacionesController,
                  decoration: const InputDecoration(
                    labelText: 'Observaciones (Opcional)',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 32),

                // --- Botón Guardar ---
                ElevatedButton(
                  onPressed: _guardarEntrega,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Finalizar Alquiler'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}