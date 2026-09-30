import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;

final connectivityProvider = StateNotifierProvider<ConnectivityNotifier, bool>((
    ref,
    ) {
  return ConnectivityNotifier();
});

class ConnectivityNotifier extends StateNotifier<bool> {
  ConnectivityNotifier() : super(true) {
    _init();
  }

  late StreamSubscription<List<ConnectivityResult>> _subscription;
  Timer? _reachabilityTimer;

  bool _isChecking = false;
  bool _initialCheckDone = false; // guards against the stale cold-start event
  int _consecutiveFailures = 0;

  static const _failureThreshold =
  2; // for "wifi connected but no real internet"

  void _init() {
    _checkReachability().then((_) => _initialCheckDone = true);

    _subscription = Connectivity().onConnectivityChanged.listen((results) {
      if (!_initialCheckDone) {
        return; // ignore the spurious first event at cold start
      }

      final deviceHasNoNetwork = results.every(
            (r) => r == ConnectivityResult.none,
      );

      if (deviceHasNoNetwork) {
        // The device itself says there's no radio connection at all —
        // this is reliable once we're past cold start, so trust it immediately.
        _consecutiveFailures = _failureThreshold;
        if (state) state = false;
        _scheduleTimer(fast: true);
      } else {
        // Wifi/mobile is connected, but that doesn't guarantee real internet —
        // verify with a reachability check.
        _checkReachability();
      }
    });

    _scheduleTimer(fast: !state);
  }

  void _scheduleTimer({required bool fast}) {
    _reachabilityTimer?.cancel();
    // Poll faster while offline (to recover quickly), slower while online
    // (to avoid hammering your server / draining battery).
    final interval = fast
        ? const Duration(seconds: 5)
        : const Duration(seconds: 15);
    _reachabilityTimer = Timer.periodic(interval, (_) => _checkReachability());
  }

  Future<void> _checkReachability() async {
    if (_isChecking) return;
    _isChecking = true;

    bool reachable;
    try {
      final response = await http
          .head(Uri.parse('https://www.gstatic.com/generate_204'))
          .timeout(const Duration(seconds: 5));
      reachable = response.statusCode >= 200 && response.statusCode < 500;
    } catch (_) {
      reachable = false;
    }

    if (reachable) {
      _consecutiveFailures = 0;
      if (!state) {
        state = true;
        _scheduleTimer(fast: false); // back to slow polling once online
      }
    } else {
      _consecutiveFailures++;
      if (_consecutiveFailures >= _failureThreshold && state) {
        state = false;
        _scheduleTimer(fast: true); // poll faster to catch recovery
      }
    }

    _isChecking = false;
  }

  @override
  void dispose() {
    _subscription.cancel();
    _reachabilityTimer?.cancel();
    super.dispose();
  }
}
