import 'package:flutter/material.dart';
import 'package:localbiz/core/theme/app_colors.dart';
import 'package:localbiz/core/ui/app_help_action_button.dart';
import 'package:localbiz/core/ui/labeled_fields.dart';
import 'package:localbiz/features/produtos/domain/entities/produto_model.dart';
import 'package:localbiz/features/produtos/presentation/widgets/produto_image.dart';

enum MovimentoEstoque { entrada, saida }

class ProdutoEstoquePage extends StatelessWidget {
  const ProdutoEstoquePage({
    super.key,
    required this.produto,
    required this.movimento,
    required this.quantidadeController,
    required this.estoqueLocal,
    required this.estoques,
    required this.onMovimentoChanged,
    required this.onEstoqueChanged,
    required this.onVoltar,
    required this.onConcluir,
  });

  final Produto produto;
  final MovimentoEstoque movimento;
  final TextEditingController quantidadeController;
  final String estoqueLocal;
  final List<String> estoques;
  final ValueChanged<MovimentoEstoque> onMovimentoChanged;
  final ValueChanged<String?> onEstoqueChanged;
  final VoidCallback onVoltar;
  final VoidCallback onConcluir;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _TopBar(onVoltar: onVoltar),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Estoque',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 32,
                        height: 1,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Divider(color: AppColors.textSecondary),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        '${produto.estoqueAtual} unidades',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                Text(
                  produto.nome,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 18,
                    height: 1.25,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Cod.:${produto.codigoBarras}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 18,
                    height: 1.25,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 28),
                Center(
                  child: ProdutoImage(
                    assetPath: produto.imagemAsset,
                    memoryBytes: produto.imagemBytes,
                    networkUrl: produto.imagemUrl,
                    width: 148,
                    height: 190,
                  ),
                ),
                const SizedBox(height: 34),
                _MovimentoSegmentedControl(
                  movimento: movimento,
                  onChanged: onMovimentoChanged,
                ),
                const SizedBox(height: 24),
                LabeledTextField(
                  label: 'Quantidade',
                  hint: '',
                  controller: quantidadeController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                LabeledDropdown(
                  label: 'Estoque',
                  value: estoqueLocal,
                  items: estoques,
                  onChanged: onEstoqueChanged,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: FormSubmitButton(label: 'Concluir', onPressed: onConcluir),
        ),
      ],
    );
  }
}

class _MovimentoSegmentedControl extends StatelessWidget {
  const _MovimentoSegmentedControl({
    required this.movimento,
    required this.onChanged,
  });

  final MovimentoEstoque movimento;
  final ValueChanged<MovimentoEstoque> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.fieldFill,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Row(
            children: [
              Expanded(
                child: _SegmentOption(
                  label: 'Entrada',
                  selected: movimento == MovimentoEstoque.entrada,
                  onTap: () => onChanged(MovimentoEstoque.entrada),
                ),
              ),
              Expanded(
                child: _SegmentOption(
                  label: 'Saída',
                  selected: movimento == MovimentoEstoque.saida,
                  onTap: () => onChanged(MovimentoEstoque.saida),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SegmentOption extends StatelessWidget {
  const _SegmentOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.surface : Colors.transparent,
      borderRadius: BorderRadius.circular(7),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: selected ? AppColors.blue : AppColors.backText,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onVoltar});

  final VoidCallback onVoltar;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          InkWell(
            onTap: onVoltar,
            borderRadius: BorderRadius.circular(8),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Row(
                children: [
                  Icon(Icons.arrow_back, size: 20, color: AppColors.backText),
                  SizedBox(width: 8),
                  Text(
                    'VOLTAR',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: AppColors.backText,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          const AppHelpActionButton(),
        ],
      ),
    );
  }
}
