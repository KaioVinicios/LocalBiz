import 'package:flutter/material.dart';
import 'package:localbiz/features/clientes/presentation/models/cliente_model.dart';
import 'package:localbiz/core/theme/app_colors.dart';
import 'package:localbiz/core/theme/app_design_tokens.dart';

class ClienteListItem extends StatelessWidget {
  const ClienteListItem({super.key, required this.cliente, this.onTap});

  final Cliente cliente;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    var inicial = cliente.nome.isEmpty ? '?' : cliente.nome[0].toUpperCase();

    return _ClienteCard(
      key: ValueKey('cliente-card-${cliente.nome}'),
      nome: cliente.nome,
      telefone: cliente.telefone,
      inicial: inicial,
      onTap: onTap,
    );
  }
}

class _ClienteCard extends StatelessWidget {
  const _ClienteCard({
    super.key,
    required this.nome,
    required this.telefone,
    required this.inicial,
    required this.onTap,
  });

  final String nome;
  final String telefone;
  final String inicial;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    var nomeStyle = AppTextStyles.clientName.copyWith(
      color: AppColors.cardIconFg,
      fontSize: 16,
      height: 1,
      fontWeight: FontWeight.w700,
    );
    var telefoneStyle = AppTextStyles.clientDetail.copyWith(
      color: AppColors.textMuted,
      fontSize: 13,
      height: 1.2,
      fontWeight: FontWeight.w500,
    );

    return SizedBox(
      width: AppSizes.contentWidth,
      height: AppSizes.clientCardHeight,
      child: Material(
        color: AppColors.clientCardBg,
        borderRadius: BorderRadius.circular(AppRadii.sm),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                SizedBox.square(
                  dimension: 36,
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      color: AppColors.avatarBg,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        inicial,
                        style: const TextStyle(
                          color: AppColors.avatarFg,
                          fontSize: 16,
                          height: 1,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nome,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: nomeStyle,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        telefone,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: telefoneStyle,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox.square(
                  dimension: 40,
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      color: AppColors.cardIconBg,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.chevron_right,
                      color: AppColors.cardIconFg,
                      size: 26,
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
