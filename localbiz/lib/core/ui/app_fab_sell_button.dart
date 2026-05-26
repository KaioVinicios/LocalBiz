import 'package:flutter/material.dart';
import 'package:localbiz/core/ui/app_floating_add_button.dart';

@Deprecated('Use AppFloatingAddButton instead.')
class VendaFab extends StatelessWidget {
  const VendaFab({super.key, required this.onPressed, this.itemCount = 0});

  final VoidCallback onPressed;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return AppFloatingAddButton(
      onPressed: onPressed,
      badgeCount: itemCount,
      tooltip: 'Abrir carrinho',
    );
  }
}
