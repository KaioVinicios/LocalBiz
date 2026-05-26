import 'package:flutter/material.dart';

class BusinessProfile {
  const BusinessProfile({required this.name, required this.avatarHint});

  final String name;
  final String avatarHint;
}

class ConfigItem {
  const ConfigItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.route,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String? route;
}

class ConfigSection {
  const ConfigSection({required this.title, required this.items});

  final String title;
  final List<ConfigItem> items;
}

const BusinessProfile mockBusinessProfile = BusinessProfile(
  name: 'Meu Negócio Local',
  avatarHint: 'Clique para alterar a foto do perfil',
);

const List<ConfigSection> mockConfigSections = [
  ConfigSection(
    title: 'CONTA E NEGÓCIO',
    items: [
      ConfigItem(
        icon: Icons.storefront_outlined,
        title: 'Perfil do Negócio',
        subtitle: 'Nome, logo e informações de contato',
        route: '/business-profile',
      ),
      ConfigItem(
        icon: Icons.description_outlined,
        title: 'Relatórios',
        subtitle: 'Alterar senha e verificação em duas etapas',
        route: '/report',
      ),
    ],
  ),
  ConfigSection(
    title: 'APP E USO',
    items: [
      ConfigItem(
        icon: Icons.help_outline,
        title: 'Ajuda e Suporte',
        subtitle: 'Fale conosco e perguntas frequentes',
      ),
    ],
  ),
];

const String mockAppVersion = 'Versão 1.0.0 (2026)';
