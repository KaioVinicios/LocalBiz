import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:localbiz/core/router/app_route.dart';
import 'package:localbiz/core/theme/app_colors.dart';
import 'package:localbiz/core/theme/app_design_tokens.dart';
import 'package:localbiz/features/services/data/repositories/dashboard_repository.dart';
import 'package:localbiz/features/services/domain/dashboard_summary.dart';

part 'widgets/dashboard_content.dart';
part 'widgets/dashboard_header.dart';
part 'widgets/dashboard_inventory_alert.dart';
part 'widgets/dashboard_nav_bar.dart';
part 'widgets/dashboard_quick_actions.dart';
part 'widgets/dashboard_summary_cards.dart';

const _dashboardWideBreakpoint = 900.0;

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key, this.repository, this.usuarioId});

  final DashboardRepositoryContract? repository;
  final String? usuarioId;

  DashboardRepositoryContract get _repository =>
      repository ?? DashboardRepository();

  String? get _uid => usuarioId ?? _usuarioAtualId();

  String? _usuarioAtualId() {
    try {
      return FirebaseAuth.instance.currentUser?.uid;
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dashboardRepository = _repository;
    final uid = _uid;

    return Scaffold(
      backgroundColor: AppColorTokens.surfaceWhite,
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= _dashboardWideBreakpoint;

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      isWide ? 32 : 18,
                      isWide ? 32 : 20,
                      isWide ? 32 : 18,
                      28,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _DashboardHeader(),
                        const SizedBox(height: 22),
                        _QuickActions(
                          isWide: isWide,
                          onServiceCreate: () => Navigator.of(
                            context,
                          ).pushNamed(AppRoute.serviceCreate.path),
                        ),
                        SizedBox(height: isWide ? 28 : 20),
                        _DashboardContent(
                          isWide: isWide,
                          repository: dashboardRepository,
                          uid: uid,
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
                const _DashboardNavBar(),
              ],
            );
          },
        ),
      ),
    );
  }
}

@Preview(name: 'Dashboard', size: Size(428, 926))
Widget dashboardPagePreview() {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.blue),
    ),
    home: const DashboardPage(),
  );
}
