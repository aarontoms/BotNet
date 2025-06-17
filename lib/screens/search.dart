import 'package:flutter/material.dart';
import 'package:botnet/widgets/bottomBar.dart';

class Search extends StatefulWidget{
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: const Center(
        child: Text('Search Page'),
      ),
        bottomNavigationBar: CustomBottomNavBar(currentIndex: 1),
    );
  }
}