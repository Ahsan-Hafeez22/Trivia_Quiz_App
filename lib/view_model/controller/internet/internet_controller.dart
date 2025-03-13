import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'dart:developer';

class InternetController extends GetxController {
  var hasInternet = true.obs;

  @override
  void onInit() {
    super.onInit();
    _listenToConnectivity();
  }

  void _listenToConnectivity() {
    Connectivity().onConnectivityChanged.listen((results) {
      bool isConnected = !results.contains(ConnectivityResult.none);
      hasInternet.value = isConnected;
      log("Internet Status: ${isConnected ? 'Connected' : 'Disconnected'}");
    });
  }
}
