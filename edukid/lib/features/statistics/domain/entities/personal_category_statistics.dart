class PersonalCategoryStatistics {
  int currentCorrect;
  int currentDone;
  int latestCorrect;
  int latestDone;

  PersonalCategoryStatistics({this.currentCorrect = 0, this.currentDone = 0, this.latestCorrect = 0,
  this.latestDone = 0});

  List<Object> get props => [currentCorrect, currentDone, latestCorrect, latestDone];
}
