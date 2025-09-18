import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../../../../core/theme/app_theme.dart';

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _particleController;
  late List<FuturisticParticle> _particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
    
    _particleController = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat();
    
    _particles = List.generate(30, (index) => FuturisticParticle());
  }

  @override
  void dispose() {
    _controller.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  AppTheme.deepSpace,
                  AppTheme.cosmicPurple,
                  AppTheme.deepSpace,
                ]
              : [
                  const Color(0xFFF0F2F5),
                  AppTheme.glowWhite,
                  const Color(0xFFE3F2FD),
                ],
        ),
      ),
      child: Stack(
        children: [
          // Animated Gradient Overlay
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(
                      math.sin(_controller.value * 2 * math.pi) * 0.5,
                      math.cos(_controller.value * 2 * math.pi) * 0.5,
                    ),
                    radius: 1.5,
                    colors: isDark
                        ? [
                            AppTheme.neonPink.withOpacity(0.1),
                            AppTheme.neonPurple.withOpacity(0.05),
                            Colors.transparent,
                          ]
                        : [
                            AppTheme.neonPink.withOpacity(0.05),
                            AppTheme.neonBlue.withOpacity(0.03),
                            Colors.transparent,
                          ],
                  ),
                ),
              );
            },
          ),
          
          // Floating Particles
          AnimatedBuilder(
            animation: _particleController,
            builder: (context, child) {
              return CustomPaint(
                painter: FuturisticParticlesPainter(
                  _particles, 
                  _particleController.value,
                  isDark,
                ),
                size: Size.infinite,
              );
            },
          ),
          
          // Holographic Grid Effect
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: HolographicGridPainter(
                  _controller.value,
                  isDark,
                ),
                size: Size.infinite,
              );
            },
          ),
        ],
      ),
    );
  }
}

class FuturisticParticle {
  late double x;
  late double y;
  late double size;
  late Color color;
  late double speed;
  late double direction;
  late double opacity;
  late double pulsePhase;

  FuturisticParticle() {
    x = math.Random().nextDouble();
    y = math.Random().nextDouble();
    size = math.Random().nextDouble() * 3 + 1;
    speed = math.Random().nextDouble() * 0.3 + 0.1;
    direction = math.Random().nextDouble() * 2 * math.pi;
    opacity = math.Random().nextDouble() * 0.6 + 0.2;
    pulsePhase = math.Random().nextDouble() * 2 * math.pi;
    
    final colors = [
      AppTheme.neonPink,
      AppTheme.neonPurple,
      AppTheme.neonBlue,
      AppTheme.holographicBlue,
      AppTheme.holographicPurple,
    ];
    color = colors[math.Random().nextInt(colors.length)];
  }

  void update(double time) {
    x += math.cos(direction) * speed * 0.005;
    y += math.sin(direction) * speed * 0.005;
    
    if (x < 0) x = 1;
    if (x > 1) x = 0;
    if (y < 0) y = 1;
    if (y > 1) y = 0;
    
    // Add floating effect
    y += math.sin(time * 2 * math.pi + pulsePhase) * 0.001;
  }
}

class FuturisticParticlesPainter extends CustomPainter {
  final List<FuturisticParticle> particles;
  final double time;
  final bool isDark;

  FuturisticParticlesPainter(this.particles, this.time, this.isDark);

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      particle.update(time);
      
      final paint = Paint()
        ..color = particle.color.withOpacity(
          particle.opacity * (isDark ? 0.8 : 0.4)
        )
        ..style = PaintingStyle.fill;
      
      // Add glow effect
      final glowPaint = Paint()
        ..color = particle.color.withOpacity(
          particle.opacity * 0.3 * (isDark ? 1.0 : 0.5)
        )
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
      
      final center = Offset(
        particle.x * size.width,
        particle.y * size.height,
      );
      
      // Draw glow
      canvas.drawCircle(center, particle.size * 2, glowPaint);
      
      // Draw particle
      canvas.drawCircle(center, particle.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class HolographicGridPainter extends CustomPainter {
  final double time;
  final bool isDark;

  HolographicGridPainter(this.time, this.isDark);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (isDark ? AppTheme.neonBlue : AppTheme.neonPink)
          .withOpacity(0.1 + 0.05 * math.sin(time * 2 * math.pi))
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    const gridSize = 50.0;
    final cols = (size.width / gridSize).ceil();
    final rows = (size.height / gridSize).ceil();

    // Draw vertical lines
    for (int i = 0; i <= cols; i++) {
      final x = i * gridSize + (math.sin(time * 2 * math.pi + i * 0.1) * 5);
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Draw horizontal lines
    for (int i = 0; i <= rows; i++) {
      final y = i * gridSize + (math.cos(time * 2 * math.pi + i * 0.1) * 5);
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}