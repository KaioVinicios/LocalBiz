part of '../service_form_fields.dart';

class ServicePlaceholderImage extends StatelessWidget {
  const ServicePlaceholderImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(
          color: AppColorTokens.slate300,
          child: Center(
            child: Container(
              width: 112,
              height: 112,
              decoration: BoxDecoration(
                border: Border.all(color: AppColorTokens.white65, width: 7),
              ),
              child: CustomPaint(painter: _PlaceholderCrossPainter()),
            ),
          ),
        ),
        Positioned(
          right: 12,
          top: 12,
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColorTokens.white62,
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Icon(
              Icons.add_photo_alternate,
              color: AppColors.textSecondary,
              size: 22,
            ),
          ),
        ),
      ],
    );
  }
}

class ServiceHeroImage extends StatelessWidget {
  const ServiceHeroImage({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            AppColorTokens.serviceHeroDark,
            AppColorTokens.serviceHeroLight,
            AppColorTokens.serviceHeroAccent,
          ],
          stops: [0, 0.52, 1],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 92,
            top: 10,
            child: Container(
              width: 172,
              height: 126,
              decoration: BoxDecoration(
                color: AppColorTokens.serviceHeroSkin,
                borderRadius: BorderRadius.circular(80),
              ),
            ),
          ),
          Positioned(
            left: 108,
            top: 38,
            child: Container(
              width: 132,
              height: 54,
              decoration: BoxDecoration(
                color: AppColorTokens.serviceHeroSkinShade,
                borderRadius: BorderRadius.circular(60),
              ),
            ),
          ),
          Positioned(
            left: 194,
            top: 22,
            child: Container(
              width: 86,
              height: 88,
              decoration: const BoxDecoration(
                color: AppColorTokens.serviceHeroHair,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: 30,
            top: 0,
            bottom: 0,
            child: Transform.rotate(
              angle: -0.18,
              child: Container(
                width: 22,
                color: AppColorTokens.serviceHeroTool,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceholderCrossPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColorTokens.white65
      ..strokeWidth = 7
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset.zero, Offset(size.width, size.height), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(0, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
