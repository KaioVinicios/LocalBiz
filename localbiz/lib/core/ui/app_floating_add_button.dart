import 'package:flutter/material.dart';
import 'package:localbiz/core/theme/app_colors.dart';
import 'package:localbiz/core/theme/app_design_tokens.dart';

class AppFloatingAddButton extends StatelessWidget {
  const AppFloatingAddButton({
    super.key,
    required this.onPressed,
    this.badgeCount = 0,
    this.tooltip,
  });

  final VoidCallback? onPressed;
  final int badgeCount;
  final String? tooltip;

  static const double _width = 64;
  static const double _height = 65;
  static const double _paddingH = 16;
  static const double _iconSize = 28;
  static const double _badgeSize = 18;
  static const double _badgeFontSize = 10;
  static const double _badgeOffset = -4;

  @override
  Widget build(BuildContext context) {
    final button = SizedBox(
      width: _width,
      height: _height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.blue,
          disabledBackgroundColor: AppColors.blue.withValues(alpha: 0.45),
          elevation: 4,
          shadowColor: AppColors.blue.withValues(alpha: 0.4),
          padding: const EdgeInsets.symmetric(horizontal: _paddingH),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.sm),
          ),
        ),
        child: const Icon(Icons.add, color: Colors.white, size: _iconSize),
      ),
    );

    return Stack(
      clipBehavior: Clip.none,
      children: [
        if (tooltip == null)
          button
        else
          Tooltip(message: tooltip!, child: button),
        if (badgeCount > 0)
          Positioned(
            top: _badgeOffset,
            right: _badgeOffset,
            child: Container(
              width: _badgeSize,
              height: _badgeSize,
              decoration: const BoxDecoration(
                color: AppColors.danger,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                badgeCount > 99 ? '99+' : '$badgeCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: _badgeFontSize,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
