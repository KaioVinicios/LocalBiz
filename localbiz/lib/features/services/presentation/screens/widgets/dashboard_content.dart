part of '../dashboard_page.dart';

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({
    required this.isWide,
    required this.repository,
    required this.uid,
  });

  final bool isWide;
  final DashboardRepositoryContract repository;
  final String? uid;

  @override
  Widget build(BuildContext context) {
    final alerts = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Alertas importantes',
          style: TextStyle(
            color: AppColorTokens.dashboardPurple,
            fontSize: 24,
            fontWeight: FontWeight.w800,
            height: 1,
          ),
        ),
        const SizedBox(height: 24),
        _InventoryAlertCard(repository: repository, uid: uid),
      ],
    );

    if (isWide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 7,
            child: _SummaryCards(repository: repository, uid: uid),
          ),
          const SizedBox(width: 28),
          Expanded(flex: 5, child: alerts),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SummaryCards(repository: repository, uid: uid),
        const SizedBox(height: 24),
        alerts,
      ],
    );
  }
}
