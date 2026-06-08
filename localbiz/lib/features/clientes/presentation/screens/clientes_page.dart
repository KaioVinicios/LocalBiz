import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:localbiz/features/clientes/presentation/screens/cliente_detalhe_page.dart';
import 'package:localbiz/features/clientes/presentation/widgets/cliente_list_item.dart';
import 'package:localbiz/features/clientes/domain/entities/cliente_model.dart';
import 'package:localbiz/features/clientes/data/repositories/cliente_repository.dart';
import 'package:localbiz/features/clientes/presentation/widgets/novo_cliente_form.dart';
import 'package:localbiz/features/services/presentation/screens/auth/auth_service.dart';
import 'package:localbiz/core/theme/app_colors.dart';
import 'package:localbiz/core/theme/app_design_tokens.dart';
import 'package:localbiz/core/ui/app_floating_add_button.dart';
import 'package:localbiz/core/ui/app_help_action_button.dart';
import 'package:localbiz/core/ui/app_text_field.dart';

const _buscaAltura = 56.0;
const _formDuracao = Duration(milliseconds: 280);

class ClientesPage extends StatefulWidget {
  const ClientesPage({super.key});

  @override
  State<ClientesPage> createState() => _ClientesPageState();
}

class _ClientesPageState extends State<ClientesPage> {
  final _authService = AuthService();
  final _clienteRepository = ClienteRepository();
  late final String? _uid = _authService.usuarioAtual?.uid;

  final buscaController = TextEditingController();
  final nomeController = TextEditingController();
  final telefoneController = TextEditingController();
  final emailController = TextEditingController();

  bool abrindoForm = false;
  bool _salvando = false;
  String? _clienteSelecionadoId;
  String? _clienteEmEdicaoId;

