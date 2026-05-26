import 'package:flutter/material.dart';
import 'package:localbiz/core/theme/app_colors.dart';
import 'package:localbiz/core/theme/app_design_tokens.dart';

class ServiceFormField extends StatelessWidget {
  const ServiceFormField({
    super.key,
    required this.label,
    this.value,
    this.hint,
    this.trailing,
  });

  final String label;
  final String? value;
  final String? hint;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final displayText = value ?? hint;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            label,
            style: const TextStyle(
              color: AppColorTokens.slate700,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              height: 20 / 14,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 48,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColorTokens.formInputFill,
            border: Border.all(color: AppColorTokens.slate200),
          ),
          child: Row(
            children: [
              if (displayText != null)
                Expanded(
                  child: Text(
                    displayText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColorTokens.slate500,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 28 / 14,
                    ),
                  ),
                )
              else
                const Spacer(),
              ?trailing,
            ],
          ),
        ),
      ],
    );
  }
}

class ServiceFormScaffold extends StatelessWidget {
  const ServiceFormScaffold({
    super.key,
    required this.title,
    required this.description,
    required this.image,
    required this.category,
    this.name,
    this.price,
  });

  final String title;
  final String description;
  final Widget image;
  final String category;
  final String? name;
  final String? price;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorTokens.surfaceWhite,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 428),
            child: Column(
              children: [
                const _ServiceTopBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        Text(
                          title,
                          style: const TextStyle(
                            color: AppColorTokens.slate900,
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            height: 38.4 / 30,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          description,
                          style: const TextStyle(
                            color: AppColorTokens.slate600,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            height: 26.3 / 16,
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 146,
                          child: image,
                        ),
                        const SizedBox(height: 18),
                        ServiceFormField(
                          label: 'Categoria',
                          value: category,
                          hint: category,
                          trailing: const Icon(
                            Icons.arrow_drop_down,
                            color: AppColorTokens.black,
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ServiceFormField(label: 'Nome', value: name),
                        const SizedBox(height: 24),
                        ServiceFormField(label: 'Preço', value: price),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: SizedBox(
                    height: 60,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: AppColors.blue,
                        foregroundColor: AppColorTokens.surfaceWhite,
                        shape: const RoundedRectangleBorder(),
                      ),
                      child: const Text(
                        'Concluir',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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

class _ServiceTopBar extends StatelessWidget {
  const _ServiceTopBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 19, 18, 7),
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => Navigator.of(context).maybePop(),
            child: const Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Icon(
                    Icons.arrow_back,
                    color: AppColorTokens.slate600,
                    size: 16,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'VOLTAR',
                    style: TextStyle(
                      color: AppColorTokens.slate600,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.7,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.all(8),
            child: Icon(
              Icons.help_outline,
              color: AppColorTokens.slate900,
              size: 22,
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
