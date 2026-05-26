import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:localbiz/core/theme/app_colors.dart';
import 'package:localbiz/core/theme/app_design_tokens.dart';

class ProdutoImage extends StatelessWidget {
  const ProdutoImage({
    super.key,
    this.assetPath,
    this.memoryBytes,
    required this.width,
    required this.height,
    this.fit = BoxFit.contain,
    this.borderRadius = AppRadii.sm,
  });

  final String? assetPath;
  final Uint8List? memoryBytes;
  final double width;
  final double height;
  final BoxFit fit;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final bytes = memoryBytes;

    if (bytes != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Image.memory(
          bytes,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) {
            return ProdutoImagePlaceholder(
              width: width,
              height: height,
              borderRadius: borderRadius,
            );
          },
        ),
      );
    }

    if (assetPath == null || assetPath!.isEmpty) {
      return ProdutoImagePlaceholder(
        width: width,
        height: height,
        borderRadius: borderRadius,
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.asset(
        assetPath!,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return ProdutoImagePlaceholder(
            width: width,
            height: height,
            borderRadius: borderRadius,
          );
        },
      ),
    );
  }
}

class ProdutoImagePlaceholder extends StatelessWidget {
  const ProdutoImagePlaceholder({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = AppRadii.sm,
  });

  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.divider,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Center(
          child: Icon(
            Icons.image_outlined,
            color: Colors.white.withValues(alpha: 0.9),
            size: height < 96 ? height * 0.5 : 72,
          ),
        ),
      ),
    );
  }
}
