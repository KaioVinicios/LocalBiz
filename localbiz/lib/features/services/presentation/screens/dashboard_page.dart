import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:localbiz/core/theme/app_colors.dart';
import 'package:localbiz/core/theme/app_design_tokens.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorTokens.surfaceWhite,
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 428),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(18, 20, 18, 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _DashboardHeader(),
                        const SizedBox(height: 22),
                        _QuickActions(
                          onServiceCreate: () =>
                              Navigator.of(context).pushNamed('/services/new'),
                        ),
                        const SizedBox(height: 20),
                        const _SummaryCards(),
                        const SizedBox(height: 24),
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
                        const _InventoryAlertCard(),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
                const _DashboardNavBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.onServiceCreate});

  final VoidCallback onServiceCreate;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 86,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _QuickActionCard(
            label: 'Venda',
            icon: Icons.show_chart,
            onTap: () {},
          ),
          const SizedBox(width: 16),
          _QuickActionCard(
            label: 'Agendar',
            icon: Icons.show_chart,
            onTap: () => Navigator.of(context).pushNamed('/service-details'),
          ),
          const SizedBox(width: 16),
          _QuickActionCard(
            label: 'Clientes',
            icon: Icons.show_chart,
            onTap: () => Navigator.of(context).pushNamed('/clientes'),
          ),
          const SizedBox(width: 16),
          _QuickActionCard(
            label: 'Cadastrar serviço',
            visibleLabel: 'Mais',
            icon: Icons.show_chart,
            highlighted: true,
            onTap: onServiceCreate,
          ),
        ],
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

class _SummaryCards extends StatelessWidget {
  const _SummaryCards();

  @override
  Widget build(BuildContext context) {
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
              const Text.rich(
                TextSpan(
                  text: 'R\$',
                  style: TextStyle(
                    color: AppColorTokens.white60,
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                  ),
                  children: [
                    TextSpan(
                      text: '845',
                      style: TextStyle(
                        color: AppColorTokens.surfaceWhite,
                        fontSize: 44,
                      ),
                    ),
                    TextSpan(
                      text: ',50',
                      style: TextStyle(
                        color: AppColorTokens.surfaceWhite,
                        fontSize: 33,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                decoration: BoxDecoration(
                  color: AppColorTokens.slate200,
                  borderRadius: BorderRadius.circular(33),
                ),
                child: const Text(
                  '+12% vs. ontem',
                  style: TextStyle(
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
        const Row(
          children: [
            Expanded(child: _AttendanceCard()),
            SizedBox(width: 22),
            Expanded(child: _NextClientCard()),
          ],
        ),
      ],
    );
  }
}

class _AttendanceCard extends StatelessWidget {
  const _AttendanceCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      padding: const EdgeInsets.all(14),
      decoration: _softCardDecoration(),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Atendimentos\nConcluídos',
            style: TextStyle(
              color: AppColorTokens.slate900,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
          Text.rich(
            TextSpan(
              text: '08',
              style: TextStyle(
                color: AppColorTokens.primaryBlue83,
                fontSize: 40,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
              children: [TextSpan(text: '/12', style: TextStyle(fontSize: 20))],
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

class _InventoryAlertCard extends StatelessWidget {
  const _InventoryAlertCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColorTokens.primaryBlue20,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.blue),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Estoque baixo',
                  style: TextStyle(
                    color: AppColorTokens.slate700,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '3 Itens',
                  style: TextStyle(
                    color: AppColorTokens.surfaceWhite,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Os seguintes produtos atingiram o nível mínimo de reposição.',
            style: TextStyle(
              color: AppColorTokens.slate700,
              fontSize: 12,
              fontWeight: FontWeight.w300,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 14),
          const _InventoryItem(name: 'Shampoo Argan', quantity: '2 un.'),
          const SizedBox(height: 14),
          const _InventoryItem(name: 'Máscara Recon.', quantity: '1 un.'),
        ],
      ),
    );
  }
}

class _InventoryItem extends StatelessWidget {
  const _InventoryItem({required this.name, required this.quantity});

  final String name;
  final String quantity;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColorTokens.slate50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                color: AppColorTokens.inventoryText,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColorTokens.inventoryPillBg,
              borderRadius: BorderRadius.circular(36),
            ),
            child: Text(
              quantity,
              style: const TextStyle(
                color: AppColorTokens.inventoryPillText,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
            onTap: () => Navigator.of(context).pushNamed('/services'),
          ),
          _DashboardNavItem(
            icon: Icons.inventory_2_outlined,
            label: 'Produtos',
            onTap: () {},
          ),
          _DashboardNavItem(
            icon: Icons.settings_outlined,
            label: 'Configurações',
            onTap: () => Navigator.of(context).pushNamed('/configuration'),
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

@Preview(name: 'Dashboard', size: Size(428, 926))
Widget dashboardPagePreview() {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.blue),
    ),
    home: const DashboardPage(),
  );
}
