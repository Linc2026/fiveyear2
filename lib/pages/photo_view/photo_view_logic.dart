import 'package:get/get.dart';

class PhotoViewLogic extends GetxController {
  late String path;

  @override
  void onInit() {
    super.onInit();
    path = (Get.arguments as Map)['path'] as String;
  }
}
