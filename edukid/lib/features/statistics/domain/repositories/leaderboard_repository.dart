import 'package:edukid/features/statistics/domain/entities/entry_leaderboard.dart';

abstract class LeaderboardRepository {
  Future<List<EntryLeaderboard>> getAllEntriesLeaderboard();

  Future<List<EntryLeaderboard>> getPodium();

  List<EntryLeaderboard> limitLeaderboard(
      List<EntryLeaderboard> list, int numItems);

  Future<EntryLeaderboard> getPersonalEntry();
}
