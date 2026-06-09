part of '../service_form_fields.dart';

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
