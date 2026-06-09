import 'package:flutter/material.dart';

import 'package:localbiz/core/theme/app_colors.dart';
import 'package:localbiz/core/ui/labeled_fields.dart';
import 'package:localbiz/core/ui/app_top_bar.dart';
import 'package:localbiz/features/configuration/data/models/relatorio_model.dart';
import 'package:localbiz/features/configuration/data/repositories/relatorio_repository.dart';
import 'package:localbiz/features/services/presentation/screens/auth/auth_service.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  String _type = 'Financeiro';
  String _docType = 'PDF';
  String _sendTo = 'Email';

  // Datas selecionadas (guardadas para conversão ISO ao gerar).
  DateTime? _startDate;
  DateTime? _endDate;

  final _authService = AuthService();
  final _relatorioRepository = RelatorioRepository();

  bool _gerando = false;
  RelatorioModel? _resultado;

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  String _formatarBr(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/'
      '${d.month.toString().padLeft(2, '0')}/${d.year}';

  String _formatarIso(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  Future<void> _selecionarData({required bool inicio}) async {
    final agora = DateTime.now();
    final escolhida = await showDatePicker(
      context: context,
      initialDate: (inicio ? _startDate : _endDate) ?? agora,
      firstDate: DateTime(2020),
      lastDate: DateTime(agora.year + 5),
    );
    if (escolhida == null) return;
    setState(() {
      if (inicio) {
        _startDate = escolhida;
        _startDateController.text = _formatarBr(escolhida);
      } else {
        _endDate = escolhida;
        _endDateController.text = _formatarBr(escolhida);
      }
    });
  }

  Future<void> _gerar() async {
    final messenger = ScaffoldMessenger.of(context);

    if (_startDate == null || _endDate == null) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Selecione a data de início e de fim.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }
    if (_endDate!.isBefore(_startDate!)) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('A data fim deve ser maior ou igual à data início.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final uid = _authService.usuarioAtual?.uid;
    if (uid == null) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Você precisa estar logado para gerar relatórios.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      _gerando = true;
      _resultado = null;
    });
    try {
      final relatorio = await _relatorioRepository.gerar(
        uid: uid,
        tipo: _type,
        dataInicio: _formatarIso(_startDate!),
        dataFim: _formatarIso(_endDate!),
        formato: _docType,
        destino: _sendTo,
      );
      if (!mounted) return;
      setState(() => _resultado = relatorio);
      messenger.showSnackBar(
        const SnackBar(content: Text('Relatório gerado e salvo no histórico.')),
      );
    } catch (_) {
      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Não foi possível gerar o relatório.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) setState(() => _gerando = false);
    }
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Relatórios',
                      style: TextStyle(
                        fontSize: 30,
                        height: 1.1,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Para visualizar relatórios de movimentação e faturamento, preencha os filtros abaixo.',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.35,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 28),
                    LabeledDropdown(
                      label: 'Tipo',
                      value: _type,
                      items: const ['Financeiro', 'Vendas', 'Agendamentos'],
                      onChanged: (v) => setState(() => _type = v ?? _type),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: LabeledDateField(
                            label: 'Data Inicio',
                            hint: '00/00/0000',
                            controller: _startDateController,
                            onTap: () => _selecionarData(inicio: true),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: LabeledDateField(
                            label: 'Data Fim',
                            hint: '00/00/0000',
                            controller: _endDateController,
                            onTap: () => _selecionarData(inicio: false),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    LabeledDropdown(
                      label: 'Tipo do documento',
                      value: _docType,
                      items: const ['PDF', 'CSV', 'XLSX'],
                      enabled: false,
                      onChanged: (v) =>
                          setState(() => _docType = v ?? _docType),
                    ),
                    const _LegendaEmConstrucao(),
                    const SizedBox(height: 20),
                    LabeledDropdown(
                      label: 'Enviar Para',
                      value: _sendTo,
                      items: const ['Email', 'Whatsapp'],
                      enabled: false,
                      onChanged: (v) => setState(() => _sendTo = v ?? _sendTo),
                    ),
                    const _LegendaEmConstrucao(),
                    if (_resultado != null) ...[
                      const SizedBox(height: 28),
                      _ResultadoCard(relatorio: _resultado!),
                    ],
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: FormSubmitButton(
                label: _gerando ? 'Gerando...' : 'Enviar',
                onPressed: _gerando ? null : _gerar,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultadoCard extends StatelessWidget {
  const _ResultadoCard({required this.relatorio});

  final RelatorioModel relatorio;

  static String _reais(double v) =>
      'R\$ ${v.toStringAsFixed(2).replaceAll('.', ',')}';

  List<Widget> _linhasPorTipo() {
    switch (relatorio.tipo) {
      case 'Financeiro':
        return [
          _LinhaResumo(rotulo: 'Serviços', valor: _reais(relatorio.valorServicos)),
          _LinhaResumo(rotulo: 'Produtos', valor: _reais(relatorio.valorProdutos)),
          _LinhaResumo(rotulo: 'Total', valor: _reais(relatorio.valorTotal)),
        ];
      case 'Agendamentos':
        return [
          _LinhaResumo(rotulo: 'Finalizados', valor: '${relatorio.finalizados}'),
          _LinhaResumo(rotulo: 'Em aberto', valor: '${relatorio.emAberto}'),
        ];
      case 'Vendas':
      default:
        return [
          _LinhaResumo(rotulo: 'Vendas', valor: '${relatorio.quantidade}'),
          _LinhaResumo(rotulo: 'Faturamento', valor: _reais(relatorio.valorTotal)),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resumo — ${relatorio.tipo}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${relatorio.dataInicio} até ${relatorio.dataFim}',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          ..._linhasPorTipo(),
          const SizedBox(height: 8),
          const Text(
            'Salvo no histórico',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendaEmConstrucao extends StatelessWidget {
  const _LegendaEmConstrucao();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 6, left: 2),
      child: Row(
        children: [
          Icon(
            Icons.construction_outlined,
            size: 14,
            color: AppColors.textSecondary,
          ),
          SizedBox(width: 6),
          Text(
            'Funcionalidade em construção.',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _LinhaResumo extends StatelessWidget {
  const _LinhaResumo({required this.rotulo, required this.valor});

  final String rotulo;
  final String valor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            rotulo,
            style: const TextStyle(fontSize: 15, color: AppColors.textSecondary),
          ),
          Text(
            valor,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
