import 'package:flutter/material.dart';
import 'package:botnet/widgets/bottomBar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final secureStorage = FlutterSecureStorage();

    await prefs.clear();
    await secureStorage.deleteAll();

    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings and activity',
          style: GoogleFonts.poppins(fontSize: 20),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text('Logout', style: GoogleFonts.poppins(color: Colors.red)),
            onTap: logout,
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 2),
    );
  }
}
