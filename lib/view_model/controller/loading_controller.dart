import 'package:get/get.dart';

class LoadingController extends GetxController {
  RxBool loadingValue = false.obs;
  void setLoadingValue(bool loading) => loadingValue.value = loading;
}
