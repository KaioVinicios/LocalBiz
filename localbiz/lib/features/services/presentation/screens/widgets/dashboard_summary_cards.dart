part of '../dashboard_page.dart';

class _SummaryCards extends StatelessWidget {
  const _SummaryCards({required this.repository, required this.uid});

  final DashboardRepositoryContract repository;
  final String? uid;

  Stream<DashboardResumoVendas> _stream() {
    final usuario = uid;
    if (usuario == null || usuario.isEmpty) {
      return Stream.value(const DashboardResumoVendas.vazio());
    }
    return repository.observarResumoVendasHoje(usuario);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DashboardResumoVendas>(
      stream: _stream(),
      initialData: const DashboardResumoVendas.vazio(),
      builder: (context, snapshot) {
        final resumo = snapshot.data ?? const DashboardResumoVendas.vazio();

        return Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: AppColors.blue,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: AppColorTokens.shadowBlack06,
                    blurRadius: 28,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            text: 'Faturamento de ',
                            style: TextStyle(
                              color: AppColorTokens.white80,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                            children: [
                              TextSpan(
                                text: 'Hoje',
                                style: TextStyle(
                                  color: AppColorTokens.surfaceWhite,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Icon(
                        Icons.show_chart,
                        color: AppColorTokens.surfaceWhite,
                        size: 18,
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Text(
                    formatarMoedaBr(resumo.faturamentoHoje),
                    style: const TextStyle(
                      color: AppColorTokens.surfaceWhite,
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: AppColorTokens.slate200,
                      borderRadius: BorderRadius.circular(33),
                    ),
                    child: Text(
                      resumo.variacaoFormatada,
                      style: const TextStyle(
                        color: AppColors.blue,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(child: _AttendanceCard(vendasHoje: resumo.vendasHoje)),
                const SizedBox(width: 22),
                const Expanded(child: _NextClientCard()),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _AttendanceCard extends StatelessWidget {
  const _AttendanceCard({required this.vendasHoje});

  final int vendasHoje;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      padding: const EdgeInsets.all(14),
      decoration: _softCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Vendas\nConcluídas',
            style: TextStyle(
              color: AppColorTokens.slate900,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
          Text.rich(
            TextSpan(
              text: '$vendasHoje',
              style: const TextStyle(
                color: AppColorTokens.primaryBlue83,
                fontSize: 40,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NextClientCard extends StatelessWidget {
  const _NextClientCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      padding: const EdgeInsets.all(14),
      decoration: _softCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Próximo\nCliente',
                  style: TextStyle(
                    color: AppColorTokens.slate900,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
              ),
              Icon(
                Icons.access_time,
                color: AppColorTokens.dashboardPurple,
                size: 15,
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Mariana',
            style: TextStyle(
              color: AppColorTokens.slate700,
              fontSize: 18,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
            decoration: BoxDecoration(
              color: AppColorTokens.slate100,
              borderRadius: BorderRadius.circular(33),
            ),
            child: const Text(
              '14:30 • Luzes',
              style: TextStyle(
                color: AppColors.blue,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

BoxDecoration _softCardDecoration() {
  return BoxDecoration(
    color: AppColorTokens.primaryBlue10,
    borderRadius: BorderRadius.circular(8),
    boxShadow: [
      BoxShadow(
        color: AppColorTokens.shadowBlack04,
        blurRadius: 18,
        offset: const Offset(0, 5),
      ),
    ],
  );
}
