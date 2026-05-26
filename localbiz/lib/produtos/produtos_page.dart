import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:localbiz/produtos/produto_estoque_page.dart';
import 'package:localbiz/produtos/produto_form_page.dart';
import 'package:localbiz/produtos/produto_list_item.dart';
import 'package:localbiz/produtos/produto_model.dart';
import 'package:localbiz/produtos/produto_photo_picker.dart';
import 'package:localbiz/theme/app_colors.dart';
import 'package:localbiz/theme/app_design_tokens.dart';
import 'package:localbiz/widgets/app_square_action_button.dart';
import 'package:localbiz/widgets/nav_bar_button.dart';

const _buscaAltura = 56.0;
const _finiAsset = 'assets/products/fini-salada-frutas.jpg';
const _searchIcon = 'assets/icons/search.png';
const _helpIcon = 'assets/icons/help.png';

enum _ProdutosView { lista, cadastro, edicao, estoque }

class ProdutosPage extends StatefulWidget {
  const ProdutosPage({super.key});

  @override
  State<ProdutosPage> createState() => _ProdutosPageState();
}

class _ProdutosPageState extends State<ProdutosPage> {
  final buscaController = TextEditingController();
  final nomeController = TextEditingController();
  final precoController = TextEditingController();
  final codigoController = TextEditingController();
  final quantidadeController = TextEditingController();

  final categorias = const [
    'Selecione',
    'Doces',
    'Bebidas',
    'Higiene',
    'Outros',
  ];
  final estoques = const ['Selecione', 'Estoque A', 'Estoque B', 'Estoque C'];

  var _view = _ProdutosView.lista;
  var _categoriaSelecionada = 'Selecione';
  var _estoqueSelecionado = 'Selecione';
  var _movimento = MovimentoEstoque.entrada;
  Uint8List? _imagemSelecionadaBytes;
  Produto? _produtoSelecionado;

  final produtos = <Produto>[
    Produto(
      categoria: 'Doces',
      nome: 'Fini Salada de Frutas',
      preco: 'R\$ 7,99',
      codigoBarras: '7898279794835',
      estoqueAtual: 48,
      estoqueLocal: 'Estoque A',
      imagemAsset: _finiAsset,
    ),
  ];

  @override
  void dispose() {
    buscaController.dispose();
    nomeController.dispose();
    precoController.dispose();
    codigoController.dispose();
    quantidadeController.dispose();
    super.dispose();
  }

  List<Produto> get produtosFiltrados {
    var busca = buscaController.text.trim().toLowerCase();

    if (busca.isEmpty) {
      return produtos;
    }

    return produtos.where((produto) {
      return produto.nome.toLowerCase().contains(busca) ||
          produto.codigoBarras.toLowerCase().contains(busca) ||
          produto.categoria.toLowerCase().contains(busca);
    }).toList();
  }

  void _abrirCadastro() {
    setState(() {
      _produtoSelecionado = null;
      nomeController.clear();
      precoController.clear();
      codigoController.clear();
      _imagemSelecionadaBytes = null;
      _categoriaSelecionada = 'Selecione';
      _estoqueSelecionado = 'Selecione';
      _view = _ProdutosView.cadastro;
    });
  }

  void _abrirEdicao(Produto produto) {
    setState(() {
      _produtoSelecionado = produto;
      nomeController.text = produto.nome;
      precoController.text = produto.preco;
      codigoController.text = produto.codigoBarras;
      _imagemSelecionadaBytes = produto.imagemBytes;
      _categoriaSelecionada = produto.categoria;
      _estoqueSelecionado = produto.estoqueLocal;
      _view = _ProdutosView.edicao;
    });
  }

  void _abrirEstoque(Produto produto) {
    setState(() {
      _produtoSelecionado = produto;
      quantidadeController.clear();
      _movimento = MovimentoEstoque.entrada;
      _estoqueSelecionado = produto.estoqueLocal;
      _view = _ProdutosView.estoque;
    });
  }

  void _voltarParaLista() {
    setState(() {
      _view = _ProdutosView.lista;
      _produtoSelecionado = null;
      _imagemSelecionadaBytes = null;
      quantidadeController.clear();
    });
  }

  Future<void> _selecionarFotoProduto() async {
    final bytes = await escolherFotoProduto();

    if (bytes == null || !mounted) {
      return;
    }

    setState(() {
      _imagemSelecionadaBytes = bytes;
    });
  }

