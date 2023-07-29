import 'package:edukid/core/config/colors.dart' as app_colors;
import 'package:edukid/core/presentation/widgets/menuDrawer.dart';
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
  List<int> listRanks = [];
  List<String> listNames = [];
  List<String> listSurnames = [];
  List<int> listPoints = [];
  List<int> listCurrentCorrect = [];
  List<int> listLatestCorrect = [];
  List<int> listCurrentDone = [];
  List<int> listLatestDone = [];

  late TabController _tabController;
  List<Color> tabIndicatorColors = [
    app_colors.fucsia,
    app_colors.blue,
    app_colors.green,
    app_colors.orange
  ];
  List<String> tabTitles = ['Math', 'Geo', 'History', 'Science'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabTitles.length, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Rebuild the widget when the selected tab index changes
    });
    loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    disposeAll();
    super.dispose();
  }

  Future<void> loadData() async {
  await getPodium();
  await getPersonalEntry();
  await getPersonalCategoryStatistics();
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
        drawer: MenuDrawer(
          pageNumber: 2,
        ),
        body: Stack(fit: StackFit.expand, children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/doodle.png'),
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
                        border: Border.all(color: app_colors.orange, width: 3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('LEADERBOARD', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold)),
                          SizedBox(height: 2.h),
                          for (int index = 0; index < listRanks.length-1; index++)
                            _buildPodiumEntry(
                              listRanks[index],
                              listNames[index],
                              listSurnames[index],
                              listPoints[index],
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text('Your points: ${listPoints.last}',
                        style: TextStyle(fontSize: 13.sp)),
                    Text(
                      'Your position in the ranking: ${listRanks.last}',
                      style: TextStyle(fontSize: 13.sp),
                    ),
                    SizedBox(height: 2.h),
                    DefaultTabController(
                      length: 4,
                      child: Column(
                        children: [
                          customTabBar(context),
                          Container(
                            height: 45.h, // Adjust the height as needed

                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                buildStatisticsWidget(context, 50, 70, 90, 110,
                                    app_colors.fucsia),
                                buildStatisticsWidget(
                                    context, 50, 70, 90, 110, app_colors.blue),
                                buildStatisticsWidget(
                                    context, 50, 70, 90, 110, app_colors.green),
                                buildStatisticsWidget(
                                    context, 50, 70, 90, 110, app_colors.orange)
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ]),
            )
          ]))
        ]));
  }

  Widget _buildPodiumEntry(
      int rank, String firstName, String lastName, int points) {
    return Container(
      padding: EdgeInsets.all(1.5.h),
      margin: EdgeInsets.only(top: 2.h),
      decoration: BoxDecoration(
        color: app_colors.white,
        border: Border.all(color: app_colors.orange, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
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
                  'images/coin.png',
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
          Text(
            currentCorrect / currentDone > latestCorrect / latestDone
                ? 'Good job! You are improving, keep it like this!'
                : "C'mon you can do better! Take the challenge and beat yesterday's score!",
            style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: currentCorrect / currentDone > latestCorrect / latestDone
                    ? app_colors.green
                    : app_colors.red),
          ),
          SizedBox(height: 2.h),
          Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Today's stats",
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
                  value: currentCorrect / currentDone,
                  minHeight: 3.5.h,
                  backgroundColor: Colors.grey[300], // Set the background color
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              )),
          Text('Correct answers: $currentCorrect/$currentDone'),
          SizedBox(height: 2.h),
          Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Yesterday's stats",
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
                  value: latestCorrect / latestDone,
                  minHeight: 3.5.h,
                  backgroundColor: Colors.grey[300], // Set the background color
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              )),
          Text('Correct answers: $latestCorrect/$latestDone'),
        ],
      ),
    );
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
