import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:localbiz/core/theme/app_colors.dart';
import 'package:localbiz/core/theme/app_design_tokens.dart';
import 'package:localbiz/core/ui/app_floating_add_button.dart';
import 'package:localbiz/core/ui/app_help_action_button.dart';
import 'package:localbiz/features/produtos/data/repositories/produto_repository.dart';
import 'package:localbiz/features/produtos/domain/entities/produto_model.dart';
import 'package:localbiz/features/produtos/presentation/screens/produto_estoque_page.dart';
import 'package:localbiz/features/produtos/presentation/screens/produto_form_page.dart';
import 'package:localbiz/features/produtos/presentation/widgets/produto_list_item.dart';
import 'package:localbiz/features/produtos/presentation/widgets/produto_photo_picker.dart';
import 'package:localbiz/features/services/presentation/screens/auth/auth_service.dart';

const _buscaAltura = 56.0;
const _searchIcon = 'assets/icons/search.png';

enum _ProdutosView { lista, cadastro, edicao, estoque }

class ProdutosPage extends StatefulWidget {
  const ProdutosPage({super.key});

  @override
  State<ProdutosPage> createState() => _ProdutosPageState();
}

class _ProdutosPageState extends State<ProdutosPage> {
  final _authService = AuthService();
  final _produtoRepository = ProdutoRepository();
  late final String? _uid = _authService.usuarioAtual?.uid;

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
  bool _salvando = false;
  Uint8List? _imagemSelecionadaBytes;
  Produto? _produtoSelecionado;

  @override
  void dispose() {
    buscaController.dispose();
    nomeController.dispose();
    precoController.dispose();
    codigoController.dispose();
    quantidadeController.dispose();
    super.dispose();
  }

