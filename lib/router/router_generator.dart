import 'package:flutter/material.dart';
import 'package:planning_poker/data_user.dart';
import 'package:planning_poker/home_view.dart';
import 'package:planning_poker/login_view.dart';

class RouteGenerator {
  static Route<dynamic> generateRouter(RouteSettings settings) {
    if (!DataUser().isLogin) {
      return MaterialPageRoute(builder: (_) => const LoginView());
    }

    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginView());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeView());
      default:
        return MaterialPageRoute(builder: (_) => const LoginView());
    }
  }
}
