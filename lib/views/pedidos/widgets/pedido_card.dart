import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/pedido.dart';

class PedidoCard extends StatelessWidget {
  final Pedido pedido;
  final VoidCallback onTap;

  const PedidoCard({super.key, required this.pedido, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Código y Badge de estado
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    pedido.codigo,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  _buildEstadoBadge(),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                pedido.cliente.nombre,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),

              // Dirección de entrega
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.location_on,
                    color: AppColors.accent,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Dirección de entrega',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          pedido.direccionEntrega,
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

              const SizedBox(height: 12),

              // Teléfono
              Row(
                children: [
                  const Icon(Icons.phone, color: AppColors.accent, size: 20),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Teléfono',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        pedido.cliente.telefono,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Productos
              Row(
                children: [
                  const Icon(
                    Icons.shopping_bag,
                    color: AppColors.accent,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '3 productos',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        pedido.productos
                            .take(2)
                            .map((p) => '${p.cantidad}x ${p.nombre}')
                            .join(', '),
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),

              // Footer: Tiempo y Total
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${pedido.tiempoEstimado} min',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Bs.${pedido.total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Botón Ver Detalles
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onTap,
                  icon: const Text('Ver Detalles'),
                  label: const Icon(Icons.arrow_forward, size: 16),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEstadoBadge() {
    Color badgeColor;

    switch (pedido.estado) {
      case EstadoPedido.pendiente:
        badgeColor = AppColors.badgeNuevo;
        break;
      case EstadoPedido.aceptado:
        badgeColor = AppColors.badgeAceptado;
        break;
      case EstadoPedido.recogido:
        badgeColor = AppColors.badgeRecogido;
        break;
      case EstadoPedido.entregado:
        badgeColor = AppColors.badgeEntregado;
        break;
      case EstadoPedido.cancelado:
        badgeColor = AppColors.badgeCancelado;
        break;
      default:
        badgeColor = AppColors.textSecondary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        pedido.estadoTexto,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
