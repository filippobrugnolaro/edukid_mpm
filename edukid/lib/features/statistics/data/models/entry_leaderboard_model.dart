import 'package:edukid/features/statistics/domain/entities/entry_leaderboard.dart';

class EntryLeaderboardModel extends EntryLeaderboard {
  EntryLeaderboardModel(
      {int rank = -1,
      String name = '-',
      String surname = '-',
      String email = '-',
      int points = 0,
      int correct = 0,
      int lastTimestamp = 0})
      : super(
            rank: rank,
            name: name,
            surname: surname,
            email: email,
            points: points,
            correct: correct,
            lastTimestamp: lastTimestamp);

  factory EntryLeaderboardModel.fromJson(Map<String, dynamic> json, int pos) {
    return EntryLeaderboardModel(
        rank: pos,
        name: json['name'],
        surname: json['surname'],
        email: json['email'],
        points: (json['points'] as num).toInt(),
        correct: (json['statistics']['Global']['correct'] as num).toInt(),
        lastTimestamp:
            (json['statistics']['Global']['timestamp'] as num).toInt());
  }
}
