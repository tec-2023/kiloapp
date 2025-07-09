import 'package:flutter/material.dart';
import 'format_utils.dart';

class AppColors {
  static const Color primaryBlue = Color(0xFF0A1254); // Azul oscuro
  static const Color secondaryRed = Color(0xFFA50044); // Granate
  static const Color accentYellow = Color(0xFFF2C500); // Amarillo para CTA

  static const Color background = Colors.white;
  static const Color surface = Colors.white;

  static const Color onPrimary = Colors.white;
  static const Color onSecondary = Colors.white;
  static const Color onBackground = Color(0xFF0A1254);
  static const Color onSurface = Color(0xFF0A1254);
  static const Color onAccent = Color(0xFF0A1254);

  static const Color inputBackground = Color(0xFFF5F5F5);
}

class AppStrings {
  static const String appName = 'KiloApp';
  static const String splashText = 'KiloApp';

  // Permissions Screen
  static const String permissionTitle = 'Para comenzar...';
  static const String permissionLocation = 'Acceso a ubicación en segundo plano';
  static const String permissionStorage = 'Acceso a almacenamiento local';
  static const String btnGrantPermissions = 'Conceder permisos';

  // Authentication
  static const String btnLogin = 'Iniciar sesión';
  static const String btnRegister = 'Registrarme';
  static const String lblEmail = 'Correo electrónico';
  static const String lblPassword = 'Contraseña';
  static const String lblName = 'Nombre completo';

  // Home
  static const String btnStartTrip = 'Iniciar viaje';
  static const String btnStopTrip = 'Detener viaje';

  // Tabs
  static const String tabMap = 'Mapa';
  static const String tabHistory = 'Historial';
  static const String tabProfile = 'Perfil';

  static String formatDate(DateTime date) => FormatUtils.formatDate(date);
  static String formatTime(DateTime date) => FormatUtils.formatTime(date);
}
