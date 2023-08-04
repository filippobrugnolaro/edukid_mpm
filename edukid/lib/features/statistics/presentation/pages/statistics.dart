import 'package:edukid/core/config/colors.dart' as app_colors;
import 'package:edukid/core/presentation/widgets/menu_drawer.dart';
import 'package:edukid/di_container.dart';
import 'package:edukid/features/statistics/domain/repositories/leaderboard_repository.dart';
import 'package:edukid/features/statistics/domain/repositories/personal_category_statistics_repository.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage>
    with SingleTickerProviderStateMixin {
  final leaderBoardRepository = sl<LeaderboardRepository>();
  final personalCategoryStatisticsRepository = sl<PersonalCategoryStatisticsRepository>();
  List<int> listRanks = [];
  List<String> listNames = [];
  List<String> listSurnames = [];
  List<int> listPoints = [];
  List<int> listCurrentCorrect = [];
  List<int> listLatestCorrect = [];
  List<int> listCurrentDone = [];
  List<int> listLatestDone = [];
  bool isConnected = true;

  late TabController _tabController;
  List<Color> tabIndicatorColors = [
    app_colors.fucsia,
    app_colors.blue,
    app_colors.green,
    app_colors.orange
  ];
  List<String> tabTitles = ['Maths', 'Geography', 'History', 'Science'];
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    loadData();
    _tabController = TabController(length: tabTitles.length, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Rebuild the widget when the selected tab index changes
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    disposeAll();
    super.dispose();
  }

  Future<void> loadData() async {
    if(await leaderBoardRepository.isDeviceConnected()
        && await personalCategoryStatisticsRepository.isDeviceConnected()) {
      await getPodium();
      await getPersonalEntry();
      await getPersonalCategoryStatistics();
      setState(() {
        isLoaded = true; // Set isLoading to false when data is loaded
      });
    } else {
      setState(() {
        isConnected = false;
      });
    }
  }

  void disposeAll() {
    listRanks.clear();
    listNames.clear();
    listSurnames.clear();
    listPoints.clear();
    listCurrentCorrect.clear();
    listCurrentDone.clear();
    listLatestCorrect.clear();
    listLatestDone.clear();
  }

  Future<void> getPodium() async {
    final podium = await sl<LeaderboardRepository>().getPodium();
    setState(() {
      for (final element in podium) {
        listRanks.add(element.rank);
        listNames.add(element.name);
        listSurnames.add(element.surname);
        listPoints.add(element.points);
      }
    });
  }

  Future<void> getPersonalEntry() async {
    final personalEntry = await sl<LeaderboardRepository>().getPersonalEntry();
    setState(() {
      listRanks.add(personalEntry.rank);
      listNames.add(personalEntry.name);
      listSurnames.add(personalEntry.surname);
      listPoints.add(personalEntry.points);
    });
  }

  Future<void> getPersonalCategoryStatistics() async {
    final listStatistics =
        await sl<PersonalCategoryStatisticsRepository>().getListStatistics();
    setState(() {
      for (final element in listStatistics) {
        listCurrentCorrect.add(element.currentCorrect);
        listCurrentDone.add(element.currentDone);
        listLatestCorrect.add(element.latestCorrect);
        listLatestDone.add(element.latestDone);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            'Statistics',
          ),
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                // Now Scaffold.of(context) will work correctly
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
          backgroundColor: app_colors.orange,
        ),
        drawer: const MenuDrawer(
          pageNumber: 2,
        ),
        body: isLoaded ?
        Stack(fit: StackFit.expand, children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/doodle.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
              child: Column(children: [
            Padding(
              padding: EdgeInsets.all(5.w),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: app_colors.transparent,
                        border: Border.all(
                            color: app_colors.orange, width: 3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('LEADERBOARD',
                              style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold)),
                          for (int index = 0;
                              index < listRanks.length - 1;
                              index++)
                            _buildPodiumEntry(
                              listRanks[index],
                              listNames[index],
                              listSurnames[index],
                              listPoints[index],
                            ),
                          listRanks.last != 1 &&
                                  listRanks.last != 2 &&
                                  listRanks.last != 3
                              ? const Text('. . .')
                              : const SizedBox(),
                          listRanks.last != 1 &&
                                  listRanks.last != 2 &&
                                  listRanks.last != 3
                              ? _buildPodiumEntry(
                                  listRanks.last,
                                  listNames.last,
                                  listSurnames.last,
                                  listPoints.last)
                              : const SizedBox(),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h),
                    DefaultTabController(
                      length: 4,
                      child: Column(
                        children: [
                          customTabBar(context),
                          SizedBox(
                            height: 45.h, // Adjust the height as needed
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                for (int index = 0;
                                    index < listCurrentCorrect.length;
                                    index++)
                                  buildStatisticsWidget(
                                    context,
                                    listCurrentCorrect[index],
                                    listCurrentDone[index],
                                    listLatestCorrect[index],
                                    listLatestDone[index],
                                    tabIndicatorColors[index],
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ]),
            )
          ]))
        ]) :
        Stack(
          fit: StackFit.expand,
          children: [
            const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(app_colors.orange),)),
            if(!isConnected)
              AlertDialog(
                actionsPadding: const EdgeInsets.all(20),
                title: const Text('Error'),
                content: const Text('It seems there is no internet connection. Please connect to a wifi or mobile data network.'),
                actions: <Widget>[
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: app_colors.orange),
                      onPressed: () {
                        Navigator.pushNamed(context, "statistics");
                        if(isConnected) {
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text('Ok')),
                ],
              ),
          ],
        ),
    );
  }

  Widget _buildPodiumEntry(
      int rank, String firstName, String lastName, int points) {
    return Container(
      padding: EdgeInsets.all(1.5.h),
      margin: EdgeInsets.only(top: 2.h),
      decoration: BoxDecoration(
        color:
            rank == listRanks.last ? app_colors.lightOrange : app_colors.white,
        border: Border.all(color: app_colors.orange, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Text(
              '$rank.',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp),
            ),
            SizedBox(width: 2.w),
            Text('$firstName $lastName', style: TextStyle(fontSize: 13.sp)),
          ]),
          Expanded(
            // Use Expanded to align the icon and points to the right
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '$points',
                  style:
                      TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 2.w),
                Image.asset(
                  'assets/images/coin.png',
                  height: 3.5.h,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStatisticsWidget(BuildContext context, int currentCorrect,
      int currentDone, int latestCorrect, int latestDone, Color color) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 2.h),
          getText(
              context, currentCorrect, currentDone, latestCorrect, latestDone),
          SizedBox(height: 2.h),
          Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Today stats",
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
              )),
          Container(
              height: 3.5.h, // Adjust the height of the linear progress bar
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    8), // Adjust the circular border radius
                border: Border.all(
                    color: app_colors.black,
                    width: 1), // Border color and width
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: currentCorrect != 0 && currentDone != 0
                      ? currentCorrect / currentDone
                      : 0,
                  minHeight: 3.5.h,
                  backgroundColor: Colors.grey[300], // Set the background color
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              )),
          Text('Score: $currentCorrect/$currentDone'),
          SizedBox(height: 2.h),
          Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Latest stats",
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
              )),
          Container(
              height: 3.5.h, // Adjust the height of the linear progress bar
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    8), // Adjust the circular border radius
                border: Border.all(
                    color: app_colors.black,
                    width: 1), // Border color and width
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: latestCorrect != 0 && latestDone != 0
                      ? latestCorrect / latestDone
                      : 0,
                  minHeight: 3.5.h,
                  backgroundColor: Colors.grey[300], // Set the background color
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              )),
          Text('Score: $latestCorrect/$latestDone'),
        ],
      ),
    );
  }

  Text getText(BuildContext context, int currentCorrect, int currentDone,
      int latestCorrect, int latestDone) {
    if (currentDone == 0) {//examples :: c: 0/0 -> l: 0/0
      return Text(
          "You did not answer to any question yet! Let's set today's score!",
          style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: app_colors.red));
    }
    if (latestDone == 0 && currentCorrect > 0) { //examples :: c: 1/1 -> l: 0/0
      return Text("Good job! You are improving, keep it like this!",
          style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: app_colors.green));
    }
    if (latestDone == 0 && currentCorrect == 0) {//examples :: c: 0/1 -> l: 0/0
      return Text("You are exercising more, try to do your best to improve the score!",
          style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: app_colors.orange));
    }
    if (currentCorrect / currentDone > latestCorrect / latestDone &&
        currentDone >= latestDone) { //examples :: c: 2/3 -> l: 1/2 or 2/3 -> l: 1/3
      return Text("Good job! You are improving, keep it like this!",
          style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: app_colors.green));
    }
    if (currentCorrect / currentDone > latestCorrect / latestDone &&
        currentDone < latestDone) { //examples :: c: 1/2 -> l: 1/3
      return Text(
          'You are improving, but you need to exercise more. Keep it going!',
          style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: app_colors.orange));
    }
    if (currentCorrect / currentDone == latestCorrect / latestDone &&
        currentDone > latestDone) { //examples :: c: 2/4 -> l: 1/2
      return Text(
          "You are not improving, but you are exercising more. Keep going and try to do your best!",
          style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: app_colors.orange));
    }
    if (currentCorrect / currentDone == latestCorrect / latestDone &&
        currentDone <= latestDone) { //examples :: c: 1/2 -> l: 1/2 or c: 1/2 -> l: 2/4
      return Text(
          "You are not improving and doing more exercise. Keep going and try to do your best!",
          style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: app_colors.orange));
    }
    if (currentCorrect / currentDone < latestCorrect / latestDone &&
        currentDone > latestDone) { //examples :: c: 2/6 -> l: 1/2
      return Text(
          "You are not improving, but you are exercising more. Keep going and try to do your best!",
          style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: app_colors.orange));
    } else { // 1. < , == ::: 2. < , < :: examples :: c: 1/4 -> l: 2/4 and c: 1/2 -> l: 2/3
      return Text(
          "Try hard, you can do better! Exercise more and take the challenge to beat your last score!",
          style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: app_colors.red));
    }
  }

  Widget customTabBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 246, 246, 246),
        border: Border.all(
          color: const Color.fromARGB(255, 246, 246, 246),
        ),
        borderRadius:
            BorderRadius.circular(10), // Border color for inactive tabs
      ),
      child: TabBar(
        isScrollable: true,
        controller: _tabController,
        tabs: [
          for (int i = 0; i < tabTitles.length; i++)
            Tab(
              child: Text(
                tabTitles[i],
                style: TextStyle(
                  color:
                      _tabController.index == i ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
        indicator: BoxDecoration(
          color: tabIndicatorColors[_tabController
              .index], // Set the background color for the selected tab
          borderRadius:
              BorderRadius.circular(10), // Optional: Add rounded corners
        ),
      ),
    );
  }
}
