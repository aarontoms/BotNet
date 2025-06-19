import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      items: [
        BottomNavigationBarItem(icon: Icon(currentIndex == 0 ? Icons.home : Icons.home_outlined), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(currentIndex == 0 ? Icons.search : Icons.search_outlined), label: 'Search'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
      onTap: (index) {
        if (index == currentIndex) return;
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        if (index == 1) Navigator.pushNamed(context, '/search');
        if (index == 2) Navigator.pushNamed(context, '/profile');
      },
    );
  }
}
