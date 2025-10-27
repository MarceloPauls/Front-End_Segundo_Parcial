import 'package:flutter/material.dart';
import '../models/vehiculo.dart';

class VehiculoService extends ChangeNotifier {
  // Lista en memoria 
  final List<Vehiculo> _vehiculos = [
    Vehiculo(idVehiculo: 'v1', marca: 'Toyota', modelo: 'Corolla', anio: 2022, disponible: 'Sí'),
    Vehiculo(idVehiculo: 'v2', marca: 'Honda', modelo: 'Civic', anio: 2021, disponible: 'Sí'),
    Vehiculo(idVehiculo: 'v3', marca: 'Ford', modelo: 'Focus', anio: 2020, disponible: 'No'),
    Vehiculo(idVehiculo: 'v4', marca: 'Nissan', modelo: 'March', anio: 2019, disponible: 'Sí'),
    Vehiculo(idVehiculo: 'v5', marca: 'Kia', modelo: 'Picanto', anio: 2010, disponible: 'No'),
  ];

  List<Vehiculo> get vehiculos => _vehiculos;
  
  // Lógica para el CRUD 
  void agregarVehiculo(Vehiculo vehiculo) {
    _vehiculos.add(vehiculo);
    notifyListeners(); // Notifica a los widgets que los datos cambiaron
  }

  void modificarVehiculo(Vehiculo vehiculoActualizado) {
    final index = _vehiculos.indexWhere((v) => v.idVehiculo == vehiculoActualizado.idVehiculo);
    if (index != -1) {
      _vehiculos[index] = vehiculoActualizado;
      notifyListeners();
    }
  }

  void eliminarVehiculo(String idVehiculo) {
    _vehiculos.removeWhere((v) => v.idVehiculo == idVehiculo);
    notifyListeners();
  }

  // Lógica para cambiar disponibilidad 
  void setDisponibilidad(String idVehiculo, bool estaDisponible) {
     final index = _vehiculos.indexWhere((v) => v.idVehiculo == idVehiculo);
     if (index != -1) {
      _vehiculos[index].disponible = estaDisponible ? 'Sí' : 'No';
      notifyListeners();
     }
  }

  Vehiculo? getVehiculoPorId(String idVehiculo) {
    try {
      return _vehiculos.firstWhere((v) => v.idVehiculo == idVehiculo);
    } catch (e) {
      return null; // No encontrado
    }
  }

  int get totalVehiculosDisponibles {
    return _vehiculos.where((v) => v.disponible == 'Sí').length;
  }
}