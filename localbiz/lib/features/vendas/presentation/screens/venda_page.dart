import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:localbiz/core/router/app_route.dart';
import 'package:localbiz/core/theme/app_colors.dart';
import 'package:localbiz/core/theme/app_design_tokens.dart';
import 'package:localbiz/core/ui/app_sale_completed_overlay.dart';
import 'package:localbiz/core/ui/app_search_bar.dart';
import 'package:localbiz/core/ui/app_product_card.dart';
import 'package:localbiz/core/ui/app_floating_add_button.dart';
import 'package:localbiz/core/ui/app_cart_menu.dart';
import 'package:localbiz/core/ui/app_top_bar.dart';
import 'package:localbiz/features/vendas/models/venda_produto_model.dart';
import 'package:localbiz/features/vendas/repositories/venda_repository.dart';

class ItemCarrinho {
  ItemCarrinho({required this.produto, this.quantidade = 1});

  final VendaProdutoModel produto;
  int quantidade;
}

class VendaPage extends StatefulWidget {
  const VendaPage({super.key});

  @override
  State<VendaPage> createState() => _VendaPageState();
}

class _VendaPageState extends State<VendaPage> {
  final _buscaController = TextEditingController();
  final _carrinho = <ItemCarrinho>[];
  final _repository = VendaRepository();

  final String _negocioId = FirebaseAuth.instance.currentUser?.uid ?? '';

  bool _carrinhoAberto = false;
  bool _vendaFinalizada = false;
  bool _salvando = false;
  String _busca = '';

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  List<VendaProdutoModel> _filtrar(List<VendaProdutoModel> produtos) {
    if (_busca.isEmpty) return produtos;
    final busca = _busca.toLowerCase();
    return produtos.where((p) => p.nome.toLowerCase().contains(busca)).toList();
  }

  double get _totalCarrinho =>
      _carrinho.fold(0, (acc, i) => acc + i.produto.preco * i.quantidade);

  void _adicionarAoCarrinho(VendaProdutoModel produto) {
    setState(() {
      final existente =
          _carrinho.where((i) => i.produto.id == produto.id).firstOrNull;
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

  Future<void> _finalizarVenda() async {
    setState(() => _salvando = true);

    try {
      final itens = _carrinho
          .map((i) => {
                'produtoId': i.produto.id,
                'nome': i.produto.nome,
                'preco': i.produto.preco,
                'quantidade': i.quantidade,
              })
          .toList();

      await _repository.finalizarVenda(
        negocioId: _negocioId,
        itens: itens,
        total: _totalCarrinho,
      );

      setState(() {
        _carrinhoAberto = false;
        _vendaFinalizada = true;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Erro ao finalizar venda. Tente novamente.')),
        );
      }
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  void _voltarAoInicio() {
    setState(() {
      _carrinho.clear();
      _vendaFinalizada = false;
      _carrinhoAberto = false;
      _busca = '';
      _buscaController.clear();
    });
    Navigator.of(context).pushReplacementNamed(AppRoute.dashboard.path);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      ),
      child: Scaffold(
        backgroundColor: AppColors.surface,
        body: Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  AppTopBar(
                    onBack: () => Navigator.of(context)
                        .pushReplacementNamed(AppRoute.dashboard.path),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Nova Venda',
                        style: AppTextStyles.pageTitle.copyWith(
                          color: const Color(0xFF334155),
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          height: 1.0,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: VendaSearchBar(
                      controller: _buscaController,
                      onChanged: (v) => setState(() => _busca = v),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: StreamBuilder<List<VendaProdutoModel>>(
                      stream: _repository.listarProdutos(_negocioId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return const Center(
                              child: Text('Erro ao carregar produtos.'));
                        }
                        final produtos = _filtrar(snapshot.data ?? []);
                        if (produtos.isEmpty) {
                          return const Center(
                              child: Text('Nenhum produto encontrado.'));
                        }
                        return _ProdutosGrid(
                          produtos: produtos,
                          onAdicionar: _adicionarAoCarrinho,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
            if (!_vendaFinalizada)
              Positioned(
                right: 24,
                bottom: 24,
                child: SafeArea(
                  child: AppFloatingAddButton(
                    badgeCount:
                        _carrinho.fold(0, (acc, i) => acc + i.quantidade),
                    tooltip: 'Abrir carrinho',
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
                onCobrar: _salvando ? () {} : _finalizarVenda,
              ),
            if (_vendaFinalizada)
              AppSaleCompletedOverlay(
                total: _totalCarrinho,
                onVoltar: _voltarAoInicio,
              ),
          ],
        ),
      ),
    );
  }
}

class _ProdutosGrid extends StatelessWidget {
  const _ProdutosGrid({required this.produtos, required this.onAdicionar});

  final List<VendaProdutoModel> produtos;
  final ValueChanged<VendaProdutoModel> onAdicionar;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.xs,
        mainAxisSpacing: AppSpacing.xs,
        mainAxisExtent: 186,
      ),
      itemCount: produtos.length,
      itemBuilder: (context, i) {
        final p = produtos[i];
        return ProdutoCard(
          nome: p.nome,
          estoque: p.estoqueAtual,
          preco: p.preco,
          emEstoque: p.emEstoque,
          onAdicionar: () => onAdicionar(p),
        );
      },
    );
  }
}