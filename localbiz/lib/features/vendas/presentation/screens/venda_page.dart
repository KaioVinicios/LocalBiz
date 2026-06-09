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
import 'package:localbiz/features/vendas/models/venda_model.dart';
import 'package:localbiz/features/vendas/models/venda_produto_model.dart';
import 'package:localbiz/features/vendas/repositories/venda_repository.dart';

class ItemCarrinho {
  ItemCarrinho({required this.produto, this.quantidade = 1});

  final VendaProdutoModel produto;
  int quantidade;
}

class VendaPage extends StatefulWidget {
  const VendaPage({
    super.key,
    this.repository,
    this.negocioId,
    this.vendaInicial,
  });

  final VendaRepositoryContract? repository;
  final String? negocioId;
  final VendaModel? vendaInicial;

  @override
  State<VendaPage> createState() => _VendaPageState();
}

class _VendaPageState extends State<VendaPage> {
  final _buscaController = TextEditingController();
  final _carrinho = <ItemCarrinho>[];

  late final VendaRepositoryContract _repository;
  late final String _negocioId;

  bool _carrinhoAberto = false;
  bool _vendaFinalizada = false;
  bool _salvando = false;
  String _busca = '';

  bool get _modoEdicao => widget.vendaInicial != null;

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? VendaRepository();
    _negocioId = widget.negocioId ?? _usuarioAtualId();

    final venda = widget.vendaInicial;
    if (venda != null) {
      _carrinho.addAll(
        venda.itens.map(
          (item) => ItemCarrinho(
            produto: VendaProdutoModel(
              id: item.produtoId,
              nome: item.nome,
              precoCentavos: item.precoCentavos,
              estoqueAtual: item.quantidade,
              negocioId: _negocioId,
            ),
            quantidade: item.quantidade,
          ),
        ),
      );
      _carrinhoAberto = true;
    }
  }

  String _usuarioAtualId() {
    try {
      return FirebaseAuth.instance.currentUser?.uid ?? '';
    } catch (_) {
      return '';
    }
  }

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

  int get _totalCentavos => _carrinho.fold(
    0,
    (acc, i) => acc + i.produto.precoCentavos * i.quantidade,
  );

  double get _totalReais => _totalCentavos / 100;

  List<VendaItemModel> get _itensCarrinho {
    return _carrinho
        .map(
          (i) => VendaItemModel(
            produtoId: i.produto.id,
            nome: i.produto.nome,
            precoCentavos: i.produto.precoCentavos,
            quantidade: i.quantidade,
          ),
        )
        .toList();
  }

  void _adicionarAoCarrinho(VendaProdutoModel produto) {
    setState(() {
      final existente = _carrinho
          .where((i) => i.produto.id == produto.id)
          .firstOrNull;
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

  Future<void> _salvarVenda() async {
    if (_negocioId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Faça login para registrar vendas.')),
      );
      return;
    }

    if (_carrinho.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Adicione ao menos um produto.')),
      );
      return;
    }

    setState(() => _salvando = true);

    try {
      final vendaInicial = widget.vendaInicial;

      if (vendaInicial == null) {
        await _repository.criarVenda(
          negocioId: _negocioId,
          itens: _itensCarrinho,
        );

        setState(() {
          _carrinhoAberto = false;
          _vendaFinalizada = true;
        });
        return;
      }

      await _repository.atualizarVenda(
        negocioId: _negocioId,
        vendaId: vendaInicial.id,
        itens: _itensCarrinho,
      );

      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Venda atualizada com sucesso.')),
      );
      Navigator.of(context).maybePop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _modoEdicao
                  ? 'Erro ao atualizar venda. Tente novamente.'
                  : 'Erro ao finalizar venda. Tente novamente.',
            ),
          ),
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
                    onBack: () => Navigator.of(
                      context,
                    ).pushReplacementNamed(AppRoute.dashboard.path),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _modoEdicao ? 'Editar Venda' : 'Nova Venda',
                              style: AppTextStyles.pageTitle.copyWith(
                                color: const Color(0xFF334155),
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                height: 1.0,
                                letterSpacing: 0,
                              ),
                            ),
                          ),
                          if (!_modoEdicao)
                            TextButton.icon(
                              onPressed: () => Navigator.of(
                                context,
                              ).pushNamed(AppRoute.vendasHistorico.path),
                              icon: const Icon(Icons.receipt_long_outlined),
                              label: const Text('Histórico'),
                            ),
                        ],
                      ),
                    ),
                  ),
                  if (_negocioId.isEmpty)
                    const Expanded(
                      child: Center(
                        child: Text('Faça login para ver seus produtos.'),
                      ),
                    )
                  else ...[
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
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.hasError) {
                            return const Center(
                              child: Text('Erro ao carregar produtos.'),
                            );
                          }
                          final produtos = _filtrar(snapshot.data ?? []);
                          if (produtos.isEmpty) {
                            return const Center(
                              child: Text('Nenhum produto encontrado.'),
                            );
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
                ],
              ),
            ),
            if (!_vendaFinalizada)
              Positioned(
                right: 24,
                bottom: 24,
                child: SafeArea(
                  child: AppFloatingAddButton(
                    badgeCount: _carrinho.fold(
                      0,
                      (acc, i) => acc + i.quantidade,
                    ),
                    tooltip: 'Abrir carrinho',
                    onPressed: () => setState(() => _carrinhoAberto = true),
                  ),
                ),
              ),
            if (_carrinhoAberto)
              AppCartMenu(
                itens: _carrinho
                    .map(
                      (i) => CarrinhoItemData(
                        nome: i.produto.nome,
                        preco: i.produto.precoReais,
                        quantidade: i.quantidade,
                      ),
                    )
                    .toList(),
                onFechar: () => setState(() => _carrinhoAberto = false),
                onIncrement: (i) => _alterarQuantidade(_carrinho[i], 1),
                onDecrement: (i) => _alterarQuantidade(_carrinho[i], -1),
                onCobrar: _salvando ? () {} : _salvarVenda,
                actionLabel: _modoEdicao ? 'Salvar' : 'Cobrar',
              ),
            if (_vendaFinalizada)
              AppSaleCompletedOverlay(
                total: _totalReais,
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
          preco: p.precoReais,
          emEstoque: p.emEstoque,
          onAdicionar: () => onAdicionar(p),
        );
      },
    );
  }
}
