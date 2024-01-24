// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$audioPlayerHash() => r'0f9f941057440935279fb5ed67e9d88ff0d6549a';

/// See also [audioPlayer].
@ProviderFor(audioPlayer)
final audioPlayerProvider = AutoDisposeProvider<AudioPlayer>.internal(
  audioPlayer,
  name: r'audioPlayerProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$audioPlayerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AudioPlayerRef = AutoDisposeProviderRef<AudioPlayer>;
String _$stopwatchHash() => r'980d1d0065a4379ff9ada22648c75559735a2db4';

/// See also [stopwatch].
@ProviderFor(stopwatch)
final stopwatchProvider = AutoDisposeProvider<Stopwatch>.internal(
  stopwatch,
  name: r'stopwatchProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$stopwatchHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef StopwatchRef = AutoDisposeProviderRef<Stopwatch>;
String _$gameServiceHash() => r'f4843e37f40570749dc4ed96b24d39f6b415dee8';

/// See also [GameService].
@ProviderFor(GameService)
final gameServiceProvider =
    AutoDisposeNotifierProvider<GameService, Game>.internal(
  GameService.new,
  name: r'gameServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$gameServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$GameService = AutoDisposeNotifier<Game>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
