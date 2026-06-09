part of '../dashboard_page.dart';

class _DashboardNavBar extends StatelessWidget {
  const _DashboardNavBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 89,
      color: AppColorTokens.slate200,
      child: Row(
        children: [
          _DashboardNavItem(
            icon: Icons.inbox_outlined,
            label: 'Inicio',
            selected: true,
            onTap: () {},
          ),
          _DashboardNavItem(
            icon: Icons.stars_outlined,
            label: 'Serviços',
            onTap: () =>
                Navigator.of(context).pushNamed(AppRoute.services.path),
          ),
          _DashboardNavItem(
            icon: Icons.inventory_2_outlined,
            label: 'Produtos',
            onTap: () =>
                Navigator.of(context).pushNamed(AppRoute.produtos.path),
          ),
          _DashboardNavItem(
            icon: Icons.settings_outlined,
            label: 'Configurações',
            onTap: () =>
                Navigator.of(context).pushNamed(AppRoute.configuration.path),
          ),
        ],
      ),
    );
  }
}

class _DashboardNavItem extends StatelessWidget {
  const _DashboardNavItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 58,
              height: 33,
              decoration: BoxDecoration(
                color: selected
                    ? AppColorTokens.primaryBlue50
                    : AppColorTokens.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: AppColorTokens.dashboardNavText,
                size: 25,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: AppColorTokens.dashboardNavText,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
