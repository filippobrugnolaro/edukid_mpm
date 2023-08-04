

class PersonalData {
  String email;
  String name;
  String surname;
  int points;

  PersonalData({
    this.email = '',
    this.name = '',
    this.surname = '',
    this.points = 0
  });

  List<Object> get props => [email, name, surname, points];

}