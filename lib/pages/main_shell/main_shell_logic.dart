import 'package:get/get.dart';
import '../calendar/calendar_logic.dart';
import '../diary/diary_logic.dart';
import '../trail/trail_logic.dart';
import '../memories/memories_logic.dart';
import '../profile/profile_logic.dart';

class MainShellLogic extends GetxController {
  final currentIndex = 0.obs;

  void changeTab(int index) {
    currentIndex.value = index;
    _refreshTab(index);
  }

  void refreshCurrentTab() {
    _refreshTab(currentIndex.value);
  }

  void _refreshTab(int index) {
    switch (index) {
      case 0:
        Get.find<DiaryLogic>().loadData();
      case 1:
        Get.find<CalendarLogic>().loadData();
      case 2:
        Get.find<TrailLogic>().loadData();
      case 3:
        Get.find<MemoriesLogic>().loadData();
      case 4:
        Get.find<ProfileLogic>().loadData();
    }
  }
}
