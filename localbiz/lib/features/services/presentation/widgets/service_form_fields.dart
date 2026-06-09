import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localbiz/core/theme/app_colors.dart';
import 'package:localbiz/core/theme/app_design_tokens.dart';
import 'package:localbiz/core/ui/app_help_action_button.dart';
import 'package:localbiz/core/utils/money.dart';

const serviceCategoryOptions = [
  'Serviços Capilares',
  'Barbearia',
  'Manicure e Pedicure',
  'Estética Facial',
  'Massoterapia',
];

const _serviceFormWideBreakpoint = 900.0;
const _serviceFormDesktopButtonWidth = 260.0;

class ServiceFormValue {
  const ServiceFormValue({
    required this.category,
    required this.name,
    required this.price,
  });

  final String category;
  final String name;
  final double price;
}

class ServiceTextField extends StatelessWidget {
  const ServiceTextField({
    super.key,
    required this.label,
    required this.controller,
    this.keyboardType,
    this.inputFormatters,
  });

  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ServiceFieldLabel(label),
        const SizedBox(height: 6),
        SizedBox(
          height: 48,
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            cursorColor: AppColors.blue,
            style: const TextStyle(
              color: AppColorTokens.slate900,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 28 / 14,
            ),
            decoration: _serviceInputDecoration(),
          ),
        ),
      ],
    );
  }
}

class ServiceCategoryField extends StatelessWidget {
  const ServiceCategoryField({
    super.key,
    required this.value,
    required this.categories,
    required this.onChanged,
  });

  final String? value;
  final List<String> categories;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _ServiceFieldLabel('Categoria'),
        const SizedBox(height: 6),
        SizedBox(
          height: 48,
          child: DropdownButtonFormField<String>(
            initialValue: value,
            isExpanded: true,
            icon: const Icon(
              Icons.arrow_drop_down,
              color: AppColorTokens.black,
              size: 24,
            ),
            hint: const Text(
              'Selecione',
              style: TextStyle(
                color: AppColorTokens.slate500,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 28 / 14,
              ),
            ),
            items: categories
                .map(
                  (category) => DropdownMenuItem<String>(
                    value: category,
                    child: Text(
                      category,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
                .toList(),
            onChanged: onChanged,
            style: const TextStyle(
              color: AppColorTokens.slate900,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 28 / 14,
            ),
            decoration: _serviceInputDecoration(),
          ),
        ),
      ],
    );
  }
}

class _ServiceFieldLabel extends StatelessWidget {
  const _ServiceFieldLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}

InputDecoration _serviceInputDecoration() {
  return const InputDecoration(
    filled: true,
    fillColor: AppColorTokens.formInputFill,
    contentPadding: EdgeInsets.symmetric(horizontal: 16),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColorTokens.slate200),
      borderRadius: BorderRadius.zero,
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.blue, width: 1.4),
      borderRadius: BorderRadius.zero,
    ),
  );
}

class RealCurrencyInputFormatter extends TextInputFormatter {
  const RealCurrencyInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    if (digits.isEmpty) {
      return TextEditingValue.empty;
    }

    final cents = int.parse(digits);
    final reais = cents ~/ 100;
    final centavos = cents % 100;
    final formatted = 'R\$ $reais,${centavos.toString().padLeft(2, '0')}';

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class ServiceFormScaffold extends StatefulWidget {
  const ServiceFormScaffold({
    super.key,
    required this.title,
    required this.description,
    required this.image,
    required this.category,
    this.categories = serviceCategoryOptions,
    this.name,
    this.price,
    this.onSubmit,
  });

  final String title;
  final String description;
  final Widget image;
  final String category;
  final List<String> categories;
  final String? name;
  final String? price;
  final Future<void> Function(ServiceFormValue value)? onSubmit;

  @override
  State<ServiceFormScaffold> createState() => _ServiceFormScaffoldState();
}

class _ServiceFormScaffoldState extends State<ServiceFormScaffold> {
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  String? _selectedCategory;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name ?? '');
    _priceController = TextEditingController(text: widget.price ?? '');
    _selectedCategory = widget.categories.contains(widget.category)
        ? widget.category
        : null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorTokens.surfaceWhite,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= _serviceFormWideBreakpoint;

