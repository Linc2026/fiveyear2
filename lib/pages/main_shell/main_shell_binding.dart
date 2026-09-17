import 'package:get/get.dart';
import '../calendar/calendar_logic.dart';
import '../diary/diary_logic.dart';
import '../trail/trail_logic.dart';
import '../memories/memories_logic.dart';
import '../profile/profile_logic.dart';
import 'main_shell_logic.dart';

class MainShellBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MainShellLogic());
    Get.lazyPut(() => DiaryLogic());
    Get.lazyPut(() => CalendarLogic());
    Get.lazyPut(() => TrailLogic());
    Get.lazyPut(() => MemoriesLogic());
    Get.lazyPut(() => ProfileLogic());
  }
}
