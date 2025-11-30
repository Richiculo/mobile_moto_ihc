import 'package:flutter/material.dart';
import 'home_screen.dart';

class ConductorSelectorScreen extends StatelessWidget {
  const ConductorSelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo o título
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5C842),
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: const Icon(
                    Icons.delivery_dining,
                    size: 60,
                    color: Color(0xFF0D5F3F),
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'CambaEats Conductor',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D5F3F),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Selecciona tu perfil',
                  style: TextStyle(fontSize: 16, color: Color(0xFF666666)),
                ),
                const SizedBox(height: 48),
                // Botón Tachero 1
                _buildConductorButton(
                  context: context,
                  conductorId: 'tachero-1',
                  conductorName: 'Tachero 1',
                  icon: Icons.person,
                  color: const Color(0xFF0D5F3F),
                ),
                const SizedBox(height: 16),
                // Botón Tachero 2
                _buildConductorButton(
                  context: context,
                  conductorId: 'tachero-2',
                  conductorName: 'Tachero 2',
                  icon: Icons.person_outline,
                  color: const Color(0xFFE67E22),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConductorButton({
    required BuildContext context,
    required String conductorId,
    required String conductorName,
    required IconData icon,
    required Color color,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 70,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(conductorId: conductorId),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32),
            const SizedBox(width: 16),
            Text(
              conductorName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
