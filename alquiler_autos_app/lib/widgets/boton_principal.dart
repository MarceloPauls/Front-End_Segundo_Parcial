import 'package:flutter/material.dart';

class BotonPrincipal extends StatelessWidget {
  final String texto;
  final VoidCallback onPressed; // Tipo de dato para funciones void

  const BotonPrincipal({
    super.key, 
    required this.texto, 
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Un estilo extra
        ),
      ),
      child: Text(texto),
    );
  }
}