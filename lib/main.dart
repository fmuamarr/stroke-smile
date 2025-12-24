import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'core/constants/app_strings.dart';
import 'core/theme/app_theme.dart';
import 'features/checklist/presentation/pages/checklist_page.dart';
import 'features/common/presentation/pages/home_page.dart';
import 'features/education/presentation/pages/article_detail_page.dart';
import 'features/education/presentation/pages/education_page.dart';
import 'features/emergency_guide/presentation/pages/emergency_page.dart';
import 'features/onboarding/presentation/pages/onboarding_page.dart';
import 'features/step_by_step/domain/entities/step_guide.dart';
import 'features/step_by_step/presentation/pages/step_detail_page.dart';
import 'features/step_by_step/presentation/pages/step_list_page.dart';
import 'features/videos/presentation/pages/video_list_page.dart';
import 'features/videos/presentation/pages/video_player_page.dart';
import 'injection/injection_container.dart' as di;

import 'package:intl/date_symbol_data_local.dart';
import 'features/common/presentation/pages/notification_page.dart';
import 'features/common/presentation/widgets/scaffold_with_navbar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  await di.init();
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const OnboardingPage()),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationPage(),
    ),
    GoRoute(
      path: '/steps/detail',
      builder: (context, state) {
        final step = state.extra as StepGuide;
        return StepDetailPage(step: step);
      },
    ),
    GoRoute(
      path: '/education/detail',
      builder: (context, state) {
        final article = state.extra as Map<String, String>;
        return ArticleDetailPage(article: article);
      },
    ),
    GoRoute(
      path: '/videos/player',
      builder: (context, state) {
        final args = state.extra as Map<String, String>;
        return VideoPlayerPage(videoUrl: args['url']!, title: args['title']!);
      },
    ),
    ShellRoute(
      builder: (context, state, child) {
        return ScaffoldWithNavBar(child: child);
      },
      routes: [
        GoRoute(path: '/home', builder: (context, state) => const HomePage()),
        GoRoute(
          path: '/checklist',
          builder: (context, state) => const ChecklistPage(),
        ),
        GoRoute(
          path: '/education',
          builder: (context, state) => const EducationPage(),
        ),
        GoRoute(
          path: '/videos',
          builder: (context, state) => const VideoListPage(),
        ),
        GoRoute(
          path: '/steps',
          builder: (context, state) => const StepListPage(),
        ),
        GoRoute(
          path: '/emergency',
          builder: (context, state) => const EmergencyPage(),
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppStrings.appName,
      theme: AppTheme.lightTheme,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
