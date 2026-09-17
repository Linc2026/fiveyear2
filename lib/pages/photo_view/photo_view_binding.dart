import 'package:get/get.dart';
import 'photo_view_logic.dart';

class PhotoViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PhotoViewLogic());
  }
}
