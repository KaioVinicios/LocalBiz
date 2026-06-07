import 'package:flutter/material.dart';

import 'package:localbiz/core/router/app_route.dart';
import 'package:localbiz/core/theme/app_colors.dart';
import 'package:localbiz/core/ui/app_top_bar.dart';
import 'package:localbiz/core/ui/photo_picker.dart';
import 'package:localbiz/features/configuration/data/models/negocio_model.dart';
import 'package:localbiz/features/configuration/data/repositories/negocio_repository.dart';
import 'package:localbiz/features/configuration/presentation/models/mock_data.dart';
import 'package:localbiz/features/services/presentation/screens/auth/auth_service.dart';

class ConfigurationPage extends StatelessWidget {
  const ConfigurationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            AppTopBar(
              onHelp: () => Navigator.of(context).pushNamed(AppRoute.ajuda.path),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                children: [
                  const _ProfileHeader(),
                  const SizedBox(height: 32),
                  for (final section in mockConfigSections) ...[
                    _SectionLabel(section.title),
                    const SizedBox(height: 12),
                    for (int i = 0; i < section.items.length; i++) ...[
                      _ConfigCard(item: section.items[i]),
                      if (i < section.items.length - 1)
                        const SizedBox(height: 12),
                    ],
                    const SizedBox(height: 28),
                  ],
                  const _SignOutButton(),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text(
                      mockAppVersion,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatefulWidget {
  const _ProfileHeader();

  @override
  State<_ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<_ProfileHeader> {
  final _authService = AuthService();
  final _negocioRepository = NegocioRepository();
  bool _enviando = false;

  Future<void> _selecionarFoto() async {
    final messenger = ScaffoldMessenger.of(context);
    final uid = _authService.usuarioAtual?.uid;
    if (uid == null) return;

    final bytes = await escolherImagem();
    if (bytes == null) return; // usuário cancelou

    setState(() => _enviando = true);
    try {
      await _negocioRepository.uploadFoto(uid, bytes);
      // O StreamBuilder abaixo atualiza a foto automaticamente via fotoUrl.
      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(content: Text('Foto do negócio atualizada.')),
      );
    } catch (_) {
      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Não foi possível enviar a foto. Tente novamente.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) setState(() => _enviando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = _authService.usuarioAtual?.uid;
    final stream = uid == null
        ? const Stream<NegocioModel?>.empty()
        : _negocioRepository.observar(uid);

    return StreamBuilder<NegocioModel?>(
      stream: stream,
      builder: (context, snapshot) {
        final negocio = snapshot.data;
        final nome = (negocio?.nome.isNotEmpty ?? false)
            ? negocio!.nome
            : mockBusinessProfile.name;
        return _buildHeader(nome, negocio?.fotoUrl ?? '');
      },
    );
  }

  Widget _buildHeader(String nome, String fotoUrl) {
    return Column(
      children: [
        const SizedBox(height: 8),
        SizedBox(
          width: 128,
          height: 128,
          child: Stack(
            children: [
              Container(
                width: 128,
                height: 128,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(child: _buildAvatarConteudo(fotoUrl)),
              ),
              Positioned(
                right: 4,
                bottom: 4,
                child: GestureDetector(
                  onTap: _enviando ? null : _selecionarFoto,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.accent,
                    ),
                    child: _enviando
                        ? const Padding(
                            padding: EdgeInsets.all(8),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(
                            Icons.photo_camera,
                            size: 16,
                            color: Colors.white,
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          nome,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          mockBusinessProfile.avatarHint,
          style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildAvatarConteudo(String fotoUrl) {
    if (fotoUrl.isEmpty) {
      // Placeholder padrão (círculo interno) quando ainda não há foto.
      return Center(
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.85),
              width: 2,
            ),
          ),
        ),
      );
    }
    return Image.network(
      fotoUrl,
      width: 128,
      height: 128,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return const Center(
          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
        );
      },
      errorBuilder: (context, error, stackTrace) => const Icon(
        Icons.storefront,
        size: 48,
        color: Colors.white,
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.1,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _ConfigCard extends StatelessWidget {
  const _ConfigCard({required this.item});

  final ConfigItem item;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: item.route == null
            ? null
            : () => Navigator.of(context).pushNamed(item.route!.path),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
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
                child: Icon(item.icon, size: 22, color: AppColors.cardIconFg),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}

class _SignOutButton extends StatelessWidget {
  const _SignOutButton();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.dangerBg,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: () async {
          final navigator = Navigator.of(context);
          await AuthService().logout();
          navigator.pushNamedAndRemoveUntil(
            AppRoute.login.path,
            (route) => false,
          );
        },
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.danger.withValues(alpha: 0.25)),
          ),
          child: const Text(
            'Sair da Conta',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.danger,
            ),
          ),
        ),
      ),
    );
  }
}
