class TransactionModel {
  final int? id;
  final String title;
  final double amount;
  final String type; // income / expense
  final String category;
  final String date;

  TransactionModel({
    this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
  });

  // Convert Object to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'type': type,
      'category': category,
      'date': date,
    };
  }

  // Convert Map to Object
  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      title: map['title'],
      amount: map['amount'].toDouble(),
      type: map['type'],
      category: map['category'],
      date: map['date'],
    );
  }
}