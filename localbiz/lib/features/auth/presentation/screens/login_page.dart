import 'package:flutter/material.dart';

import 'package:localbiz/core/router/app_route.dart';
import 'package:localbiz/core/theme/app_colors.dart';
import 'package:localbiz/core/theme/app_design_tokens.dart';
import 'package:localbiz/core/ui/app_help_action_button.dart';
import 'package:localbiz/core/ui/app_outlined_text_field.dart';
import 'package:localbiz/features/services/presentation/screens/auth/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _authService = AuthService();
  bool _carregando = false;

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
              AppOutlinedTextField(controller: _emailController),

              const SizedBox(height: AppSpacing.sm),

              // PASSWORD LABEL
              Text(
                "Senha",
                style: AppTextStyles.fieldLabel.copyWith(fontSize: 14),
              ),

              const SizedBox(height: AppSpacing.xs),

              // PASSWORD FIELD
              AppOutlinedTextField(
                controller: _senhaController,
                obscureText: true,
              ),

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
                  onPressed: _carregando
                      ? null
                      : () async {
                          final navigator = Navigator.of(context);
                          final scaffoldMessenger = ScaffoldMessenger.of(
                            context,
                          );

                          setState(() => _carregando = true);
                          try {
                            await _authService.loginComEmail(
                              _emailController.text.trim(),
                              _senhaController.text.trim(),
                            );

                            if (!mounted) return;
                            navigator.pushNamedAndRemoveUntil(
                              AppRoute.dashboard.path,
                              (route) => false,
                            );
                          } catch (e) {
                            if(!mounted) return;

                            String messageError = "Ocorreu um erro inesperado, tente novamente mais tarde.";
                            String erroString = e.toString();
                            
                            if(erroString.contains("invalid-credential")) {
                              messageError = "E-mail ou senha inválidos";
                            }

                            scaffoldMessenger.showSnackBar(
                              SnackBar(
                                content: Text(messageError),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          } finally {
                            if (mounted) {
                              setState(() => _carregando = false);
                            }
                          }
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
                  onPressed: _carregando
                      ? null
                      : () async {
                          final navigator = Navigator.of(context);
                          final scaffoldMessenger = ScaffoldMessenger.of(
                            context,
                          );

                          setState(() => _carregando = true);
                          try {
                            await _authService.loginComGoogle();

                            if (!mounted) return;

                            navigator.pushNamedAndRemoveUntil(
                              AppRoute.dashboard.path,
                              (route) => false,
                            );
                          } catch (e) {
                            if (!mounted) return;

                            String messageError = "Ocorreu um erro inesperado.";
                            String erroString = e.toString();

                            if (erroString.contains("user-not-found")) {
                              messageError =
                                  "Nenhum usuário encontrado com este e-mail.";
                            } else if (erroString.contains("wrong-password")) {
                              messageError =
                                  "Senha incorreta. Tente novamente.";
                            } else if (erroString.contains("invalid-email")) {
                              messageError =
                                  "O formato do e-mail digitado é inválido.";
                            } else if (erroString.contains(
                              "email-already-in-use",
                            )) {
                              messageError =
                                  "Este e-mail já está cadastrado em outra conta.";
                            } else if (erroString.contains("Acesso negado")) {
                              // Captura a nossa regra de domínio do @souunit.com.br
                              messageError = erroString.replaceAll(
                                "Exception: ",
                                "",
                              );
                            }

                            scaffoldMessenger.showSnackBar(
                              SnackBar(
                                content: Text(messageError),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          } finally {
                            if (mounted) {
                              setState(() => _carregando = false);
                            }
                          }
                        },

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
