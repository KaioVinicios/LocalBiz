import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:localbiz/features/clientes/presentation/screens/cliente_detalhe_page.dart';
import 'package:localbiz/features/clientes/presentation/widgets/cliente_list_item.dart';
import 'package:localbiz/features/clientes/domain/entities/cliente_model.dart';
import 'package:localbiz/features/clientes/presentation/widgets/novo_cliente_form.dart';
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
  final buscaController = TextEditingController();
  final nomeController = TextEditingController();
  final telefoneController = TextEditingController();
  final emailController = TextEditingController();

  bool abrindoForm = false;
  Cliente? clienteSelecionado;
  Cliente? clienteEmEdicao;

  final clientes = <Cliente>[
    Cliente(
      nome: 'Carlos Mendes',
      telefone: '(79) 9915131-22',
      email: 'carlos@email.com',
      historico: const [
        ClienteHistorico(
          data: '02/05/2026',
          servico: 'Corte Masculino',
          valor: 'R\$45,00',
        ),
      ],
    ),
    Cliente(
      nome: 'Mariana Silva',
      telefone: '(79) 9915131-22',
      email: 'mariana@email.com',
      historico: const [
        ClienteHistorico(
          data: '04/05/2026',
          servico: 'Escova',
          valor: 'R\$70,00',
        ),
      ],
    ),
    Cliente(
      nome: 'Julian Torres',
      telefone: '(79) 9987654-33',
      email: 'julian@email.com',
      historico: const [
        ClienteHistorico(
          data: '08/05/2026',
          servico: 'Barba',
          valor: 'R\$35,00',
        ),
      ],
    ),
    Cliente(
      nome: 'Ana Patricia',
      telefone: '(79) 9876543-21',
      email: 'ana@email.com',
      historico: const [
        ClienteHistorico(
          data: '11/05/2026',
          servico: 'Manicure',
          valor: 'R\$30,00',
        ),
      ],
    ),
  ];

  @override
  void dispose() {
    buscaController.dispose();
    nomeController.dispose();
    telefoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  List<Cliente> get clientesFiltrados {
    var busca = buscaController.text.trim().toLowerCase();

    if (busca.isEmpty) {
      return clientes;
    }

    return clientes.where((cliente) {
      return cliente.nome.toLowerCase().contains(busca) ||
          cliente.telefone.toLowerCase().contains(busca);
    }).toList();
  }

  void abrirForm() {
    setState(() {
      clienteEmEdicao = null;
      nomeController.clear();
      telefoneController.clear();
      emailController.clear();
      abrindoForm = true;
    });
  }

  void fecharForm() {
    setState(() {
      abrindoForm = false;
      clienteEmEdicao = null;
      nomeController.clear();
      telefoneController.clear();
      emailController.clear();
    });
  }

  void abrirEdicao(Cliente cliente) {
    setState(() {
      clienteEmEdicao = cliente;
      nomeController.text = cliente.nome;
      telefoneController.text = cliente.telefone;
      emailController.text = cliente.email;
      abrindoForm = true;
    });
  }

  void salvarCliente() {
    var nome = nomeController.text.trim();
    var telefone = telefoneController.text.trim();
    var email = emailController.text.trim();

    if (nome.isEmpty) {
      return;
    }

    setState(() {
      var cliente = clienteEmEdicao;

      if (cliente == null) {
        clientes.add(
          Cliente(nome: nome, telefone: telefone, email: email, historico: []),
        );
      } else {
        cliente.nome = nome;
        cliente.telefone = telefone;
        cliente.email = email;
      }

      nomeController.clear();
      telefoneController.clear();
      emailController.clear();
      clienteEmEdicao = null;
      abrindoForm = false;
    });
  }

  void selecionarCliente(Cliente cliente) {
    setState(() {
      clienteSelecionado = cliente;
    });
  }

  void voltarParaLista() {
    setState(() {
      clienteSelecionado = null;
    });
  }

  Future<void> confirmarExclusao(Cliente cliente) async {
    var excluir = await showDialog<bool>(
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

    setState(() {
      clientes.remove(cliente);
      clienteSelecionado = null;
      clienteEmEdicao = null;
      abrindoForm = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var lista = clientesFiltrados;
    var cliente = clienteSelecionado;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Stack(
          children: [
            if (cliente == null)
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
                      child: ListView.separated(
                        padding: const EdgeInsets.only(
                          bottom: AppSizes.squareAction + AppSpacing.lg,
                        ),
                        itemCount: lista.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          return ClienteListItem(
                            cliente: lista[index],
                            onTap: () => selecionarCliente(lista[index]),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
            else
              ClienteDetalhePage(
                cliente: cliente,
                onVoltar: voltarParaLista,
                onEditar: () => abrirEdicao(cliente),
                onExcluir: () => confirmarExclusao(cliente),
              ),
            if (cliente == null)
              Positioned(
                right: AppSpacing.lg,
                bottom: AppSpacing.lg,
                child: AppFloatingAddButton(
                  tooltip: 'Adicionar cliente',
                  onPressed: abrirForm,
                ),
              ),
            Positioned.fill(
              child: _FormBackdrop(visible: abrindoForm, onTap: fecharForm),
            ),
            Positioned.fill(
              child: _FormSheetTransition(
                visible: abrindoForm,
                child: NovoClienteForm(
                  title: clienteEmEdicao == null
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
