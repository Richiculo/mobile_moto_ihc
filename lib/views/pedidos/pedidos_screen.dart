import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../viewmodels/pedidos_viewmodel.dart';
import 'widgets/pedido_card.dart';
import '../detalle/detalle_pedido_screen.dart';

class PedidosScreen extends StatefulWidget {
  const PedidosScreen({super.key});

  @override
  State<PedidosScreen> createState() => _PedidosScreenState();
}

class _PedidosScreenState extends State<PedidosScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PedidosViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.delivery_dining,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            const Text('CambaEats'),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Adolf Hitler',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.secondary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.accent,
          indicatorWeight: 3,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.inbox, size: 20),
                  const SizedBox(width: 8),
                  Text('Entrantes (${viewModel.pedidosEntrantes.length})'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.local_shipping, size: 20),
                  const SizedBox(width: 8),
                  Text('En Curso (${viewModel.pedidosEnCurso.length})'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle, size: 20),
                  const SizedBox(width: 8),
                  Text('Mis Entregas (${viewModel.misEntregas.length})'),
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPedidosList(viewModel.pedidosEntrantes, viewModel),
          _buildPedidosList(viewModel.pedidosEnCurso, viewModel),
          _buildPedidosList(viewModel.misEntregas, viewModel),
        ],
      ),
    );
  }

  Widget _buildPedidosList(pedidos, PedidosViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (pedidos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 80,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No hay pedidos',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.textSecondary.withOpacity(0.7),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await viewModel.cargarPedidos();
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: pedidos.length,
        itemBuilder: (context, index) {
          final pedido = pedidos[index];
          return PedidoCard(
            pedido: pedido,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetallePedidoScreen(pedido: pedido),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
