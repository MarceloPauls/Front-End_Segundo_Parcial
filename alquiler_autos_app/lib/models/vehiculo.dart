class Vehiculo {
  String idVehiculo;
  String marca;
  String modelo;
  int anio;
  String disponible; // "Sí" o "No" 

  Vehiculo({
    required this.idVehiculo,
    required this.marca,
    required this.modelo,
    required this.anio,
    required this.disponible,
  });
}