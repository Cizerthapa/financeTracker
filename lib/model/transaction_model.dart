class TransactionModel {
  final String id;
  final String title;
  final double amount;
  final String date;
  final String method;
  final String? type; // <-- This must be present

  TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.method,
    this.type,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> data) {
    return TransactionModel(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      amount: (data['amount'] as num).toDouble(),
      date: data['date'] ?? '',
      method: data['method'] ?? '',
      type: data['type'] ?? '', // Add this line
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date,
      'method': method,
      'title': title,
    };
  }
}
