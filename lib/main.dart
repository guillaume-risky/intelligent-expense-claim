import 'package:flutter/material.dart';

import 'pages/dashboard_page.dart';
import 'pages/expenses_page.dart';
import 'pages/trips_page.dart';
import 'pages/budget_page.dart';
import 'pages/reports_page.dart';
import 'pages/settings_page.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const IECApp());
}

class IECApp extends StatelessWidget {
  const IECApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Intelligent Expense Claim',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const HomeShell(),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int index = 0;

  final pages = const [
    DashboardPage(),
    ExpensesPage(),
    TripsPage(),
    BudgetPage(),
    ReportsPage(),
  ];

  String get title {
    switch (index) {
      case 0:
        return 'Dashboard';
      case 1:
        return 'Expenses';
      case 2:
        return 'Trips';
      case 3:
        return 'Budget';
      case 4:
        return 'Reports';
      default:
        return 'IEC';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme.backgroundGradient,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(title),
          actions: [
            IconButton(
              tooltip: 'Settings',
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SettingsPage()),
                );
              },
            ),
          ],
        ),
        body: pages[index],
        bottomNavigationBar: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (i) => setState(() => index = i),
          backgroundColor: Colors.white.withValues(alpha: 0.06),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            NavigationDestination(
              icon: Icon(Icons.receipt_long),
              label: 'Expenses',
            ),
            NavigationDestination(
              icon: Icon(Icons.route),
              label: 'Trips',
            ),
            NavigationDestination(
              icon: Icon(Icons.account_balance_wallet),
              label: 'Budget',
            ),
            NavigationDestination(
              icon: Icon(Icons.bar_chart),
              label: 'Reports',
            ),
          ],
        ),
      ),
    );
  }
}
