class PlayerTransition {
  final String name;
  final int interval;

  PlayerTransition(this.name, this.interval);

  @override
  String toString() {
    return '$name:$interval';
  }
}

Map<String, dynamic> dataToJson(List<String> players, List<PlayerTransition> transitions) {
  Map<String, dynamic> json = {
    'players': players,
    'transitions': [
      for (var transition in transitions) {transition.name: transition.interval}
    ],
  };

  return json;
}