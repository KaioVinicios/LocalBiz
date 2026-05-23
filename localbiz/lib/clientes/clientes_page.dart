import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:localbiz/theme/app_colors.dart';
import 'package:localbiz/theme/app_design_tokens.dart';
import 'package:localbiz/widgets/app_list_card.dart';
import 'package:localbiz/widgets/app_primary_button.dart';
import 'package:localbiz/widgets/app_square_action_button.dart';
import 'package:localbiz/widgets/app_text_field.dart';

class Cliente {
  Cliente({required this.nome, required this.telefone, required this.email});

  String nome;
  String telefone;
  String email;
}

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

  final clientes = <Cliente>[
    Cliente(
      nome: 'Mariana Silva',
      telefone: '(79) 9915131-22',
      email: 'mariana@email.com',
    ),
    Cliente(
      nome: 'Julian Torres',
      telefone: '(79) 9987654-33',
      email: 'julian@email.com',
    ),
    Cliente(
      nome: 'Ana Patricia',
      telefone: '(79) 9876543-21',
      email: 'ana@email.com',
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
      abrindoForm = true;
    });
  }

  void fecharForm() {
    setState(() {
      abrindoForm = false;
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
      clientes.add(Cliente(nome: nome, telefone: telefone, email: email));
      nomeController.clear();
      telefoneController.clear();
      emailController.clear();
      abrindoForm = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var lista = clientesFiltrados;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSizes.screenMaxWidth,
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _ClientesTopBar(),
                      const SizedBox(height: AppSpacing.lg),
                      const Text('Clientes', style: AppTextStyles.pageTitle),
                      const SizedBox(height: AppSpacing.md),
                      AppTextField(
                        hint: 'Buscar por nome ...',
                        controller: buscaController,
                        prefixIcon: Icons.search,
                        height: AppSizes.searchHeight,
                        radius: AppRadii.pill,
                        prefixIconSize: 34,
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Expanded(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: SizedBox(
                            width: AppSizes.contentWidth,
                            child: ListView.separated(
                              padding: const EdgeInsets.only(
                                bottom: AppSizes.squareAction + AppSpacing.lg,
                              ),
                              itemCount: lista.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: AppSpacing.md),
                              itemBuilder: (context, index) {
                                return ClienteListItem(cliente: lista[index]);
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: AppSpacing.lg,
                  bottom: AppSpacing.lg,
                  child: AppSquareActionButton(
                    icon: Icons.add,
                    tooltip: 'Adicionar cliente',
                    onPressed: abrirForm,
                  ),
                ),
                if (abrindoForm)
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: fecharForm,
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                        child: Container(
                          color: AppColors.surface.withValues(alpha: 0.58),
                        ),
                      ),
                    ),
                  ),
                if (abrindoForm)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: NovoClienteForm(
                      nomeController: nomeController,
                      telefoneController: telefoneController,
                      emailController: emailController,
                      onFechar: fecharForm,
                      onSalvar: salvarCliente,
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
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.arrow_back, color: AppColors.backText, size: 28),
                SizedBox(width: AppSpacing.xs),
                Text('VOLTAR', style: AppTextStyles.backButton),
              ],
            ),
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () {},
          tooltip: 'Ajuda',
          icon: const Icon(
            Icons.help_outline,
            color: AppColors.textPrimary,
            size: 30,
          ),
        ),
      ],
    );
  }
}

class ClienteListItem extends StatelessWidget {
  const ClienteListItem({super.key, required this.cliente});

  final Cliente cliente;

  @override
  Widget build(BuildContext context) {
    var inicial = cliente.nome.isEmpty ? '?' : cliente.nome[0].toUpperCase();

    return AppListCard(
      title: cliente.nome,
      subtitle: cliente.telefone,
      initial: inicial,
    );
  }
}

class NovoClienteForm extends StatelessWidget {
  const NovoClienteForm({
    super.key,
    required this.nomeController,
    required this.telefoneController,
    required this.emailController,
    required this.onFechar,
    required this.onSalvar,
  });

  final TextEditingController nomeController;
  final TextEditingController telefoneController;
  final TextEditingController emailController;
  final VoidCallback onFechar;
  final VoidCallback onSalvar;

  @override
  Widget build(BuildContext context) {
    var bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    var availableHeight =
        MediaQuery.sizeOf(context).height -
        MediaQuery.paddingOf(context).top -
        AppSpacing.md;
    var targetHeight = AppSizes.clientFormHeight + bottomInset;
    var sheetHeight = targetHeight > availableHeight
        ? availableHeight
        : targetHeight;

    return Material(
      color: Colors.transparent,
      child: SizedBox(
        key: const ValueKey('novo-cliente-form-sheet'),
        width: double.infinity,
        height: sheetHeight,
        child: Container(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.sm + bottomInset,
          ),
          decoration: const BoxDecoration(
            color: AppColors.sheetSurface,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppRadii.sheet),
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x22000000),
                blurRadius: 26,
                offset: Offset(0, -8),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: AppSizes.sheetHandleWidth,
                    height: AppSizes.sheetHandleHeight,
                    decoration: BoxDecoration(
                      color: AppColors.textPrimary,
                      borderRadius: BorderRadius.circular(AppRadii.sm),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Novo Cliente',
                        style: AppTextStyles.sheetTitle,
                      ),
                    ),
                    Tooltip(
                      message: 'Fechar',
                      child: InkWell(
                        onTap: onFechar,
                        borderRadius: BorderRadius.circular(AppRadii.md),
                        child: const SizedBox.square(
                          dimension: 40,
                          child: Icon(
                            Icons.close,
                            color: AppColors.textPrimary,
                            size: 26,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                AppTextField(
                  label: 'Nome*',
                  hint: 'Ex: Maria Silva',
                  controller: nomeController,
                  textInputAction: TextInputAction.next,
                  labelGap: 2,
                ),
                const SizedBox(height: AppSpacing.xs),
                AppTextField(
                  label: 'Telefone',
                  hint: '(00) 00000-0000',
                  controller: telefoneController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  labelGap: 2,
                ),
                const SizedBox(height: AppSpacing.xs),
                AppTextField(
                  label: 'E-mail',
                  hint: 'email@exemplo.com',
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  labelGap: 2,
                ),
                const SizedBox(height: AppSpacing.xs),
                AppPrimaryButton(label: 'Salvar Cliente', onPressed: onSalvar),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
