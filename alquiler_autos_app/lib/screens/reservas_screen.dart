import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../services/reserva_service.dart';
import '../services/cliente_service.dart';
import '../services/vehiculo_service.dart';

class ReservasScreen extends StatelessWidget {
  const ReservasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Leemos los 3 servicios para cruzar la información
    final reservaService = context.watch<ReservaService>();
    final clienteService = context.watch<ClienteService>();
    final vehiculoService = context.watch<VehiculoService>();
    
    final reservasActivas = reservaService.reservas;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservas Activas'),
      ),
      body: reservasActivas.isEmpty
          ? const Center(
              child: Text(
                'No hay reservas activas en este momento.',
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
            )
          : ListView.builder(
              itemCount: reservasActivas.length,
              itemBuilder: (context, index) {
                final reserva = reservasActivas[index];

                // Buscamos los nombres usando los IDs
                final cliente = clienteService.getClientePorId(reserva.idCliente);
                final vehiculo = vehiculoService.getVehiculoPorId(reserva.idVehiculo);
                
                // Formateamos las fechas
                final fInicio = DateFormat('dd/MM/yyyy').format(reserva.fechaInicio);
                final fFin = DateFormat('dd/MM/yyyy').format(reserva.fechaFin);

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.book_online, color: Colors.blueAccent, size: 40),
                    title: Text(
                      // Mostramos el nombre del cliente o un 'No encontrado'
                      'Cliente: ${cliente?.nombre ?? 'No encontrado'} ${cliente?.apellido ?? ''}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          // Mostramos los datos del vehículo
                          'Vehículo: ${vehiculo?.marca ?? 'No encontrado'} ${vehiculo?.modelo ?? ''}',
                        ),
                        Text('Desde: $fInicio - Hasta: $fFin'),
                        Text('ID Reserva: ${reserva.idReserva}', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                      ],
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
    );
  }
}