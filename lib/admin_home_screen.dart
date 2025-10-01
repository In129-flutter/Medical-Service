import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:medicalservic/utils/colours.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  List<Map<String, dynamic>> requests = [];

  @override
  void initState() {
    super.initState();
    loadRequests();
  }

  Future<void> loadRequests() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? storedRequests = prefs.getStringList('requests');

    if (storedRequests != null && storedRequests.isNotEmpty) {
      requests =
          storedRequests.map((r) {
            try {
              return jsonDecode(r) as Map<String, dynamic>;
            } catch (e) {
              return <String, dynamic>{};
            }
          }).toList();
    } else {
      requests = [];
    }

    setState(() {});
  }

  Future<void> updateStatus(int index, String status) async {
    final prefs = await SharedPreferences.getInstance();
    requests[index]['status'] = status;
    List<String> encoded = requests.map((r) => jsonEncode(r)).toList();
    await prefs.setStringList('requests', encoded);

    await loadRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.blueDark,
        title: const Text(
          "Admin Panel",
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.white),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('is_logged_in', false);
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child:
            requests.isEmpty
                ? const Center(
                  child: Text(
                    "No requests found!",
                    style: TextStyle(fontSize: 16, color: AppColors.grey),
                  ),
                )
                : ListView.builder(
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    final req = requests[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.blueLight,
                          child: const Icon(
                            Icons.person,
                            color: AppColors.blueDark,
                          ),
                        ),
                        title: Text(
                          req['service'] ?? "",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Text(
                            "User: ${req['username']}\nStatus: ${req['status']}",
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.grey,
                            ),
                          ),
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: AppColors.blueLight.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: DropdownButton<String>(
                            value: req['status'],
                            underline: const SizedBox(),
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: AppColors.blueDark,
                            ),
                            items:
                                ['Pending', 'Accepted', 'Rejected', 'Completed']
                                    .map(
                                      (status) => DropdownMenuItem(
                                        value: status,
                                        child: Text(
                                          status,
                                          style: TextStyle(
                                            color:
                                                status == "Pending"
                                                    ? Colors.orange
                                                    : status == "Accepted"
                                                    ? Colors.green
                                                    : status == "Rejected"
                                                    ? Colors.red
                                                    : AppColors.blueDark,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (val) {
                              if (val != null) updateStatus(index, val);
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