  @override
  void dispose() {
    buscaController.dispose();
    nomeController.dispose();
    telefoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  List<Cliente> _filtrar(List<Cliente> clientes) {
    final busca = buscaController.text.trim().toLowerCase();

    if (busca.isEmpty) {
      return clientes;
    }

    return clientes.where((cliente) {
      return cliente.nome.toLowerCase().contains(busca) ||
          cliente.telefone.toLowerCase().contains(busca);
    }).toList();
  }

  Cliente? _clienteAtual(List<Cliente> clientes) {
    final id = _clienteSelecionadoId;
    if (id == null) {
      return null;
    }
    for (final cliente in clientes) {
      if (cliente.id == id) {
        return cliente;
      }
    }
    return null;
  }

  void abrirForm() {
    setState(() {
      _clienteEmEdicaoId = null;
      nomeController.clear();
      telefoneController.clear();
      emailController.clear();
      abrindoForm = true;
    });
  }

  void fecharForm() {
    setState(() {
      abrindoForm = false;
      _clienteEmEdicaoId = null;
      nomeController.clear();
      telefoneController.clear();
      emailController.clear();
    });
  }

  void abrirEdicao(Cliente cliente) {
    setState(() {
      _clienteEmEdicaoId = cliente.id;
      nomeController.text = cliente.nome;
      telefoneController.text = cliente.telefone;
      emailController.text = cliente.email;
      abrindoForm = true;
    });
  }

  Future<void> salvarCliente() async {
    final uid = _uid;
    if (uid == null || _salvando) {
      return;
    }

    final nome = nomeController.text.trim();
    final telefone = telefoneController.text.trim();
    final email = emailController.text.trim();

    if (nome.isEmpty) {
      return;
    }

    setState(() => _salvando = true);

    final idEmEdicao = _clienteEmEdicaoId;
    try {
      if (idEmEdicao == null) {
        await _clienteRepository.criar(
          uid,
          Cliente(nome: nome, telefone: telefone, email: email),
        );
      } else {
        await _clienteRepository.atualizar(
          uid,
          Cliente(
            id: idEmEdicao,
            nome: nome,
            telefone: telefone,
            email: email,
          ),
        );
      }

      if (!mounted) {
        return;
      }
      setState(() {
        nomeController.clear();
        telefoneController.clear();
        emailController.clear();
        _clienteEmEdicaoId = null;
        abrindoForm = false;
      });
    } catch (_) {
      if (mounted) {
        _mostrarErro('Não foi possível salvar o cliente. Tente novamente.');
      }
    } finally {
      if (mounted) {
        setState(() => _salvando = false);
      }
    }
  }

  void selecionarCliente(Cliente cliente) {
    setState(() {
      _clienteSelecionadoId = cliente.id;
    });
  }

  void voltarParaLista() {
    setState(() {
      _clienteSelecionadoId = null;
    });
  }

  Future<void> confirmarExclusao(Cliente cliente) async {
    final uid = _uid;
    final clienteId = cliente.id;
    if (uid == null || clienteId == null) {
      return;
    }

    final excluir = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir cliente'),
          content: Text('Deseja excluir ${cliente.nome}?'),
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
      await _clienteRepository.excluir(uid, clienteId);
      if (!mounted) {
        return;
      }
      setState(() {
        _clienteSelecionadoId = null;
        _clienteEmEdicaoId = null;
        abrindoForm = false;
      });
    } catch (_) {
      if (mounted) {
        _mostrarErro('Não foi possível excluir o cliente. Tente novamente.');
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
    final uid = _uid;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: uid == null
            ? const _ClientesEstadoVazio(
                mensagem: 'Faça login para ver seus clientes.',
              )
            : StreamBuilder<List<Cliente>>(
                stream: _clienteRepository.observar(uid),
                builder: (context, snapshot) {
                  final carregando =
                      snapshot.connectionState == ConnectionState.waiting;
                  final temErro = snapshot.hasError;
                  final todos = snapshot.data ?? const <Cliente>[];
                  final clienteSelecionado = _clienteAtual(todos);
                  final lista = _filtrar(todos);

                  return Stack(
                    children: [
                      if (clienteSelecionado == null)
                        Padding(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const _ClientesTopBar(),
                              const SizedBox(height: AppSpacing.lg),
                              Text(
                                'Clientes',
                                style: AppTextStyles.pageTitle.copyWith(
                                  fontSize: 32,
                                  height: 1,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.md),
                              AppTextField(
                                hint: 'Buscar por nome ...',
                                controller: buscaController,
                                prefixIcon: Icons.search,
                                height: _buscaAltura,
                                radius: AppRadii.pill,
                                prefixIconSize: 28,
                                prefixIconMinWidth: _buscaAltura,
                                prefixIconColor: AppColors.cardIconFg,
                                textStyle: AppTextStyles.fieldText.copyWith(
                                  fontSize: 18,
                                  height: 1,
                                ),
                                hintStyle: AppTextStyles.fieldHint.copyWith(
                                  fontSize: 18,
                                  height: 1,
                                  fontWeight: FontWeight.w500,
                                ),
                                contentPadding: const EdgeInsets.only(right: 16),
                                onChanged: (value) {
                                  setState(() {});
                                },
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Expanded(
                                child: _ClientesConteudo(
                                  carregando: carregando,
                                  erro: temErro,
                                  clientes: lista,
                                  temBusca:
                                      buscaController.text.trim().isNotEmpty,
                                  onSelecionar: selecionarCliente,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        ClienteDetalhePage(
                          cliente: clienteSelecionado,
                          onVoltar: voltarParaLista,
                          onEditar: () => abrirEdicao(clienteSelecionado),
                          onExcluir: () => confirmarExclusao(clienteSelecionado),
                        ),
                      if (clienteSelecionado == null)
                        Positioned(
                          right: AppSpacing.lg,
                          bottom: AppSpacing.lg,
                          child: AppFloatingAddButton(
                            tooltip: 'Adicionar cliente',
                            onPressed: abrirForm,
                          ),
                        ),
                      Positioned.fill(
                        child: _FormBackdrop(
                          visible: abrindoForm,
                          onTap: fecharForm,
                        ),
                      ),
                      Positioned.fill(
                        child: _FormSheetTransition(
                          visible: abrindoForm,
                          child: NovoClienteForm(
                            title: _clienteEmEdicaoId == null
                                ? 'Novo Cliente'
                                : 'Editar Cliente',
                            nomeController: nomeController,
                            telefoneController: telefoneController,
                            emailController: emailController,
                            onFechar: fecharForm,
                            onSalvar: salvarCliente,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }
}

class _ClientesConteudo extends StatelessWidget {
  const _ClientesConteudo({
    required this.carregando,
    required this.erro,
    required this.clientes,
    required this.temBusca,
    required this.onSelecionar,
  });

  final bool carregando;
  final bool erro;
  final List<Cliente> clientes;
  final bool temBusca;
  final ValueChanged<Cliente> onSelecionar;

  @override
  Widget build(BuildContext context) {
    if (erro) {
      return const _ClientesEstadoVazio(
        mensagem: 'Não foi possível carregar os clientes.\nTente novamente.',
      );
    }

    if (carregando && clientes.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (clientes.isEmpty) {
      return _ClientesEstadoVazio(
        mensagem: temBusca
            ? 'Nenhum cliente encontrado.'
            : 'Nenhum cliente cadastrado ainda.',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.only(
        bottom: AppSizes.squareAction + AppSpacing.lg,
      ),
      itemCount: clientes.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final cliente = clientes[index];
        return ClienteListItem(
          cliente: cliente,
          onTap: () => onSelecionar(cliente),
        );
      },
    );
  }
}

class _ClientesEstadoVazio extends StatelessWidget {
  const _ClientesEstadoVazio({required this.mensagem});

  final String mensagem;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Text(
          mensagem,
          textAlign: TextAlign.center,
          style: AppTextStyles.clientDetail.copyWith(
            color: AppColors.textMuted,
            fontSize: 16,
            height: 1.3,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _FormBackdrop extends StatelessWidget {
  const _FormBackdrop({required this.visible, required this.onTap});

  final bool visible;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: _formDuracao,
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      child: visible
          ? GestureDetector(
              key: const ValueKey('cliente-form-backdrop'),
              onTap: onTap,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: Container(
                  color: AppColors.surface.withValues(alpha: 0.58),
                ),
              ),
            )
          : const SizedBox.shrink(key: ValueKey('cliente-form-backdrop-empty')),
    );
  }
}

class _FormSheetTransition extends StatelessWidget {
  const _FormSheetTransition({required this.visible, required this.child});

  final bool visible;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: _formDuracao,
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        var position = Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(animation);

        return SlideTransition(position: position, child: child);
      },
      child: visible
          ? Align(
              key: const ValueKey('cliente-form-sheet-visible'),
              alignment: Alignment.bottomCenter,
              child: child,
            )
          : const SizedBox.shrink(key: ValueKey('cliente-form-sheet-empty')),
    );
  }
}

class _ClientesTopBar extends StatelessWidget {
  const _ClientesTopBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(AppRadii.md),
          onTap: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.arrow_back,
                  color: AppColors.backText,
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  'VOLTAR',
                  style: AppTextStyles.backButton.copyWith(
                    fontSize: 14,
                    height: 1,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),
        ),
        const Spacer(),
        const AppHelpActionButton(),
      ],
    );
  }
}
