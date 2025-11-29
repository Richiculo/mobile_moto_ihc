import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'services/api_service.dart';
import 'viewmodels/login_viewmodel.dart';
import 'viewmodels/pedidos_viewmodel.dart';
import 'viewmodels/detalle_pedido_viewmodel.dart';
import 'views/auth/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Crear instancia única de ApiService
    final apiService = ApiService();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel(apiService)),
        ChangeNotifierProvider(create: (_) => PedidosViewModel(apiService)),
        ChangeNotifierProvider(
          create: (_) => DetallePedidoViewModel(apiService),
        ),
      ],
      child: MaterialApp(
        title: 'CambaEats Moto',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const LoginScreen(),
      ),
    );
  }
}
