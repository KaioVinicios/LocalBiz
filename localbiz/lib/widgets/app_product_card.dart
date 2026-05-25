import 'package:flutter/material.dart';
import 'package:localbiz/widgets/app_add_button.dart';

class ProdutoCard extends StatelessWidget {
  const ProdutoCard({
    super.key,
    required this.nome,
    required this.estoque,
    required this.preco,
    required this.onAdicionar,
    this.emEstoque = true,
  });

  final String nome;
  final int estoque;
  final double preco;
  final VoidCallback? onAdicionar;
  final bool emEstoque;

  static const double _radius       = 8;
  static const double _gap          = 5.45;
  static const double _imageHeight  = 96;   // área da imagem placeholder

  static const Color _bgColor       = Color(0x1A0D56E6); // #0D56E6 @ 10%
  static const Color _imageBg       = Color(0xFFDDE1E6); // placeholder topo
  static const Color _imageFg       = Color(0xFFFFFFFF); // ícone X placeholder

  static const Color _nomeColor     = Color(0xFF253E7B);
  static const Color _estoqueColor  = Color(0x80253E7B); // #253E7B @ 50%
  static const Color _precoPrefix   = Color(0xCC334155); // #334155 @ 80%
  static const Color _precoColor    = Color(0xFF334155); // #334155 @ 100%

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(_radius),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(_radius),
            ),
            child: Container(
              height: _imageHeight,
              color: _imageBg,
              child: Center(
                child: CustomPaint(
                  size: const Size(48, 48),
                  painter: _ImagePlaceholderPainter(color: _imageFg),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nome — Poppins SemiBold 14.54px lh 100%
                Text(
                  nome,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: _nomeColor,
                    fontSize: 14.54,
                    fontWeight: FontWeight.w600,
                    height: 1.0,
                    letterSpacing: 0,
                  ),
                ),

                SizedBox(height: _gap),

                // Estoque — Poppins SemiBold 12px lh 100%
                Text(
                  emEstoque
                      ? '$estoque em estoque'
                      : 'Sem estoque',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: emEstoque ? _estoqueColor : Colors.redAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    height: 1.0,
                    letterSpacing: 0,
                  ),
                ),

                SizedBox(height: _gap),

                SizedBox(
                  width: double.infinity,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'R\$',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            color: _precoPrefix,
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            height: 1.0,
                            letterSpacing: 0,
                          ),
                        ),
                        TextSpan(
                          text: preco
                              .toStringAsFixed(2)
                              .replaceAll('.', ','),
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            color: _precoColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            height: 1.0,
                            letterSpacing: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: _gap * 1.6),

                AddButton(
                  onPressed: emEstoque ? onAdicionar : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ImagePlaceholderPainter extends CustomPainter {
  const _ImagePlaceholderPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, paint);
    canvas.drawLine(rect.topLeft, rect.bottomRight, paint);
    canvas.drawLine(rect.topRight, rect.bottomLeft, paint);
  }

  @override
  bool shouldRepaint(_ImagePlaceholderPainter old) => old.color != color;
}