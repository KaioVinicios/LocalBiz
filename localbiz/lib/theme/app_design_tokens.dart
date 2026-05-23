import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppSpacing {
  AppSpacing._();

  static const double xs = 8;
  static const double sm = 16;
  static const double md = 24;
  static const double lg = 32;
}

class AppRadii {
  AppRadii._();

  static const double sm = 8;
  static const double md = 16;
  static const double pill = 54;
  static const double sheet = 54;
}

class AppSizes {
  AppSizes._();

  static const double screenMaxWidth = 428;
  static const double contentWidth = 380;
  static const double searchHeight = 80;
  static const double inputHeight = 64;
  static const double clientCardHeight = 64;
  static const double clientAvatar = 48;
  static const double clientAction = 48;
  static const double squareAction = 64;
  static const double primaryButtonHeight = 64;
  static const double clientFormHeight = 449;
  static const double sheetHandleWidth = 44;
  static const double sheetHandleHeight = 4;
}

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle pageTitle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 42,
    fontWeight: FontWeight.w900,
  );

  static const TextStyle sheetTitle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 30,
    height: 1,
    fontWeight: FontWeight.w900,
  );

  static const TextStyle backButton = TextStyle(
    color: AppColors.backText,
    fontSize: 16,
    fontWeight: FontWeight.w900,
  );

  static const TextStyle clientName = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 21,
    fontWeight: FontWeight.w900,
  );

  static const TextStyle clientDetail = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle fieldLabel = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 18,
    height: 1,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle fieldText = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 20,
    height: 1,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle fieldHint = TextStyle(
    color: AppColors.textMuted,
    fontSize: 20,
    height: 1,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle primaryButton = TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.w900,
  );
}
