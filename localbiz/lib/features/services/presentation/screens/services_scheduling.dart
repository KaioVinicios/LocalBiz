import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localbiz/features/services/models/agendamento_model.dart';
import 'package:localbiz/features/services/models/servico_model.dart';
import 'package:localbiz/features/services/repositories/agendamentos_repositories.dart';
import 'package:localbiz/features/services/presentation/screens/widgets/service_calendar.dart';
import 'package:localbiz/core/theme/app_colors.dart';


class AgendamentoServicoScreen extends StatefulWidget {
  const AgendamentoServicoScreen({super.key, this.servico});

  final ServicoModel? servico;

  @override
  State<AgendamentoServicoScreen> createState() =>
      _AgendamentoServicoScreenState();
}

class _AgendamentoServicoScreenState extends State<AgendamentoServicoScreen> {
  final TextEditingController _clienteController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final AgendamentosRepository _agendamentosRepository =
      AgendamentosRepository();

  String? _categoriaSelecionada;
  String? _horarioSelecionado;

  DateTime _mesAtual = DateTime.now();
  int? _diaSelecionado;

  static const List<String> _categorias = [
    'Novo Cliente',
    'Cliente Recorrente',
    'Cliente VIP',
  ];

  static const List<String> _horarios = [
    '08:00',
    '08:30',
    '09:00',
    '09:30',
    '10:00',
    '10:30',
    '11:00',
    '11:30',
    '13:00',
    '13:30',
    '14:00',
    '14:30',
    '15:00',
    '15:30',
    '16:00',
    '16:30',
    '17:00',
    '17:30',
  ];

  @override
  void initState() {
    super.initState();
    _categoriaSelecionada = _categorias.first; 
  }

  void _mesAnterior() => setState(() {
    _mesAtual = DateTime(_mesAtual.year, _mesAtual.month - 1);
    _diaSelecionado = null;
  });

  void _proximoMes() => setState(() {
    _mesAtual = DateTime(_mesAtual.year, _mesAtual.month + 1);
    _diaSelecionado = null;
  });

  String _formatCurrency(double value) {
    return value.toStringAsFixed(2).replaceAll('.', ',');
  }

  String _dataSelecionadaIso() {
    final dia = _diaSelecionado!;
    final data = DateTime(_mesAtual.year, _mesAtual.month, dia);
    final mes = data.month.toString().padLeft(2, '0');
    final diaFormatado = data.day.toString().padLeft(2, '0');
    return '${data.year}-$mes-$diaFormatado';
  }

  Set<int> _diasComAgendamentoNoMes(List<AgendamentoModel> agendamentos) {
    final dias = <int>{};
    for (final item in agendamentos) {
      final parsedData = DateTime.tryParse(item.data.trim());
      if (parsedData == null) {
        continue;
      }
      if (parsedData.year == _mesAtual.year &&
          parsedData.month == _mesAtual.month) {
        dias.add(parsedData.day);
      }
    }
    return dias;
  }

  Future<void> _confirmarAgendamento() async {
    final servico = widget.servico;
    if (servico == null || servico.id.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Servico invalido para agendamento.')),
      );
      return;
    }

