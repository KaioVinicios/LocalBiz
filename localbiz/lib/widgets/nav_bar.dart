import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class NavBar extends StatefulWidget {
  const NavBar({
    super.key,
    this.initialIndex = 1,
  });

  final int initialIndex;

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  late int _indiceAtual;

  @override
  void initState() {
    super.initState();
    _indiceAtual = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: _indiceAtual,
      onDestinationSelected: (index) {
        final rota = _rotaParaIndice(index);

        setState(() {
          _indiceAtual = index;
        });

        if (rota == null || ModalRoute.of(context)?.settings.name == rota) {
          return;
        }

        Navigator.of(context).pushReplacementNamed(rota);
      },
      indicatorColor: AppColors.blue.withValues(alpha: 0.16),
      backgroundColor: Colors.white,
      destinations: [
        const NavigationDestination(
          icon: Icon(Icons.menu),
          selectedIcon: Icon(Icons.menu, color: AppColors.blue),
          label: 'Início',
        ),
        const NavigationDestination(
          icon: Icon(Icons.home_repair_service_rounded),
          selectedIcon: Icon(Icons.home_repair_service_rounded, color: AppColors.blue),
          label: 'Serviços',
        ),
        const NavigationDestination(
          icon: Icon(Icons.supervisor_account),
          selectedIcon: Icon(Icons.supervisor_account, color: AppColors.blue),
          label: 'Clientes',
        ),
        const NavigationDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings_outlined, color: AppColors.blue),
          label: 'Configurações',
        ),
      ],
    );
  }

  String? _rotaParaIndice(int index) {
    switch (index) {
      case 0:
        return '/home';
      case 1:
        return '/services';
      case 2:
        return '/clientes';
      case 3:
        return '/configuration';
      default:
        return null;
    }
  }
}