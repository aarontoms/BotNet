import 'package:flutter/material.dart';
import 'package:botnet/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dio_interceptor.dart';
import 'screens/login.dart';
import 'screens/signup.dart';
import 'screens/forgot_password.dart';
import 'screens/home.dart';
import 'screens/search.dart';
import 'screens/profile.dart';
import 'screens/settingsPage.dart';
import 'screens/edit_profile.dart';
import 'screens/cameraPage.dart';
import 'screens/viewUserPage.dart';
import 'screens/notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDio();
  final prefs = await SharedPreferences.getInstance();
  final accessToken = prefs.getString('access_token');

  runApp(MyApp(initialRoute: accessToken != null ? '/home' : '/'));
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BotNet',
      initialRoute: initialRoute,
      navigatorKey: navigatorKey,
      routes: {
        '/': (context) => Login(),
        '/signup': (context) => SignUp(),
        '/forgot_password': (context) => Forgot(),
        '/home': (context) => Home(),
        '/search': (context) => Search(),
        '/profile': (context) => Profile(),
        '/notifications': (context) => NotificationsScreen(),
        '/settings': (context) => SettingsPage(),
        '/edit_profile': (context) => EditProfile(),
        '/camera': (context) => CameraPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/viewUser') {
          final username = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => ViewUserPage(username: username),
          );
        }

        return null; // fallback to default
      },
      theme: AppTheme.themeData,
    );
  }
}
