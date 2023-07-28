class EntryLeaderboard {
  int rank;
  String name;
  String surname;
  String email;
  int points;
  int correct;
  int lastTimestamp;

  EntryLeaderboard(
      {this.rank = -1,
      this.name = '-',
      this.surname = '-',
      this.email = '-',
      this.points = 0,
      this.correct = 0,
      this.lastTimestamp = 0});

  List<Object> get props =>
      [rank, name, surname, email, points, correct, lastTimestamp];
}
