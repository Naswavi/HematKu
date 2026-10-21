
class Tx {
  int? id;
  bool expense;
  int amount;
  String cat;
  DateTime date;
  String note;
  Tx({this.id, required this.expense, required this.amount, required this.cat, required this.date, this.note = ''});
  Map<String, Object?> toMap() => {'id': id, 'expense': expense ? 1 : 0, 'amount': amount, 'cat': cat, 'date': date.toIso8601String(), 'note': note};
  factory Tx.fromMap(Map<String, Object?> m) => Tx(
      id: m['id'] as int, expense: m['expense'] == 1, amount: m['amount'] as int,
      cat: m['cat'] as String, date: DateTime.parse(m['date'] as String), note: m['note'] as String);
}

