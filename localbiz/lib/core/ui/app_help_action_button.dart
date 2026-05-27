import 'package:flutter/material.dart';
import 'package:localbiz/core/theme/app_colors.dart';

class AppHelpActionButton extends StatelessWidget {
  const AppHelpActionButton({
    super.key,
    this.onPressed,
    this.tooltip = 'Ajuda',
  });

  final VoidCallback? onPressed;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    final button = Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(
        Icons.help_outline,
        color: AppColors.textPrimary,
        size: 20,
      ),
    );

    final child = onPressed == null
        ? button
        : Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onPressed,
              borderRadius: BorderRadius.circular(10),
              child: button,
            ),
          );

    return Tooltip(message: tooltip, child: child);
  }
}
