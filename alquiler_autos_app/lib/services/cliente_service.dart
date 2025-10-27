import 'package:flutter/material.dart';
import '../models/cliente.dart';
import 'reserva_service.dart';

class ClienteService extends ChangeNotifier {
  
  // Lista en memoria
  final List<Cliente> _clientes = [
    // Datos de prueba
    Cliente(idCliente: 'c1', nombre: 'Marcelo', apellido: 'Pauls', documento: '5571234'),
    Cliente(idCliente: 'c2', nombre: 'Bruno', apellido: 'Diaz', documento: '9876543'),
    Cliente(idCliente: 'c3', nombre: 'Ana', apellido: 'Gomez', documento: '1234567'),
    Cliente(idCliente: 'c4', nombre: 'Santiago', apellido: 'Peña', documento: '9638527'),
  ];

  List<Cliente> get clientes => _clientes;

  void agregarCliente(Cliente cliente) {
    _clientes.add(cliente);
    notifyListeners();
  }

  void modificarCliente(Cliente clienteActualizado) {
    final index = _clientes.indexWhere((c) => c.idCliente == clienteActualizado.idCliente);
    if (index != -1) {
      _clientes[index] = clienteActualizado;
      notifyListeners();
    }
  }

  void eliminarCliente(String idCliente) {
    _clientes.removeWhere((c) => c.idCliente == idCliente);
    notifyListeners();
  }

  Cliente? getClientePorId(String idCliente) {
    try {
      return _clientes.firstWhere((c) => c.idCliente == idCliente);
    } catch (e) {
      return null;
    }
  }


  Cliente? getClienteConMasReservas(ReservaService reservaService) {
    if (_clientes.isEmpty || reservaService.reservas.isEmpty) {
      return null;
    }

    Map<String, int> conteoReservas = {};

    // Contar reservas por cliente
    for (var reserva in reservaService.reservas) {
      conteoReservas[reserva.idCliente] = (conteoReservas[reserva.idCliente] ?? 0) + 1;
    }

    if (conteoReservas.isEmpty) {
      return null;
    }

    // Encontrar el ID del cliente con más reservas
    String idClienteMasReservas = conteoReservas.entries.reduce((a, b) => a.value > b.value ? a : b).key;

    // Devolver el objeto Cliente
    return getClientePorId(idClienteMasReservas);
  }
}