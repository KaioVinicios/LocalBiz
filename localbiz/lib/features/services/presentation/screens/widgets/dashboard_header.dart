part of '../dashboard_page.dart';

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Olá, Fulano',
                style: TextStyle(
                  color: AppColorTokens.dashboardGreeting,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Resumo de Hoje',
                style: TextStyle(
                  color: AppColorTokens.slate700,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 18),
        const _HeaderIconButton(icon: Icons.search),
        const SizedBox(width: 8),
        const _HeaderIconButton(icon: Icons.notifications_none),
      ],
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColorTokens.primaryBlue10,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: AppColors.blue, size: 26),
    );
  }
}
