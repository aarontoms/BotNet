import 'package:flutter/material.dart';
import '../constants.dart';
import '../dio_interceptor.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Map<String, dynamic>> requests = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRequests();
  }

  Future<void> fetchRequests() async {
    try {
      final response = await dio.get('$backendUrl/getFollowRequests');
      final List<dynamic> data = response.data['followRequests'];

      setState(() {
        requests = data.cast<Map<String, dynamic>>();
        print("Requests : $requests");
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching requests: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> _acceptRequest(String id) async {
    print("id is $id");
    try {
      final response = await dio.post('$backendUrl/acceptFollowRequest/$id');
      print("Dataa $response");
      
      if (response.statusCode == 200) {
        setState(() {
          requests.removeWhere((request) => request['_id'] == id);
        });
      }
    } catch (e) {
      print('Error accepting request: $e');
    }
  }

  Future<void> _denyRequest(String id) async {
    try {
      final response = await dio.post('$backendUrl/denyFollowRequest/$id');

      if (response.statusCode == 200) {
        setState(() {
          requests.removeWhere((request) => request['id'] == id);
        });
      }
    } catch (e) {
      print('Error denying request: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Follow Requests'),
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : requests.isEmpty
          ? const Center(child: Text('No requests found.'))
          : ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index];
                return Card(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  margin: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          request['profilePicture'] != null &&
                              request['profilePicture'].isNotEmpty
                          ? NetworkImage(request['profilePicture'])
                          : null,
                      child:
                          request['profilePicture'] == null ||
                              request['profilePicture'].isEmpty
                          ? const Icon(Icons.person)
                          : null,
                    ),
                    title: Text(request['username'] ?? 'Unknown'),
                    subtitle: Text(request['fullName'] ?? ''),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            print("Accepted request with id: ${request['_id']}");
                            _acceptRequest(request['_id']);
                          },
                          child: const Text('Confirm'),
                        ),
                        const SizedBox(width: 4),
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Color(0xFF323232),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            print("Denied request with id: ${request['id']}");
                            _denyRequest(request['id']);
                          },
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
