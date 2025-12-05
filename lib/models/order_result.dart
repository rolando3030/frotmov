// lib/models/order_result.dart
class OrderResult {
  final int orderId;
  final double totalAmount;

  OrderResult({
    required this.orderId,
    required this.totalAmount,
  });

  factory OrderResult.fromJson(Map<String, dynamic> json) {
    return OrderResult(
      orderId: (json['order_id'] ?? 0) as int,
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
    );
  }
}
