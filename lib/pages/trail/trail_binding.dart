import 'package:get/get.dart';
import 'trail_logic.dart';

class TrailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TrailLogic());
  }
}
