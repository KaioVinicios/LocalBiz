import 'package:flutter/material.dart';
import 'package:localbiz/theme/app_colors.dart';
import 'package:localbiz/theme/app_design_tokens.dart';

class AppListCard extends StatelessWidget {
  const AppListCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.initial,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final String initial;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSizes.contentWidth,
      height: AppSizes.clientCardHeight,
      child: Material(
        color: AppColors.clientCardBg,
        borderRadius: BorderRadius.circular(AppRadii.md),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: Row(
              children: [
                SizedBox.square(
                  dimension: AppSizes.clientAvatar,
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      color: AppColors.avatarBg,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        initial,
                        style: const TextStyle(
                          color: AppColors.avatarFg,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.clientName,
                      ),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.clientDetail,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                SizedBox.square(
                  dimension: AppSizes.clientAction,
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      color: AppColors.cardIconBg,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.chevron_right,
                      color: AppColors.textPrimary,
                      size: 32,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
