import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:localbiz/theme/app_colors.dart';
import 'package:localbiz/theme/app_design_tokens.dart';
import 'package:localbiz/widgets/app_primary_button.dart';
import 'package:localbiz/widgets/app_search_bar.dart';
import 'package:localbiz/widgets/app_product_card.dart';
import 'package:localbiz/widgets/app_fab_sell_button.dart';
import 'package:localbiz/widgets/app_cart_menu.dart';

// ---------------------------------------------------------------------------
// Model
// ---------------------------------------------------------------------------

class Produto {
  Produto({
    required this.nome,
    required this.preco,
    required this.emEstoque,
  });

  final String nome;
  final double preco;
  final bool emEstoque;
}

class ItemCarrinho {
  ItemCarrinho({required this.produto, this.quantidade = 1});

  final Produto produto;
  int quantidade;
}

// ---------------------------------------------------------------------------
// Mock data
// ---------------------------------------------------------------------------

final _mockProdutos = <Produto>[
  Produto(nome: 'Shampoo Argan 250ml', preco: 45.90, emEstoque: true),
  Produto(nome: 'Condicionador Nutri 250ml', preco: 49.90, emEstoque: true),
  Produto(nome: 'Mascara Reconstrutora', preco: 89.90, emEstoque: true),
  Produto(nome: 'Óleo Capilar 60ml', preco: 34.90, emEstoque: false),
];

// ---------------------------------------------------------------------------
// Page entry point
// ---------------------------------------------------------------------------

class VendaPage extends StatefulWidget {
  const VendaPage({super.key});

  @override
  State<VendaPage> createState() => _VendaPageState();
}

class _VendaPageState extends State<VendaPage> {
  final _buscaController = TextEditingController();
  final _carrinho = <ItemCarrinho>[];
  bool _carrinhoAberto = false;
  bool _vendaFinalizada = false;
  String _busca = '';

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  List<Produto> get _produtosFiltrados {
    if (_busca.isEmpty) return _mockProdutos;
    final q = _busca.toLowerCase();
    return _mockProdutos.where((p) => p.nome.toLowerCase().contains(q)).toList();
  }

  double get _totalCarrinho =>
      _carrinho.fold(0, (acc, i) => acc + i.produto.preco * i.quantidade);

  void _adicionarAoCarrinho(Produto produto) {
    setState(() {
      final existente = _carrinho.where((i) => i.produto == produto).firstOrNull;
      if (existente != null) {
        existente.quantidade++;
      } else {
        _carrinho.add(ItemCarrinho(produto: produto));
      }
    });
  }

  void _alterarQuantidade(ItemCarrinho item, int delta) {
    setState(() {
      item.quantidade += delta;
      if (item.quantidade <= 0) _carrinho.remove(item);
    });
  }

  void _removerDoCarrinho(ItemCarrinho item) {
    setState(() => _carrinho.remove(item));
  }

  void _finalizarVenda() {
    setState(() {
      _carrinhoAberto = false;
      _vendaFinalizada = true;
    });
  }

  void _voltarAoInicio() {
    setState(() {
      _carrinho.clear();
      _vendaFinalizada = false;
      _carrinhoAberto = false;
      _busca = '';
      _buscaController.clear();
    });
  }

  // ── build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          _buildMainContent(),
          // FAB posicionado manualmente dentro do Stack para que o
          // carrinho sheet e o overlay fiquem renderizados por cima dele.
          if (!_vendaFinalizada)
            Positioned(
              right: 16,
              bottom: 24,
              child: SafeArea(
                child: VendaFab(
                  itemCount: _carrinho.fold(0, (acc, i) => acc + i.quantidade),
                  onPressed: () => setState(() => _carrinhoAberto = true),
                ),
              ),
            ),
          if (_carrinhoAberto)
            AppCartMenu(
              itens: _carrinho
                  .map((i) => CarrinhoItemData(
                        nome: i.produto.nome,
                        preco: i.produto.preco,
                        quantidade: i.quantidade,
                      ))
                  .toList(),
              onFechar: () => setState(() => _carrinhoAberto = false),
              onIncrement: (i) => _alterarQuantidade(_carrinho[i], 1),
              onDecrement: (i) => _alterarQuantidade(_carrinho[i], -1),
              onCobrar: _finalizarVenda,
            ),
          if (_vendaFinalizada) _buildVendaFinalizadaOverlay(),
        ],
      ),
    );
  }

  // ── Tela 1: Lista de produtos ────────────────────────────────────────────

  Widget _buildMainContent() {
    return SafeArea(
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.maybePop(context),
                  child: Row(
                    children: const [
                      Icon(Icons.arrow_back_ios_new,
                          size: 16, color: AppColors.backText),
                      SizedBox(width: 4),
                      Text('VOLTAR', style: AppTextStyles.backButton),
                    ],
                  ),
                ),
                const Spacer(),
                const Icon(Icons.help_outline,
                    size: 24, color: AppColors.textSecondary),
              ],
            ),
          ),

          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Nova Venda', style: AppTextStyles.pageTitle),
            ),
          ),

          const SizedBox(height: AppSpacing.xs),

          // Search
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: VendaSearchBar(
              controller: _buscaController,
              onChanged: (v) => setState(() => _busca = v),
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          // Grid de produtos
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppSpacing.xs,
                mainAxisSpacing: AppSpacing.xs,
                mainAxisExtent: 204,
              ),
              itemCount: _produtosFiltrados.length,
              itemBuilder: (context, i) {
                final p = _produtosFiltrados[i];
                return ProdutoCard(
                  nome: p.nome,
                  estoque: 1,
                  preco: p.preco,
                  emEstoque: p.emEstoque,
                  onAdicionar: () => _adicionarAoCarrinho(p),
                );
              },
            ),
          ),

          // Espaço para o FAB não sobrepor o último card
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  // _buildBottomBar removido — o carrinho agora abre exclusivamente pelo VendaFab.

  // ── Tela 3: Venda Finalizada (overlay) ──────────────────────────────────

  Widget _buildVendaFinalizadaOverlay() {
    final total = _totalCarrinho == 0
        ? _carrinho.fold<double>(
            0, (acc, i) => acc + i.produto.preco * i.quantidade)
        : _totalCarrinho;

    // Recalcula o total que foi finalizado (carrinho já pode ter sido limpo)
    // Guarda o total em uma variável de estado se necessário; aqui usamos
    // o valor corrente pois _finalizarVenda não limpa imediatamente.
    return Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Container(color: Colors.black.withOpacity(0.3)),
        ),
        Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.sheetSurface,
              borderRadius: BorderRadius.circular(AppRadii.md),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Ícone
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.fieldFill,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.storefront_outlined,
                    color: AppColors.blue,
                    size: 36,
                  ),
                ),

                const SizedBox(height: AppSpacing.sm),

                const Text(
                  'Venda Finalizada!',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 4),

                const Text(
                  'O estoque foi atualizado automaticamente',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                // Valor recebido
                AppPrimaryButton(
                  label:
                      'Valor recebido\nR\$${_totalCarrinho.toStringAsFixed(2).replaceAll('.', ',')}',
                  onPressed: null,
                  height: 72,
                ),

                const SizedBox(height: AppSpacing.xs),

                // Voltar ao Início
                SizedBox(
                  height: AppSizes.primaryButtonHeight,
                  width: double.infinity,
                  child: TextButton(
                    onPressed: _voltarAoInicio,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadii.sm),
                      ),
                    ),
                    child: const Text(
                      'Voltar ao Início',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Sub-widgets
// ---------------------------------------------------------------------------