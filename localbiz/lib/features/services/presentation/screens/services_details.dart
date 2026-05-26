import 'package:flutter/material.dart';
import 'package:localbiz/core/theme/app_colors.dart';

class DetalheServicoScreen extends StatefulWidget {
  const DetalheServicoScreen({super.key});

  @override
  State<DetalheServicoScreen> createState() => _DetalheServicoScreenState();
}

class _DetalheServicoScreenState extends State<DetalheServicoScreen> {
  DateTime _mesAtual = DateTime(2026, 4);
  int? _diaSelecionado = 5;

  final List<_Agendamento> _agendamentos = const [
    _Agendamento(
      nome: 'Maria jose da Silva',
      data: '07 Abril 2026',
      hora: '14:30',
    ),
    _Agendamento(nome: 'Clarissa Neres', data: '08 Abril 2026', hora: '09:30'),
    _Agendamento(nome: 'Rafaella Pessoa', data: '10 Abril 2026', hora: '16:20'),
  ];

  final Set<int> _diasComAgendamento = {7, 8, 9, 10};

  static const List<String> _diasSemana = [
    'DOM',
    'SEG',
    'TER',
    'QUA',
    'QUI',
    'SEX',
    'SÁB',
  ];
  static const List<String> _meses = [
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro',
  ];

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
      backgroundColor: Colors.white,
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
                color: const Color(0xFFF0F0F0),
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () =>
                    Navigator.of(context).pushNamed('/services/edit'),
                icon: const Icon(
                  Icons.edit,
                  color: AppColors.textPrimary,
                  size: 18,
                ),
              ),
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
    final primeiroDia = DateTime(_mesAtual.year, _mesAtual.month, 1);
    final ultimoDia = DateTime(_mesAtual.year, _mesAtual.month + 1, 0);
    final diasNoMes = ultimoDia.day;
    final iniciaSemana = primeiroDia.weekday % 7; // 0=Dom

    final diasMesAnterior = DateTime(_mesAtual.year, _mesAtual.month, 0).day;

    List<_DiaCalendario> dias = [];

    for (int i = iniciaSemana - 1; i >= 0; i--) {
      dias.add(_DiaCalendario(dia: diasMesAnterior - i, mesAtual: false));
    }

    for (int i = 1; i <= diasNoMes; i++) {
      dias.add(_DiaCalendario(dia: i, mesAtual: true));
    }

    int restante = 7 - (dias.length % 7);
    if (restante < 7) {
      for (int i = 1; i <= restante; i++) {
        dias.add(_DiaCalendario(dia: i, mesAtual: false));
      }
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: _mesAnterior,
                child: const Icon(Icons.chevron_left, color: Colors.black54),
              ),
              Text(
                '${_meses[_mesAtual.month - 1]} ${_mesAtual.year}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              GestureDetector(
                onTap: _proximoMes,
                child: const Icon(Icons.chevron_right, color: Colors.black54),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            children: _diasSemana
                .map(
                  (d) => Expanded(
                    child: Center(
                      child: Text(
                        d,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[500],
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 8),

          ...List.generate(dias.length ~/ 7, (semana) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: List.generate(7, (col) {
                  final item = dias[semana * 7 + col];
                  final isSelecionado =
                      item.mesAtual && item.dia == _diaSelecionado;
                  final temAgendamento =
                      item.mesAtual && _diasComAgendamento.contains(item.dia);

                  return Expanded(
                    child: GestureDetector(
                      onTap: item.mesAtual
                          ? () => setState(() => _diaSelecionado = item.dia)
                          : null,
                      child: Container(
                        height: 36,
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        decoration: BoxDecoration(
                          color: isSelecionado
                              ? AppColors.blue
                              : temAgendamento
                              ? AppColors.fieldFill
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child: Text(
                            '${item.dia}',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isSelecionado || temAgendamento
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              color: isSelecionado
                                  ? AppColors.fieldFill
                                  : item.mesAtual
                                  ? Colors.black87
                                  : Colors.grey[400],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            );
          }),
        ],
      ),
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
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.blue,
          foregroundColor: Colors.white,
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

class _DiaCalendario {
  final int dia;
  final bool mesAtual;
  const _DiaCalendario({required this.dia, required this.mesAtual});
}

class _Agendamento {
  final String nome;
  final String data;
  final String hora;
  const _Agendamento({
    required this.nome,
    required this.data,
    required this.hora,
  });
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
        color: Colors.white,
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
              color: Color(0xFF1A3A8F),
              size: 24,
            ),
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
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${agendamento.data} • ${agendamento.hora}',
                  style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
          const Text(
            'R\$ 180',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: Color(0xFF1A3A8F),
            ),
          ),
        ],
      ),
    );
  }
}
