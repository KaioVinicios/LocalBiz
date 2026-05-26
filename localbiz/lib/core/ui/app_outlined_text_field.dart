import 'package:flutter/material.dart';
import 'package:localbiz/core/theme/app_colors.dart';
import 'package:localbiz/core/theme/app_design_tokens.dart';

class AppOutlinedTextField extends StatelessWidget {
  const AppOutlinedTextField({
    super.key,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.height = AppSizes.inputHeight,
    this.textStyle,
    this.contentPadding,
  });

  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final double height;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: textStyle ?? AppTextStyles.fieldText,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              contentPadding ??
              const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(color: AppColors.divider),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(color: AppColors.blue, width: 1.5),
          ),
          border: const OutlineInputBorder(borderRadius: BorderRadius.zero),
        ),
      ),
    );
  }
}
