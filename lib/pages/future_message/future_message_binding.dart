import 'package:get/get.dart';
import 'future_message_logic.dart';

class FutureMessageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(FutureMessageLogic());
  }
}
