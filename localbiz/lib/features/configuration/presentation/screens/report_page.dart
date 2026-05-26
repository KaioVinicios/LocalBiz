import 'package:flutter/material.dart';

import 'package:localbiz/core/theme/app_colors.dart';
import 'package:localbiz/core/ui/labeled_fields.dart';
import 'package:localbiz/core/ui/app_top_bar.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  String _type = 'Financeiro';
  String _docType = 'PDF';
  String _sendTo = 'Email';

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            const AppTopBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Relatórios',
                      style: TextStyle(
                        fontSize: 30,
                        height: 1.1,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Para visualizar relatórios de movimentação e faturamento, preencha os filtros abaixo.',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.35,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 28),
                    LabeledDropdown(
                      label: 'Tipo',
                      value: _type,
                      items: const ['Financeiro', 'Movimentação', 'Vendas'],
                      onChanged: (v) => setState(() => _type = v ?? _type),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: LabeledDateField(
                            label: 'Data Inicio',
                            hint: '00/00/0000',
                            controller: _startDateController,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: LabeledDateField(
                            label: 'Data Fim',
                            hint: '00/00/0000',
                            controller: _endDateController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    LabeledDropdown(
                      label: 'Tipo do documento',
                      value: _docType,
                      items: const ['PDF', 'CSV', 'XLSX'],
                      onChanged: (v) =>
                          setState(() => _docType = v ?? _docType),
                    ),
                    const SizedBox(height: 20),
                    LabeledDropdown(
                      label: 'Enviar Para',
                      value: _sendTo,
                      items: const ['Email', 'Whatsapp'],
                      onChanged: (v) => setState(() => _sendTo = v ?? _sendTo),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: FormSubmitButton(label: 'Enviar', onPressed: () {}),
            ),
          ],
        ),
      ),
    );
  }
}
