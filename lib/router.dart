import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/onboarding/welcome_screen.dart';
import 'screens/onboarding/language_screen.dart';
import 'screens/onboarding/step1_personal_screen.dart';
import 'screens/onboarding/step2_academic_screen.dart';
import 'screens/onboarding/step3_interests_screen.dart';
import 'screens/onboarding/step4_location_screen.dart';
import 'screens/onboarding/step5_preferences_screen.dart';
import 'screens/onboarding/processing_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/home/chat_screen.dart';
import 'screens/home/guide_screen.dart';
import 'screens/home/profile_screen.dart';
import 'screens/home/career_path_screen.dart';
import 'screens/home/subject_matrix_screen.dart';
import 'screens/home/skills_gap_screen.dart';
import 'screens/home/internship_screen.dart';
import 'screens/home/study_plan_screen.dart';

Page<void> _buildPage(BuildContext context, GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 180),
    reverseTransitionDuration: const Duration(milliseconds: 140),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.03),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
          child: child,
        ),
      );
    },
  );
}

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => _buildPage(context, state, const WelcomeScreen()),
    ),
    GoRoute(
      path: '/onboarding/language',
      pageBuilder: (context, state) => _buildPage(context, state, const LanguageScreen()),
    ),
    GoRoute(
      path: '/onboarding/step1',
      pageBuilder: (context, state) => _buildPage(context, state, const Step1PersonalScreen()),
    ),
    GoRoute(
      path: '/onboarding/step2',
      pageBuilder: (context, state) => _buildPage(context, state, const Step2AcademicScreen()),
    ),
    GoRoute(
      path: '/onboarding/step3',
      pageBuilder: (context, state) => _buildPage(context, state, const Step3InterestsScreen()),
    ),
    GoRoute(
      path: '/onboarding/step4',
      pageBuilder: (context, state) => _buildPage(context, state, const Step4LocationScreen()),
    ),
    GoRoute(
      path: '/onboarding/step5',
      pageBuilder: (context, state) => _buildPage(context, state, const Step5PreferencesScreen()),
    ),
    GoRoute(
      path: '/onboarding/processing',
      pageBuilder: (context, state) => _buildPage(context, state, const ProcessingScreen()),
    ),
    GoRoute(
      path: '/home',
      pageBuilder: (context, state) => _buildPage(context, state, const HomeScreen()),
    ),
    GoRoute(
      path: '/chat',
      pageBuilder: (context, state) => _buildPage(context, state, const ChatScreen()),
    ),
    GoRoute(
      path: '/guide',
      pageBuilder: (context, state) => _buildPage(context, state, const GuideScreen()),
    ),
    GoRoute(
      path: '/profile',
      pageBuilder: (context, state) => _buildPage(context, state, const ProfileScreen()),
    ),
    GoRoute(
      path: '/career-path',
      pageBuilder: (context, state) => _buildPage(context, state, const CareerPathScreen()),
    ),
    GoRoute(
      path: '/subject-matrix',
      pageBuilder: (context, state) => _buildPage(context, state, const SubjectMatrixScreen()),
    ),
    GoRoute(
      path: '/skills-gap',
      pageBuilder: (context, state) => _buildPage(context, state, const SkillsGapScreen()),
    ),
    GoRoute(
      path: '/internship',
      pageBuilder: (context, state) => _buildPage(context, state, const InternshipScreen()),
    ),
    GoRoute(
      path: '/study-plan',
      pageBuilder: (context, state) => _buildPage(context, state, const StudyPlanScreen()),
    ),
  ],
);