  List<Produto> _filtrar(List<Produto> produtos) {
    final busca = buscaController.text.trim().toLowerCase();

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

  Future<void> _salvarProduto() async {
    final uid = _uid;
    if (uid == null || _salvando) {
      return;
    }

    final nome = nomeController.text.trim();
    final preco = precoController.text.trim();
    final codigo = codigoController.text.trim();

    if (nome.isEmpty) {
      return;
    }

    final categoria = _categoriaSelecionada == 'Selecione'
        ? 'Sem categoria'
        : _categoriaSelecionada;
    final estoqueLocal = _estoqueSelecionado == 'Selecione'
        ? 'Estoque A'
        : _estoqueSelecionado;
    final selecionado = _produtoSelecionado;
    final imagemBytes = _imagemSelecionadaBytes;

    setState(() => _salvando = true);

    try {
      if (selecionado == null) {
        await _produtoRepository.criar(
          uid,
          Produto(
            categoria: categoria,
            nome: nome,
            preco: preco.isEmpty ? 'R\$ 0,00' : preco,
            codigoBarras: codigo,
            estoqueAtual: 0,
            estoqueLocal: estoqueLocal,
          ),
          imagemBytes: imagemBytes,
        );
      } else {
        await _produtoRepository.atualizar(
          uid,
          Produto(
            id: selecionado.id,
            categoria: categoria,
            nome: nome,
            preco: preco.isEmpty ? selecionado.preco : preco,
            codigoBarras: codigo,
            estoqueAtual: selecionado.estoqueAtual,
            estoqueLocal: selecionado.estoqueLocal,
            imagemUrl: selecionado.imagemUrl,
          ),
          novaImagemBytes: imagemBytes,
        );
      }

      if (!mounted) {
        return;
      }
      setState(() {
        _view = _ProdutosView.lista;
        _produtoSelecionado = null;
        _imagemSelecionadaBytes = null;
      });
    } catch (_) {
      if (mounted) {
        _mostrarErro('Não foi possível salvar o produto. Tente novamente.');
      }
    } finally {
      if (mounted) {
        setState(() => _salvando = false);
      }
    }
  }

  Future<void> _concluirMovimentoEstoque() async {
    final uid = _uid;
    final produto = _produtoSelecionado;
    if (uid == null || produto == null || produto.id == null) {
      _voltarParaLista();
      return;
    }

    final quantidade = int.tryParse(quantidadeController.text.trim());
    if (quantidade == null || quantidade <= 0) {
      return;
    }

    final delta = _movimento == MovimentoEstoque.entrada
        ? quantidade
        : -quantidade;
    final novoLocal = _estoqueSelecionado != 'Selecione'
        ? _estoqueSelecionado
        : null;

    try {
      await _produtoRepository.movimentarEstoque(
        uid,
        produto.id!,
        delta: delta,
        estoqueLocal: novoLocal,
      );
      if (!mounted) {
        return;
      }
      setState(() {
        quantidadeController.clear();
        _produtoSelecionado = null;
        _view = _ProdutosView.lista;
      });
    } catch (_) {
      if (mounted) {
        _mostrarErro('Não foi possível atualizar o estoque. Tente novamente.');
      }
    }
  }

  Future<void> _confirmarExclusao(Produto produto) async {
    final uid = _uid;
    final produtoId = produto.id;
    if (uid == null || produtoId == null) {
      return;
    }

    final excluir = await showDialog<bool>(
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

    try {
      await _produtoRepository.excluir(uid, produtoId);
    } catch (_) {
      if (mounted) {
        _mostrarErro('Não foi possível excluir o produto. Tente novamente.');
      }
    }
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(mensagem)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: switch (_view) {
            _ProdutosView.lista => _buildLista(),
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
              imagemUrl: _produtoSelecionado?.imagemUrl,
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
    );
  }

  Widget _buildLista() {
    final uid = _uid;

    if (uid == null) {
      return _ProdutosListView(
        produtos: const [],
        mensagemVazia: 'Faça login para ver seus produtos.',
        buscaController: buscaController,
        onBuscaChanged: (_) => setState(() {}),
        onAdicionar: _abrirCadastro,
        onEditar: _abrirEdicao,
        onEstoque: _abrirEstoque,
        onExcluir: _confirmarExclusao,
      );
    }

    return StreamBuilder<List<Produto>>(
      stream: _produtoRepository.observar(uid),
      builder: (context, snapshot) {
        final carregando = snapshot.connectionState == ConnectionState.waiting;
        final erro = snapshot.hasError;
        final todos = snapshot.data ?? const <Produto>[];

        return _ProdutosListView(
          produtos: _filtrar(todos),
          carregando: carregando,
          erro: erro,
          buscaController: buscaController,
          onBuscaChanged: (_) => setState(() {}),
          onAdicionar: _abrirCadastro,
          onEditar: _abrirEdicao,
          onEstoque: _abrirEstoque,
          onExcluir: _confirmarExclusao,
        );
      },
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
    this.carregando = false,
    this.erro = false,
    this.mensagemVazia = 'Nenhum produto encontrado',
  });

  final List<Produto> produtos;
  final TextEditingController buscaController;
  final ValueChanged<String> onBuscaChanged;
  final VoidCallback onAdicionar;
  final ValueChanged<Produto> onEditar;
  final ValueChanged<Produto> onEstoque;
  final ValueChanged<Produto> onExcluir;
  final bool carregando;
  final bool erro;
  final String mensagemVazia;

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
                      child: erro
                          ? const _ProdutosEmptyState(
                              mensagem:
                                  'Não foi possível carregar os produtos.',
                            )
                          : carregando && produtos.isEmpty
                          ? const Center(child: CircularProgressIndicator())
                          : produtos.isEmpty
                          ? _ProdutosEmptyState(mensagem: mensagemVazia)
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
          ],
        ),
        Positioned(
          right: AppSpacing.lg,
          bottom: AppSpacing.lg,
          child: AppFloatingAddButton(
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
          const AppHelpActionButton(),
        ],
      ),
    );
  }
}

class _ProdutosEmptyState extends StatelessWidget {
  const _ProdutosEmptyState({this.mensagem = 'Nenhum produto encontrado'});

  final String mensagem;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        mensagem,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: AppColors.textMuted,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
