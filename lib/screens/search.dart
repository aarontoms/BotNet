import 'dart:async';
import 'package:flutter/material.dart';
import 'package:botnet/widgets/bottomBar.dart';

import '../constants.dart';
import '../dio_interceptor.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchController = TextEditingController();
  Timer? _debounce;
  List<dynamic> searchResults = [];

  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), () async {
      // if (query.trim().isEmpty) return;

      try {
        final response = await dio.get(
          '$backendUrl/searchUsers',
          queryParameters: {'q': query.trim()},
        );
        if (response.statusCode == 200) {
          setState(() {
            searchResults = response.data['users'];
          });
        }
      } catch (e) {
        print('Search error: $e');
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              onChanged: onSearchChanged,
              decoration: const InputDecoration(
                labelText: 'Search users',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final user = searchResults[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: user['profilePicture'] == ''
                          ? null
                          : NetworkImage(user['profilePicture']),
                      child: user['profilePicture'] == ''
                          ? const Icon(Icons.person)
                          : null,
                    ),
                    title: Text('@${user['username'] ?? ''}'),
                    subtitle: Text(user['fullName'] ?? ''),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/viewUser',
                        arguments: user['username'],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 1),
    );
  }
}
