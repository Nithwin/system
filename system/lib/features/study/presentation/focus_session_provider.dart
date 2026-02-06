import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FocusSessionState {
  final Duration duration;
  final bool isRunning;

  const FocusSessionState({
    required this.duration,
    required this.isRunning,
  });

  factory FocusSessionState.initial() {
    return const FocusSessionState(
      duration: Duration.zero,
      isRunning: false,
    );
  }

  FocusSessionState copyWith({
    Duration? duration,
    bool? isRunning,
  }) {
    return FocusSessionState(
      duration: duration ?? this.duration,
      isRunning: isRunning ?? this.isRunning,
    );
  }
}

class FocusSessionNotifier extends Notifier<FocusSessionState> {
  Timer? _timer;

  @override
  FocusSessionState build() {
    ref.onDispose(() {
      _timer?.cancel();
    });
    return FocusSessionState.initial();
  }

  void start() {
    if (state.isRunning) return;

    state = state.copyWith(isRunning: true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      state = state.copyWith(duration: state.duration + const Duration(seconds: 1));
    });
  }

  void pause() {
    _timer?.cancel();
    state = state.copyWith(isRunning: false);
  }

  void reset() {
    _timer?.cancel();
    state = FocusSessionState.initial();
  }
}

final focusSessionProvider = NotifierProvider<FocusSessionNotifier, FocusSessionState>(() {
  return FocusSessionNotifier();
});
