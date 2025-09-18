import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:math' as math;

import '../../../../core/models/cart_model.dart';
import '../../../../core/theme/app_theme.dart';

class CartItemCard extends StatefulWidget {
  final CartItemModel item;
  final Function(int) onQuantityChanged;
  final VoidCallback onRemove;

  const CartItemCard({
    super.key,
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  State<CartItemCard> createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    
    _glowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppTheme.neonPink.withOpacity(0.2 * _glowAnimation.value),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Container(
              padding: const EdgeInsets.all(20),
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
              child: Row(
                children: [
                  // Futuristic Product Image
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.holographicBlue.withOpacity(0.3),
                          blurRadius: 15,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        children: [
                          CachedNetworkImage(
                            imageUrl: widget.item.productImage.isNotEmpty 
                                ? widget.item.productImage 
                                : 'https://images.pexels.com/photos/1070850/pexels-photo-1070850.jpeg',
                            width: 90,
                            height: 90,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppTheme.neonPink.withOpacity(0.2),
                                    AppTheme.neonPurple.withOpacity(0.2),
                                  ],
                                ),
                              ),
                              child: Icon(
                                Icons.local_florist_rounded,
                                color: AppTheme.neonPink,
                                size: 32,
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppTheme.neonPink.withOpacity(0.2),
                                    AppTheme.neonPurple.withOpacity(0.2),
                                  ],
                                ),
                              ),
                              child: Icon(
                                Icons.local_florist_rounded,
                                color: AppTheme.neonPink,
                                size: 32,
                              ),
                            ),
                          ),
                          
                          // Holographic Overlay
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.transparent,
                                  AppTheme.neonBlue.withOpacity(0.1),
                                  Colors.transparent,
                                  AppTheme.holographicPurple.withOpacity(0.1),
                                  Colors.transparent,
                                ],
                                stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 20),

                  // Product Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Name
                        Text(
                          widget.item.productName,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppTheme.glowWhite : AppTheme.deepSpace,
                            letterSpacing: 0.5,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 8),

                        // Product Options with Neon Tags
                        if (widget.item.selectedSize != null || widget.item.selectedColor != null) ...[
                          Wrap(
                            spacing: 8,
                            children: [
                              if (widget.item.selectedSize != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppTheme.neonPink.withOpacity(0.2),
                                        AppTheme.neonPurple.withOpacity(0.2),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppTheme.neonPink.withOpacity(0.4),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    widget.item.selectedSize!,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: AppTheme.neonPink,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              if (widget.item.selectedColor != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppTheme.neonBlue.withOpacity(0.2),
                                        AppTheme.holographicBlue.withOpacity(0.2),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppTheme.neonBlue.withOpacity(0.4),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    widget.item.selectedColor!,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: AppTheme.neonBlue,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 12),
                        ],

                        // Price and Quantity Controls
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Price with Gradient
                            ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [
                                  AppTheme.neonPink,
                                  AppTheme.neonPurple,
                                ],
                              ).createShader(bounds),
                              child: Text(
                                '${widget.item.totalPrice.toInt()} ر.س',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),

                            // Futuristic Quantity Controls
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppTheme.neonBlue.withOpacity(0.1),
                                    AppTheme.neonPurple.withOpacity(0.1),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppTheme.neonBlue.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _buildQuantityButton(
                                    Icons.remove_rounded,
                                    () {
                                      if (widget.item.quantity > 1) {
                                        widget.onQuantityChanged(widget.item.quantity - 1);
                                      }
                                    },
                                    widget.item.quantity > 1,
                                    isDark,
                                  ),

                                  Container(
                                    width: 50,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    child: Text(
                                      widget.item.quantity.toString(),
                                      style: theme.textTheme.bodyLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.neonPink,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),

                                  _buildQuantityButton(
                                    Icons.add_rounded,
                                    () {
                                      widget.onQuantityChanged(widget.item.quantity + 1);
                                    },
                                    true,
                                    isDark,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Futuristic Remove Button
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Colors.red.withOpacity(0.2),
                          Colors.redAccent.withOpacity(0.2),
                        ],
                      ),
                      border: Border.all(
                        color: Colors.red.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: IconButton(
                      onPressed: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (context) => _buildFuturisticDialog(context),
                        );

                        if (confirmed == true) {
                          widget.onRemove();
                        }
                      },
                      icon: Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.red.shade400,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuantityButton(
    IconData icon,
    VoidCallback onPressed,
    bool enabled,
    bool isDark,
  ) {
    return GestureDetector(
      onTap: enabled ? onPressed : null,
      child: Container(
        width: 40,
        height: 40,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          gradient: enabled
              ? LinearGradient(
                  colors: [
                    AppTheme.neonPink.withOpacity(0.8),
                    AppTheme.neonPurple.withOpacity(0.8),
                  ],
                )
              : LinearGradient(
                  colors: [
                    Colors.grey.withOpacity(0.3),
                    Colors.grey.withOpacity(0.2),
                  ],
                ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: AppTheme.neonPink.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Icon(
          icon,
          size: 18,
          color: enabled ? Colors.white : Colors.grey,
        ),
      ),
    );
  }

  Widget _buildFuturisticDialog(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppTheme.neonPink.withOpacity(0.3),
              blurRadius: 25,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        AppTheme.cosmicPurple.withOpacity(0.95),
                        AppTheme.deepSpace.withOpacity(0.9),
                      ]
                    : [
                        Colors.white.withOpacity(0.95),
                        AppTheme.glowWhite.withOpacity(0.9),
                      ],
              ),
              border: Border.all(
                color: AppTheme.neonBlue.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: AppTheme.neonPink,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  'حذف من الكون الرقمي',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppTheme.glowWhite : AppTheme.deepSpace,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'هل أنت متأكد من حذف ${widget.item.productName} من سلتك المستقبلية؟',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: (isDark ? AppTheme.glowWhite : AppTheme.deepSpace)
                        .withOpacity(0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context, false),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppTheme.neonBlue),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          'إلغاء',
                          style: TextStyle(color: AppTheme.neonBlue),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'حذف',
                          style: TextStyle(color: Colors.white),
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
    );
  }
}