    if (_clienteController.text.trim().isEmpty ||
        _telefoneController.text.trim().isEmpty ||
        _diaSelecionado == null ||
        _horarioSelecionado == null ||
        _horarioSelecionado!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos obrigatorios.')),
      );
      return;
    }

    final payload = <String, dynamic>{
      'servicoId': servico.id,
      'clienteNome': _clienteController.text.trim(),
      'clienteTelefone': _telefoneController.text.trim(),
      'categoriaCliente': _categoriaSelecionada ?? _categorias.first,
      'data': _dataSelecionadaIso(),
      'hora': _horarioSelecionado,
      'valor': servico.preco,
      'status': 'confirmado',
    };

    try {
      await _agendamentosRepository.criarAgendamento(payload);
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agendamento confirmado com sucesso.')),
      );
      Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falha ao confirmar agendamento.')),
      );
    }
  }

  @override
  void dispose() {
    _clienteController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTopBar(),
                    const SizedBox(height: 12),
                    _buildTitulo(),
                    const SizedBox(height: 24),
                    _buildCampoProcedimento(),
                    const SizedBox(height: 16),
                    _buildCampoCliente(),
                    const SizedBox(height: 16),
                    _buildDropdownCategoria(),
                    const SizedBox(height: 16),
                    _buildCampoTelefone(),
                    const SizedBox(height: 24),
                    _buildSectionLabel('Selecionar Data'),
                    const SizedBox(height: 12),
                    _buildCalendario(),
                    const SizedBox(height: 24),
                    _buildSectionLabel('Selecionar Horário'),
                    const SizedBox(height: 12),
                    _buildDropdownHorario(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            _buildBottomButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.arrow_back, color: AppColors.blue, size: 20),
                SizedBox(width: 6),
                Text(
                  'VOLTAR',
                  style: TextStyle(
                    color: AppColors.blue,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.help_outline,
            color: AppColors.textPrimary,
            size: 24,
          ),
        ],
      ),
    );
  }

  Widget _buildTitulo() {
    final servico = widget.servico;
    final categoria = servico?.categoria ?? 'Servico';
    final preco = servico != null
        ? 'R\$ ${_formatCurrency(servico.preco)}'
        : 'R\$ 0,00';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Agendamento',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _BadgeTexto(label: categoria, cor: AppColors.blue),
            const SizedBox(width: 12),
            _BadgeTexto(label: preco, cor: AppColors.blue),
          ],
        ),
      ],
    );
  }

  Widget _buildCampoProcedimento() {
    final nomeServico = widget.servico?.nome ?? 'Servico nao informado';
    return _CampoLabel(
      label: 'Procedimento',
      child: _InputReadOnly(texto: nomeServico),
    );
  }

  Widget _buildCampoCliente() {
    return _CampoLabel(
      label: 'Cliente',
      child: _InputField(
        controller: _clienteController,
        hint: '',
        keyboardType: TextInputType.name,
        textCapitalization: TextCapitalization.words,
      ),
    );
  }

  Widget _buildDropdownCategoria() {
    return _CampoLabel(
      label: 'Categoria',
      child: _DropdownField<String>(
        value: _categoriaSelecionada ?? _categorias.first,
        items: _categorias,
        labelBuilder: (v) => v,
        onChanged: (v) => setState(() => _categoriaSelecionada = v),
      ),
    );
  }

  Widget _buildCampoTelefone() {
    return _CampoLabel(
      label: 'Telefone',
      child: _InputField(
        controller: _telefoneController,
        hint: '(00) 00000-0000',
        keyboardType: TextInputType.phone,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      ),
    );
  }

  Widget _buildSectionLabel(String texto) {
    return Text(
      texto,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildCalendario() {
    final servicoId = widget.servico?.id;
    if (servicoId == null || servicoId.isEmpty) {
      return ServiceCalendar(
        mesAtual: _mesAtual,
        diaSelecionado: _diaSelecionado,
        diasComAgendamento: const {},
        onMesAnterior: _mesAnterior,
        onProximoMes: _proximoMes,
        onDiaSelecionado: (dia) => setState(() => _diaSelecionado = dia),
      );
    }

    return StreamBuilder<List<AgendamentoModel>>(
      stream: _agendamentosRepository.listarPorServico(servicoId),
      builder: (context, snapshot) {
        final diasComAgendamento = _diasComAgendamentoNoMes(
          snapshot.data ?? const [],
        );
        return ServiceCalendar(
          mesAtual: _mesAtual,
          diaSelecionado: _diaSelecionado,
          diasComAgendamento: diasComAgendamento,
          onMesAnterior: _mesAnterior,
          onProximoMes: _proximoMes,
          onDiaSelecionado: (dia) => setState(() => _diaSelecionado = dia),
        );
      },
    );
  }

  Widget _buildDropdownHorario() {
    return _DropdownField<String>(
      value: _horarioSelecionado,
      items: _horarios,
      labelBuilder: (v) => v,
      hint: 'Selecionar',
      onChanged: (v) => setState(() => _horarioSelecionado = v),
    );
  }

  Widget _buildBottomButton() {
    return Container(
      width: double.infinity,
      color: AppColors.sheetSurface,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: ElevatedButton(
        onPressed: _confirmarAgendamento,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.blue,
          foregroundColor: AppColors.sheetSurface,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
        child: const Text(
          'Confirmar Agendamento',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _BadgeTexto extends StatelessWidget {
  final String label;
  final Color cor;

  const _BadgeTexto({required this.label, required this.cor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: cor.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(color: cor, fontSize: 13, fontWeight: FontWeight.w500),
      ),
    );
  }
}

class _CampoLabel extends StatelessWidget {
  final String label;
  final Widget child;

  const _CampoLabel({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _InputReadOnly extends StatelessWidget {
  final String texto;

  const _InputReadOnly({required this.texto});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        texto,
        style: TextStyle(fontSize: 15, color: AppColors.textSecondary),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;

  const _InputField({
    required this.controller,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      inputFormatters: inputFormatters,
      style: const TextStyle(fontSize: 15, color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 15),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        filled: true,
        fillColor: AppColors.sheetSurface,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.blue, width: 1.5),
        ),
      ),
    );
  }
}

class _DropdownField<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final String Function(T) labelBuilder;
  final ValueChanged<T?> onChanged;
  final String? hint;

  const _DropdownField({
    required this.value,
    required this.items,
    required this.labelBuilder,
    required this.onChanged,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          hint: hint != null
              ? Text(
                  hint!,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.textMuted,
                  ),
                )
              : null,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.textSecondary,
          ),
          style: const TextStyle(fontSize: 15, color: AppColors.textPrimary),
          items: items
              .map(
                (item) => DropdownMenuItem<T>(
                  value: item,
                  child: Text(labelBuilder(item)),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}