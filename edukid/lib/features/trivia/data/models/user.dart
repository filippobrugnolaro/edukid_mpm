class User {
  final int id;
  final String name;
  final String surname;
  final String email;

  const User({
    required this.id,
    required this.name,
    required this.surname,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        surname: json["surname"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "surname": surname,
        "email": email,
      };

  factory User.fromRestrictedJson(Map<String, dynamic> json) =>
      User(id: json["id"], name: "", surname: "", email: "");

  Map<String, dynamic> toRestrictedJson() => {"id": id, "isCustomer": true};
}
