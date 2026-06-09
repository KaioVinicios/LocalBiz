part of '../dashboard_page.dart';

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.onServiceCreate, required this.isWide});

  final VoidCallback onServiceCreate;
  final bool isWide;

  @override
  Widget build(BuildContext context) {
    final actions = [
      _QuickActionCard(
        label: 'Venda',
        icon: Icons.show_chart,
        onTap: () => Navigator.of(context).pushNamed(AppRoute.vendas.path),
      ),
      _QuickActionCard(
        label: 'Agendar',
        icon: Icons.show_chart,
        onTap: () =>
            Navigator.of(context).pushNamed(AppRoute.serviceSchedules.path),
      ),
      _QuickActionCard(
        label: 'Clientes',
        icon: Icons.show_chart,
        onTap: () => Navigator.of(context).pushNamed(AppRoute.clientes.path),
      ),
      _QuickActionCard(
        label: 'Cadastrar serviço',
        visibleLabel: 'Mais',
        icon: Icons.show_chart,
        highlighted: true,
        onTap: onServiceCreate,
      ),
    ];

    if (isWide) {
      return Row(
        children: [
          for (final action in actions) ...[
            Expanded(child: action),
            if (action != actions.last) const SizedBox(width: 16),
          ],
        ],
      );
    }

    return SizedBox(
      height: 86,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: actions.length,
        separatorBuilder: (_, _) => const SizedBox(width: 16),
        itemBuilder: (_, index) => actions[index],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.label,
    required this.icon,
    required this.onTap,
    this.visibleLabel,
    this.highlighted = false,
  });

  final String label;
  final String? visibleLabel;
  final IconData icon;
  final VoidCallback onTap;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 86,
          width: visibleLabel == null ? 86 : 100,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColorTokens.primaryBlue10,
            borderRadius: BorderRadius.circular(8),
            border: highlighted
                ? Border.all(color: AppColors.blue, style: BorderStyle.solid)
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColorTokens.primaryBlue26,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.blue, size: 17),
              ),
              const SizedBox(height: 10),
              Text(
                visibleLabel ?? label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: highlighted
                      ? AppColors.blue
                      : AppColorTokens.dashboardActionText,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
