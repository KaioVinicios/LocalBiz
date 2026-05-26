import 'dart:typed_data';

class Produto {
  Produto({
    required this.categoria,
    required this.nome,
    required this.preco,
    required this.codigoBarras,
    required this.estoqueAtual,
    required this.estoqueLocal,
    this.imagemAsset,
    this.imagemBytes,
  });

  String categoria;
  String nome;
  String preco;
  String codigoBarras;
  int estoqueAtual;
  String estoqueLocal;
  String? imagemAsset;
  Uint8List? imagemBytes;
}
