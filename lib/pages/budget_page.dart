import 'package:flutter/material.dart';
import '../widgets/glass_card.dart';

class BudgetPage extends StatelessWidget {
  const BudgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: GlassCard(
        child: Text(
          'Budget',
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}


