import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import '../../../../core/config/app_config.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class HomeAppBar extends StatefulWidget {
  const HomeAppBar({super.key});

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _pulseAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // Futuristic Logo
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Container(
                width: 60,
                height: 60,
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
                      color: AppTheme.neonPink.withOpacity(
                        0.4 + (0.3 * math.sin(_pulseAnimation.value * 2 * math.pi))
                      ),
                      blurRadius: 20,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark 
                        ? AppTheme.deepSpace.withOpacity(0.8)
                        : Colors.white.withOpacity(0.9),
                  ),
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    color: AppTheme.neonPink,
                    size: 28,
                  ),
                ),
              );
            },
          ),
          
          const SizedBox(width: 16),
          
          // Welcome Text with Futuristic Style
          Expanded(
            child: Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'مرحباً في المستقبل',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: (isDark ? AppTheme.glowWhite : AppTheme.deepSpace)
                            .withOpacity(0.7),
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 2),
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [
                          AppTheme.neonPink,
                          AppTheme.neonPurple,
                          AppTheme.neonBlue,
                        ],
                      ).createShader(bounds),
                      child: Text(
                        authProvider.currentUser?.fullName ?? 'مستكشف الكون',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          
          // Futuristic Notifications
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.neonBlue.withOpacity(0.2),
                      AppTheme.neonPurple.withOpacity(0.2),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.neonBlue.withOpacity(
                        0.3 * math.sin(_pulseAnimation.value * 2 * math.pi)
                      ),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () {
                    // TODO: Navigate to notifications
                  },
                  icon: Stack(
                    children: [
                      Icon(
                        Icons.notifications_none_rounded,
                        color: isDark ? AppTheme.glowWhite : AppTheme.deepSpace,
                        size: 26,
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                AppTheme.neonPink,
                                AppTheme.neonPurple,
                              ],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.neonPink.withOpacity(0.6),
                                blurRadius: 6,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          
          const SizedBox(width: 8),
          
          // Futuristic Profile Avatar
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, AppConfig.profileRoute);
            },
            child: Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.neonPink.withOpacity(0.8),
                            AppTheme.neonPurple.withOpacity(0.8),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.neonPink.withOpacity(
                              0.4 + (0.2 * math.sin(_pulseAnimation.value * 2 * math.pi))
                            ),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(2),
                        child: CircleAvatar(
                          radius: 22,
                          backgroundColor: isDark 
                              ? AppTheme.cosmicPurple
                              : AppTheme.glowWhite,
                          backgroundImage: authProvider.currentUser?.profileImage != null
                              ? NetworkImage(authProvider.currentUser!.profileImage!)
                              : null,
                          child: authProvider.currentUser?.profileImage == null
                              ? Icon(
                                  Icons.person_rounded,
                                  color: AppTheme.neonPink,
                                  size: 24,
                                )
                              : null,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}