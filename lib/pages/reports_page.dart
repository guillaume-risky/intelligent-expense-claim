import 'package:flutter/material.dart';
import '../widgets/glass_card.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: GlassCard(
        child: Text(
          'Reports',
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}



