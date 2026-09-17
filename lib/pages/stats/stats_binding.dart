import 'package:get/get.dart';
import 'stats_logic.dart';

class StatsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(StatsLogic());
  }
}
