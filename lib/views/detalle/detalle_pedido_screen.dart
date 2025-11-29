import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../models/pedido.dart';
import '../../viewmodels/detalle_pedido_viewmodel.dart';
import 'widgets/progreso_widget.dart';
import 'widgets/info_cliente_widget.dart';
import 'widgets/ubicacion_widget.dart';
import 'widgets/productos_widget.dart';

class DetallePedidoScreen extends StatefulWidget {
  final Pedido pedido;

  const DetallePedidoScreen({super.key, required this.pedido});

  @override
  State<DetallePedidoScreen> createState() => _DetallePedidoScreenState();
}

class _DetallePedidoScreenState extends State<DetallePedidoScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DetallePedidoViewModel>().setPedido(widget.pedido);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DetallePedidoViewModel>();
    final pedido = viewModel.pedido ?? widget.pedido;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pedido ${pedido.codigo}'),
            const Text(
              'Detalles del pedido',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: _getEstadoBadgeColor(pedido.estado),
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
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Progreso del pedido (solo si no está cancelado)
            if (pedido.estado != EstadoPedido.cancelado)
              ProgresoWidget(pedido: pedido),

            // Información del cliente
            InfoClienteWidget(pedido: pedido),

            // Ubicación y ruta
            UbicacionWidget(pedido: pedido),

            // Detalles del pedido (productos)
            ProductosWidget(pedido: pedido),

            // Botones de acción
            _buildBotonesAccion(pedido, viewModel),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildBotonesAccion(Pedido pedido, DetallePedidoViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Botones según el estado
          if (pedido.estado == EstadoPedido.pendiente) ...[
            // Aceptar pedido
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final confirm = await _mostrarDialogoConfirmacion(
                    context,
                    '¿Aceptar pedido?',
                    'Confirma que deseas aceptar este pedido',
                  );
                  if (confirm == true) {
                    await viewModel.aceptarPedido();
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Pedido aceptado')),
                      );
                    }
                  }
                },
                icon: const Icon(Icons.check_circle),
                label: const Text('Aceptar Pedido'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Cancelar pedido
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () async {
                  final confirm = await _mostrarDialogoConfirmacion(
                    context,
                    '¿Cancelar pedido?',
                    'Esta acción no se puede deshacer',
                  );
                  if (confirm == true) {
                    await viewModel.cancelarPedido();
                    if (mounted) {
                      Navigator.pop(context);
                    }
                  }
                },
                icon: const Icon(Icons.cancel),
                label: const Text('Cancelar Pedido'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error, width: 2),
                ),
              ),
            ),
          ] else if (pedido.estado == EstadoPedido.aceptado) ...[
            // Marcar como recogido
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await viewModel.marcarComoRecogido();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Pedido marcado como recogido'),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.inventory),
                label: const Text('Marcar como Recogido'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                ),
              ),
            ),
          ] else if (pedido.estado == EstadoPedido.recogido) ...[
            // En camino
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await viewModel.marcarEnCamino();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pedido en camino')),
                    );
                  }
                },
                icon: const Icon(Icons.delivery_dining),
                label: const Text('Iniciar Entrega'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                ),
              ),
            ),
          ] else if (pedido.estado == EstadoPedido.enCamino) ...[
            // Entregado
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final confirm = await _mostrarDialogoConfirmacion(
                    context,
                    '¿Confirmar entrega?',
                    'Confirma que el pedido fue entregado al cliente',
                  );
                  if (confirm == true) {
                    await viewModel.marcarComoEntregado();
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Pedido entregado')),
                      );
                      Navigator.pop(context);
                    }
                  }
                },
                icon: const Icon(Icons.check_circle),
                label: const Text('Confirmar Entrega'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<bool?> _mostrarDialogoConfirmacion(
    BuildContext context,
    String titulo,
    String mensaje,
  ) {
    return showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(titulo),
            content: Text(mensaje),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Confirmar'),
              ),
            ],
          ),
    );
  }

  Color _getEstadoBadgeColor(EstadoPedido estado) {
    switch (estado) {
      case EstadoPedido.pendiente:
        return AppColors.badgeNuevo;
      case EstadoPedido.aceptado:
        return AppColors.badgeAceptado;
      case EstadoPedido.recogido:
        return AppColors.badgeRecogido;
      case EstadoPedido.entregado:
        return AppColors.badgeEntregado;
      case EstadoPedido.cancelado:
        return AppColors.badgeCancelado;
      default:
        return AppColors.textSecondary;
    }
  }
}
