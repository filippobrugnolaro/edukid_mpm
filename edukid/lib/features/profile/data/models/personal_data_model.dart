import 'package:edukid/features/profile/domain/entities/personal_data.dart';

class PersonalDataModel extends PersonalData {
  PersonalDataModel({
    String email = '',
    String name = '',
    String surname = '',
    int points = 0
  }) : super(email: email, name: name, surname: surname, points: points);

  factory PersonalDataModel.fromJson(Map<String, dynamic> json) {
    return PersonalDataModel(
      email: json['email'],
      name: json['name'],
      surname: json['surname'],
      points: (json['points'] as num).toInt()
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'surname': surname,
      'points': points
    };
  }

}