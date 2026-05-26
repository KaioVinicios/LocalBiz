import 'package:flutter/material.dart';

class VendaFab extends StatelessWidget {
  const VendaFab({
    super.key,
    required this.onPressed,
    this.itemCount = 0,
  });

  final VoidCallback onPressed;
  final int itemCount;

  static const double _width        = 64;
  static const double _height       = 65;
  static const double _radius       = 8;
  static const double _paddingH     = 16;   // padding right & left
  static const double _iconSize     = 28;
  static const double _badgeSize    = 18;
  static const double _badgeFontSize = 10;
  static const double _badgeOffset  = -4;

  static const Color _bgColor  = Color(0xFF043DAE);
  static const Color _badgeBg  = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          width: _width,
          height: _height,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: _bgColor,
              elevation: 4,
              shadowColor: _bgColor.withOpacity(0.4),
              padding: const EdgeInsets.symmetric(horizontal: _paddingH),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_radius),
              ),
            ),
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: _iconSize,
            ),
          ),
        ),

        if (itemCount > 0)
          Positioned(
            top: _badgeOffset,
            right: _badgeOffset,
            child: Container(
              width: _badgeSize,
              height: _badgeSize,
              decoration: const BoxDecoration(
                color: _badgeBg,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                itemCount > 99 ? '99+' : '$itemCount',
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