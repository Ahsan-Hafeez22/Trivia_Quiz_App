import 'package:get/get.dart';
import 'package:trivia_quiz_app/view_model/controller/loading_controller.dart';

class LoadingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoadingController>(() => LoadingController());
  }
}
