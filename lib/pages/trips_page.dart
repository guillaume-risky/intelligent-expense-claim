import 'package:flutter/material.dart';
import '../widgets/glass_card.dart';

class TripsPage extends StatelessWidget {
  const TripsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: GlassCard(
        child: Text(
          'Trips',
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}



