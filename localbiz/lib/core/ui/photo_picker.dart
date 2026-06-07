import 'dart:typed_data';

import 'photo_picker_stub.dart'
    if (dart.library.html) 'photo_picker_web.dart';

/// Abre o seletor de arquivos do sistema e devolve os bytes da imagem
/// escolhida (ou `null` se o usuário cancelar). Implementação web.
Future<Uint8List?> escolherImagem() {
  return escolherImagemImpl();
}
