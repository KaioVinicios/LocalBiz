part of '../service_form_fields.dart';

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
    this.popResult,
  });

  final String title;
  final String description;
  final Widget image;
  final String category;
  final List<String> categories;
  final String? name;
  final String? price;
  final Future<void> Function(ServiceFormValue value)? onSubmit;
  final Object? popResult;

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
        Navigator.of(context).maybePop(widget.popResult);
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
