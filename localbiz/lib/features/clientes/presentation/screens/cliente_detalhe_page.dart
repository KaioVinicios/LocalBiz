import 'package:flutter/material.dart';
import 'package:localbiz/features/clientes/presentation/models/cliente_model.dart';
import 'package:localbiz/core/theme/app_colors.dart';
import 'package:localbiz/core/theme/app_design_tokens.dart';

class ClienteDetalhePage extends StatelessWidget {
  const ClienteDetalhePage({
    super.key,
    required this.cliente,
    required this.onVoltar,
    required this.onEditar,
    required this.onExcluir,
  });

  final Cliente cliente;
  final VoidCallback onVoltar;
  final VoidCallback onEditar;
  final VoidCallback onExcluir;

  @override
  Widget build(BuildContext context) {
    var inicial = cliente.nome.isEmpty ? '?' : cliente.nome[0].toUpperCase();

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: ListView(
        children: [
          _ClienteDetalheTopBar(
            onVoltar: onVoltar,
            onEditar: onEditar,
            onExcluir: onExcluir,
          ),
          const SizedBox(height: AppSpacing.lg),
          Center(
            child: SizedBox(
              width: 102,
              height: 96,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.avatarBg,
                  borderRadius: BorderRadius.circular(21),
                ),
                child: Center(
                  child: Text(
                    inicial,
                    style: const TextStyle(
                      color: AppColors.avatarFg,
                      fontSize: 42,
                      height: 1,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            cliente.nome,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 32,
              height: 1,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _ClienteInfoCard(
            icon: Icons.phone_in_talk_outlined,
            label: cliente.telefone,
          ),
          const SizedBox(height: AppSpacing.xs),
          _ClienteInfoCard(icon: Icons.mail_outline, label: cliente.email),
          const SizedBox(height: AppSpacing.lg),
          const Text(
            'Histórico',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 24,
              height: 1,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          if (cliente.historico.isEmpty)
            const _HistoricoVazio()
          else
            ...cliente.historico.map(_HistoricoClienteCard.new),
        ],
      ),
    );
  }
}

class _ClienteDetalheTopBar extends StatelessWidget {
  const _ClienteDetalheTopBar({
    required this.onVoltar,
    required this.onEditar,
    required this.onExcluir,
  });

  final VoidCallback onVoltar;
  final VoidCallback onEditar;
  final VoidCallback onExcluir;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(AppRadii.md),
          onTap: onVoltar,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.arrow_back,
                  color: AppColors.backText,
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  'VOLTAR',
                  style: AppTextStyles.backButton.copyWith(
                    fontSize: 14,
                    height: 1,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),
        ),
        const Spacer(),
        _ClienteDetalheAction(
          actionKey: const ValueKey('cliente-detail-edit-action'),
          icon: Icons.edit_outlined,
          tooltip: 'Editar cliente',
          color: AppColors.cardIconFg,
          backgroundColor: AppColors.cardIconBg,
          onTap: onEditar,
        ),
        const SizedBox(width: AppSpacing.xs),
        _ClienteDetalheAction(
          actionKey: const ValueKey('cliente-detail-delete-action'),
          icon: Icons.delete_outline,
          tooltip: 'Excluir cliente',
          color: AppColors.danger,
          backgroundColor: AppColors.dangerBg,
          onTap: onExcluir,
        ),
      ],
    );
  }
}

class _ClienteDetalheAction extends StatelessWidget {
  const _ClienteDetalheAction({
    required this.actionKey,
    required this.icon,
    required this.tooltip,
    required this.color,
    required this.backgroundColor,
    required this.onTap,
  });

  final Key actionKey;
  final IconData icon;
  final String tooltip;
  final Color color;
  final Color backgroundColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: SizedBox.square(
        key: actionKey,
        dimension: 40,
        child: Material(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(AppRadii.sm),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Icon(icon, color: color, size: 24),
          ),
        ),
      ),
    );
  }
}

class _ClienteInfoCard extends StatelessWidget {
  const _ClienteInfoCard({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.clientCardHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.clientCardBg,
          borderRadius: BorderRadius.circular(AppRadii.sm),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Row(
            children: [
              SizedBox.square(
                dimension: 32,
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    color: AppColors.cardIconBg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: AppColors.cardIconFg, size: 18),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.cardIconFg,
                    fontSize: 16,
                    height: 1,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HistoricoClienteCard extends StatelessWidget {
  const _HistoricoClienteCard(this.item);

  final ClienteHistorico item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: SizedBox(
        height: AppSizes.clientCardHeight,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.clientCardBg,
            borderRadius: BorderRadius.circular(AppRadii.sm),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.data,
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 13,
                          height: 1,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        item.servico,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.cardIconFg,
                          fontSize: 16,
                          height: 1,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  item.valor,
                  style: const TextStyle(
                    color: AppColors.cardIconFg,
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

class _HistoricoVazio extends StatelessWidget {
  const _HistoricoVazio();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.clientCardHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.clientCardBg,
          borderRadius: BorderRadius.circular(AppRadii.sm),
        ),
        child: Center(
          child: Text(
            'Nenhum atendimento registrado',
            style: AppTextStyles.clientDetail.copyWith(
              color: AppColors.textMuted,
              fontSize: 13,
              height: 1.2,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
