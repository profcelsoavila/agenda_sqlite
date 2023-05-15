class Contact {
  static const String tableName = 'contact';
  static const String columnName = 'name';
  static const String columnPhone = 'phone';

  final String name;
  final String phone;

  Contact({required this.name, required this.phone});

  Map<String, dynamic> toMap() {
    return {'name': name, 'phone': phone};
  }
}
