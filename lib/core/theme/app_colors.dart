import 'package:flutter/material.dart';

class AppColors {
  // Colores principales
  static const Color primary = Color(0xFFF8C022); // Amarillo
  static const Color secondary = Color(0xFF133A1C); // Verde
  static const Color accent = Color(0xFFCC632C); // Naranja
  static const Color gradientDark = Color(
    0xFF8B2F05,
  ); // Naranja café (degradado)

  // Colores de estado
  static const Color success = Color(0xFF28A745);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFDC3545);
  static const Color info = Color(0xFF17A2B8);

  // Colores de texto
  static const Color textPrimary = Color(0xFF212529);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color textLight = Color(0xFFFFFFFF);

  // Colores de fondo
  static const Color background = Color(0xFFFFFBF0); // Beige claro
  static const Color cardBackground = Color(0xFFFFFFFF);

  // Colores de badges según estado
  static const Color badgeNuevo = Color(0xFFFFC107); // Amarillo
  static const Color badgeAceptado = Color(0xFF133A1C); // Verde oscuro
  static const Color badgeRecogido = Color(0xFFCC632C); // Naranja
  static const Color badgeEntregado = Color(0xFF28A745); // Verde
  static const Color badgeCancelado = Color(0xFFDC3545); // Rojo
}
