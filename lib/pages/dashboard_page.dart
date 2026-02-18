import 'package:flutter/material.dart';
import '../widgets/glass_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: GlassCard(
        child: Text(
          'Dashboard',
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
