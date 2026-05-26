import 'dart:typed_data';

import 'produto_photo_picker_stub.dart'
    if (dart.library.html) 'produto_photo_picker_web.dart';

Future<Uint8List?> escolherFotoProduto() {
  return escolherFotoProdutoImpl();
}
