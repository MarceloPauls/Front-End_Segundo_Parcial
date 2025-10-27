import 'package:flutter/material.dart';
import '../models/entrega.dart';
import 'reserva_service.dart';
import 'vehiculo_service.dart';

class EntregaService extends ChangeNotifier {
  
  final List<Entrega> _entregas = [];

  List<Entrega> get entregas => _entregas;

  void agregarEntrega({
    required Entrega entrega,
    required ReservaService reservaService,
    required VehiculoService vehiculoService,
  }) {
    _entregas.add(entrega);

    // Buscar la reserva original para saber qué vehículo liberar
    final reservaOriginal = reservaService.getReservaPorId(entrega.idReserva);

    if (reservaOriginal != null) {
      // Marcar vehiculo como disponible
      vehiculoService.setDisponibilidad(reservaOriginal.idVehiculo, true); // true = Disponible

      // Quitar la reserva de la lista de "activas"
      reservaService.completarReserva(entrega.idReserva);
    }
    
    notifyListeners();
  }
}