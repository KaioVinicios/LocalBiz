import 'dart:async';
import 'package:flutter/material.dart';
import 'package:localbiz/features/services/models/agendamento_model.dart';
import 'package:localbiz/features/services/models/servico_model.dart';
import 'package:localbiz/features/services/repositories/agendamentos_repositories.dart';
import 'package:localbiz/features/services/repositories/servicos_repositories.dart';
import 'package:localbiz/features/services/presentation/screens/services_scheduling.dart';
import 'package:localbiz/features/services/presentation/screens/widgets/service_calendar.dart';
import 'package:localbiz/core/theme/app_colors.dart';

class DetalheServicoScreen extends StatefulWidget {
  const DetalheServicoScreen({super.key, required this.servicoId});

  final String servicoId;

  @override
  State<DetalheServicoScreen> createState() => _DetalheServicoScreenState();
}

class _DetalheServicoScreenState extends State<DetalheServicoScreen> {
  final ServicosRepository _servicosRepository = ServicosRepository();
  final AgendamentosRepository _agendamentosRepository =
      AgendamentosRepository();

  late final Future<ServicoModel?> _servicoFuture;
  StreamSubscription<List<AgendamentoModel>>? _agendamentosSub;
  List<AgendamentoModel> _agendamentosCached = [];

  DateTime _mesAtual = DateTime.now();
  int? _diaSelecionado;

  @override
  void initState() {
    super.initState();
    _servicoFuture = _servicosRepository.buscarPorId(widget.servicoId);
    _agendamentosSub = _agendamentosRepository
        .listarPorServico(widget.servicoId)
        .listen((lista) {
          setState(() => _agendamentosCached = lista);
        });
  }

  @override
  void dispose() {
    _agendamentosSub?.cancel();
    super.dispose();
  }

  void _mesAnterior() => setState(() {
    _mesAtual = DateTime(_mesAtual.year, _mesAtual.month - 1);
    _diaSelecionado = null;
  });

  void _proximoMes() => setState(() {
    _mesAtual = DateTime(_mesAtual.year, _mesAtual.month + 1);
    _diaSelecionado = null;
  });

  DateTime? _parseData(String data) {
    try {
      final iso = DateTime.tryParse(data.trim());
      if (iso != null) return iso;
      final partes = data.trim().split('/');
      if (partes.length == 3) {
        return DateTime(
          int.parse(partes[2]),
          int.parse(partes[1]),
          int.parse(partes[0]),
        );
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Set<int> _diasComAgendamentoNoMes(List<AgendamentoModel> agendamentos) {
    final dias = <int>{};
    for (final item in agendamentos) {
      final data = _parseData(item.data);
      if (data == null) continue;
      if (data.year == _mesAtual.year && data.month == _mesAtual.month) {
        dias.add(data.day);
      }
    }
    return dias;
  }

  List<AgendamentoModel> _filtrarPorDia(List<AgendamentoModel> agendamentos) {
    if (_diaSelecionado == null) return agendamentos;
    return agendamentos.where((a) {
      final data = _parseData(a.data);
      return data != null &&
          data.year == _mesAtual.year &&
          data.month == _mesAtual.month &&
          data.day == _diaSelecionado;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ServicoModel?>(
      future: _servicoFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Text(
                'Erro ao carregar o servico.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          );
        }

        final servico = snapshot.data;
        if (servico == null) {
          return const Scaffold(
            body: Center(
              child: Text(
                'Servico nao encontrado.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          );
        }

        final diasComAgendamento = _diasComAgendamentoNoMes(
          _agendamentosCached,
        );
        final filtrados = _filtrarPorDia(_agendamentosCached);

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
                        _buildTitulo(servico),
                        const SizedBox(height: 20),
                        ServiceCalendar(
                          mesAtual: _mesAtual,
                          diaSelecionado: _diaSelecionado,
                          diasComAgendamento: diasComAgendamento,
                          onMesAnterior: _mesAnterior,
                          onProximoMes: _proximoMes,
                          onDiaSelecionado: (dia) =>
                              setState(() => _diaSelecionado = dia),
                        ),
                        const SizedBox(height: 28),
                        _buildAgendamentos(
                          servico: servico,
                          agendamentos: filtrados,
                          todosVazios: _agendamentosCached.isEmpty,
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                _buildBottomButton(servico),
              ],
            ),
          ),
        );
      },
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

  String _formatCurrency(double value) {
    return value.toStringAsFixed(2).replaceAll('.', ',');
  }

  Widget _buildTitulo(ServicoModel servico) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                servico.nome,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.navBarBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.edit,
                color: AppColors.textPrimary,
                size: 18,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              servico.categoria,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              'R\$ ${_formatCurrency(servico.preco)}',
              style: const TextStyle(
                color: AppColors.blue,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAgendamentos({
    required ServicoModel servico,
    required List<AgendamentoModel> agendamentos,
    required bool todosVazios,
  }) {
    final tituloSecao = _diaSelecionado != null
        ? 'Agendamentos em $_diaSelecionado/${_mesAtual.month.toString().padLeft(2, '0')}'
        : 'Ultimos Agendamentos';

    if (todosVazios) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tituloSecao,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Nenhum agendamento para este servico.',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      );
    }

    if (agendamentos.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tituloSecao,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Nenhum agendamento neste dia.',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tituloSecao,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ...agendamentos
            .take(4)
            .map(
              (a) =>
                  _AgendamentoCard(agendamento: a, nomeServico: servico.nome),
            ),
      ],
    );
  }

  Widget _buildBottomButton(ServicoModel servico) {
    return Container(
      width: double.infinity,
      color: AppColors.sheetSurface,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => AgendamentoServicoScreen(servico: servico),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.blue,
          foregroundColor: AppColors.sheetSurface,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
        child: const Text(
          'Agendar',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _AgendamentoCard extends StatelessWidget {
  final AgendamentoModel agendamento;
  final String nomeServico;

  const _AgendamentoCard({
    required this.agendamento,
    required this.nomeServico,
  });

  String _formatCurrency(double value) {
    return value.toStringAsFixed(2).replaceAll('.', ',');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.sheetSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.fieldFill,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.person_outline,
              color: AppColors.cardIconFg,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nomeServico,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${agendamento.clienteNome} • ${agendamento.data} • ${agendamento.hora.trim()}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            'R\$ ${_formatCurrency(agendamento.valor)}',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: AppColors.cardIconFg,
            ),
          ),
        ],
      ),
    );
  }
}
