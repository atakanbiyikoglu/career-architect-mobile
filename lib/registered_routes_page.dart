import 'package:flutter/material.dart';

class RegisteredRoutesPage extends StatelessWidget {
  const RegisteredRoutesPage({super.key});

  static const List<Map<String, String>> _pastRoles = [
    {
      'role': 'Junior Yazılım Geliştirici',
      'company': 'Tech Startup Inc.',
      'duration': '2021 - 2022',
    },
    {
      'role': 'Orta Seviye Yazılım Geliştirici',
      'company': 'Digital Solutions Ltd.',
      'duration': '2022 - 2024',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: const Text(
          'Kayıtlı Rotalar',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: _pastRoles.length,
        itemBuilder: (context, index) {
          final role = _pastRoles[index];
          return Column(
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        role['role']!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        role['company']!,
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        role['duration']!,
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ),
              ),
              if (index < _pastRoles.length - 1) const SizedBox(height: 12),
            ],
          );
        },
      ),
    );
  }
}
