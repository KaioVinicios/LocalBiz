import 'package:flutter/material.dart';
import 'package:localbiz/core/theme/app_colors.dart';
import 'package:localbiz/core/ui/app_help_action_button.dart';

class AppTopBar extends StatelessWidget {
  const AppTopBar({
    super.key,
    this.backLabel = 'VOLTAR',
    this.onBack,
    this.showHelp = true,
    this.padding = const EdgeInsets.fromLTRB(16, 12, 16, 4),
  });

  final String backLabel;
  final VoidCallback? onBack;
  final bool showHelp;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: onBack ?? () => Navigator.of(context).maybePop(),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.arrow_back, color: AppColors.blue, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    backLabel,
                    style: const TextStyle(
                      color: AppColors.blue,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (showHelp) const AppHelpActionButton(),
        ],
      ),
    );
  }
}
