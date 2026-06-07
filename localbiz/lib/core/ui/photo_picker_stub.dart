import 'dart:typed_data';

/// Fallback para plataformas sem suporte (mobile/desktop ainda não implementado).
Future<Uint8List?> escolherImagemImpl() async {
  return null;
}
