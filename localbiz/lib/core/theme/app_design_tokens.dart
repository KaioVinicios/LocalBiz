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

class AppColorTokens {
  AppColorTokens._();

  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color transparent = Color(0x00000000);
  static const Color black = Color(0xFF000000);
  static const Color shadowBlack04 = Color(0x0A000000);
  static const Color shadowBlack06 = Color(0x0F000000);

  static const Color primaryBlue10 = Color(0x1A043DAE);
  static const Color primaryBlue20 = Color(0x33043DAE);
  static const Color primaryBlue26 = Color(0x42043DAE);
  static const Color primaryBlue50 = Color(0x80043DAE);
  static const Color primaryBlue83 = Color(0xD4043DAE);

  static const Color slate900 = Color(0xFF0F172A);
  static const Color slate700 = Color(0xFF334155);
  static const Color slate600 = Color(0xFF475569);
  static const Color slate500 = Color(0xFF5C677D);
  static const Color slate300 = Color(0xFFDDE1E6);
  static const Color slate200 = Color(0xFFE2E8F0);
  static const Color slate100 = Color(0xFFF1F5F9);
  static const Color slate50 = Color(0xFFEDF2F7);
  static const Color formInputFill = Color(0x4DF8FAFC);

  static const Color dashboardPurple = Color(0xFF2B1A49);
  static const Color dashboardGreeting = Color(0xFF79747E);
  static const Color dashboardActionText = Color(0xFF4A4459);
  static const Color dashboardNavText = Color(0xFF49454F);
  static const Color inventoryText = Color(0xFF183D8C);
  static const Color inventoryPillText = Color(0xFF182F8C);
  static const Color inventoryPillBg = Color(0xFFDCE8F9);

  static const Color white80 = Color(0xCCFFFFFF);
  static const Color white65 = Color(0xA6FFFFFF);
  static const Color white62 = Color(0x9EFFFFFF);
  static const Color white60 = Color(0x99FFFFFF);

  static const Color serviceHeroDark = Color(0xFF211C1D);
  static const Color serviceHeroLight = Color(0xFFF2D3BE);
  static const Color serviceHeroAccent = Color(0xFF8A5A3F);
  static const Color serviceHeroSkin = Color(0xFFF6D7C3);
  static const Color serviceHeroSkinShade = Color(0xFFF9CDB5);
  static const Color serviceHeroHair = Color(0xFF6D3E2E);
  static const Color serviceHeroTool = Color(0xFF2B1A14);
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
    color: AppColorTokens.surfaceWhite,
    fontSize: 20,
    fontWeight: FontWeight.w900,
  );
}
