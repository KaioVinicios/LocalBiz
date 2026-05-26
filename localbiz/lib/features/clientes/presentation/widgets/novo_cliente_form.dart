import 'package:flutter/material.dart';
import 'package:localbiz/core/theme/app_colors.dart';
import 'package:localbiz/core/theme/app_design_tokens.dart';
import 'package:localbiz/core/ui/app_primary_button.dart';
import 'package:localbiz/core/ui/app_text_field.dart';

const _campoAltura = 48.0;

class NovoClienteForm extends StatelessWidget {
  const NovoClienteForm({
    super.key,
    this.title = 'Novo Cliente',
    required this.nomeController,
    required this.telefoneController,
    required this.emailController,
    required this.onFechar,
    required this.onSalvar,
  });

  final String title;
  final TextEditingController nomeController;
  final TextEditingController telefoneController;
  final TextEditingController emailController;
  final VoidCallback onFechar;
  final VoidCallback onSalvar;

  @override
  Widget build(BuildContext context) {
    var bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    var labelStyle = const TextStyle(
      color: AppColors.blue,
      fontSize: 14,
      height: 1,
      fontWeight: FontWeight.w700,
    );
    var fieldStyle = AppTextStyles.fieldText.copyWith(fontSize: 16);
    var hintStyle = AppTextStyles.fieldHint.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w500,
    );
    var availableHeight =
        MediaQuery.sizeOf(context).height -
        MediaQuery.paddingOf(context).top -
        AppSpacing.md;
    var targetHeight = AppSizes.clientFormHeight + bottomInset;
    var sheetHeight = targetHeight > availableHeight
        ? availableHeight
        : targetHeight;

    return Material(
      color: Colors.transparent,
      child: SizedBox(
        key: const ValueKey('novo-cliente-form-sheet'),
        width: double.infinity,
        height: sheetHeight,
        child: Container(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.sm + bottomInset,
          ),
          decoration: const BoxDecoration(
            color: AppColors.sheetSurface,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppRadii.sheet),
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x22000000),
                blurRadius: 26,
                offset: Offset(0, -8),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: AppSizes.sheetHandleWidth,
                    height: AppSizes.sheetHandleHeight,
                    decoration: BoxDecoration(
                      color: AppColors.blue,
                      borderRadius: BorderRadius.circular(AppRadii.sm),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: AppTextStyles.sheetTitle.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Tooltip(
                      message: 'Fechar',
                      child: SizedBox.square(
                        dimension: 40,
                        child: Material(
                          color: AppColors.avatarBg.withValues(alpha: 0.22),
                          shape: const CircleBorder(),
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            onTap: onFechar,
                            child: const Icon(
                              Icons.close,
                              color: AppColors.avatarFg,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                AppTextField(
                  label: 'Nome*',
                  hint: 'Ex: Maria Silva',
                  controller: nomeController,
                  textInputAction: TextInputAction.next,
                  height: _campoAltura,
                  radius: AppRadii.sm,
                  labelGap: 4,
                  labelStyle: labelStyle,
                  textStyle: fieldStyle,
                  hintStyle: hintStyle,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                const SizedBox(height: AppSpacing.xs),
                AppTextField(
                  label: 'Telefone',
                  hint: '(00) 00000-0000',
                  controller: telefoneController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  height: _campoAltura,
                  radius: AppRadii.sm,
                  labelGap: 4,
                  labelStyle: labelStyle,
                  textStyle: fieldStyle,
                  hintStyle: hintStyle,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                const SizedBox(height: AppSpacing.xs),
                AppTextField(
                  label: 'E-mail',
                  hint: 'email@exemplo.com',
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  height: _campoAltura,
                  radius: AppRadii.sm,
                  labelGap: 4,
                  labelStyle: labelStyle,
                  textStyle: fieldStyle,
                  hintStyle: hintStyle,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                const SizedBox(height: AppSpacing.xs),
                AppPrimaryButton(
                  label: 'Salvar Cliente',
                  onPressed: onSalvar,
                  height: _campoAltura,
                  radius: AppRadii.sm,
                  textStyle: AppTextStyles.primaryButton.copyWith(
                    fontSize: 16,
                    height: 1,
                    fontWeight: FontWeight.w700,
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
