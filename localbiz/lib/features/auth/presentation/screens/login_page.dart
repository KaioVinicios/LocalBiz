import 'package:flutter/material.dart';

import 'package:localbiz/core/router/app_route.dart';
import 'package:localbiz/core/theme/app_colors.dart';
import 'package:localbiz/core/theme/app_design_tokens.dart';
import 'package:localbiz/core/ui/app_help_action_button.dart';
import 'package:localbiz/core/ui/app_outlined_text_field.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,

      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,

        title: Padding(
          padding: const EdgeInsets.only(top: AppSpacing.sm),

          child: Text(
            "LocalBiz",

            style: TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w900,
              fontSize: 18,
            ),
          ),
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(
              top: AppSpacing.sm,
              right: AppSpacing.sm,
            ),
            child: AppHelpActionButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Ajuda ainda não implementada")),
                );
              },
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,

            children: [
              const SizedBox(height: AppSpacing.xs),

              // TITLE
              const Text(
                "Entrar",
                textAlign: TextAlign.center,

                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: AppSpacing.xs),

              // SUBTITLE
              const Text(
                "Bem-vindo de volta ao seu comércio local",
                textAlign: TextAlign.center,

                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: AppRadii.sheet),

              // EMAIL LABEL
              Text(
                "E-mail/Empresa",
                style: AppTextStyles.fieldLabel.copyWith(fontSize: 14),
              ),

              const SizedBox(height: AppSpacing.xs),

              // EMAIL FIELD
              const AppOutlinedTextField(),

              const SizedBox(height: AppSpacing.sm),

              // PASSWORD LABEL
              Text(
                "Senha",
                style: AppTextStyles.fieldLabel.copyWith(fontSize: 14),
              ),

              const SizedBox(height: AppSpacing.xs),

              // PASSWORD FIELD
              const AppOutlinedTextField(obscureText: true),

              const SizedBox(height: AppSpacing.sm),

              // FORGOT PASSWORD
              Align(
                alignment: Alignment.centerRight,

                child: TextButton(
                  onPressed: () {
                    Navigator.of(
                      context,
                    ).pushNamed(AppRoute.forgotPassword.path);
                  },

                  child: const Text(
                    "Esqueci minha senha",

                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // LOGIN BUTTON
              SizedBox(
                height: AppSizes.primaryButtonHeight,

                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoute.dashboard.path,
                      (route) => false,
                    );
                  },

                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: AppColors.blue,

                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),

                  child: Text(
                    "Entrar",
                    style: AppTextStyles.primaryButton.copyWith(fontSize: 18),
                  ),
                ),
              ),

              const SizedBox(height: AppRadii.sheet),

              // REGISTER
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const Text(
                    "Não tenho conta",

                    style: TextStyle(
                      color: AppColors.backText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRoute.register.path);
                    },

                    child: const Text(
                      " cadastrar",

                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppRadii.sheet),

              // DIVIDER
              Row(
                children: [
                  const Expanded(child: Divider(color: AppColors.divider)),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),

                    child: Text(
                      "OU ENTRE COM",

                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                  ),

                  const Expanded(child: Divider(color: AppColors.divider)),
                ],
              ),

              const SizedBox(height: AppSpacing.lg),

              // GOOGLE BUTTON
              SizedBox(
                height: AppRadii.pill,

                child: OutlinedButton(
                  onPressed: () {},

                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.divider),

                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),

                  child: const Text(
                    "Google",

                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppRadii.sheet),

              // FOOTER
              const Text(
                "© 2024 LocalBiz. Todos os direitos reservados.",
                textAlign: TextAlign.center,

                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}
