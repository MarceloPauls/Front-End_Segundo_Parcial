import 'package:flutter/material.dart';
import '../models/reserva.dart';
import 'vehiculo_service.dart';

class ReservaService extends ChangeNotifier {
  
  // Esta lista representa las "reservas activas"
  final List<Reserva> _reservas = [];

  List<Reserva> get reservas => _reservas;

  int get totalReservasActivas => _reservas.length;

  Reserva? getReservaPorId(String idReserva) {
    try {
      return _reservas.firstWhere((r) => r.idReserva == idReserva);
    } catch (e) {
      return null;
    }
  }

  void agregarReserva(Reserva reserva, VehiculoService vehiculoService) {
    _reservas.add(reserva);
    
    vehiculoService.setDisponibilidad(reserva.idVehiculo, false); // false = No disponible

    notifyListeners();
  }

  // Cuando se completa una entrega, eliminamos la reserva de la lista de activas
  void completarReserva(String idReserva) {
     _reservas.removeWhere((r) => r.idReserva == idReserva);
     notifyListeners();
  }
}