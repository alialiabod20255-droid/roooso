import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../theme/app_theme.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/products/presentation/providers/products_provider.dart';
import '../../features/cart/presentation/providers/cart_provider.dart';
import '../../features/orders/presentation/providers/orders_provider.dart';
import '../../features/vendor/presentation/providers/vendor_provider.dart';

class AppProviders {
  static List<SingleChildWidget> get providers => [
    // Theme & Locale
    ChangeNotifierProvider(create: (_) => ThemeProvider()),
    ChangeNotifierProvider(create: (_) => LocaleProvider()),
    
    // Auth
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    
    // Products
    ChangeNotifierProvider(create: (_) => ProductsProvider()),
    
    // Cart
    ChangeNotifierProvider(create: (_) => CartProvider()),
    
    // Orders
    ChangeNotifierProvider(create: (_) => OrdersProvider()),
    
    // Vendor
    ChangeNotifierProvider(create: (_) => VendorProvider()),
  ];
}