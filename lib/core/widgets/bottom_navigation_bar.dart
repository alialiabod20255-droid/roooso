import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import '../theme/app_theme.dart';
import '../providers/navigation_provider.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  State<CustomBottomNavigationBar> createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late AnimationController _pulseController;
  late Animation<double> _glowAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

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
    _glowController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Consumer<NavigationProvider>(
      builder: (context, navigationProvider, child) {
        return Container(
          height: 90,
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: isDark 
                    ? AppTheme.neonPink.withOpacity(0.3)
                    : AppTheme.neonPink.withOpacity(0.2),
                blurRadius: 20,
                spreadRadius: 0,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: AnimatedBuilder(
              animation: _glowAnimation,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? [
                              AppTheme.cosmicPurple.withOpacity(0.9),
                              AppTheme.deepSpace.withOpacity(0.9),
                            ]
                          : [
                              Colors.white.withOpacity(0.9),
                              AppTheme.glowWhite.withOpacity(0.8),
                            ],
                    ),
                    border: Border.all(
                      color: isDark
                          ? AppTheme.neonBlue.withOpacity(0.3 * _glowAnimation.value)
                          : AppTheme.neonPink.withOpacity(0.2 * _glowAnimation.value),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNavItem(
                        context,
                        icon: Icons.home_outlined,
                        activeIcon: Icons.home_rounded,
                        label: 'الرئيسية',
                        index: 0,
                        isActive: navigationProvider.currentIndex == 0,
                        onTap: () => navigationProvider.setIndex(0),
                        isDark: isDark,
                      ),
                      _buildNavItem(
                        context,
                        icon: Icons.shopping_cart_outlined,
                        activeIcon: Icons.shopping_cart_rounded,
                        label: 'السلة',
                        index: 1,
                        isActive: navigationProvider.currentIndex == 1,
                        onTap: () => navigationProvider.setIndex(1),
                        badge: navigationProvider.cartItemCount > 0 
                            ? navigationProvider.cartItemCount.toString() 
                            : null,
                        isDark: isDark,
                      ),
                      _buildNavItem(
                        context,
                        icon: Icons.receipt_long_outlined,
                        activeIcon: Icons.receipt_long_rounded,
                        label: 'الطلبات',
                        index: 2,
                        isActive: navigationProvider.currentIndex == 2,
                        onTap: () => navigationProvider.setIndex(2),
                        isDark: isDark,
                      ),
                      _buildNavItem(
                        context,
                        icon: Icons.search_outlined,
                        activeIcon: Icons.search_rounded,
                        label: 'البحث',
                        index: 3,
                        isActive: navigationProvider.currentIndex == 3,
                        onTap: () => navigationProvider.setIndex(3),
                        isDark: isDark,
                      ),
                      _buildNavItem(
                        context,
                        icon: Icons.person_outline_rounded,
                        activeIcon: Icons.person_rounded,
                        label: 'الملف الشخصي',
                        index: 4,
                        isActive: navigationProvider.currentIndex == 4,
                        onTap: () => navigationProvider.setIndex(4),
                        isDark: isDark,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
    required bool isActive,
    required VoidCallback onTap,
    required bool isDark,
    String? badge,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: isActive
                            ? LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppTheme.neonPink.withOpacity(0.8),
                                  AppTheme.neonPurple.withOpacity(0.8),
                                ],
                              )
                            : null,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: isActive
                            ? [
                                BoxShadow(
                                  color: AppTheme.neonPink.withOpacity(
                                    0.4 + (0.2 * math.sin(_pulseAnimation.value * 2 * math.pi))
                                  ),
                                  blurRadius: 15,
                                  spreadRadius: 2,
                                ),
                              ]
                            : null,
                      ),
                      child: Icon(
                        isActive ? activeIcon : icon,
                        color: isActive 
                            ? Colors.white
                            : isDark 
                                ? Colors.grey.shade400
                                : Colors.grey.shade600,
                        size: isActive ? 28 : 24,
                      ),
                    );
                  },
                ),
                
                // Badge for cart
                if (badge != null)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: 1.0 + (0.1 * math.sin(_pulseAnimation.value * 2 * math.pi)),
                          child: Container(
                            padding: const EdgeInsets.all(6),
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
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 20,
                              minHeight: 20,
                            ),
                            child: Text(
                              badge,
                              style: GoogleFonts.orbitron(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
            
            const SizedBox(height: 6),
            
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: GoogleFonts.inter(
                fontSize: isActive ? 11 : 10,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive 
                    ? AppTheme.neonPink
                    : isDark 
                        ? Colors.grey.shade400
                        : Colors.grey.shade600,
                letterSpacing: 0.5,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}