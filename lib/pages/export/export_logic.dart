import 'dart:io';

import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../components/app_ui_kit.dart';
import '../../db_five_year_diary/db_five_year_diary_helper.dart';
import '../../lang/lang.dart';

class ExportLogic extends GetxController {
  final exporting = false.obs;
  final exportPath = RxnString();

  Future<void> exportCsv() async {
    exporting.value = true;
    try {
      final entries = await DbFiveYearDiaryHelper.instance.getAllEntries();
      final buffer = StringBuffer();
      buffer.writeln(
        'year,month,day,content,mood,weather,scene,location,weight,photo_path',
      );
      for (final e in entries) {
        buffer.writeln(
          '${e.year},${e.month},${e.day},"${e.content.replaceAll('"', '""')}",'
          '${e.mood},"${e.weather}","${e.scene}","${e.location}",'
          '${e.weight ?? ""},"${e.photoPath ?? ""}"',
        );
      }
      final dir = await getApplicationDocumentsDirectory();
      final file = File(p.join(dir.path, 'five_year_diary_export.csv'));
      await file.writeAsString(buffer.toString());
      exportPath.value = file.path;
      AppUi.showMessageSheet(
        title: Lang.exportSuccess,
        message: file.path,
      );
    } catch (_) {
      Get.snackbar('', Lang.exportFailed, snackPosition: SnackPosition.BOTTOM);
    }
    exporting.value = false;
  }

  Future<void> shareFile() async {
    final path = exportPath.value;
    if (path == null) return;
    await Share.shareXFiles([XFile(path)], text: Lang.appName);
  }
}
