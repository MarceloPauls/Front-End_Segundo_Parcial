class Entrega {
  String idReserva;
  DateTime fechaEntregaReal;
  String? observaciones; // Opcional 

  Entrega({
    required this.idReserva,
    required this.fechaEntregaReal,
    this.observaciones,
  });
}