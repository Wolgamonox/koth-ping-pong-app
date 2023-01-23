class PlayerTransition {
  final String name;
  final int interval;

  PlayerTransition(this.name, this.interval);

  @override
  String toString() {
    return '$name:$interval';
  }
}

Map<String, dynamic> transitionsToJson(List<PlayerTransition> transitions) {
  Map<String, dynamic> json = {
    'transitions': [
      for (var transition in transitions) {transition.name: transition.interval}
    ],
  };

  return json;
}