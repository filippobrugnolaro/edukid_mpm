import 'package:edukid/core/data/data_sources/auth_api.dart';
import 'package:edukid/core/network/network_info.dart';
import 'package:edukid/features/statistics/data/data_sources/leaderboard_data_source.dart';
import 'package:edukid/features/statistics/domain/entities/entry_leaderboard.dart';
import 'package:edukid/features/statistics/domain/repositories/leaderboard_repository.dart';

class LeaderboardRepositoryImpl implements LeaderboardRepository {
  final LeaderboardDataSource leaderboardDataSource;
  final AuthAPI authAPI;
  final NetworkInfo networkInfo;

  LeaderboardRepositoryImpl(
      {required this.leaderboardDataSource, required this.authAPI, required this.networkInfo});

  @override
  Future<List<EntryLeaderboard>> getAllEntriesLeaderboard() async {
    return await leaderboardDataSource.getAllEntriesLeaderboard();
  }

  @override
  Future<List<EntryLeaderboard>> getPodium() async {
    final podium = await getAllEntriesLeaderboard();
    return podium.length > 3 ? limitLeaderboard(podium, 3) : podium;
  }

  @override
  List<EntryLeaderboard> limitLeaderboard(
      List<EntryLeaderboard> list, int numItems) {
    return list.sublist(0, numItems);
  }

  @override
  Future<EntryLeaderboard> getPersonalEntry() async {
    final allEntries = await getAllEntriesLeaderboard();
    final emailToMatch = await leaderboardDataSource
        .getEmailFromUID(authAPI.getSignedInUserUID());
    return allEntries.firstWhere((element) =>
         emailToMatch.toString() ==
        element.email);
  }

  @override
  Future<bool> isDeviceConnected() async {
    return await networkInfo.isConnected;
  }
}
