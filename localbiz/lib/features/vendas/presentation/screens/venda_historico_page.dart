import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:localbiz/core/router/app_route.dart';
import 'package:localbiz/core/theme/app_colors.dart';
import 'package:localbiz/core/theme/app_design_tokens.dart';
import 'package:localbiz/core/ui/app_top_bar.dart';
import 'package:localbiz/features/services/domain/dashboard_summary.dart';
import 'package:localbiz/features/vendas/models/venda_model.dart';
import 'package:localbiz/features/vendas/repositories/venda_repository.dart';

class VendaHistoricoPage extends StatefulWidget {
  const VendaHistoricoPage({
    super.key,
    this.repository,
    this.negocioId,
    this.editRoutePath,
  });

  final VendaRepositoryContract? repository;
  final String? negocioId;
  final String? editRoutePath;

  @override
  State<VendaHistoricoPage> createState() => _VendaHistoricoPageState();
}

class _VendaHistoricoPageState extends State<VendaHistoricoPage> {
  late final VendaRepositoryContract _repository;
  late final String _negocioId;

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? VendaRepository();
    _negocioId = widget.negocioId ?? _usuarioAtualId();
  }

  String get _editRoutePath => widget.editRoutePath ?? AppRoute.vendaEdit.path;

  String _usuarioAtualId() {
    try {
      return FirebaseAuth.instance.currentUser?.uid ?? '';
    } catch (_) {
      return '';
    }
  }

  void _abrirEdicao(VendaModel venda) {
    Navigator.of(context).pushNamed(_editRoutePath, arguments: venda);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      ),
      child: Scaffold(
        backgroundColor: AppColors.surface,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppTopBar(),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 18),
                child: Text(
                  'Histórico de Vendas',
                  style: AppTextStyles.pageTitle.copyWith(
                    color: const Color(0xFF334155),
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    height: 1.0,
                    letterSpacing: 0,
                  ),
                ),
              ),
              Expanded(
                child: _negocioId.isEmpty
                    ? const Center(
                        child: Text('Faça login para ver suas vendas.'),
                      )
                    : StreamBuilder<List<VendaModel>>(
                        stream: _repository.observarVendas(_negocioId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.hasError) {
                            return const Center(
                              child: Text('Erro ao carregar vendas.'),
                            );
                          }

                          final vendas = snapshot.data ?? const <VendaModel>[];
                          if (vendas.isEmpty) {
                            return const Center(
                              child: Text('Nenhuma venda registrada.'),
                            );
                          }

                          return ListView.separated(
                            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                            itemCount: vendas.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final venda = vendas[index];
                              return _VendaHistoricoItem(
                                venda: venda,
                                onTap: () => _abrirEdicao(venda),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VendaHistoricoItem extends StatelessWidget {
  const _VendaHistoricoItem({required this.venda, required this.onTap});

  final VendaModel venda;
  final VoidCallback onTap;

  String get _dataFormatada {
    final data = venda.criadoEm;
    if (data == null) {
      return 'Data pendente';
    }
    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');
    final hora = data.hour.toString().padLeft(2, '0');
    final minuto = data.minute.toString().padLeft(2, '0');
    return '$dia/$mes/${data.year} - $hora:$minuto';
  }

  @override
  Widget build(BuildContext context) {
    final itens = venda.itens.fold<int>(
      0,
      (total, item) => total + item.quantidade,
    );

    return Material(
      color: const Color(0x1A0D56E6),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      venda.itens.isEmpty
                          ? 'Venda sem itens'
                          : venda.itens.first.nome,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF334155),
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$itens itens • $_dataFormatada',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                formatarMoedaBr(venda.totalReais),
                style: const TextStyle(
                  color: AppColors.blue,
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.edit_outlined, color: AppColors.blue, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
