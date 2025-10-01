import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:medicalservic/utils/colours.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  String selectedService = "Request Medical Transport"; // default
  List<Map<String, dynamic>> requests = [];

  final List<String> serviceOptions = [
    "Request Medical Transport",
    "Book a Doctor Appointment",
    "Schedule a Check-up",
    "Other",
  ];

  @override
  void initState() {
    super.initState();
    loadRequests();
  }

  Future<void> loadRequests() async {
    final prefs = await SharedPreferences.getInstance();
    String? currentUser = prefs.getString('user_email'); // logged-in user
    List<String>? storedRequests = prefs.getStringList('requests') ?? [];

    requests =
        storedRequests
            .map((r) {
              try {
                return jsonDecode(r) as Map<String, dynamic>;
              } catch (e) {
                return <String, dynamic>{};
              }
            })
            .where((r) => r['username'] == currentUser)
            .toList(); // filter by current user

    setState(() {});
  }

  Future<void> addRequest() async {
    final prefs = await SharedPreferences.getInstance();
    String? currentUser = prefs.getString('user_email');
    if (currentUser == null) return;

    List<String> storedRequests = prefs.getStringList('requests') ?? [];

    Map<String, String> newRequest = {
      'username': currentUser,
      'service': selectedService,
      'status': 'Pending',
    };

    storedRequests.add(jsonEncode(newRequest));
    await prefs.setStringList('requests', storedRequests);
    loadRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.blueDark,
        title: const Text(
          "User Panel",
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Selection Dropdown
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.blueLight.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButton<String>(
                value: selectedService,
                isExpanded: true,
                underline: const SizedBox(),
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.blueDark,
                ),
                items:
                    serviceOptions
                        .map(
                          (service) => DropdownMenuItem(
                            value: service,
                            child: Text(service),
                          ),
                        )
                        .toList(),
                onChanged: (val) {
                  setState(() {
                    selectedService = val!;
                  });
                },
              ),
            ),
            const SizedBox(height: 15),

            // Book Service Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: addRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blueDark,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  "Book Service",
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Your Requests:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 10),

            // Request List
            Expanded(
              child:
                  requests.isEmpty
                      ? const Center(
                        child: Text(
                          "No requests yet!",
                          style: TextStyle(fontSize: 16, color: AppColors.grey),
                        ),
                      )
                      : ListView.builder(
                        itemCount: requests.length,
                        itemBuilder: (context, index) {
                          final req = requests[index];
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            elevation: 3,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: AppColors.blueLight,
                                child: const Icon(
                                  Icons.medical_services,
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
                              subtitle: Text(
                                "Status: ${req['status'] ?? ""}",
                                style: TextStyle(
                                  color:
                                      req['status'] == "Pending"
                                          ? Colors.orange
                                          : Colors.green,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
