class Account {
  String id;
  String phone;
  String firstName;
  String lastName;

  Account(
      {required this.id,
      required this.phone,
      required this.firstName,
      required this.lastName});

  factory Account.fromEmpty() {
    return Account(
      id: "",
      phone: "",
      firstName: "",
      lastName: "",
    );
  }

  factory Account.fromJSON(Map<String, dynamic> json) {
    return Account(
        id: json['id'],
        phone: json['phone'],
        firstName: json['firstName'],
        lastName: json['lastName']);
  }

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'phone': phone,
      'firstName': firstName,
      'lastName': lastName,
    };
  }
}
