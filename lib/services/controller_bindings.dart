
import 'package:get/get.dart';
import 'package:vhrs_flutter_project/services/controller.dart';
class ControllerBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<Controller>(Controller());
  }

}