class TransactionModel {
  final int? id;
  final String title;
  final double amount;
  final String type;
  final String category;
  final String date;
  final String userEmail;



  TransactionModel({
    this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    required this.userEmail,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'type': type,
      'category': category,
      'date': date,
      'userEmail': userEmail,
    };
  }

  factory TransactionModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return TransactionModel(
      id: map['id'],
      title: map['title'],
      amount: (map['amount'] as num).toDouble(),
      type: map['type'],
      category: map['category'],
      date: map['date'],
      userEmail: map['userEmail'] ?? "",
    );
  }
}