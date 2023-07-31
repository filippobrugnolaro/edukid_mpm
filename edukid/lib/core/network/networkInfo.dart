import 'dart:async';

import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract class NetworkInfo {
  bool isDeviceConnected();

  void subscriptionToConnectionListener();

  Future<void> cancelSubscriptionToConnectionListener();
}

class NetworkInfoImpl implements NetworkInfo {
  late StreamSubscription<InternetStatus> subscription;
  InternetConnection internetConnection;
  bool isConnected;

  NetworkInfoImpl(
      {required this.subscription,
      required this.internetConnection,
      required this.isConnected});

  @override
  bool isDeviceConnected() {
    return isConnected;
  }

  @override
  void subscriptionToConnectionListener() {
    subscription =
        internetConnection.onStatusChange.listen((InternetStatus status) {
      isConnected = status == InternetStatus.connected;
    });
  }

  @override
  Future<void> cancelSubscriptionToConnectionListener() async {
    await subscription.cancel();
  }
}
