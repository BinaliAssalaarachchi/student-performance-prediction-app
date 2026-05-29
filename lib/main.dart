import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme.dart';
import 'home_screen.dart';
import 'dashboard_screen.dart';
import 'providers/auth_provider.dart';
import 'providers/performance_provider.dart';

void main() => runApp(const SmartStudyApp());

class SmartStudyApp extends StatelessWidget {
  const SmartStudyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PerformanceProvider()),
      ],
      child: MaterialApp(
        title: 'SmartStudy',
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: AppColors.blue,
          scaffoldBackgroundColor: AppColors.lightBlue,
          cardColor: AppColors.buttonBlue,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.lightBlue,
            elevation: 0,
            centerTitle: true,
            iconTheme: IconThemeData(color: Colors.white),
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: const Color(0xFF131B2C),
            labelStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.35), fontSize: 13),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.05)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.blue, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.redAccent, width: 2),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttonBlue,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.blue,
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            return authProvider.isAuthenticated
                ? const DashboardScreen()
                : const HomeScreen();
          },
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
