import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/pedido.dart';
import '../../../viewmodels/detalle_pedido_viewmodel.dart';

class UbicacionWidget extends StatelessWidget {
  final Pedido pedido;

  const UbicacionWidget({super.key, required this.pedido});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<DetallePedidoViewModel>();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ubicación y Ruta',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),

            // Placeholder del mapa
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.map, size: 48, color: Colors.grey.shade400),
                        const SizedBox(height: 8),
                        if (pedido.distancia != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              'Distancia\n${pedido.distancia!.toStringAsFixed(1)} km',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Marcador restaurante
                  Positioned(
                    top: 20,
                    left: 40,
                    child: _buildMarcador('Restaurante', AppColors.secondary),
                  ),
                  // Marcador cliente
                  Positioned(
                    bottom: 20,
                    right: 40,
                    child: _buildMarcador('Cliente', AppColors.accent),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Recoger en
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppColors.secondary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.restaurant,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Recoger en:',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          pedido.direccionRecogida ?? 'CambaEats Central',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Entregar en
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.home,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Entregar en:',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          pedido.direccionEntrega,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Botón Google Maps
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () => viewModel.abrirEnGoogleMaps(),
                icon: const Icon(Icons.map),
                label: const Text('Abrir en Google Maps'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarcador(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
