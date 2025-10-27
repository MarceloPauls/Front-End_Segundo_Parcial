import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/vehiculo_service.dart';
import 'services/cliente_service.dart';
import 'services/reserva_service.dart';
import 'services/entrega_service.dart';
import 'screens/vehiculos_screen.dart';
import 'screens/clientes_screen.dart'; 
import 'screens/reservas_screen.dart';
import 'screens/nueva_reserva_screen.dart';
import 'screens/entregas_screen.dart';
import 'screens/estadisticas_screen.dart';


void main() {
  runApp(const AppState());
}

// CONFIGURAR EL PROVIDER
class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VehiculoService()),
        ChangeNotifierProvider(create: (_) => ClienteService()),
        ChangeNotifierProvider(create: (_) => ReservaService()),
        ChangeNotifierProvider(create: (_) => EntregaService()),
      ],
      child: const MyApp(),
    );
  }
}

// DEFINIR EL MATERIALAPP Y LAS RUTAS
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alquiler de Autos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false, 

      // PANTALLA INICIAL Y RUTAS DE NAVEGACIÓN
      initialRoute: '/home', 
      routes: {
        '/home': (context) => const HomeScreen(),
        '/vehiculos': (context) => const VehiculosScreen(),
        '/clientes': (context) => const ClientesScreen(),
        '/reservas': (context) => const ReservasScreen(),
        '/nueva-reserva': (context) => const NuevaReservaScreen(),
        '/entregas': (context) => const EntregasScreen(),
        '/estadisticas': (context) => const EstadisticasScreen(),
      },
    );
  }
}

// PANTALLA PRINCIPAL (MENÚ)
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sistema de Alquiler de Autos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
                title: Text('Módulos Principales',
                    style: Theme.of(context).textTheme.titleLarge)),
            ElevatedButton.icon(
              icon: const Icon(Icons.directions_car),
              label: const Text('Administrar Vehículos'),
              onPressed: () => Navigator.pushNamed(context, '/vehiculos'),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.people),
              label: const Text('Administrar Clientes'),
              onPressed: () => Navigator.pushNamed(context, '/clientes'),
            ),
            const SizedBox(height: 20),
            ListTile(
                title: Text('Gestión',
                    style: Theme.of(context).textTheme.titleLarge)),
            ElevatedButton.icon(
              icon: const Icon(Icons.book_online),
              label: const Text('Registrar Nueva Reserva'),
              onPressed: () => Navigator.pushNamed(context, '/nueva-reserva'),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.key),
              label: const Text('Registrar Entrega'),
              onPressed: () => Navigator.pushNamed(context, '/entregas'),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.list_alt),
              label: const Text('Ver Reservas Activas'),
              onPressed: () => Navigator.pushNamed(context, '/reservas'),
            ),
            const SizedBox(height: 20),
            ListTile(
                title: Text('Reportes',
                    style: Theme.of(context).textTheme.titleLarge)),
            ElevatedButton.icon(
              icon: const Icon(Icons.bar_chart),
              label: const Text('Ver Estadísticas'),
              onPressed: () => Navigator.pushNamed(context, '/estadisticas'),
            ),
          ],
        ),
      ),
    );
  }
}