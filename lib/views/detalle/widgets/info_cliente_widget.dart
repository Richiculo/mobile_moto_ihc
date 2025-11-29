import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/pedido.dart';
import '../../../viewmodels/detalle_pedido_viewmodel.dart';

class InfoClienteWidget extends StatelessWidget {
  final Pedido pedido;

  const InfoClienteWidget({super.key, required this.pedido});

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
              'Información del Cliente',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),

            // Nombre
            Row(
              children: [
                const Text(
                  'Nombre:',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  pedido.cliente.nombre,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Teléfono
            Row(
              children: [
                const Text(
                  'Teléfono:',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  pedido.cliente.telefono,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Botones de contacto
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => viewModel.llamarCliente(),
                    icon: const Icon(Icons.phone, size: 20),
                    label: const Text('Llamar'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.secondary,
                      side: const BorderSide(
                        color: AppColors.secondary,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => viewModel.enviarWhatsApp(),
                    icon: const Icon(Icons.message, size: 20),
                    label: const Text('WhatsApp'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.accent,
                      side: const BorderSide(color: AppColors.accent, width: 2),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
