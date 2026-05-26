import 'package:flutter/material.dart';
import 'package:localbiz/core/theme/app_colors.dart';

class Servico {
  final String nome;
  final String categoria;
  final IconData icone;

  const Servico({
    required this.nome,
    required this.categoria,
    required this.icone,
  });
}

class ServicosScreen extends StatefulWidget {
  const ServicosScreen({super.key});

  @override
  State<ServicosScreen> createState() => _ServicosScreenState();
}

class _ServicosScreenState extends State<ServicosScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Servico> _servicos = const [
    Servico(
      nome: 'Corte e Hidratação',
      categoria: 'Serviços Capilares',
      icone: Icons.spa_outlined,
    ),
    Servico(
      nome: 'Limpeza de Pele',
      categoria: 'Serviços Capilares',
      icone: Icons.spa_outlined,
    ),
    Servico(
      nome: 'Corte e Hidratação',
      categoria: 'Serviços Capilares',
      icone: Icons.spa_outlined,
    ),
    Servico(
      nome: 'Manicure e Pedicure',
      categoria: 'Serviços Capilares',
      icone: Icons.spa_outlined,
    ),
    Servico(
      nome: 'Manicure e Pedicure',
      categoria: 'Serviços Capilares',
      icone: Icons.spa_outlined,
    ),
  ];

  List<Servico> get _servicosFiltrados {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) return _servicos;
    return _servicos
        .where(
          (s) =>
              s.nome.toLowerCase().contains(query) ||
              s.categoria.toLowerCase().contains(query),
        )
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopBar(),
            _buildTitle(),
            const SizedBox(height: 8),
            _buildSearchBar(),
            const SizedBox(height: 20),
            Expanded(child: _buildList()),
          ],
        ),
      ),
      floatingActionButton: _buildFAB(),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: () => Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/home', (route) => false),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.arrow_back, color: AppColors.blue, size: 20),
            SizedBox(width: 6),
            Text(
              'VOLTAR',
              style: TextStyle(
                color: AppColors.blue,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Text(
        'Serviços',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Pesquisar por Serviço',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
                prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                filled: true,
                fillColor: const Color(0xFFF2F2F2),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.cardIconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.tune, color: Colors.grey[600], size: 22),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      itemCount: _servicosFiltrados.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final servico = _servicosFiltrados[index];
        return _ServicoCard(
          servico: servico,
          primaryColor: AppColors.blue,
          iconBgColor: AppColors.cardIconBg,
        );
      },
    );
  }

  Widget _buildFAB() {
    return FloatingActionButton(
      onPressed: () {},
      backgroundColor: AppColors.blue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: const Icon(Icons.add, color: Colors.white, size: 28),
    );
  }
}

class _ServicoCard extends StatelessWidget {
  final Servico servico;
  final Color primaryColor;
  final Color iconBgColor;

  const _ServicoCard({
    required this.servico,
    required this.primaryColor,
    required this.iconBgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.of(context).pushNamed('/service-details'),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFEEEEEE), width: 1),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(servico.icone, color: primaryColor, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      servico.nome,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      servico.categoria,
                      style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey[400], size: 22),
            ],
          ),
        ),
      ),
    );
  }
}
