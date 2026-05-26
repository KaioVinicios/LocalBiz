import 'package:flutter/material.dart';
import 'package:localbiz/produtos/produto_image.dart';
import 'package:localbiz/produtos/produto_model.dart';
import 'package:localbiz/theme/app_colors.dart';
import 'package:localbiz/theme/app_design_tokens.dart';

const _editIcon = 'assets/icons/edit.png';
const _stockIcon = 'assets/icons/stock.png';
const _deleteIcon = 'assets/icons/delete.png';

class ProdutoListItem extends StatelessWidget {
  const ProdutoListItem({
    super.key,
    required this.produto,
    required this.onEditar,
    required this.onEstoque,
    required this.onExcluir,
  });

  final Produto produto;
  final VoidCallback onEditar;
  final VoidCallback onEstoque;
  final VoidCallback onExcluir;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSizes.contentWidth,
      height: 176,
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.sm),
        clipBehavior: Clip.antiAlias,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadii.sm),
            border: Border.all(color: const Color(0xFFDCE4F0)),
          ),
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProdutoImage(
                            assetPath: produto.imagemAsset,
                            memoryBytes: produto.imagemBytes,
                            width: 72,
                            height: 72,
                            borderRadius: 0,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  produto.nome,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 20,
                                    height: 1.1,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  produto.preco,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 22,
                                    height: 1,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          _CategoriaPill(label: produto.categoria),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Estoque: ${produto.estoqueAtual} unidades',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 16,
                                height: 1,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(height: 1, color: Color(0xFFE7ECF4)),
              SizedBox(
                height: 52,
                child: Row(
                  children: [
                    Expanded(
                      child: _ProdutoCardAction(
                        iconAsset: _editIcon,
                        label: 'Editar',
                        tooltip: 'Editar produto',
                        onTap: onEditar,
                      ),
                    ),
                    const VerticalDivider(width: 1, color: Color(0xFFE7ECF4)),
                    Expanded(
                      child: _ProdutoCardAction(
                        iconAsset: _stockIcon,
                        label: 'Estoque',
                        tooltip: 'Estoque do produto',
                        onTap: onEstoque,
                      ),
                    ),
                    const VerticalDivider(width: 1, color: Color(0xFFE7ECF4)),
                    Expanded(
                      child: _ProdutoCardAction(
                        iconAsset: _deleteIcon,
                        label: 'Excluir',
                        tooltip: 'Excluir produto',
                        color: AppColors.danger,
                        onTap: onExcluir,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoriaPill extends StatelessWidget {
  const _CategoriaPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4FF),
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Text(
          label,
          style: const TextStyle(
            color: AppColors.blue,
            fontSize: 14,
            height: 1,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _ProdutoCardAction extends StatelessWidget {
  const _ProdutoCardAction({
    required this.iconAsset,
    required this.label,
    required this.tooltip,
    required this.onTap,
    this.color = AppColors.backText,
  });

  final String iconAsset;
  final String label;
  final String tooltip;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(iconAsset, width: 20, height: 20),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 15,
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
