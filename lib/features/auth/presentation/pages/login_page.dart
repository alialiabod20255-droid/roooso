import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import '../../../../core/config/app_config.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../splash/presentation/widgets/animated_background.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/social_login_button.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  late AnimationController _animationController;
  late AnimationController _logoController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _logoRotation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _logoController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    ));

    _logoRotation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.linear,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _logoController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.signInWithEmail(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (success && mounted) {
      if (authProvider.currentUser?.isVendor == true) {
        Navigator.pushReplacementNamed(context, AppConfig.vendorDashboardRoute);
      } else {
        Navigator.pushReplacementNamed(context, AppConfig.homeRoute);
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.signInWithGoogle();

    if (success && mounted) {
      if (authProvider.currentUser?.isVendor == true) {
        Navigator.pushReplacementNamed(context, AppConfig.vendorDashboardRoute);
      } else {
        Navigator.pushReplacementNamed(context, AppConfig.homeRoute);
      }
    }
  }

  Future<void> _handleAppleSignIn() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.signInWithApple();

    if (success && mounted) {
      if (authProvider.currentUser?.isVendor == true) {
        Navigator.pushReplacementNamed(context, AppConfig.vendorDashboardRoute);
      } else {
        Navigator.pushReplacementNamed(context, AppConfig.homeRoute);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          const AnimatedBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 40),
                      
                      // Futuristic Logo
                      Hero(
                        tag: 'app_logo',
                        child: AnimatedBuilder(
                          animation: _logoRotation,
                          builder: (context, child) {
                            return Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    AppTheme.neonPink,
                                    AppTheme.neonPurple,
                                    AppTheme.neonBlue,
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.neonPink.withOpacity(0.5),
                                    blurRadius: 30,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Container(
                                margin: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isDark 
                                      ? AppTheme.deepSpace.withOpacity(0.9)
                                      : Colors.white.withOpacity(0.9),
                                ),
                                child: Transform.rotate(
                                  angle: _logoRotation.value,
                                  child: const Icon(
                                    Icons.auto_awesome_rounded,
                                    size: 60,
                                    color: AppTheme.neonPink,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Welcome Text with Gradient
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [
                            AppTheme.neonPink,
                            AppTheme.neonPurple,
                            AppTheme.neonBlue,
                          ],
                        ).createShader(bounds),
                        child: Text(
                          l10n.welcome,
                          style: theme.textTheme.displayMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      Text(
                        'ادخل إلى عالم الورود المستقبلي',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: (isDark ? AppTheme.glowWhite : AppTheme.deepSpace)
                              .withOpacity(0.7),
                          letterSpacing: 0.8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: 48),
                      
                      // Futuristic Login Form
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.neonBlue.withOpacity(0.2),
                              blurRadius: 25,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(28),
                          child: Container(
                            padding: const EdgeInsets.all(28),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: isDark
                                    ? [
                                        AppTheme.cosmicPurple.withOpacity(0.9),
                                        AppTheme.deepSpace.withOpacity(0.8),
                                      ]
                                    : [
                                        Colors.white.withOpacity(0.9),
                                        AppTheme.glowWhite.withOpacity(0.8),
                                      ],
                              ),
                              border: Border.all(
                                color: AppTheme.neonBlue.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  AuthTextField(
                                    controller: _emailController,
                                    label: l10n.email,
                                    keyboardType: TextInputType.emailAddress,
                                    prefixIcon: Icons.email_rounded,
                                    validator: (value) {
                                      if (value?.isEmpty ?? true) {
                                        return 'يرجى إدخال البريد الإلكتروني';
                                      }
                                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                          .hasMatch(value!)) {
                                        return 'البريد الإلكتروني غير صحيح';
                                      }
                                      return null;
                                    },
                                  ),
                                  
                                  const SizedBox(height: 20),
                                  
                                  AuthTextField(
                                    controller: _passwordController,
                                    label: l10n.password,
                                    isPassword: true,
                                    prefixIcon: Icons.lock_rounded,
                                    validator: (value) {
                                      if (value?.isEmpty ?? true) {
                                        return 'يرجى إدخال كلمة المرور';
                                      }
                                      if (value!.length < 6) {
                                        return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                                      }
                                      return null;
                                    },
                                  ),
                                  
                                  const SizedBox(height: 32),
                                  
                                  // Futuristic Login Button
                                  Consumer<AuthProvider>(
                                    builder: (context, authProvider, child) {
                                      return Container(
                                        width: double.infinity,
                                        height: 56,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppTheme.neonPink.withOpacity(0.4),
                                              blurRadius: 20,
                                              spreadRadius: 2,
                                            ),
                                          ],
                                        ),
                                        child: ElevatedButton(
                                          onPressed: authProvider.isLoading 
                                              ? null 
                                              : _handleLogin,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                colors: [
                                                  AppTheme.neonPink,
                                                  AppTheme.neonPurple,
                                                ],
                                              ),
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Center(
                                              child: authProvider.isLoading
                                                  ? const SizedBox(
                                                      width: 24,
                                                      height: 24,
                                                      child: CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        valueColor: AlwaysStoppedAnimation(
                                                          Colors.white,
                                                        ),
                                                      ),
                                                    )
                                                  : Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        const Icon(
                                                          Icons.login_rounded,
                                                          color: Colors.white,
                                                        ),
                                                        const SizedBox(width: 12),
                                                        Text(
                                                          l10n.login,
                                                          style: theme.textTheme.bodyLarge?.copyWith(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.bold,
                                                            letterSpacing: 1.0,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  
                                  // Error Message
                                  Consumer<AuthProvider>(
                                    builder: (context, authProvider, child) {
                                      if (authProvider.errorMessage != null) {
                                        return Padding(
                                          padding: const EdgeInsets.only(top: 16),
                                          child: Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: Colors.red.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(12),
                                              border: Border.all(
                                                color: Colors.red.withOpacity(0.3),
                                              ),
                                            ),
                                            child: Text(
                                              authProvider.errorMessage!,
                                              style: TextStyle(
                                                color: Colors.red.shade400,
                                                fontSize: 14,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        );
                                      }
                                      return const SizedBox.shrink();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Divider with Holographic Effect
                      Container(
                        height: 1,
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              AppTheme.neonBlue.withOpacity(0.5),
                              AppTheme.neonPink.withOpacity(0.5),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      
                      Text(
                        'أو ادخل عبر البوابات الكونية',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: (isDark ? AppTheme.glowWhite : AppTheme.deepSpace)
                              .withOpacity(0.6),
                          letterSpacing: 0.8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Social Login Buttons
                      Row(
                        children: [
                          Expanded(
                            child: SocialLoginButton(
                              icon: Icons.g_mobiledata_rounded,
                              label: 'Google',
                              onPressed: _handleGoogleSignIn,
                              backgroundColor: isDark 
                                  ? AppTheme.cosmicPurple.withOpacity(0.8)
                                  : Colors.white,
                              textColor: isDark ? AppTheme.glowWhite : Colors.black87,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: SocialLoginButton(
                              icon: Icons.apple_rounded,
                              label: 'Apple',
                              onPressed: _handleAppleSignIn,
                              backgroundColor: AppTheme.deepSpace,
                              textColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Register Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'مستكشف جديد؟ ',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: (isDark ? AppTheme.glowWhite : AppTheme.deepSpace)
                                  .withOpacity(0.7),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) => 
                                      const RegisterPage(),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    return SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(1.0, 0.0),
                                        end: Offset.zero,
                                      ).animate(CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.easeInOutCubic,
                                      )),
                                      child: child,
                                    );
                                  },
                                  transitionDuration: const Duration(milliseconds: 400),
                                ),
                              );
                            },
                            child: ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [
                                  AppTheme.neonPink,
                                  AppTheme.neonPurple,
                                ],
                              ).createShader(bounds),
                              child: Text(
                                l10n.register,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}