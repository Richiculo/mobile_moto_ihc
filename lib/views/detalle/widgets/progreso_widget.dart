import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/pedido.dart';

class ProgresoWidget extends StatelessWidget {
  final Pedido pedido;

  const ProgresoWidget({super.key, required this.pedido});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Progreso del Pedido',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            _buildPasoProgreso(
              'Pedido Recibido',
              EstadoPedido.pendiente,
              'En progreso...',
              true,
            ),
            _buildLinea(pedido.estado.index > EstadoPedido.pendiente.index),
            _buildPasoProgreso('Aceptado', EstadoPedido.aceptado, null, false),
            _buildLinea(pedido.estado.index > EstadoPedido.aceptado.index),
            _buildPasoProgreso('Recogido', EstadoPedido.recogido, null, false),
            _buildLinea(pedido.estado.index > EstadoPedido.recogido.index),
            _buildPasoProgreso('En Camino', EstadoPedido.enCamino, null, false),
            _buildLinea(pedido.estado.index > EstadoPedido.enCamino.index),
            _buildPasoProgreso(
              'Entregado',
              EstadoPedido.entregado,
              null,
              false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasoProgreso(
    String titulo,
    EstadoPedido estadoRequerido,
    String? subtitulo,
    bool mostrarSpinner,
  ) {
    final completado = pedido.estado.index >= estadoRequerido.index;
    final enProceso = pedido.estado == estadoRequerido && mostrarSpinner;

    return Row(
      children: [
        // Círculo indicador
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: completado ? AppColors.accent : Colors.grey.shade300,
            shape: BoxShape.circle,
          ),
          child: Center(
            child:
                enProceso
                    ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                    : Icon(
                      completado ? Icons.check : Icons.circle,
                      color: Colors.white,
                      size: 16,
                    ),
          ),
        ),
        const SizedBox(width: 12),
        // Texto
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titulo,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: completado ? FontWeight.bold : FontWeight.normal,
                  color:
                      completado
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                ),
              ),
              if (subtitulo != null)
                Text(
                  subtitulo,
                  style: const TextStyle(fontSize: 12, color: AppColors.accent),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLinea(bool completado) {
    return Container(
      margin: const EdgeInsets.only(left: 15.5),
      width: 1,
      height: 20,
      color: completado ? AppColors.accent : Colors.grey.shade300,
    );
  }
}
