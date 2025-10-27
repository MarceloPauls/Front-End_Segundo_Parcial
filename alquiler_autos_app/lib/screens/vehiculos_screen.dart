import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/vehiculo.dart';
import '../services/vehiculo_service.dart';
import 'vehiculo_form_screen.dart'; 

// Usamos un StatefulWidget para manejar el estado del campo de filtro
class VehiculosScreen extends StatefulWidget {
  const VehiculosScreen({super.key});

  @override
  State<VehiculosScreen> createState() => _VehiculosScreenState();
}

class _VehiculosScreenState extends State<VehiculosScreen> {
  // Controlador para el campo de texto del filtro
  final TextEditingController _filtroController = TextEditingController();
  String _filtro = '';

  @override
  void initState() {
    super.initState();
    // Escuchamos los cambios en el campo de texto para actualizar el filtro
    _filtroController.addListener(() {
      setState(() {
        _filtro = _filtroController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _filtroController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Usamos context.watch para que la UI se actualice si los datos cambian
    final vehiculoService = context.watch<VehiculoService>();

    final List<Vehiculo> vehiculosFiltrados =
        vehiculoService.vehiculos.where((vehiculo) {
      if (_filtro.isEmpty) {
        return true; // Mostrar todos si no hay filtro
      }
      // Búsqueda case-insensitive
      final marca = vehiculo.marca.toLowerCase();
      final modelo = vehiculo.modelo.toLowerCase();
      return marca.contains(_filtro) || modelo.contains(_filtro);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrar Vehículos'),
      ),
      body: Column(
        children: [
          // --- CAMPO DE FILTRO ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _filtroController,
              decoration: InputDecoration(
                labelText: 'Filtrar por marca o modelo',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
          ),

          // --- INICIO DE LA CABECERA (AÑADIR ESTO) ---
          ListTile(
            dense: true, // Hace la cabecera un poco más delgada
            title: Text(
              'Vehículo',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade700),
            ),
            trailing: Text(
              'Disponible', // Tu etiqueta
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade700),
            ),
          ),
          const Divider(height: 1, thickness: 1), // Una línea divisoria

          // --- LISTA DE VEHÍCULOS ---
          // Usamos Expanded para que la lista ocupe el espacio restante
          Expanded(
            child: ListView.builder(
              itemCount: vehiculosFiltrados.length,
              itemBuilder: (context, index) {
                final vehiculo = vehiculosFiltrados[index];
                return ListTile(
                  leading: const Icon(Icons.directions_car_filled, size: 40),
                  title: Text(
                    '${vehiculo.marca} ${vehiculo.modelo}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Año: ${vehiculo.anio}'),
                  // Mostramos la disponibilidad con un color
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min, // Para que la Row no ocupe toda la línea
                    children: [
                      Text(
                        vehiculo.disponible,
                        style: TextStyle(
                          color: vehiculo.disponible == 'Sí'
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),

                      // --- BOTÓN EDITAR ---
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          // Navegamos al formulario en modo "Editar"
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  VehiculoFormScreen(vehiculo: vehiculo),
                            ),
                          );
                        },
                      ),

                      // --- BOTÓN ELIMINAR ---
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () {
                          _mostrarDialogoConfirmacion(context, vehiculo.idVehiculo);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // --- BOTÓN AÑADIR ---
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navegamos al formulario en modo "Añadir" (pasamos null)
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const VehiculoFormScreen(vehiculo: null),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // --- Diálogo de confirmación para eliminar ---
  void _mostrarDialogoConfirmacion(BuildContext context, String idVehiculo) {
    // Usamos context.read aquí porque estamos dentro de un callback,
    // no necesitamos "escuchar" cambios, solo ejecutar una acción.
    final vehiculoService = context.read<VehiculoService>();

    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Confirmar Eliminación'),
          content: const Text('¿Estás seguro de que deseas eliminar este vehículo?'),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(ctx).pop(); // Cierra el diálogo
              },
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Eliminar'),
              onPressed: () {
                vehiculoService.eliminarVehiculo(idVehiculo);
                Navigator.of(ctx).pop(); // Cierra el diálogo
              },
            ),
          ],
        );
      },
    );
  }
}