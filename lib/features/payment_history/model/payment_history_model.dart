class PaymentHistoryModel {
  final String? message;
  final TransactionData? data;

  PaymentHistoryModel({
      this.message,
      this.data,
  });

  factory PaymentHistoryModel.fromJson(Map<String, dynamic> json) {
    return PaymentHistoryModel(
      message: json['message'] ?? '',
      data: TransactionData.fromJson(json['data'] ?? {}),
    );
  }
}

class TransactionData {
  final List<Transaction> transactions;

  TransactionData({required this.transactions});

  factory TransactionData.fromJson(Map<String, dynamic> json) {
    var list = <Transaction>[];
    if (json['transactions'] != null) {
      list = List<Transaction>.from(
        json['transactions'].map((x) => Transaction.fromJson(x)),
      );
    }
    return TransactionData(transactions: list);
  }
}

class Transaction {
  final int id;
  final int enrollmentId;
  final String name;
  final String email;
  final String courseTitle;
  final String paymentMethod;
  final double paymentAmount;
  final int isPaid;
  final String paidAt;
  final String status;
  final String payAt;
  final int courseId; // 👈 added

  Transaction({
    required this.id,
    required this.enrollmentId,
    required this.name,
    required this.email,
    required this.courseTitle,
    required this.paymentMethod,
    required this.paymentAmount,
    required this.isPaid,
    required this.paidAt,
    required this.status,
    required this.payAt,
    required this.courseId,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      enrollmentId: json['enrollment_id'],
      name: json['name'],
      email: json['email'],
      courseTitle: json['course_title'],
      paymentMethod: json['payment_method'],
      paymentAmount: (json['payment_amount'] as num).toDouble(),
      isPaid: json['is_paid'],
      paidAt: json['paid_at'],
      status: json['status'],
      payAt: json['pay_at'],
      courseId: json['course']?['id'] ?? 0, // 👈 safely map course id
    );
  }
}

