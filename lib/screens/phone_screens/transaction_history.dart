import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/transaction_model.dart';
import '../../providers/transaction_provider.dart';

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<TransactionProvider>(
      context,
      listen: false,
    ).fetchTransactionsFromFirebase().then((_) {
      setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context);
    final transactions = provider.transactions;

    final grouped = <String, List<TransactionModel>>{};
    for (var tx in transactions) {
      grouped.putIfAbsent(tx.date, () => []).add(tx);
    }

    return Scaffold(
      backgroundColor: const Color(0xff0077A3),
      appBar: AppBar(
        title: const Text('Transaction History'),
        backgroundColor: const Color(0xff0077A3),
        centerTitle: true,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : grouped.isEmpty
              ? const Center(
                child: Text(
                  'No transaction history available.',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              )
              : ListView(
                children:
                    grouped.entries.map((entry) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                            (tx) => Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 4,
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          tx.title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          tx.method,
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '${tx.type == 'Income' ? '▲' : '▼'} \$${tx.amount.abs().toStringAsFixed(2)}',
                                      style: TextStyle(
                                        color:
                                            tx.type == 'Income'
                                                ? Colors.green
                                                : Colors.red,
                                        fontWeight: FontWeight.bold,
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
    );
  }
}
