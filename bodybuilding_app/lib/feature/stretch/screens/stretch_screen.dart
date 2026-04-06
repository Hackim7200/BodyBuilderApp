import 'package:flutter/material.dart';
import 'package:bodybuilding_app/core/widgets/kinetic_app_bar.dart';
import 'package:bodybuilding_app/core/widgets/empty_state_widget.dart';

class StretchScreen extends StatelessWidget {
  const StretchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: KineticAppBar(showProfileButton: true),
      body: EmptyStateWidget(
        icon: Icons.self_improvement_outlined,
        title: 'Coming Soon',
        subtitle:
            'Stretching content is under development.\nStay tuned for updates.',
      ),
    );
  }
}
