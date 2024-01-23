// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

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
String _$gameServiceHash() => r'dc0bca5e0aedd1265068f410be552984365e0043';

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
