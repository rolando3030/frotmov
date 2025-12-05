// lib/models/seat.dart
class Seat {
  final int id;
  final int row;
  final int column;
  final String status; // "free", "reserved", "sold"

  Seat({
    required this.id,
    required this.row,
    required this.column,
    required this.status,
  });

  bool get isFree => status == 'free';
  bool get isReserved => status == 'reserved';
  bool get isSold => status == 'sold';

  factory Seat.fromJson(Map<String, dynamic> json) {
    return Seat(
      id: json['id'] as int,
      row: json['row'] as int,
      column: json['column'] as int,
      status: json['status'] as String,
    );
  }
}
