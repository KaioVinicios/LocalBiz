import 'package:flutter/material.dart';

import 'package:localbiz/core/theme/app_colors.dart';
import 'package:localbiz/core/theme/app_design_tokens.dart';
import 'package:localbiz/core/ui/app_outlined_text_field.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,

      body: SafeArea(
        child: Column(
          children: [
            // HEADER IMAGE
            Container(
              width: double.infinity,
              height: 220,
              color: const Color(0xFFD9DDE3),

              child: Center(
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.45),
                      width: 6,
                    ),
                  ),

                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CustomPaint(painter: _XPlaceholderPainter()),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.lg,
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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

                          SizedBox(width: 8),

                          Text(
                            "VOLTAR PARA LOGIN",
                            style: AppTextStyles.backButton,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 48),

                    // TITLE
                    const Text(
                      "Esqueceu sua\nsenha?",
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 30,
                        height: 1.05,
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // DESCRIPTION
                    const Text(
                      "Não se preocupe! Insira seu e-mail\n"
                      "cadastrado abaixo para receber um link de\n"
                      "redefinição de senha com segurança.",
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        height: 1.7,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: AppRadii.sheet),

                    // LABEL
                    const Text(
                      "E-MAIL DE CADASTRO",
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                        letterSpacing: 1.8,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 14),

                    // INPUT
                    AppOutlinedTextField(
                      textStyle: AppTextStyles.fieldText.copyWith(fontSize: 16),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 18,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.sm),

                    // BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: AppSizes.primaryButtonHeight,

                      child: ElevatedButton(
                        onPressed: () {},

                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: AppColors.blue,

                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),

                        child: Text(
                          "Enviar Link de Recuperação",
                          style: AppTextStyles.primaryButton.copyWith(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    Divider(
                      color: AppColors.dangerBg, // Cor da linha
                      thickness: 1,
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // SUPPORT
                    Center(
                      child: RichText(
                        textAlign: TextAlign.center,

                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                            height: 1.6,
                          ),

                          children: [
                            TextSpan(
                              text: "Ainda tendo problemas? ",
                              style: TextStyle(fontSize: 14),
                            ),

                            TextSpan(
                              text: "Fale com\no Suporte",
                              style: TextStyle(
                                color: AppColors.backText,
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _XPlaceholderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.35)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset.zero, Offset(size.width, size.height), paint);

    canvas.drawLine(Offset(size.width, 0), Offset(0, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
