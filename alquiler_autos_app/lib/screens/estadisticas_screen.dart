import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cliente.dart';
import '../services/reserva_service.dart';
import '../services/vehiculo_service.dart';
import '../services/cliente_service.dart';

class EstadisticasScreen extends StatelessWidget {
  const EstadisticasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // OBTENER TODOS LOS SERVICIOS NECESARIOS
    // context.watch para que los números se actualicen en tiempo real
    final reservaService = context.watch<ReservaService>();
    final vehiculoService = context.watch<VehiculoService>();
    final clienteService = context.watch<ClienteService>();

    // CALCULAR LAS ESTADÍSTICAS
    final int totalReservas = reservaService.totalReservasActivas;

    final int totalVehiculosDisponibles = vehiculoService.totalVehiculosDisponibles;


    final Cliente? clienteEstrella = clienteService.getClienteConMasReservas(reservaService); 
    // Texto para el cliente estrella (manejando el caso de que sea nulo)
    final String nombreClienteEstrella = clienteEstrella == null
        ? 'N/A (Sin reservas)'
        : '${clienteEstrella.nombre} ${clienteEstrella.apellido}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Estadísticas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Tarjeta para Reservas Activas ---
            _buildStatCard(
              context: context,
              icon: Icons.book_online,
              color: Colors.blue,
              titulo: 'Total de Reservas Activas',
              valor: totalReservas.toString(),
            ),
            const SizedBox(height: 16),

            // --- Tarjeta for Vehículos Disponibles ---
            _buildStatCard(
              context: context,
              icon: Icons.directions_car_filled,
              color: Colors.green,
              titulo: 'Vehículos Disponibles',
              valor: totalVehiculosDisponibles.toString(),
            ),
            const SizedBox(height: 16),
            
            // --- Tarjeta para Cliente con más Reservas ---
            _buildStatCard(
              context: context,
              icon: Icons.star,
              color: Colors.amber,
              titulo: 'Cliente con Más Reservas',
              valor: nombreClienteEstrella,
              esValorTexto: true, 
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET REUTILIZABLE (Componente) ---
  // Creamos un widget personalizado para mostrar cada estadística
  Widget _buildStatCard({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required String titulo,
    required String valor,
    bool esValorTexto = false,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          children: [
            Icon(icon, size: 50, color: color),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    valor,
                    style: esValorTexto
                        ? Theme.of(context).textTheme.headlineSmall
                        : Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}