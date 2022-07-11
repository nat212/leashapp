class Tracker {
  final String? id;
  final String name;
  final String? description;
  final double amount;

  const Tracker({
    this.id,
    required this.name,
    required this.amount,
    this.description,
  });

  static double _mapAmountToDouble(dynamic amount) {
    if (amount is int) {
      return amount.toDouble();
    } else if (amount is double) {
      return amount;
    } else if (amount == null) {
      return 0.0;
    } else {
      throw Exception('Invalid amount type: ${amount.runtimeType}');
    }
  }

  Tracker.fromMap(Map<String, dynamic> map)
      : id = map['id'] as String,
        name = map['name'] as String,
        amount = _mapAmountToDouble(map['amount']),
        description = map['description'] as String?;

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "amount": amount,
    "description": description,
  };

  Tracker copyWith({
    String? id,
    String? name,
    String? description,
    double? amount,
  }) {
    return Tracker(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      amount: amount ?? this.amount,
    );
  }

  @override
  String toString() => 'Tracker(id: $id, name: $name, amount: $amount, description: $description)';
}
