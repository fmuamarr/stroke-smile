import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/utils/database_helper.dart';
import '../core/utils/notification_service.dart';
import '../features/checklist/data/datasources/checklist_local_datasource_sqlite.dart';
import '../features/checklist/data/repositories/checklist_repository_impl.dart';
import '../features/checklist/domain/repositories/checklist_repository.dart';
import '../features/checklist/domain/usecases/get_daily_checklist.dart';
import '../features/checklist/domain/usecases/get_start_date.dart';
import '../features/checklist/domain/usecases/toggle_checklist_item.dart';
import '../features/checklist/presentation/bloc/checklist_bloc.dart';
import '../features/step_by_step/data/datasources/step_local_datasource.dart';
import '../features/step_by_step/data/repositories/step_repository_impl.dart';
import '../features/step_by_step/domain/repositories/step_repository.dart';
import '../features/step_by_step/presentation/bloc/step_bloc.dart';
import '../features/videos/data/datasources/video_local_datasource.dart';
import '../features/videos/data/repositories/video_repository_impl.dart';
import '../features/videos/domain/repositories/video_repository.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await sl.reset();
  // ! External
  await Hive.initFlutter();
  final videoBox = await Hive.openBox('videos');
  sl.registerLazySingleton(() => Dio());
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  if (sharedPreferences.getString('install_date') == null) {
    await sharedPreferences.setString(
      'install_date',
      DateTime.now().toIso8601String(),
    );
  }

  // Database & Notifications
  sl.registerLazySingleton(() => DatabaseHelper());
  final notificationService = NotificationService();
  await notificationService.init();
  // Schedule reminders on app start
  await notificationService.scheduleAllReminders();
  sl.registerLazySingleton(() => notificationService);

  // ! Features - Step by Step
  // Bloc
  sl.registerFactory(() => StepBloc(repository: sl()));
  // Repository
  sl.registerLazySingleton<StepRepository>(
    () => StepRepositoryImpl(localDataSource: sl()),
  );
  // Data Source
  sl.registerLazySingleton<StepLocalDataSource>(
    () => StepLocalDataSourceImpl(),
  );

  // ! Features - Checklist
  // Bloc
  sl.registerFactory(
    () => ChecklistBloc(
      getDailyChecklist: sl(),
      toggleChecklistItem: sl(),
      getStartDate: sl(),
    ),
  );
  // Use Cases
  sl.registerLazySingleton(() => GetDailyChecklist(sl()));
  sl.registerLazySingleton(() => GetStartDate(sl()));
  sl.registerLazySingleton(() => ToggleChecklistItem(sl()));
  // Repository
  sl.registerLazySingleton<ChecklistRepository>(
    () => ChecklistRepositoryImpl(localDataSource: sl()),
  );
  // Data Source
  sl.registerLazySingleton<ChecklistLocalDataSource>(
    () => ChecklistLocalDataSourceImpl(
      databaseHelper: sl(),
      sharedPreferences: sl(),
    ),
  );

  // ! Features - Videos
  // Repository
  sl.registerLazySingleton<VideoRepository>(
    () => VideoRepositoryImpl(localDataSource: sl(), dio: sl()),
  );
  // Data Source
  sl.registerLazySingleton<VideoLocalDataSource>(
    () => VideoLocalDataSourceImpl(box: videoBox),
  );
}
