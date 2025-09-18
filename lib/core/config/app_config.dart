import 'package:flutter/material.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/products/presentation/pages/product_details_page.dart';
import '../../features/cart/presentation/pages/cart_page.dart';
import '../../features/orders/presentation/pages/orders_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/vendor/presentation/pages/vendor_dashboard_page.dart';

class AppConfig {
  static const String appName = 'Roses Store';
  static const String appVersion = '1.0.0';
  
  // Supported locales
  static const List<Locale> supportedLocales = [
    Locale('ar', 'SA'), // Arabic
    Locale('en', 'US'), // English
  ];
  
  // Default locale
  static const Locale defaultLocale = Locale('ar', 'SA');
  
  // Routes
  static const String splashRoute = '/';
  static const String loginRoute = '/login';
  static const String homeRoute = '/home';
  static const String productDetailsRoute = '/product-details';
  static const String cartRoute = '/cart';
  static const String ordersRoute = '/orders';
  static const String profileRoute = '/profile';
  static const String vendorDashboardRoute = '/vendor-dashboard';
  
  // Generate routes
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginRoute:
        return _createRoute(const LoginPage());
      case homeRoute:
        return _createRoute(const HomePage());
      case productDetailsRoute:
        final args = settings.arguments as Map<String, dynamic>?;
        return _createRoute(ProductDetailsPage(productId: args?['productId']));
      case cartRoute:
        return _createRoute(const CartPage());
      case ordersRoute:
        return _createRoute(const OrdersPage());
      case profileRoute:
        return _createRoute(const ProfilePage());
      case vendorDashboardRoute:
        return _createRoute(const VendorDashboardPage());
      default:
        return null;
    }
  }
  
  static PageRouteBuilder _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;
        
        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );
        
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}