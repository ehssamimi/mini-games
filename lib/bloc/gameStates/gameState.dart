class GameState {
  final int hp; // تعداد جان (مثلاً ۴)
  final int xp; // امتیاز تجربه
  final int currentLevel; // مرحله فعلی

  GameState({
    required this.hp,
    required this.xp,
    required this.currentLevel,
  });

  GameState copyWith({int? hp, int? xp, int? currentLevel}) =>
      GameState(
        hp: hp ?? this.hp,
        xp: xp ?? this.xp,
        currentLevel: currentLevel ?? this.currentLevel,
      );
}
