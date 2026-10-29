import 'package:five_year_diary/pages/export/export_table.dart';
import 'package:five_year_diary/pages/five_year/five_year_binding.dart';
import 'package:five_year_diary/pages/five_year/five_year_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'db_five_year_diary/data.dart';
import 'lang/lang.dart';
import '../pages/about/about_binding.dart';
import '../pages/about/about_view.dart';
import '../pages/diary_edit/diary_edit_binding.dart';
import '../pages/diary_edit/diary_edit_view.dart';
import '../pages/entry/entry_binding.dart';
import '../pages/entry/entry_view.dart';
import '../pages/export/export_binding.dart';
import '../pages/export/export_view.dart';
import '../pages/future_message/future_message_binding.dart';
import '../pages/future_message/future_message_view.dart';
import '../pages/guide/guide_binding.dart';
import '../pages/guide/guide_view.dart';
import '../pages/help/help_binding.dart';
import '../pages/help/help_view.dart';
import 'pages/main_shell/main_shell_binding.dart';
import 'pages/main_shell/main_shell_view.dart';
import '../pages/photo_view/photo_view_binding.dart';
import '../pages/photo_view/photo_view_view.dart';
import '../pages/settings/settings_binding.dart';
import 'pages/settings/settings_view.dart';
import '../pages/stats/stats_binding.dart';
import '../pages/stats/stats_view.dart';
import 'utils/app_theme.dart';
import 'utils/theme_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('zh_CN', null);
  await initializeDateFormatting('en_US', null);
  await DbFiveYearDiaryData.initSampleData();
  Get.put(ThemeController());
  runApp(const FiveYearDiaryApp());
}

class FiveYearDiaryApp extends StatelessWidget {
  const FiveYearDiaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) {
        return Obx(
          () => GetMaterialApp(
            title: Lang.appName,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: themeController.isDark.value
                ? ThemeMode.dark
                : ThemeMode.light,
            debugShowCheckedModeBanner: false,
            initialRoute: '/',
            getPages: FiveYear,
            locale: const Locale('en', 'US'),
            fallbackLocale: const Locale('zh', 'CN'),
          ),
        );
      },
    );
  }
}

List<GetPage<dynamic>> FiveYear = [
  GetPage(
    name: '/',
    page: () => const FiveYearView(),
    binding: FiveYearBinding(),
  ),
  GetPage(
    name: '/five_entry',
    page: () => const EntryView(),
    binding: EntryBinding(),
  ),
  GetPage(
    name: '/five_guide',
    page: () => const GuideView(),
    binding: GuideBinding(),
  ),
  GetPage(
    name: '/five_main',
    page: () => const MainShellView(),
    binding: MainShellBinding(),
  ),
  GetPage(
    name: '/five_diary_edit',
    page: () => const DiaryEditView(),
    binding: DiaryEditBinding(),
  ),
  GetPage(
    name: '/five_export_table',
    page: () => const ExportTable(),
  ),
  GetPage(
    name: '/five_stats',
    page: () => const StatsView(),
    binding: StatsBinding(),
  ),
  GetPage(
    name: '/five_settings',
    page: () => const SettingsView(),
    binding: SettingsBinding(),
  ),
  GetPage(
    name: '/five_help',
    page: () => const HelpView(),
    binding: HelpBinding(),
  ),
  GetPage(
    name: '/five_about',
    page: () => const AboutView(),
    binding: AboutBinding(),
  ),
  GetPage(
    name: '/five_future_message',
    page: () => const FutureMessageView(),
    binding: FutureMessageBinding(),
  ),
  GetPage(
    name: '/five_export',
    page: () => const ExportView(),
    binding: ExportBinding(),
  ),
  GetPage(
    name: '/five_photo_view',
    page: () => const PhotoViewView(),
    binding: PhotoViewBinding(),
  ),
];
