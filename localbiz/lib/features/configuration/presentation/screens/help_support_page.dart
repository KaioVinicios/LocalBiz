import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:localbiz/core/theme/app_colors.dart';
import 'package:localbiz/core/ui/app_top_bar.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  static const String _contatoEmail = 'suporte@localbiz.com.br';

  static const List<_FaqItem> _faqs = [
    _FaqItem(
      pergunta: 'Como altero os dados do meu negócio?',
      resposta:
          'Vá em Configurações → Perfil do Negócio. Lá você pode alterar '
          'nome, ramo de atividade, CNPJ/CPF, WhatsApp e endereço, e tocar '
          'em "Salvar Alterações".',
    ),
    _FaqItem(
      pergunta: 'Como troco a foto do meu negócio?',
      resposta:
          'Na tela de Configurações, toque no ícone de câmera sobre a foto '
          'de perfil e escolha uma imagem. Ela é enviada e atualizada '
          'automaticamente.',
    ),
    _FaqItem(
      pergunta: 'Como gero um relatório?',
      resposta:
          'Em Configurações → Relatórios, escolha o tipo, o período e o '
          'formato, e toque em "Enviar". O resumo aparece na tela e fica '
          'salvo no seu histórico.',
    ),
    _FaqItem(
      pergunta: 'Esqueci minha senha. O que faço?',
      resposta:
          'Na tela de login, toque em "Esqueci minha senha" e siga as '
          'instruções enviadas para o seu e-mail.',
    ),
    _FaqItem(
      pergunta: 'Como saio da minha conta?',
      resposta:
          'Em Configurações, role até o final e toque em "Sair da Conta".',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            const AppTopBar(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                children: [
                  const Text(
                    'Ajuda e Suporte',
                    style: TextStyle(
                      fontSize: 30,
                      height: 1.1,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Tire suas dúvidas nas perguntas frequentes ou fale '
                    'com a nossa equipe.',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.35,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'PERGUNTAS FREQUENTES',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.1,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  for (final faq in _faqs) ...[
                    _FaqCard(item: faq),
                    const SizedBox(height: 12),
                  ],
                  const SizedBox(height: 16),
                  const Text(
                    'CONTATO',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.1,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _ContactCard(email: _contatoEmail),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FaqItem {
  const _FaqItem({required this.pergunta, required this.resposta});

  final String pergunta;
  final String resposta;
}

class _FaqCard extends StatelessWidget {
  const _FaqCard({required this.item});

  final _FaqItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: AppColors.textPrimary,
          collapsedIconColor: AppColors.textSecondary,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          expandedAlignment: Alignment.centerLeft,
          title: Text(
            item.pergunta,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          children: [
            Text(
              item.resposta,
              style: const TextStyle(
                fontSize: 14,
                height: 1.4,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  const _ContactCard({required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.cardIconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.email_outlined,
              size: 22,
              color: AppColors.cardIconFg,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'E-mail de suporte',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  email,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Copiar e-mail',
            icon: const Icon(Icons.copy, size: 20, color: AppColors.textSecondary),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: email));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('E-mail copiado.')),
              );
            },
          ),
        ],
      ),
    );
  }
}
