import 'package:get/get.dart';
import 'entry_logic.dart';

class EntryBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(EntryLogic());
  }
}
