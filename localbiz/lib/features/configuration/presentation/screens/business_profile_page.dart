import 'package:flutter/material.dart';

import 'package:localbiz/core/theme/app_colors.dart';
import 'package:localbiz/core/ui/labeled_fields.dart';
import 'package:localbiz/core/ui/app_top_bar.dart';
import 'package:localbiz/core/utils/br_input.dart';
import 'package:localbiz/features/configuration/data/models/negocio_model.dart';
import 'package:localbiz/features/configuration/data/repositories/negocio_repository.dart';
import 'package:localbiz/features/services/presentation/screens/auth/auth_service.dart';

class BusinessProfilePage extends StatefulWidget {
  const BusinessProfilePage({super.key});

  @override
  State<BusinessProfilePage> createState() => _BusinessProfilePageState();
}

class _BusinessProfilePageState extends State<BusinessProfilePage> {
  final _nameController = TextEditingController();
  final _cnpjController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _addressController = TextEditingController();
  String _activity = 'Ambos';

  final _authService = AuthService();
  final _negocioRepository = NegocioRepository();

  bool _carregando = true;
  bool _salvando = false;

  String? _cnpjError;
  String? _whatsappError;

  @override
  void initState() {
    super.initState();
    _carregarPerfil();
  }

  Future<void> _carregarPerfil() async {
    final uid = _authService.usuarioAtual?.uid;
    if (uid == null) {
      if (mounted) setState(() => _carregando = false);
      return;
    }
    try {
      final negocio = await _negocioRepository.carregar(uid);
      if (!mounted) return;
      if (negocio != null) {
        _nameController.text = negocio.nome;
        _cnpjController.text = negocio.cnpjCpf;
        _whatsappController.text = negocio.whatsapp;
        _addressController.text = negocio.endereco;
        _activity = negocio.ramoAtividade;
      }
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  bool _validarCampos() {
    final cnpj = _cnpjController.text.trim();
    final whatsapp = _whatsappController.text.trim();

    String? cnpjErro;
    if (cnpj.isEmpty) {
      cnpjErro = 'Informe o CNPJ ou CPF.';
    } else if (!validarCpfCnpj(cnpj)) {
      cnpjErro = 'CNPJ ou CPF inválido.';
    }

    String? whatsappErro;
    if (whatsapp.isEmpty) {
      whatsappErro = 'Informe o WhatsApp de contato.';
    } else if (!validarTelefone(whatsapp)) {
      whatsappErro = 'Telefone inválido. Use DDD + número.';
    }

    setState(() {
      _cnpjError = cnpjErro;
      _whatsappError = whatsappErro;
    });
    return cnpjErro == null && whatsappErro == null;
  }

  Future<void> _salvar() async {
    final messenger = ScaffoldMessenger.of(context);
    final uid = _authService.usuarioAtual?.uid;
    if (uid == null) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Você precisa estar logado para salvar.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (!_validarCampos()) return;

    setState(() => _salvando = true);
    try {
      await _negocioRepository.salvar(
        uid,
        NegocioModel(
          nome: _nameController.text.trim(),
          ramoAtividade: _activity,
          cnpjCpf: _cnpjController.text.trim(),
          whatsapp: _whatsappController.text.trim(),
          endereco: _addressController.text.trim(),
        ),
      );
      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(content: Text('Perfil do negócio salvo com sucesso.')),
      );
    } catch (_) {
      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Não foi possível salvar. Tente novamente.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cnpjController.dispose();
    _whatsappController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            const AppTopBar(),
            Expanded(
              child: _carregando
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Perfil do Negócio',
                            style: TextStyle(
                              fontSize: 30,
                              height: 1.1,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Altere os dados abaixo para mudança do perfil de negócio.',
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.35,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 28),
                          LabeledTextField(
                            label: 'Nome da Empresa',
                            hint: 'Meu negócio Local',
                            controller: _nameController,
                          ),
                          const SizedBox(height: 20),
                          LabeledDropdown(
                            label: 'Ramo da Atividade',
                            value: _activity,
                            items: const ['Ambos', 'Produtos', 'Serviços'],
                            onChanged: (v) =>
                                setState(() => _activity = v ?? _activity),
                          ),
                          const SizedBox(height: 20),
                          LabeledTextField(
                            label: 'CNPJ ou CPF',
                            hint: '00.000.000/0000-00',
                            controller: _cnpjController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [CpfCnpjInputFormatter()],
                            errorText: _cnpjError,
                            onChanged: (_) {
                              if (_cnpjError != null) {
                                setState(() => _cnpjError = null);
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          LabeledTextField(
                            label: 'Whatsapp de Contato',
                            hint: '(79) 99999-9999',
                            controller: _whatsappController,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [TelefoneInputFormatter()],
                            errorText: _whatsappError,
                            onChanged: (_) {
                              if (_whatsappError != null) {
                                setState(() => _whatsappError = null);
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          LabeledTextField(
                            label: 'Endereço Completo',
                            hint: 'Rua, Número, Bairro , Cidade',
                            controller: _addressController,
                          ),
                        ],
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: FormSubmitButton(
                label: _salvando ? 'Salvando...' : 'Salvar Alterações',
                onPressed: (_carregando || _salvando) ? null : _salvar,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