            return Column(
              children: [
                const _ServiceTopBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      isWide ? 32 : 16,
                      12,
                      isWide ? 32 : 16,
                      24,
                    ),
                    child: isWide
                        ? _buildWideFormContent()
                        : _buildCompactFormContent(),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    isWide ? 32 : 16,
                    8,
                    isWide ? 32 : 16,
                    16,
                  ),
                  child: Align(
                    alignment: isWide
                        ? Alignment.centerRight
                        : Alignment.center,
                    child: SizedBox(
                      height: 60,
                      width: isWide
                          ? _serviceFormDesktopButtonWidth
                          : double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitting ? null : _handleSubmit,
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
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCompactFormContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ServiceFormIntro(title: widget.title, description: widget.description),
        const SizedBox(height: 20),
        SizedBox(width: double.infinity, height: 146, child: widget.image),
        const SizedBox(height: 18),
        _ServiceFormFields(
          selectedCategory: _selectedCategory,
          categories: widget.categories,
          nameController: _nameController,
          priceController: _priceController,
          onCategoryChanged: _updateCategory,
        ),
      ],
    );
  }

  Widget _buildWideFormContent() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ServiceFormIntro(
                title: widget.title,
                description: widget.description,
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 260,
                child: widget.image,
              ),
            ],
          ),
        ),
        const SizedBox(width: 40),
        Expanded(
          flex: 6,
          child: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: _ServiceFormFields(
              selectedCategory: _selectedCategory,
              categories: widget.categories,
              nameController: _nameController,
              priceController: _priceController,
              onCategoryChanged: _updateCategory,
            ),
          ),
        ),
      ],
    );
  }

  void _updateCategory(String? category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  Future<void> _handleSubmit() async {
    final onSubmit = widget.onSubmit;
    if (onSubmit == null) {
      Navigator.of(context).maybePop();
      return;
    }

    final name = _nameController.text.trim();
    if (name.isEmpty) {
      _showError('Informe o nome do serviço.');
      return;
    }

    final category = _selectedCategory?.trim().isNotEmpty == true
        ? _selectedCategory!.trim()
        : 'Sem categoria';
    final price = centavosFromInput(_priceController.text) / 100;

    setState(() => _submitting = true);
    try {
      await onSubmit(
        ServiceFormValue(category: category, name: name, price: price),
      );
      if (mounted) {
        Navigator.of(context).maybePop();
      }
    } catch (_) {
      if (mounted) {
        _showError('Não foi possível salvar o serviço. Tente novamente.');
      }
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

class _ServiceFormIntro extends StatelessWidget {
  const _ServiceFormIntro({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
      ],
    );
  }
}

class _ServiceFormFields extends StatelessWidget {
  const _ServiceFormFields({
    required this.selectedCategory,
    required this.categories,
    required this.nameController,
    required this.priceController,
    required this.onCategoryChanged,
  });

  final String? selectedCategory;
  final List<String> categories;
  final TextEditingController nameController;
  final TextEditingController priceController;
  final ValueChanged<String?> onCategoryChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ServiceCategoryField(
          value: selectedCategory,
          categories: categories,
          onChanged: onCategoryChanged,
        ),
        const SizedBox(height: 24),
        ServiceTextField(label: 'Nome', controller: nameController),
        const SizedBox(height: 24),
        ServiceTextField(
          label: 'Preço',
          controller: priceController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: const [RealCurrencyInputFormatter()],
        ),
        const SizedBox(height: 24),
      ],
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
          const AppHelpActionButton(),
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
