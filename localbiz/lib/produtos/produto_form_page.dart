import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:localbiz/produtos/produto_image.dart';
import 'package:localbiz/theme/app_colors.dart';
import 'package:localbiz/widgets/labeled_fields.dart';

const _helpIcon = 'assets/icons/help.png';
const _cameraIcon = 'assets/icons/camera.png';

class ProdutoFormPage extends StatelessWidget {
  const ProdutoFormPage({
    super.key,
    required this.title,
    required this.description,
    required this.nomeController,
    required this.precoController,
    required this.codigoController,
    required this.categoria,
    required this.categorias,
    required this.estoqueLocal,
    required this.estoques,
    required this.onCategoriaChanged,
    required this.onEstoqueChanged,
    required this.onSelecionarFoto,
    required this.onVoltar,
    required this.onConcluir,
    this.imagemAsset,
    this.imagemBytes,
    this.showEstoqueField = true,
  });

  final String title;
  final String description;
  final TextEditingController nomeController;
  final TextEditingController precoController;
  final TextEditingController codigoController;
  final String categoria;
  final List<String> categorias;
  final String estoqueLocal;
  final List<String> estoques;
  final ValueChanged<String?> onCategoriaChanged;
  final ValueChanged<String?> onEstoqueChanged;
  final VoidCallback onSelecionarFoto;
  final VoidCallback onVoltar;
  final VoidCallback onConcluir;
  final String? imagemAsset;
  final Uint8List? imagemBytes;
  final bool showEstoqueField;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ProdutoTopBar(onVoltar: onVoltar),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 30,
                    height: 1.1,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.35,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 28),
                _ProdutoPhotoField(
                  imagemAsset: imagemAsset,
                  imagemBytes: imagemBytes,
                  onTap: onSelecionarFoto,
                ),
                const SizedBox(height: 28),
                LabeledDropdown(
                  label: 'Categoria',
                  value: categoria,
                  items: categorias,
                  onChanged: onCategoriaChanged,
                ),
                const SizedBox(height: 20),
                LabeledTextField(
                  label: 'Nome',
                  hint: '',
                  controller: nomeController,
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 20),
                LabeledTextField(
                  label: 'Preço',
                  hint: '',
                  controller: precoController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                _CodigoBarrasField(
                  label: 'Código de barras',
                  hint: '',
                  controller: codigoController,
                  keyboardType: TextInputType.number,
                ),
                if (showEstoqueField) ...[
                  const SizedBox(height: 20),
                  LabeledDropdown(
                    label: 'Estoque',
                    value: estoqueLocal,
                    items: estoques,
                    onChanged: onEstoqueChanged,
                  ),
                ],
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: FormSubmitButton(label: 'Concluir', onPressed: onConcluir),
        ),
      ],
    );
  }
}

class _ProdutoPhotoField extends StatelessWidget {
  const _ProdutoPhotoField({
    required this.imagemAsset,
    required this.imagemBytes,
    required this.onTap,
  });

  final String? imagemAsset;
  final Uint8List? imagemBytes;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasImage =
        imagemBytes != null || (imagemAsset != null && imagemAsset!.isNotEmpty);

    return Tooltip(
      message: 'Adicionar foto do produto',
      child: Semantics(
        button: true,
        label: 'Adicionar foto do produto',
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            mouseCursor: SystemMouseCursors.click,
            child: hasImage
                ? Center(
                    child: ProdutoImage(
                      assetPath: imagemAsset,
                      memoryBytes: imagemBytes,
                      width: 148,
                      height: 190,
                    ),
                  )
                : LayoutBuilder(
                    builder: (context, constraints) {
                      return ProdutoImagePlaceholder(
                        width: constraints.maxWidth,
                        height: 156,
                        borderRadius: 4,
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }
}

class _ProdutoTopBar extends StatelessWidget {
  const _ProdutoTopBar({required this.onVoltar});

  final VoidCallback onVoltar;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          InkWell(
            onTap: onVoltar,
            borderRadius: BorderRadius.circular(8),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Row(
                children: [
                  Icon(Icons.arrow_back, size: 20, color: AppColors.backText),
                  SizedBox(width: 8),
                  Text(
                    'VOLTAR',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: AppColors.backText,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          const SizedBox(
            width: 36,
            height: 36,
            child: Center(
              child: Image(image: AssetImage(_helpIcon), width: 24, height: 24),
            ),
          ),
        ],
      ),
    );
  }
}

class _CodigoBarrasField extends StatelessWidget {
  const _CodigoBarrasField({
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: kFieldLabelStyle),
        const SizedBox(height: 8),
        SizedBox(
          height: kFieldHeight,
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: kFieldTextStyle,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: hint,
              hintStyle: kFieldHintStyle,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              suffixIcon: Center(
                child: Image.asset(_cameraIcon, width: 24, height: 24),
              ),
              suffixIconConstraints: const BoxConstraints(
                minWidth: 44,
                minHeight: kFieldHeight,
              ),
              border: fieldBorderShape(),
              enabledBorder: fieldBorderShape(),
              focusedBorder: fieldBorderShape(focused: true),
            ),
          ),
        ),
      ],
    );
  }
}
