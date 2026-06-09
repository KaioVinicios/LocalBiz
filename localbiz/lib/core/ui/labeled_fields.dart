import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show TextInputFormatter;

import 'package:localbiz/core/theme/app_colors.dart';

const double kFieldHeight = 52;
const double kFieldRadius = 4;
const Color kFieldBorder = Color(0xFFD7DCE5);

const TextStyle kFieldLabelStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w700,
  color: AppColors.textPrimary,
);

const TextStyle kFieldTextStyle = TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.w500,
  color: AppColors.textPrimary,
);

const TextStyle kFieldHintStyle = TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.w500,
  color: AppColors.textSecondary,
);

OutlineInputBorder fieldBorderShape({
  bool focused = false,
  bool error = false,
}) {
  final Color color = error
      ? AppColors.danger
      : (focused ? AppColors.blue : kFieldBorder);
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(kFieldRadius),
    borderSide: BorderSide(color: color, width: (focused || error) ? 1.4 : 1),
  );
}

InputDecoration _baseDecoration({
  String? hint,
  Widget? suffixIcon,
  bool hasError = false,
}) {
  return InputDecoration(
    filled: true,
    fillColor: Colors.white,
    hintText: hint,
    hintStyle: kFieldHintStyle,
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    suffixIcon: suffixIcon,
    suffixIconConstraints: suffixIcon == null
        ? null
        : const BoxConstraints(minWidth: 44, minHeight: kFieldHeight),
    border: fieldBorderShape(error: hasError),
    enabledBorder: fieldBorderShape(error: hasError),
    focusedBorder: fieldBorderShape(focused: true, error: hasError),
  );
}

class _LabelWrap extends StatelessWidget {
  const _LabelWrap({
    required this.label,
    required this.child,
    this.errorText,
  });

  final String label;
  final Widget child;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: kFieldLabelStyle),
        const SizedBox(height: 8),
        SizedBox(height: kFieldHeight, child: child),
        if (errorText != null) ...[
          const SizedBox(height: 6),
          Text(
            errorText!,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.danger,
            ),
          ),
        ],
      ],
    );
  }
}

class LabeledTextField extends StatelessWidget {
  const LabeledTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType,
    this.inputFormatters,
    this.errorText,
    this.onChanged,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return _LabelWrap(
      label: label,
      errorText: errorText,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        onChanged: onChanged,
        style: kFieldTextStyle,
        textAlignVertical: TextAlignVertical.center,
        decoration: _baseDecoration(hint: hint, hasError: errorText != null),
      ),
    );
  }
}

class LabeledDropdown extends StatelessWidget {
  const LabeledDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.enabled = true,
  });

  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  /// Quando `false`, o campo fica acinzentado e não recebe interação.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return _LabelWrap(
      label: label,
      child: DropdownButtonFormField<String>(
        initialValue: value,
        onChanged: enabled ? onChanged : null,
        isExpanded: true,
        icon: const Icon(
          Icons.keyboard_arrow_down,
          color: AppColors.textPrimary,
        ),
        style: kFieldTextStyle,
        dropdownColor: Colors.white,
        decoration: _baseDecoration(),
        items: [
          for (final item in items)
            DropdownMenuItem(value: item, child: Text(item)),
        ],
      ),
    );
  }
}

class LabeledDateField extends StatelessWidget {
  const LabeledDateField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.onTap,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return _LabelWrap(
      label: label,
      child: TextField(
        controller: controller,
        readOnly: true,
        onTap: onTap,
        style: kFieldTextStyle,
        textAlignVertical: TextAlignVertical.center,
        decoration: _baseDecoration(
          hint: hint,
          suffixIcon: const Icon(
            Icons.calendar_today_outlined,
            size: 20,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

class FormSubmitButton extends StatelessWidget {
  const FormSubmitButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.blue,
          disabledBackgroundColor: AppColors.blue.withValues(alpha: 0.45),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kFieldRadius),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
