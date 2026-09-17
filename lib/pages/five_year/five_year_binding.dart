import 'package:get/get.dart';

import 'five_year_logic.dart';

class FiveYearBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      FiveYearLogic(),
      permanent: true,
    );
  }
}
