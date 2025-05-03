class TransactionModel {
  final String title;
  final double amount;
  final String method;
  final String date;

  TransactionModel({
    required this.title,
    required this.amount,
    required this.method,
    required this.date,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      amount: (map['amount'] as num).toDouble(),
      date: map['date'] ?? '',
      method: map['method'] ?? '',
      title: map['title'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'date': date,
      'method': method,
      'title': title,
    };
  }
}
