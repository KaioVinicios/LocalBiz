import 'package:flutter/material.dart';

import 'package:localbiz/core/theme/app_colors.dart';
import 'package:localbiz/core/theme/app_design_tokens.dart';
import 'package:localbiz/core/ui/app_help_action_button.dart';
import 'package:localbiz/core/ui/app_outlined_text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _acceptedTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,

      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,

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
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,

          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),

          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppSizes.contentWidth,
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,

                children: [
                  const SizedBox(height: AppSpacing.sm),

                  // BACK BUTTON
                  InkWell(
                    onTap: () => Navigator.pop(context),

                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.arrow_back,
                          size: 18,
                          color: AppColors.backText,
                        ),

                        SizedBox(width: AppSpacing.xs),

                        Text(
                          "VOLTAR PARA LOGIN",
                          style: AppTextStyles.backButton,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.sm),

                  // TITLE
                  const Text(
                    "Crie sua conta\nno LocalBiz",

                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      height: 1.15,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // DESCRIPTION
                  const Text(
                    "Preencha os dados abaixo para começar "
                    "a expandir sua presença local.",

                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: AppSpacing.sm,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // NAME
                  Text(
                    "Nome Completo",
                    style: AppTextStyles.fieldLabel.copyWith(fontSize: 14),
                  ),

                  const SizedBox(height: AppSpacing.xs),

                  const AppOutlinedTextField(),

                  const SizedBox(height: AppSpacing.sm),

                  // BUSINESS
                  Text(
                    "Nome do Negócio",
                    style: AppTextStyles.fieldLabel.copyWith(fontSize: 14),
                  ),

                  const SizedBox(height: AppSpacing.xs),

                  const AppOutlinedTextField(),

                  const SizedBox(height: AppSpacing.sm),

                  // EMAIL
                  Text(
                    "E-mail",
                    style: AppTextStyles.fieldLabel.copyWith(fontSize: 14),
                  ),

                  const SizedBox(height: AppSpacing.xs),

                  const AppOutlinedTextField(
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: AppSpacing.sm),

                  // PHONE
                  Text(
                    "Telefone",
                    style: AppTextStyles.fieldLabel.copyWith(fontSize: 14),
                  ),

                  const SizedBox(height: AppSpacing.xs),

                  const AppOutlinedTextField(keyboardType: TextInputType.phone),

                  const SizedBox(height: AppSpacing.sm),

                  // PASSWORD
                  Text(
                    "Senha",
                    style: AppTextStyles.fieldLabel.copyWith(fontSize: 14),
                  ),

                  const SizedBox(height: AppSpacing.xs),

                  const AppOutlinedTextField(obscureText: true),

                  const SizedBox(height: AppSpacing.md),

                  // TERMS
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,

                        child: Checkbox(
                          value: _acceptedTerms,

                          side: const BorderSide(
                            color: AppColors.divider,
                            width: 1.5,
                          ),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadii.sm),
                          ),

                          activeColor: AppColors.blue,

                          onChanged: (value) {
                            setState(() {
                              _acceptedTerms = value ?? false;
                            });
                          },
                        ),
                      ),

                      const SizedBox(width: 12),

                      const Expanded(
                        child: Text.rich(
                          TextSpan(
                            text: "Li e concordo com os ",

                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                            ),

                            children: [
                              TextSpan(
                                text: "Termos de Uso",

                                style: TextStyle(
                                  color: AppColors.backText,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14,
                                ),
                              ),

                              TextSpan(
                                text: " e ",
                                style: TextStyle(fontSize: 14),
                              ),

                              TextSpan(
                                text: "Políticas ",

                                style: TextStyle(
                                  color: AppColors.backText,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14,
                                ),
                              ),

                              TextSpan(
                                text: "de Privacidade",
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ),
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),

          child: SizedBox(
            height: AppSizes.primaryButtonHeight,

            child: ElevatedButton(
              onPressed: _acceptedTerms ? () {} : null,

              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: AppColors.blue,
                disabledBackgroundColor: AppColors.textMuted.withValues(
                  alpha: 0.4,
                ),

                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),

              child: Text(
                "Criar Conta",
                style: AppTextStyles.primaryButton.copyWith(
                  fontSize: AppRadii.md,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
