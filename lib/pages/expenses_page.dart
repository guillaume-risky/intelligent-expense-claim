import 'dart:ui';
import 'package:flutter/material.dart';
import '../widgets/glass_card.dart';
import '../theme/app_theme.dart';

class ExpenseItem {
  final double amount;
  final String category;
  final DateTime date;
  final String note;

  ExpenseItem({
    required this.amount,
    required this.category,
    required this.date,
    required this.note,
  });
}

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key});

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  final List<ExpenseItem> _items = [];

  String _formatDate(DateTime d) {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${d.year}-${two(d.month)}-${two(d.day)}';
  }

  Future<void> _addExpense() async {
    final result = await showDialog<ExpenseItem>(
      context: context,
      builder: (_) => const _AddExpenseDialog(),
    );

    if (result != null) {
      setState(() => _items.insert(0, result));
    }
  }

  void _openExpense(ExpenseItem e) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ExpenseDetailPage(item: e)),
    );
  }

  void _deleteWithUndo(int index) {
    final removed = _items[index];
    final removedIndex = index;

    setState(() => _items.removeAt(index));

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Expense deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() => _items.insert(removedIndex, removed));
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          GlassCard(
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Expenses',
                    style: TextStyle(fontSize: 22),
                  ),
                ),
                GlassActionButton(
                  icon: Icons.add,
                  label: 'Add',
                  onPressed: _addExpense,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: _items.isEmpty
                ? const Center(
                    child: GlassCard(
                      child: Text(
                        'No expenses yet. Click Add to create one.',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  )
                : ListView.separated(
                    itemCount: _items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, i) {
                      final e = _items[i];

                      return Dismissible(
                        key: ValueKey('${e.date.toIso8601String()}_${e.category}_${e.amount}_$i'),
                        direction: DismissDirection.endToStart,
                        background: const _DeleteSwipeBackground(),
                        onDismissed: (_) => _deleteWithUndo(i),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () => _openExpense(e),
                          child: GlassCard(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        e.category,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        _formatDate(e.date),
                                        style: TextStyle(
                                          color: Colors.white.withValues(alpha: 0.75),
                                        ),
                                      ),
                                      if (e.note.trim().isNotEmpty) ...[
                                        const SizedBox(height: 8),
                                        Text(e.note),
                                      ],
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'R ${e.amount.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    GlassIconButton(
                                      icon: Icons.delete_outline,
                                      tooltip: 'Delete',
                                      onPressed: () => _deleteWithUndo(i),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _DeleteSwipeBackground extends StatelessWidget {
  const _DeleteSwipeBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white.withValues(alpha: 0.06),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: const Icon(Icons.delete_outline, size: 28),
    );
  }
}

/// Glass style action button (icon + label)
class GlassActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const GlassActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Material(
          color: Colors.white.withValues(alpha: 0.08),
          child: InkWell(
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                children: [
                  Icon(icon, size: 18),
                  const SizedBox(width: 8),
                  Text(label),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Small glass icon button (used for delete)
class GlassIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  const GlassIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Material(
            color: Colors.white.withValues(alpha: 0.07),
            child: InkWell(
              onTap: onPressed,
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(Icons.delete_outline, size: 18),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AddExpenseDialog extends StatefulWidget {
  const _AddExpenseDialog();

  @override
  State<_AddExpenseDialog> createState() => _AddExpenseDialogState();
}

class _AddExpenseDialogState extends State<_AddExpenseDialog> {
  final _formKey = GlobalKey<FormState>();

  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  String _category = 'Fuel';
  DateTime _date = DateTime.now();

  final List<String> _categories = const [
    'Fuel',
    'Meals',
    'Parking',
    'Tolls',
    'Accommodation',
    'Supplies',
    'Other',
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime d) {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${d.year}-${two(d.month)}-${two(d.day)}';
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _date = picked);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.parse(_amountController.text.trim());

    Navigator.of(context).pop(
      ExpenseItem(
        amount: amount,
        category: _category,
        date: _date,
        note: _noteController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Expense'),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Amount (ZAR)',
                  prefixText: 'R ',
                ),
                validator: (v) {
                  final t = (v ?? '').trim();
                  if (t.isEmpty) return 'Enter an amount';
                  final n = double.tryParse(t);
                  if (n == null) return 'Enter a valid number';
                  if (n <= 0) return 'Amount must be more than 0';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _category,
                items: _categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => _category = v ?? 'Other'),
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: InputDecorator(
                      decoration: const InputDecoration(labelText: 'Date'),
                      child: Text(_formatDate(_date)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  OutlinedButton(
                    onPressed: _pickDate,
                    child: const Text('Pick'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(labelText: 'Note (optional)'),
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _save,
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class ExpenseDetailPage extends StatelessWidget {
  final ExpenseItem item;

  const ExpenseDetailPage({super.key, required this.item});

  String _formatDate(DateTime d) {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${d.year}-${two(d.month)}-${two(d.day)}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme.backgroundGradient,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Expense'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.category,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10),
                Text(
                  'Date: ${_formatDate(item.date)}',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.80)),
                ),
                const SizedBox(height: 10),
                Text(
                  'Amount: R ${item.amount.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                if (item.note.trim().isNotEmpty) ...[
                  const SizedBox(height: 14),
                  const Text('Note:', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Text(item.note),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
