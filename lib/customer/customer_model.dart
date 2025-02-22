class Customer {
  int? id; // Nullable ID for auto-increment
  String name;
  String phone;
  String email;

  Customer({this.id, required this.name, required this.phone, required this.email});

  Map<String, dynamic> toMap() {
    return {
      'id': id, // SQLite me auto-increment ho jayega
      'name': name,
      'phone': phone,
      'email': email,
    };
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      email: map['email'],
    );
  }
}
