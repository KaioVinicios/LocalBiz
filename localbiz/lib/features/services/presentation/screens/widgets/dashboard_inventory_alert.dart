part of '../dashboard_page.dart';

class _InventoryAlertCard extends StatelessWidget {
  const _InventoryAlertCard({required this.repository, required this.uid});

  final DashboardRepositoryContract repository;
  final String? uid;

  Stream<List<ProdutoEstoqueBaixo>> _stream() {
    final usuario = uid;
    if (usuario == null || usuario.isEmpty) {
      return Stream.value(const <ProdutoEstoqueBaixo>[]);
    }
    return repository.observarEstoqueBaixo(usuario);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ProdutoEstoqueBaixo>>(
      stream: _stream(),
      initialData: const <ProdutoEstoqueBaixo>[],
      builder: (context, snapshot) {
        final produtos = snapshot.data ?? const <ProdutoEstoqueBaixo>[];

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
                    child: Text(
                      '${produtos.length} Itens',
                      style: const TextStyle(
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
              if (produtos.isEmpty)
                const Text(
                  'Nenhum produto com estoque baixo.',
                  style: TextStyle(
                    color: AppColorTokens.slate700,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                )
              else
                for (final produto in produtos) ...[
                  _InventoryItem(
                    name: produto.nome,
                    quantity: '${produto.estoqueAtual} un.',
                  ),
                  if (produto != produtos.last) const SizedBox(height: 14),
                ],
            ],
          ),
        );
      },
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
