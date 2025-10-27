import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cliente.dart';
import '../services/cliente_service.dart';
import 'cliente_form_screen.dart'; 

// Usamos StatefulWidget para el filtro
class ClientesScreen extends StatefulWidget {
  const ClientesScreen({super.key});

  @override
  State<ClientesScreen> createState() => _ClientesScreenState();
}

class _ClientesScreenState extends State<ClientesScreen> {
  final TextEditingController _filtroController = TextEditingController();
  String _filtro = '';

  @override
  void initState() {
    super.initState();
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
    // OBTENER EL SERVICIO
    final clienteService = context.watch<ClienteService>();

    // APLICAR EL FILTRO
    final List<Cliente> clientesFiltrados =
        clienteService.clientes.where((cliente) {
      if (_filtro.isEmpty) {
        return true;
      }
      final nombre = cliente.nombre.toLowerCase();
      final apellido = cliente.apellido.toLowerCase();
      final documento = cliente.documento.toLowerCase();
      
      return nombre.contains(_filtro) ||
             apellido.contains(_filtro) || 
             documento.contains(_filtro);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrar Clientes'),
      ),
      body: Column(
        children: [
          // --- CAMPO DE FILTRO ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _filtroController,
              decoration: InputDecoration(
                labelText: 'Filtrar por nombre, apellido o documento', 
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
          ),

          // --- LISTA DE CLIENTES ---
          Expanded(
            child: ListView.builder(
              itemCount: clientesFiltrados.length,
              itemBuilder: (context, index) {
                final cliente = clientesFiltrados[index];
                return ListTile(
                  leading: const Icon(Icons.person, size: 40),
                  title: Text(
                    '${cliente.nombre} ${cliente.apellido}', 
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Documento: ${cliente.documento}'), 
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // --- BOTÓN EDITAR ---
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          // Navegamos al formulario en modo "Editar"
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ClienteFormScreen(cliente: cliente),
                            ),
                          );
                        },
                      ),

                      // --- BOTÓN ELIMINAR ---
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () {
                          _mostrarDialogoConfirmacion(context, cliente.idCliente);
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ClienteFormScreen(cliente: null),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // --- Diálogo de confirmación para eliminar ---
  void _mostrarDialogoConfirmacion(BuildContext context, String idCliente) {
    final clienteService = context.read<ClienteService>();

    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Confirmar Eliminación'),
          content: const Text('¿Estás seguro de que deseas eliminar este cliente?'),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Eliminar'),
              onPressed: () {
                clienteService.eliminarCliente(idCliente);
                Navigator.of(ctx).pop();
              },
            ),
          ],
        );
      },
    );
  }
}