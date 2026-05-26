import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class VendaSearchBar extends StatelessWidget {
  const VendaSearchBar({
    super.key,
    required this.controller,
    this.onChanged,
    this.hint = 'Buscar produto...',
  });

  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final String hint;

  static const double _height = 56;
  static const double _radius = 24;
  static const double _padding = 16;
  static const double _gap = 10;
  static const double _iconSize = 20;

  static const Color _fillColor = Color(0x0D043DAE);
  static const Color _hintColor = Color(0x66444B58);
  static const Color _focusBorder = Color(0xFF183D8C);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textAlignVertical: TextAlignVertical.center,
        style: const TextStyle(
          color: Color(0xFF202636),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: _fillColor,
          hintText: hint,
          hintStyle: const TextStyle(
            color: _hintColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_radius),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_radius),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_radius),
            borderSide: const BorderSide(color: _focusBorder, width: 1.2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: _padding,
            vertical: 0,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: _padding, right: _gap),
            child: SvgPicture.asset(
              'assets/icons/search-02.svg',
              width: _iconSize,
              height: _iconSize,
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 0,
            minHeight: 0,
          ),
        ),
      ),
    );
  }
}
