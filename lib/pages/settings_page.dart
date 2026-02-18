import 'package:flutter/material.dart';
import '../widgets/glass_card.dart';
import '../theme/app_theme.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme.backgroundGradient,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: GlassCard(
              child: Text(
                'Settings (placeholder)',
                style: TextStyle(fontSize: 22),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
