import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../../../../core/theme/app_theme.dart';

class AuthTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool isPassword;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final String? Function(String?)? validator;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.label,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.validator,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField>
    with TickerProviderStateMixin {
  bool _obscureText = true;
  late AnimationController _focusController;
  late Animation<double> _glowAnimation;
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    
    _focusController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _focusController,
      curve: Curves.easeInOut,
    ));

    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
      
      if (_isFocused) {
        _focusController.forward();
      } else {
        _focusController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _focusController.dispose();
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
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: (_isFocused ? AppTheme.neonPink : AppTheme.neonBlue)
                    .withOpacity(0.3 * _glowAnimation.value),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            keyboardType: widget.keyboardType,
            obscureText: widget.isPassword ? _obscureText : false,
            validator: widget.validator,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: isDark ? AppTheme.glowWhite : AppTheme.deepSpace,
              letterSpacing: 0.5,
            ),
            decoration: InputDecoration(
              labelText: widget.label,
              labelStyle: theme.textTheme.bodyMedium?.copyWith(
                color: _isFocused 
                    ? AppTheme.neonPink
                    : (isDark ? AppTheme.glowWhite : AppTheme.deepSpace)
                        .withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
              prefixIcon: widget.prefixIcon != null 
                  ? Container(
                      padding: const EdgeInsets.all(12),
                      child: Icon(
                        widget.prefixIcon,
                        color: _isFocused 
                            ? AppTheme.neonPink
                            : AppTheme.neonBlue,
                        size: 22,
                      ),
                    )
                  : null,
              suffixIcon: widget.isPassword
                  ? Container(
                      padding: const EdgeInsets.all(8),
                      child: IconButton(
                        icon: Icon(
                          _obscureText 
                              ? Icons.visibility_rounded 
                              : Icons.visibility_off_rounded,
                          color: _isFocused 
                              ? AppTheme.neonPink
                              : AppTheme.neonBlue,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    )
                  : null,
              filled: true,
              fillColor: isDark 
                  ? AppTheme.cosmicPurple.withOpacity(0.6)
                  : Colors.white.withOpacity(0.8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color: AppTheme.neonBlue.withOpacity(0.3),
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color: AppTheme.neonBlue.withOpacity(0.3),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(
                  color: AppTheme.neonPink,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(
                  color: Colors.red,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),
            ),
          ),
        );
      },
    );
  }
}