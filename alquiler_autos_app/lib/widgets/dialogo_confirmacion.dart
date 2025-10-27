import 'package:flutter/material.dart';

Future<bool?> mostrarDialogoDeConfirmacion(
  BuildContext context, {
  required String titulo,
  required String contenido,
}) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext ctx) {
      return AlertDialog(
        title: Text(titulo),
        content: Text(contenido),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () {
              Navigator.of(ctx).pop(false); // Devuelve 'false'
            },
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
            onPressed: () {
              Navigator.of(ctx).pop(true); // Devuelve 'true'
            },
          ),
        ],
      );
    },
  );
}