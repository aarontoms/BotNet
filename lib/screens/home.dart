import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Padding(padding: const EdgeInsets.only(left: 10),
          child: Text('Botnet', style: GoogleFonts.dancingScript(fontSize: 42, fontWeight: FontWeight.w800,),),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, size: 32,),
            onPressed: () {

            },
          ),
          SizedBox(width: 12,),
          IconButton(
            icon: Image.asset('assets/messenger.png', height: 28, width: 28,),
            onPressed: () {

            },
          ),
        ],

      ),
      body: const Center(
        child: Text('(Feed)'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: 0,
        onTap: (index) {

        },
      ),
    );
  }
}
