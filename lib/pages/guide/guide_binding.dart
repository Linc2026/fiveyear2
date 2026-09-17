import 'package:get/get.dart';
import 'guide_logic.dart';

class GuideBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(GuideLogic());
  }
}
