class Reserva {
  String idReserva;
  String idCliente;
  String idVehiculo;
  DateTime fechaInicio;
  DateTime fechaFin;

  Reserva({
    required this.idReserva,
    required this.idCliente,
    required this.idVehiculo,
    required this.fechaInicio,
    required this.fechaFin,
  });
}