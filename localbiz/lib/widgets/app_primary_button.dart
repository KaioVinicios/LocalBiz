import 'package:flutter/material.dart';
import 'package:localbiz/theme/app_colors.dart';
import 'package:localbiz/theme/app_design_tokens.dart';

class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.height = AppSizes.primaryButtonHeight,
  });

  final String label;
  final VoidCallback? onPressed;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.blue,
          disabledBackgroundColor: AppColors.blue.withValues(alpha: 0.45),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.sm),
          ),
        ),
        child: Text(label, style: AppTextStyles.primaryButton),
      ),
    );
  }
}
