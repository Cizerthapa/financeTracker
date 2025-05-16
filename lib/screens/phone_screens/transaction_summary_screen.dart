import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../model/transaction_model.dart';
import '../../providers/transaction_provider.dart';
import 'add_transaction_page.dart';

class TransactionSummaryPage extends StatefulWidget {
  @override
  State<TransactionSummaryPage> createState() => _TransactionSummaryPageState();
}

class _TransactionSummaryPageState extends State<TransactionSummaryPage> {
  bool _isLoading = true;
  bool _isInitialized = false;
  DateTime _selectedMonth = DateTime.now();

  String _selectedTypeFilter = 'All';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      Provider.of<TransactionProvider>(
        context,
        listen: false,
      ).fetchTransactionsFromFirebase().then((_) {
        setState(() {
          _isLoading = false;
          _isInitialized = true;
        });
      });
    }
  }

  String get formattedMonthYear {
    return DateFormat.yMMMM().format(_selectedMonth);
  }

  Future<void> _pickMonthYear() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedMonth,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      helpText: 'Select Month and Year',
    );

    if (picked != null) {
      setState(() {
        _selectedMonth = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context);

    final filteredTransactions =
        provider.transactions.where((tx) {
          try {
            final txDate = DateFormat.yMMMMd().parse(tx.date);
            final matchesDate =
                txDate.month == _selectedMonth.month &&
                txDate.year == _selectedMonth.year;
            final matchesType =
                _selectedTypeFilter == 'All' || tx.type == _selectedTypeFilter;
            return matchesDate && matchesType;
          } catch (e) {
            return false;
          }
        }).toList();

    final groupedTx = <String, List<TransactionModel>>{};
    for (var tx in filteredTransactions) {
      groupedTx.putIfAbsent(tx.date, () => []).add(tx);
    }

    return Scaffold(
      backgroundColor: const Color(0xff0077A3),
      appBar: AppBar(
        backgroundColor: const Color(0xff0077A3),
        elevation: 0,
        centerTitle: true,
        title: GestureDetector(
          onTap: _pickMonthYear,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.calendar_month, size: 20, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                formattedMonthYear,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_alt_outlined),
            onSelected: (value) {
              setState(() {
                _selectedTypeFilter = value;
              });
            },
            itemBuilder:
                (context) => [
                  const PopupMenuItem(value: 'All', child: Text('All')),
                  const PopupMenuItem(value: 'Income', child: Text('Income')),
                  const PopupMenuItem(value: 'Expense', child: Text('Expense')),
                ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTransactionPage()),
          );
        },
        child: const Icon(Icons.add),
        tooltip: 'Add Income/Expense',
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SummaryItem(
                          label: 'Expenses',
                          amount:
                              '₨${provider.totalExpenses.toStringAsFixed(2)}',
                        ),
                        SummaryItem(
                          label: 'Income',
                          amount: '₨${provider.totalIncome.toStringAsFixed(2)}',
                        ),
                        SummaryItem(
                          label: 'Total',
                          amount: '₨${provider.totalAmount.toStringAsFixed(2)}',
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child:
                        groupedTx.isEmpty
                            ? const Center(
                              child: Text(
                                'Nothing to show',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            )
                            : ListView(
                              children:
                                  groupedTx.entries.map((entry) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 12,
                                          ),
                                          child: Text(
                                            entry.key,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        ...entry.value.map(
                                          (item) => Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 4,
                                            ),
                                            child: Container(
                                              padding: const EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        item.title,
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        item.method,
                                                        style: TextStyle(
                                                          color:
                                                              Colors.grey[600],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    '${item.type == 'Income' ? '▲' : '▼'} ₨${item.amount.abs().toStringAsFixed(2)}',
                                                    style: TextStyle(
                                                      color:
                                                          item.type == 'Income'
                                                              ? Colors.green
                                                              : Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                            ),
                  ),
                ],
              ),
    );
  }
}

class SummaryItem extends StatelessWidget {
  final String label;
  final String amount;

  const SummaryItem({required this.label, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(amount, style: const TextStyle(color: Colors.black)),
      ],
    );
  }
}
