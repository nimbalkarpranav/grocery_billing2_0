class Customer {
  final int? id;
  final String name;
  final String phone;
  final String email;

  Customer({this.id, required this.name, required this.phone, required this.email});

  // Convert a Customer object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
    };
  }

  // Convert a Map object into a Customer object
  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      email: map['email'],
    );
  }
}
