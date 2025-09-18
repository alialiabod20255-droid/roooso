import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import '../../../../core/models/product_model.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class ProductCard extends StatefulWidget {
  final ProductModel product;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late AnimationController _glowController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeInOut,
    ));

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
    _hoverController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) {
        setState(() => _isHovered = true);
        _hoverController.forward();
      },
      onTapUp: (_) {
        setState(() => _isHovered = false);
        _hoverController.reverse();
      },
      onTapCancel: () {
        setState(() => _isHovered = false);
        _hoverController.reverse();
      },
      child: AnimatedBuilder(
        animation: Listenable.merge([_scaleAnimation, _glowAnimation]),
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  // Outer glow
                  BoxShadow(
                    color: (isDark ? AppTheme.neonPink : AppTheme.neonBlue)
                        .withOpacity(0.3 * _glowAnimation.value),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                  // Inner shadow for depth
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Container(
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
                              AppTheme.glowWhite.withOpacity(0.7),
                            ],
                    ),
                    border: Border.all(
                      color: (isDark ? AppTheme.neonBlue : AppTheme.neonPink)
                          .withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Image with Holographic Effect
                      Expanded(
                        flex: 3,
                        child: Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(24),
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    AppTheme.holographicBlue.withOpacity(0.1),
                                    AppTheme.holographicPurple.withOpacity(0.1),
                                  ],
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(24),
                                ),
                                child: Hero(
                                  tag: 'product_${widget.product.id}',
                                  child: CachedNetworkImage(
                                    imageUrl: widget.product.images.isNotEmpty 
                                        ? widget.product.images.first 
                                        : 'https://images.pexels.com/photos/1070850/pexels-photo-1070850.jpeg',
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            AppTheme.neonPink.withOpacity(0.1),
                                            AppTheme.neonPurple.withOpacity(0.1),
                                          ],
                                        ),
                                      ),
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: AppTheme.neonPink,
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) => Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            AppTheme.neonPink.withOpacity(0.1),
                                            AppTheme.neonPurple.withOpacity(0.1),
                                          ],
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.local_florist,
                                        color: AppTheme.neonPink,
                                        size: 32,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            
                            // Holographic Overlay
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(24),
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.transparent,
                                    AppTheme.neonBlue.withOpacity(0.1),
                                    Colors.transparent,
                                    AppTheme.neonPink.withOpacity(0.1),
                                    Colors.transparent,
                                  ],
                                  stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                                ),
                              ),
                            ),
                            
                            // Discount Badge
                            if (widget.product.hasDiscount)
                              Positioned(
                                top: 12,
                                right: 12,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        AppTheme.neonPink,
                                        AppTheme.neonPurple,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme.neonPink.withOpacity(0.5),
                                        blurRadius: 8,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    '${widget.product.discount!.toInt()}%',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            
                            // Favorite Button
                            Positioned(
                              top: 12,
                              left: 12,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isDark 
                                      ? AppTheme.cosmicPurple.withOpacity(0.8)
                                      : Colors.white.withOpacity(0.9),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppTheme.neonPink.withOpacity(0.3),
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.neonPink.withOpacity(0.2),
                                      blurRadius: 8,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    // TODO: Add to favorites
                                  },
                                  icon: Icon(
                                    Icons.favorite_border_rounded,
                                    color: AppTheme.neonPink,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Product Info with Glassmorphism
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: isDark
                                  ? [
                                      AppTheme.cosmicPurple.withOpacity(0.6),
                                      AppTheme.deepSpace.withOpacity(0.8),
                                    ]
                                  : [
                                      Colors.white.withOpacity(0.8),
                                      AppTheme.glowWhite.withOpacity(0.9),
                                    ],
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Product Name
                              Text(
                                widget.product.name,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? AppTheme.glowWhite : AppTheme.deepSpace,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              
                              const SizedBox(height: 6),
                              
                              // Rating with Neon Effect
                              Row(
                                children: [
                                  ...List.generate(5, (index) {
                                    return Icon(
                                      index < widget.product.rating.floor()
                                          ? Icons.star_rounded
                                          : Icons.star_border_rounded,
                                      color: AppTheme.neonBlue,
                                      size: 14,
                                    );
                                  }),
                                  const SizedBox(width: 6),
                                  Text(
                                    '(${widget.product.reviewCount})',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: (isDark ? AppTheme.glowWhite : AppTheme.deepSpace)
                                          .withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                              
                              const Spacer(),
                              
                              // Price and Add to Cart
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (widget.product.hasDiscount)
                                        Text(
                                          '${widget.product.price.toInt()} ر.س',
                                          style: theme.textTheme.bodySmall?.copyWith(
                                            decoration: TextDecoration.lineThrough,
                                            color: (isDark ? AppTheme.glowWhite : AppTheme.deepSpace)
                                                .withOpacity(0.5),
                                          ),
                                        ),
                                      Text(
                                        '${widget.product.finalPrice.toInt()} ر.س',
                                        style: theme.textTheme.bodyLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.neonPink,
                                        ),
                                      ),
                                    ],
                                  ),
                                  
                                  Consumer2<CartProvider, AuthProvider>(
                                    builder: (context, cartProvider, authProvider, child) {
                                      return GestureDetector(
                                        onTap: () async {
                                          if (!authProvider.isAuthenticated) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: const Text('يرجى تسجيل الدخول أولاً'),
                                                backgroundColor: AppTheme.neonPink,
                                              ),
                                            );
                                            return;
                                          }
                                          
                                          await cartProvider.addToCart(
                                            userId: authProvider.currentUser!.id,
                                            productId: widget.product.id,
                                            productName: widget.product.name,
                                            productImage: widget.product.images.isNotEmpty 
                                                ? widget.product.images.first 
                                                : '',
                                            price: widget.product.finalPrice,
                                            quantity: 1,
                                          );
                                          
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('تم إضافة ${widget.product.name} للسلة'),
                                              backgroundColor: AppTheme.neonPink,
                                            ),
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [
                                                AppTheme.neonPink,
                                                AppTheme.neonPurple,
                                              ],
                                            ),
                                            borderRadius: BorderRadius.circular(16),
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppTheme.neonPink.withOpacity(0.4),
                                                blurRadius: 12,
                                                spreadRadius: 1,
                                              ),
                                            ],
                                          ),
                                          child: const Icon(
                                            Icons.add_shopping_cart_rounded,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
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
    );
  }
}