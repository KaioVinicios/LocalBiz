import 'package:flutter/material.dart';
import 'package:localbiz/theme/app_colors.dart';

class ServiceCalendar extends StatelessWidget {
  const ServiceCalendar({
    super.key,
    required this.mesAtual,
    required this.diaSelecionado,
    required this.diasComAgendamento,
    required this.onMesAnterior,
    required this.onProximoMes,
    required this.onDiaSelecionado,
  });

  final DateTime mesAtual;
  final int? diaSelecionado;
  final Set<int> diasComAgendamento;
  final VoidCallback onMesAnterior;
  final VoidCallback onProximoMes;
  final ValueChanged<int> onDiaSelecionado;

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

  @override
  Widget build(BuildContext context) {
    final primeiroDia = DateTime(mesAtual.year, mesAtual.month, 1);
    final ultimoDia = DateTime(mesAtual.year, mesAtual.month + 1, 0);
    final diasNoMes = ultimoDia.day;
    final iniciaSemana = primeiroDia.weekday % 7;

    final diasMesAnterior = DateTime(mesAtual.year, mesAtual.month, 0).day;
    final List<_CalendarDay> dias = [];

    for (int i = iniciaSemana - 1; i >= 0; i--) {
      dias.add(_CalendarDay(dia: diasMesAnterior - i, mesAtual: false));
    }

    for (int i = 1; i <= diasNoMes; i++) {
      dias.add(_CalendarDay(dia: i, mesAtual: true));
    }

    final restante = 7 - (dias.length % 7);
    if (restante < 7) {
      for (int i = 1; i <= restante; i++) {
        dias.add(_CalendarDay(dia: i, mesAtual: false));
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
                onTap: onMesAnterior,
                child: const Icon(Icons.chevron_left, color: AppColors.textSecondary),
              ),
              Text(
                '${_meses[mesAtual.month - 1]} ${mesAtual.year}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: onProximoMes,
                child: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
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
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
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
                  final isSelecionado = item.mesAtual && item.dia == diaSelecionado;
                  final temAgendamento =
                      item.mesAtual && diasComAgendamento.contains(item.dia);

                  return Expanded(
                    child: GestureDetector(
                      onTap: item.mesAtual ? () => onDiaSelecionado(item.dia) : null,
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
                                  ? AppColors.sheetSurface
                                  : item.mesAtual
                                      ? AppColors.textPrimary
                                      : AppColors.textMuted,
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
}

class _CalendarDay {
  const _CalendarDay({required this.dia, required this.mesAtual});

  final int dia;
  final bool mesAtual;
}