  void _salvarProduto() {
    var nome = nomeController.text.trim();
    var preco = precoController.text.trim();
    var codigo = codigoController.text.trim();

    if (nome.isEmpty) {
      return;
    }

    setState(() {
      var categoria = _categoriaSelecionada == 'Selecione'
          ? 'Sem categoria'
          : _categoriaSelecionada;
      var estoqueLocal = _estoqueSelecionado == 'Selecione'
          ? 'Estoque A'
          : _estoqueSelecionado;
      var produto = _produtoSelecionado;

      if (produto == null) {
        produtos.add(
          Produto(
            categoria: categoria,
            nome: nome,
            preco: preco.isEmpty ? 'R\$ 0,00' : preco,
            codigoBarras: codigo,
            estoqueAtual: 0,
            estoqueLocal: estoqueLocal,
            imagemBytes: _imagemSelecionadaBytes,
          ),
        );
      } else {
        produto.categoria = categoria;
        produto.nome = nome;
        produto.preco = preco.isEmpty ? produto.preco : preco;
        produto.codigoBarras = codigo;
        produto.imagemBytes = _imagemSelecionadaBytes;
      }

      _view = _ProdutosView.lista;
      _produtoSelecionado = null;
      _imagemSelecionadaBytes = null;
    });
  }

  void _concluirMovimentoEstoque() {
    var produto = _produtoSelecionado;
    if (produto == null) {
      _voltarParaLista();
      return;
    }

    var quantidade = int.tryParse(quantidadeController.text.trim());
    if (quantidade == null || quantidade <= 0) {
      return;
    }

    setState(() {
      if (_movimento == MovimentoEstoque.entrada) {
        produto.estoqueAtual += quantidade;
      } else {
        var novoEstoque = produto.estoqueAtual - quantidade;
        produto.estoqueAtual = novoEstoque < 0 ? 0 : novoEstoque;
      }

      if (_estoqueSelecionado != 'Selecione') {
        produto.estoqueLocal = _estoqueSelecionado;
      }

      quantidadeController.clear();
      _produtoSelecionado = null;
      _view = _ProdutosView.lista;
    });
  }

