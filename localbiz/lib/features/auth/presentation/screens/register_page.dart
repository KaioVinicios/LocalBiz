import 'package:flutter/material.dart';

import 'package:localbiz/core/router/app_route.dart';
import 'package:localbiz/core/theme/app_colors.dart';
import 'package:localbiz/core/theme/app_design_tokens.dart';
import 'package:localbiz/core/ui/app_help_action_button.dart';
import 'package:localbiz/core/ui/app_outlined_text_field.dart';
import 'package:localbiz/features/services/presentation/screens/auth/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _acceptedTerms = false;
  bool _carregando = false;

  final _nomeController = TextEditingController();
  final _negocioController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _senhaController = TextEditingController();

  final _authService = AuthService();

  @override
  void dispose() {
    _nomeController.dispose();
    _negocioController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

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
          primary: false,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.sm),
              InkWell(
                onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoute.login.path,
                  (route) => false,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.arrow_back, size: 18, color: AppColors.backText),
                    SizedBox(width: AppSpacing.xs),
                    Text("VOLTAR PARA LOGIN", style: AppTextStyles.backButton),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
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
              Text(
                "Nome Completo",
                style: AppTextStyles.fieldLabel.copyWith(fontSize: 14),
              ),
              const SizedBox(height: AppSpacing.xs),
              const AppOutlinedTextField(),
              const SizedBox(height: AppSpacing.sm),
              Text(
                "Nome do Negócio",
                style: AppTextStyles.fieldLabel.copyWith(fontSize: 14),
              ),
              const SizedBox(height: AppSpacing.xs),
              const AppOutlinedTextField(),
              const SizedBox(height: AppSpacing.sm),
              Text(
                "E-mail",
                style: AppTextStyles.fieldLabel.copyWith(fontSize: 14),
              ),
              const SizedBox(height: AppSpacing.xs),
              AppOutlinedTextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                "Telefone",
                style: AppTextStyles.fieldLabel.copyWith(fontSize: 14),
              ),
              const SizedBox(height: AppSpacing.xs),
              const AppOutlinedTextField(keyboardType: TextInputType.phone),
              const SizedBox(height: AppSpacing.sm),
              Text(
                "Senha",
                style: AppTextStyles.fieldLabel.copyWith(fontSize: 14),
              ),
              const SizedBox(height: AppSpacing.xs),
              AppOutlinedTextField(
                controller: _senhaController,
                obscureText: true,
              ),
              const SizedBox(height: AppSpacing.md),
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
                          TextSpan(text: " e ", style: TextStyle(fontSize: 14)),
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
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                height: AppSizes.primaryButtonHeight,
                child: ElevatedButton(
                  onPressed: (_acceptedTerms && !_carregando)
                      ? () async {
                          final navigator = Navigator.of(context);
                          final scaffoldMessenger = ScaffoldMessenger.of(
                            context,
                          );

                          setState(() => _carregando = true);
                          try {
                            // Executa a regra de negócio do domínio instituída no AuthService
                            await _authService.cadastrarComEmail(
                              email: _emailController.text.trim(),
                              password: _senhaController.text.trim(),
                              nomeCompleto: _nomeController.text.trim(),
                              nomeNegocio: _negocioController.text.trim(),
                              telefone: _telefoneController.text.trim(),
                            );

                            if (!mounted) return;
                            navigator.pushNamedAndRemoveUntil(
                              AppRoute.dashboard.path,
                              (route) => false,
                            );
                          } catch (e) {
                            if (!mounted) return;
                            String messageError = "Ocorreu um erro inesperado.";
                            String erroString = e.toString();
                            
                            if (erroString.contains("invalid-email")) {
                              messageError = "O formato do e-mail digitado é inválido.";
                            } else if (erroString.contains("email-already-in-use")) {
                              messageError = "Este e-mail já está cadastrado em outra conta.";
                            } else if (erroString.contains("Acesso negado")) {
                              // Captura a nossa regra de domínio do @souunit.com.br
                              messageError = erroString.replaceAll("Exception: ", "");
                            } else if (erroString.contains("Apenas e-mails @souunit.com.br são permitidos.")) {
                              messageError = erroString.replaceAll("Exception: ", "");
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
                        }
                      : null,
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
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}
