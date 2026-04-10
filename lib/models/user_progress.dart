class UserProgress {
  int xp;
  int level;

  UserProgress({this.xp = 0, this.level = 1});

  void addXP(int value) {
    xp += value;
    level = (xp ~/ 100) + 1;
  }
}
