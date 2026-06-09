import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localbiz/core/theme/app_colors.dart';
import 'package:localbiz/core/theme/app_design_tokens.dart';
import 'package:localbiz/core/ui/app_help_action_button.dart';
import 'package:localbiz/core/utils/money.dart';

part 'service_form/service_form_images.dart';
part 'service_form/service_form_inputs.dart';
part 'service_form/service_form_scaffold.dart';

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