  Future<void> _confirmarExclusao(Produto produto) async {
    var excluir = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir produto'),
          content: Text('Deseja excluir ${produto.nome}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (excluir != true || !mounted) {
      return;
    }

    setState(() {
      produtos.remove(produto);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSizes.screenMaxWidth,
            ),
            child: SizedBox(
              width: double.infinity,
              child: switch (_view) {
                _ProdutosView.lista => _ProdutosListView(
                  produtos: produtosFiltrados,
                  buscaController: buscaController,
                  onBuscaChanged: (_) => setState(() {}),
                  onAdicionar: _abrirCadastro,
                  onEditar: _abrirEdicao,
                  onEstoque: _abrirEstoque,
                  onExcluir: _confirmarExclusao,
                ),
                _ProdutosView.cadastro => ProdutoFormPage(
                  title: 'Cadastro de Produto',
                  description:
                      'Preencha os dados abaixo para o cadastro de Produto.',
                  nomeController: nomeController,
                  precoController: precoController,
                  codigoController: codigoController,
                  categoria: _categoriaSelecionada,
                  categorias: categorias,
                  estoqueLocal: _estoqueSelecionado,
                  estoques: estoques,
                  onSelecionarFoto: _selecionarFotoProduto,
                  onCategoriaChanged: (value) {
                    setState(() {
                      _categoriaSelecionada = value ?? 'Selecione';
                    });
                  },
                  onEstoqueChanged: (value) {
                    setState(() => _estoqueSelecionado = value ?? 'Selecione');
                  },
                  onVoltar: _voltarParaLista,
                  onConcluir: _salvarProduto,
                  imagemBytes: _imagemSelecionadaBytes,
                ),
                _ProdutosView.edicao => ProdutoFormPage(
                  title: 'Edição de Produto',
                  description:
                      'Preencha os dados abaixo para o cadastro de Produto.',
                  nomeController: nomeController,
                  precoController: precoController,
                  codigoController: codigoController,
                  categoria: _categoriaSelecionada,
                  categorias: categorias,
                  estoqueLocal: _estoqueSelecionado,
                  estoques: estoques,
                  imagemAsset: _produtoSelecionado?.imagemAsset,
                  imagemBytes: _imagemSelecionadaBytes,
                  showEstoqueField: false,
                  onSelecionarFoto: _selecionarFotoProduto,
                  onCategoriaChanged: (value) {
                    setState(() {
                      _categoriaSelecionada = value ?? 'Selecione';
                    });
                  },
                  onEstoqueChanged: (value) {
                    setState(() => _estoqueSelecionado = value ?? 'Selecione');
                  },
                  onVoltar: _voltarParaLista,
                  onConcluir: _salvarProduto,
                ),
                _ProdutosView.estoque => ProdutoEstoquePage(
                  produto: _produtoSelecionado!,
                  movimento: _movimento,
                  quantidadeController: quantidadeController,
                  estoqueLocal: _estoqueSelecionado,
                  estoques: estoques,
                  onMovimentoChanged: (value) {
                    setState(() => _movimento = value);
                  },
                  onEstoqueChanged: (value) {
                    setState(() => _estoqueSelecionado = value ?? 'Selecione');
                  },
                  onVoltar: _voltarParaLista,
                  onConcluir: _concluirMovimentoEstoque,
                ),
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _ProdutosListView extends StatelessWidget {
  const _ProdutosListView({
    required this.produtos,
    required this.buscaController,
    required this.onBuscaChanged,
    required this.onAdicionar,
    required this.onEditar,
    required this.onEstoque,
    required this.onExcluir,
  });

  final List<Produto> produtos;
  final TextEditingController buscaController;
  final ValueChanged<String> onBuscaChanged;
  final VoidCallback onAdicionar;
  final ValueChanged<Produto> onEditar;
  final ValueChanged<Produto> onEstoque;
  final ValueChanged<Produto> onExcluir;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _ProdutosTopBar(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Produtos',
                      style: TextStyle(
                        fontSize: 34,
                        height: 1,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: _buscaAltura,
                            child: TextField(
                              controller: buscaController,
                              onChanged: onBuscaChanged,
                              textAlignVertical: TextAlignVertical.center,
                              style: AppTextStyles.fieldText.copyWith(
                                fontSize: 16,
                                height: 1,
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xFFF3F3F3),
                                hintText: 'Pesquisar por Produto',
                                hintStyle: AppTextStyles.fieldHint.copyWith(
                                  fontSize: 16,
                                  height: 1,
                                  fontWeight: FontWeight.w400,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppRadii.sm,
                                  ),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppRadii.sm,
                                  ),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppRadii.sm,
                                  ),
                                  borderSide: const BorderSide(
                                    color: AppColors.blue,
                                    width: 1.2,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.only(
                                  right: 16,
                                ),
                                prefixIcon: Center(
                                  child: Image.asset(
                                    _searchIcon,
                                    width: 28,
                                    height: 28,
                                  ),
                                ),
                                prefixIconConstraints: const BoxConstraints(
                                  minWidth: _buscaAltura,
                                  maxWidth: _buscaAltura,
                                  minHeight: _buscaAltura,
                                  maxHeight: _buscaAltura,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          onPressed: () {},
                          tooltip: 'Filtrar produtos',
                          icon: const Icon(
                            Icons.filter_list,
                            color: Color(0xFF4A4A4A),
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: produtos.isEmpty
                          ? const _ProdutosEmptyState()
                          : ListView.separated(
                              padding: const EdgeInsets.only(bottom: 112),
                              itemCount: produtos.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 16),
                              itemBuilder: (context, index) {
                                var produto = produtos[index];
                                return ProdutoListItem(
                                  produto: produto,
                                  onEditar: () => onEditar(produto),
                                  onEstoque: () => onEstoque(produto),
                                  onExcluir: () => onExcluir(produto),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
            const _ProdutosBottomNavBar(),
          ],
        ),
        Positioned(
          right: 28,
          bottom: 96,
          child: AppSquareActionButton(
            icon: Icons.add,
            tooltip: 'Adicionar produto',
            onPressed: onAdicionar,
          ),
        ),
      ],
    );
  }
}

class _ProdutosTopBar extends StatelessWidget {
  const _ProdutosTopBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.of(context).maybePop(),
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
          const SizedBox(
            width: 36,
            height: 36,
            child: Center(
              child: Image(image: AssetImage(_helpIcon), width: 24, height: 24),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProdutosBottomNavBar extends StatelessWidget {
  const _ProdutosBottomNavBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.navBarBg,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: NavBarButton(
              icon: Icons.menu,
              label: 'Início',
              isActive: false,
              onTap: () {},
            ),
          ),
          Expanded(
            child: NavBarButton(
              icon: Icons.star_border,
              label: 'Serviços',
              isActive: false,
              onTap: () {},
            ),
          ),
          Expanded(
            child: NavBarButton(
              icon: Icons.star,
              label: 'Produtos',
              isActive: true,
              onTap: () {},
            ),
          ),
          Expanded(
            child: NavBarButton(
              icon: Icons.settings,
              label: 'Configurações',
              isActive: false,
              onTap: () =>
                  Navigator.of(context).pushReplacementNamed('/configuracoes'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProdutosEmptyState extends StatelessWidget {
  const _ProdutosEmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Nenhum produto encontrado',
        style: TextStyle(
          color: AppColors.textMuted,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
