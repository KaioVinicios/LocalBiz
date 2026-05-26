import 'package:flutter/material.dart';
import 'package:localbiz/services/services_scheduling.dart';
import 'package:localbiz/services/widgets/service_calendar.dart';
import 'package:localbiz/theme/app_colors.dart';

class DetalheServicoScreen extends StatefulWidget {
  const DetalheServicoScreen({super.key});

  @override
  State<DetalheServicoScreen> createState() => _DetalheServicoScreenState();
}

class _DetalheServicoScreenState extends State<DetalheServicoScreen> {

  DateTime _mesAtual = DateTime(2026, 4);
  int? _diaSelecionado = 5;

  final List<_Agendamento> _agendamentos = const [
    _Agendamento(nome: 'Maria jose da Silva', data: '07 Abril 2026', hora: '14:30'),
    _Agendamento(nome: 'Clarissa Neres', data: '08 Abril 2026', hora: '09:30'),
    _Agendamento(nome: 'Rafaella Pessoa', data: '10 Abril 2026', hora: '16:20'),
  ];
 
  final Set<int> _diasComAgendamento = {7, 8, 9, 10};

  void _mesAnterior() => setState(() {
        _mesAtual = DateTime(_mesAtual.year, _mesAtual.month - 1);
        _diaSelecionado = null;
      });

  void _proximoMes() => setState(() {
        _mesAtual = DateTime(_mesAtual.year, _mesAtual.month + 1);
        _diaSelecionado = null;
      });

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
                    const SizedBox(height: 20),
                    _buildCalendario(),
                    const SizedBox(height: 28),
                    _buildUltimosAgendamentos(),
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
          const Icon(Icons.help_outline, color: AppColors.textPrimary, size: 24),
        ],
      ),
    );
  }

  Widget _buildTitulo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Expanded(
              child: Text(
                'Corte + Hidratação',
                style: TextStyle(
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
              child: const Icon(Icons.edit, color: AppColors.textPrimary, size: 18),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              'Serviços Capilares',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 16),
            const Text(
              'R\$ 180,00',
              style: TextStyle(
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

  Widget _buildCalendario() {
    return ServiceCalendar(
      mesAtual: _mesAtual,
      diaSelecionado: _diaSelecionado,
      diasComAgendamento: _diasComAgendamento,
      onMesAnterior: _mesAnterior,
      onProximoMes: _proximoMes,
      onDiaSelecionado: (dia) => setState(() => _diaSelecionado = dia),
    );
  }

  Widget _buildUltimosAgendamentos() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ultimos Agendamentos',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ..._agendamentos.map((a) => _AgendamentoCard(agendamento: a)),
      ],
    );
  }

  Widget _buildBottomButton() {
    return Container(
      width: double.infinity,
      color: AppColors.sheetSurface,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const AgendamentoServicoScreen(),
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

class _Agendamento {
  final String nome;
  final String data;
  final String hora;
  const _Agendamento({required this.nome, required this.data, required this.hora});
}

class _AgendamentoCard extends StatelessWidget {
  final _Agendamento agendamento;

  const _AgendamentoCard({required this.agendamento});

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
            child: Icon(Icons.person_outline, color: AppColors.cardIconFg, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  agendamento.nome,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${agendamento.data} • ${agendamento.hora}',
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          const Text(
            'R\$ 180',
            style: TextStyle(
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