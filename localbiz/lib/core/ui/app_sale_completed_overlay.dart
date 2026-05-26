import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localbiz/core/theme/app_colors.dart';
import 'package:localbiz/core/theme/app_design_tokens.dart';

class AppSaleCompletedOverlay extends StatelessWidget {
  const AppSaleCompletedOverlay({
    super.key,
    required this.total,
    required this.onVoltar,
  });

  final double total;
  final VoidCallback onVoltar;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Container(color: Colors.black.withValues(alpha: 0.3)),
        ),

        Center(
          child: Container(
            width: 324,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.sheetSurface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 24,
              children: [
                Container(
                  width: 74,
                  height: 74,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.fieldFill,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/checkmark-badge-02.svg',
                    width: 42,
                    height: 42,
                  ),
                ),

                Column(
                  spacing: 10,
                  children: [
                    const Text(
                      'Venda Finalizada!',
                      style: TextStyle(
                        color: Color(0xFF2B1A49),
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Text(
                      'O estoque foi atualizado automaticamente',
                      maxLines: 1,
                      overflow: TextOverflow.visible,
                      softWrap: false,
                      style: TextStyle(
                        color: Color(0xFF2B1A49),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),

                Container(
                  width: double.infinity,
                  height: 72,
                  decoration: BoxDecoration(
                    color: const Color(0xFF043DAE),
                    borderRadius: BorderRadius.circular(AppRadii.sm),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 2,
                    children: [
                      const Text(
                        'Valor recebido',
                        style: TextStyle(
                          color: Color(0xCCFFFFFF),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: 'R\$',
                              style: TextStyle(
                                color: Color(0xB3FFFFFF),
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            TextSpan(
                              text: total
                                  .toStringAsFixed(2)
                                  .replaceAll('.', ','),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 46,
                  width: double.infinity,
                  child: TextButton(
                    onPressed: onVoltar,
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFEDF1F7),
                      foregroundColor: AppColors.blue,
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadii.sm),
                      ),
                    ),
                    child: const Text(
                      'Voltar ao Início',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
