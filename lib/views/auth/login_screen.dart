import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../viewmodels/login_viewmodel.dart';
import '../pedidos/pedidos_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LoginViewModel>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary, // Amarillo
              AppColors.accent, // Naranja
              AppColors.gradientDark, // Naranja café
            ],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo y título
                    _buildHeader(),

                    const SizedBox(height: 60),

                    // Título "Iniciar Sesión"
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: const BoxDecoration(color: AppColors.accent),
                      child: const Text(
                        'Iniciar Sesión',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Campos de formulario
                    _buildEmailField(),
                    const SizedBox(height: 16),
                    _buildPasswordField(),

                    const SizedBox(height: 24),

                    // Botón de login
                    _buildLoginButton(viewModel),

                    const SizedBox(height: 16),

                    // Links de registro y olvidó contraseña
                    _buildFooterLinks(),

                    // Mensaje de error
                    if (viewModel.errorMessage != null) ...[
                      const SizedBox(height: 16),
                      _buildErrorMessage(viewModel.errorMessage!),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // Placeholder para el logo del tucán
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(60),
          ),
          child: const Icon(
            Icons.delivery_dining,
            size: 60,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'CambaEats',
          style: TextStyle(
            color: AppColors.secondary,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          '¡Pedi Puej!',
          style: TextStyle(
            color: AppColors.secondary,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'Email',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            hintText: 'Ingrese su email',
            filled: true,
            fillColor: Colors.white,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingrese su email';
            }
            if (!value.contains('@')) {
              return 'Ingrese un email válido';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'Contraseña',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            hintText: 'Ingrese su contraseña',
            filled: true,
            fillColor: Colors.white,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: AppColors.textSecondary,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingrese su contraseña';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildLoginButton(LoginViewModel viewModel) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed:
            viewModel.isLoading
                ? null
                : () async {
                  if (_formKey.currentState!.validate()) {
                    final success = await viewModel.login(
                      _emailController.text,
                      _passwordController.text,
                    );

                    if (success && mounted) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const PedidosScreen(),
                        ),
                      );
                    }
                  }
                },
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondary),
        child:
            viewModel.isLoading
                ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                : const Text(
                  'Iniciar Sesión',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
      ),
    );
  }

  Widget _buildFooterLinks() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '¿No tenés cuenta? ',
              style: TextStyle(color: Colors.white),
            ),
            TextButton(
              onPressed: () {
                // TODO: Navegar a pantalla de registro cuando esté disponible
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Funcionalidad de registro próximamente'),
                  ),
                );
              },
              child: const Text(
                'Regístrate',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: () {
            // TODO: Navegar a recuperación de contraseña cuando esté disponible
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Funcionalidad de recuperación próximamente'),
              ),
            );
          },
          child: const Text(
            '¿Olvidaste tu contraseña?',
            style: TextStyle(
              color: Colors.white,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorMessage(String message) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(width: 8),
          Expanded(
            child: Text(message, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
