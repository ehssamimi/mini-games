// lib/bloc/gameStates/game2/multiplication_random.dart
import 'dart:math';

final _random = Random();

int randMain() => 2 + _random.nextInt(8); // 2 تا 9
int randCurrent() => 1 + _random.nextInt(9); // 1 تا 9

List<int> shuffledOptions(int correct) {
  var set = <int>{correct};
  while (set.length < 4) {
    set.add(1 + _random.nextInt(81));
  }
  var options = set.toList();
  options.shuffle();
  return options;
}
