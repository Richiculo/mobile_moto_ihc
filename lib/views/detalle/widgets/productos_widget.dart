import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/pedido.dart';

class ProductosWidget extends StatelessWidget {
  final Pedido pedido;

  const ProductosWidget({super.key, required this.pedido});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.shopping_bag, color: AppColors.accent),
                const SizedBox(width: 8),
                Text(
                  'Productos (${pedido.cantidadProductos})',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Lista de productos
            ...pedido.productos.map((producto) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${producto.cantidad}x ${producto.nombre}',
                        style: const TextStyle(
                          fontSize: 15,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Text(
                      'Bs.${producto.subtotal.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              );
            }),

            const Divider(height: 24),

            // Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Bs.${pedido.total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Tiempo estimado
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    color: AppColors.accent,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Tiempo Estimado',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${pedido.tiempoEstimado} min',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accent,
                    ),
                  ),
                ],
              ),
            ),

            // Notas especiales (si existen)
            if (pedido.notasEspeciales != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.yellow.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.note, color: AppColors.warning, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Notas Especiales:',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            pedido.notasEspeciales!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
