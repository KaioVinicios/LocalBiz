import 'package:flutter/material.dart';
import 'package:localbiz/theme/app_colors.dart';
import 'package:localbiz/theme/app_design_tokens.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.hint,
    required this.controller,
    this.label,
    this.prefixIcon,
    this.onChanged,
    this.keyboardType,
    this.textInputAction,
    this.height = AppSizes.inputHeight,
    this.radius = AppRadii.md,
    this.prefixIconSize = 28,
    this.labelGap = AppSpacing.xs,
  });

  final String? label;
  final String hint;
  final TextEditingController controller;
  final IconData? prefixIcon;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final double height;
  final double radius;
  final double prefixIconSize;
  final double labelGap;

  @override
  Widget build(BuildContext context) {
    final field = SizedBox(
      height: height,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        textAlignVertical: TextAlignVertical.center,
        style: AppTextStyles.fieldText,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.fieldFill,
          hintText: hint,
          hintStyle: AppTextStyles.fieldHint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: const BorderSide(color: AppColors.blue, width: 1.2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          prefixIcon: prefixIcon == null
              ? null
              : Icon(
                  prefixIcon,
                  color: AppColors.textPrimary,
                  size: prefixIconSize,
                ),
          prefixIconConstraints: prefixIcon == null
              ? null
              : BoxConstraints(minWidth: height, minHeight: height),
        ),
      ),
    );

    if (label == null) {
      return field;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label!, style: AppTextStyles.fieldLabel),
        SizedBox(height: labelGap),
        field,
      ],
    );
  }
}
