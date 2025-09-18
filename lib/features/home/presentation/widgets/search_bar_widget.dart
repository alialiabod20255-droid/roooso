import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../../../../core/theme/app_theme.dart';

class SearchBarWidget extends StatefulWidget {
  final Function(String) onSearch;

  const SearchBarWidget({
    super.key,
    required this.onSearch,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    
    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _glowController.dispose();
    _focusNode.dispose();
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
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: (_isFocused ? AppTheme.neonPink : AppTheme.neonBlue)
                    .withOpacity(0.3 * _glowAnimation.value),
                blurRadius: _isFocused ? 25 : 15,
                spreadRadius: _isFocused ? 3 : 1,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
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
                          AppTheme.glowWhite.withOpacity(0.8),
                        ],
                ),
                border: Border.all(
                  color: (_isFocused ? AppTheme.neonPink : AppTheme.neonBlue)
                      .withOpacity(0.4),
                  width: _isFocused ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                focusNode: _focusNode,
                onSubmitted: widget.onSearch,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: isDark ? AppTheme.glowWhite : AppTheme.deepSpace,
                ),
                decoration: InputDecoration(
                  hintText: 'ابحث عن باقات الورود المستقبلية...',
                  hintStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: (isDark ? AppTheme.glowWhite : AppTheme.deepSpace)
                        .withOpacity(0.6),
                  ),
                  prefixIcon: Container(
                    padding: const EdgeInsets.all(12),
                    child: Icon(
                      Icons.search_rounded,
                      color: _isFocused 
                          ? AppTheme.neonPink 
                          : AppTheme.neonBlue,
                      size: 24,
                    ),
                  ),
                  suffixIcon: _isFocused
                      ? Container(
                          padding: const EdgeInsets.all(8),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  AppTheme.neonPink,
                                  AppTheme.neonPurple,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.auto_awesome_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}