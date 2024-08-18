import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nutritrack/presentation/pages/archive.dart';
import 'package:nutritrack/presentation/pages/calender.dart';
import 'package:nutritrack/presentation/pages/forget_screen.dart';
import 'package:nutritrack/presentation/pages/home.dart';
import 'package:nutritrack/presentation/pages/kamera.dart';
import 'package:nutritrack/presentation/pages/login_screen.dart';
import 'package:nutritrack/presentation/pages/onboard.dart';
import 'package:nutritrack/presentation/pages/sign_up_screen.dart';
import 'package:nutritrack/presentation/pages/splash_screen.dart';
import 'package:nutritrack/presentation/pages/user_clasification.dart';
import 'package:nutritrack/presentation/pages/user_clasification2.dart';

void main() {
  runApp(const MyApp());
}

/// The route configuration.
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return LoginPage();
      },
    ),
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return SplashScreen();
      },
    ),
    GoRoute(
      path: '/onboard',
      builder: (BuildContext context, GoRouterState state) {
        return Onboard();
      },
    ),
    GoRoute(
      path: '/get-started',
      builder: (BuildContext context, GoRouterState state) {
        return SplashScreen();
      },
    ),
    GoRoute(
      path: '/sign-up',
      builder: (BuildContext context, GoRouterState state) {
        return Signup();
      },
    ),
    GoRoute(
      path: '/fotget-password',
      builder: (BuildContext context, GoRouterState state) {
        return ForgotPasswordScreen();
      },
    ),
    GoRoute(
      path: '/user-clasification',
      builder: (BuildContext context, GoRouterState state) {
        return UserClassificationScreen();
      },
    ),
    GoRoute(
      path: '/user-clasification2',
      builder: (BuildContext context, GoRouterState state) {
        return UserClassificationNext();
      },
    ),
    GoRoute(
      path: '/home',
      builder: (BuildContext context, GoRouterState state) {
        return HomePage();
      },
    ),
    GoRoute(
      path: '/archive',
      builder: (BuildContext context, GoRouterState state) {
        return Archive();
      },
    ),
    GoRoute(
      path: '/calender',
      builder: (BuildContext context, GoRouterState state) {
        return Calendar();
      },
    ),
    GoRoute(
      path: '/camera',
      builder: (BuildContext context, GoRouterState state) {
        return Camera();
      },
    ),
    GoRoute(
      path: '/profile',
      builder: (BuildContext context, GoRouterState state) {
        return Camera();
      },
    ),
  ],
);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}
