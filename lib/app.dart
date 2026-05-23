import 'package:flutter/material.dart';

import 'core/app_dependencies.dart';
import 'presentation/home/home_widget.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return AppDependencies(
      child: MaterialApp(
        title: 'MVVM Elementary',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6C63FF),
          ),
          useMaterial3: true,
        ),
        home: const HomeWidget(),
      ),
    );
  }
}
