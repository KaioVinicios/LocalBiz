import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:localbiz/theme/app_colors.dart';
import 'package:localbiz/theme/app_design_tokens.dart';
import 'package:localbiz/widgets/app_primary_button.dart';

// ---------------------------------------------------------------------------
// Model (re-exportado para quem importar este arquivo)
// ---------------------------------------------------------------------------

class CarrinhoItemData {
  CarrinhoItemData({
    required this.nome,
    required this.preco,
    required this.quantidade,
  });

  final String nome;
  final double preco;
  final int quantidade;
}

// ---------------------------------------------------------------------------
// AppCartMenu
// ---------------------------------------------------------------------------

/// Menu do carrinho de venda.
///
/// Renderize-o dentro de um [Stack] acima do conteúdo principal e do FAB
/// para que fique por cima de ambos.
///
/// Parâmetros:
///   [itens]          — lista de itens no carrinho
///   [onFechar]       — chamado ao tocar no X ou no backdrop
///   [onIncrement]    — chamado ao tocar em "+" de um item (recebe o índice)
///   [onDecrement]    — chamado ao tocar em "-" de um item (recebe o índice)
///   [onCobrar]       — chamado ao tocar em "Cobrar"
class AppCartMenu extends StatelessWidget {
  const AppCartMenu({
    super.key,
    required this.itens,
    required this.onFechar,
    required this.onIncrement,
    required this.onDecrement,
    required this.onCobrar,
  });

  final List<CarrinhoItemData> itens;
  final VoidCallback onFechar;
  final ValueChanged<int> onIncrement;
  final ValueChanged<int> onDecrement;
  final VoidCallback onCobrar;

  double get _total =>
      itens.fold(0, (acc, i) => acc + i.preco * i.quantidade);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ── Backdrop com blur ─────────────────────────────────────────────
        GestureDetector(
          onTap: onFechar,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Container(color: Colors.black.withOpacity(0.25)),
          ),
        ),

        // ── Sheet ─────────────────────────────────────────────────────────
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.sheetSurface,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppRadii.sheet),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.sm,
              AppSpacing.sm,
              AppSpacing.sm,
              AppSpacing.sm,
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle
                  Container(
                    width: AppSizes.sheetHandleWidth,
                    height: AppSizes.sheetHandleHeight,
                    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.divider,
                      borderRadius: BorderRadius.circular(
                        AppSizes.sheetHandleHeight,
                      ),
                    ),
                  ),

                  // Título + fechar
                  Row(
                    children: [
                      Text('Carrinho', style: AppTextStyles.sheetTitle),
                      const Spacer(),
                      _CloseButton(onTap: onFechar),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.sm),

                  // Lista de itens
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight:
                          MediaQuery.of(context).size.height * 0.35,
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: itens.length,
                      separatorBuilder: (_, __) =>
                          const Divider(color: AppColors.divider, height: 1),
                      itemBuilder: (context, i) => _CarrinhoItemRow(
                        item: itens[i],
                        onIncrement: () => onIncrement(i),
                        onDecrement: () => onDecrement(i),
                      ),
                    ),
                  ),

                  const Divider(color: AppColors.divider),
                  const SizedBox(height: AppSpacing.xs),

                  // Footer: total + cobrar
                  _CarrinhoFooter(
                    total: _total,
                    onCobrar: onCobrar,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Sub-widgets privados
// ---------------------------------------------------------------------------

class _CloseButton extends StatelessWidget {
  const _CloseButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.fieldFill,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.close,
          size: 18,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _CarrinhoItemRow extends StatelessWidget {
  const _CarrinhoItemRow({
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
  });

  final CarrinhoItemData item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          // Nome + preço
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.nome,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'R\$',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: AppColors.textPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      TextSpan(
                        text: item.preco
                            .toStringAsFixed(2)
                            .replaceAll('.', ','),
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Controle de quantidade
          _QtyControl(
            quantidade: item.quantidade,
            onIncrement: onIncrement,
            onDecrement: onDecrement,
          ),
        ],
      ),
    );
  }
}

class _QtyControl extends StatelessWidget {
  const _QtyControl({
    required this.quantidade,
    required this.onIncrement,
    required this.onDecrement,
  });

  final int quantidade;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _QtyButton(icon: Icons.remove, onTap: onDecrement),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              '$quantidade',
              style: const TextStyle(
                fontFamily: 'Poppins',
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          _QtyButton(icon: Icons.add, onTap: onIncrement),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  const _QtyButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 32,
        height: 32,
        child: Icon(icon, size: 16, color: AppColors.textSecondary),
      ),
    );
  }
}

class _CarrinhoFooter extends StatelessWidget {
  const _CarrinhoFooter({
    required this.total,
    required this.onCobrar,
  });

  final double total;
  final VoidCallback onCobrar;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.blue,
        borderRadius: BorderRadius.circular(AppRadii.md),
      ),
      child: Row(
        children: [
          // Total da venda
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Total da venda',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'R\$',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    TextSpan(
                      text: total
                          .toStringAsFixed(2)
                          .replaceAll('.', ','),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(width: AppSpacing.sm),

          // Botão Cobrar
          Expanded(
            child: SizedBox(
              height: AppSizes.primaryButtonHeight,
              child: ElevatedButton.icon(
                onPressed: onCobrar,
                icon: const Icon(
                  Icons.storefront_outlined,
                  color: AppColors.blue,
                  size: 22,
                ),
                label: const Text(
                  'Cobrar',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: AppColors.blue,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadii.sm),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}