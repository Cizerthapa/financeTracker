class TransactionModel {
  final String title;
  final double amount;
  final String date;
  final String method;
  final String? type;
  final String? category;

  TransactionModel({
    required this.title,
    required this.amount,
    required this.date,
    required this.method,
    this.type,
    this.category,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> data) {
    return TransactionModel(
      title: data['title'] ?? '',
      amount: (data['amount'] as num).toDouble(),
      date: data['date'] ?? '',
      method: data['method'] ?? '',
      type: data['type'] ?? '',
      category: data['category'] ?? '', // <-- map from Firestore
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
      'date': date,
      'method': method,
      'type': type,
      'category': category, // <-- include in upload
    };
  }
}
