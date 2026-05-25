import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  const AddButton({
    super.key,
    required this.onPressed,
    this.label = '+ Adicionar',
  });

  final VoidCallback? onPressed;
  final String label;

  static const double _height  = 26.54;
  static const double _radius  = 32.71;
  static const double _padding = 7.27;

  static const Color _textColor = Color(0xFF043DAE);
  static const Color _bgColor   = Color(0xFFF1F5F9);
  static const Color _bgDisabled = Color(0xFFE2E8F0);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height,
      width: double.infinity,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: onPressed != null ? _bgColor : _bgDisabled,
          foregroundColor: _textColor,
          disabledForegroundColor: _textColor.withOpacity(0.4),
          padding: const EdgeInsets.symmetric(horizontal: _padding),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radius),
          ),
          minimumSize: const Size(0, _height),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Poppins',
            color: _textColor,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            height: 1.0,
            letterSpacing: 0,
          ),
        ),
      ),
    );
  }
}