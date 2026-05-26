import 'dart:async';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

Future<Uint8List?> escolherFotoProdutoImpl() async {
  final completer = Completer<Uint8List?>();
  final input = web.HTMLInputElement()
    ..type = 'file'
    ..accept = 'image/*'
    ..multiple = false
    ..style.display = 'none';

  void finish(Uint8List? bytes) {
    input.remove();
    if (!completer.isCompleted) {
      completer.complete(bytes);
    }
  }

  web.document.body?.append(input);

  input.onChange.first
      .then((event) async {
        final files = input.files;

        if (files == null || files.length == 0) {
          finish(null);
          return;
        }

        final file = files.item(0);

        if (file == null) {
          finish(null);
          return;
        }

        final buffer = await file.arrayBuffer().toDart;
        finish(buffer.toDart.asUint8List());
      })
      .catchError((Object error) {
        finish(null);
      });

  input.click();

  return completer.future.timeout(
    const Duration(minutes: 1),
    onTimeout: () {
      input.remove();
      return null;
    },
  );
}
