import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localbiz/theme/app_colors.dart';
import 'package:localbiz/theme/app_design_tokens.dart';

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

  double get _total => itens.fold(0, (acc, i) => acc + i.preco * i.quantidade);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: onFechar,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Container(color: Colors.black.withValues(alpha: 0.25)),
          ),
        ),

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
                  Container(
                    width: AppSizes.sheetHandleWidth,
                    height: AppSizes.sheetHandleHeight,
                    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: const Color(0xFF043DAE),
                      borderRadius: BorderRadius.circular(
                        AppSizes.sheetHandleHeight,
                      ),
                    ),
                  ),

                  Row(
                    children: [
                      Text(
                        'Carrinho',
                        style: AppTextStyles.sheetTitle.copyWith(
                          color: const Color(0xFF2B1A49),
                        ),
                      ),
                      const Spacer(),
                      _CloseButton(onTap: onFechar),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.sm),

                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.35,
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: itens.length,
                      separatorBuilder: (_, index) => const SizedBox.shrink(),
                      itemBuilder: (context, i) => _CarrinhoItemRow(
                        item: itens[i],
                        onIncrement: () => onIncrement(i),
                        onDecrement: () => onDecrement(i),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xs),
                  const SizedBox(height: AppSpacing.xs),

                  _CarrinhoFooter(total: _total, onCobrar: onCobrar),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

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
        decoration: const BoxDecoration(
          color: Color(0x1A65558F),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: const Icon(Icons.close, size: 16, color: Color(0xFF65558F)),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.nome,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: Color(0xFF0A2463),
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
                          color: Color(0xCC0A2463),
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
                          color: Color(0xFF0A2463),
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
        color: const Color(0xFFD3E9FE),
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
                color: Color(0xFF043DAE),
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
        child: Icon(icon, size: 16, color: const Color(0xFF698CD1)),
      ),
    );
  }
}

class _CarrinhoFooter extends StatelessWidget {
  const _CarrinhoFooter({required this.total, required this.onCobrar});

  final double total;
  final VoidCallback onCobrar;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: const Color(0xFF043DAE),
        borderRadius: BorderRadius.circular(AppRadii.md),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Total da venda',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Color(0xCCFFFFFF),
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
                        color: Color(0xB3FFFFFF),
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    TextSpan(
                      text: total.toStringAsFixed(2).replaceAll('.', ','),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: Color(0xFFFFFFFF),
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const Spacer(),

          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 135),
            child: SizedBox(
              height: 56,
              child: ElevatedButton.icon(
                onPressed: onCobrar,
                icon: SvgPicture.asset(
                  'assets/icons/money-receive-01.svg',
                  width: 22,
                  height: 22,
                ),
                label: const Text(
                  'Cobrar',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Color(0xFF043DAE),
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD3E9FE),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  iconSize: 22,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
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
