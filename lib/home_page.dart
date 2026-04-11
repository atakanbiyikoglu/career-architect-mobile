import 'package:flutter/material.dart';

import 'custom_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const List<Map<String, String>> _careerList = [
    {
      'title': 'Yazılım Geliştirici',
      'description': 'Full Stack Web Development',
      'skills': 'Flutter, Dart, Firebase',
    },
    {
      'title': 'Veri Bilimci',
      'description': 'Machine Learning & Analytics',
      'skills': 'Python, TensorFlow, SQL',
    },
    {
      'title': 'UI/UX Tasarımcı',
      'description': 'Kullanıcı Arayüzü Tasarımı',
      'skills': 'Figma, Adobe XD, Prototyping',
    },
    {
      'title': 'DevOps Mühendisi',
      'description': 'Sistem Yönetimi ve Deployment',
      'skills': 'Docker, Kubernetes, AWS',
    },
    {
      'title': 'Mobil Geliştirici',
      'description': 'iOS/Android Uygulama Geliştirme',
      'skills': 'Swift, Kotlin, React Native',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: const Text(
          'Career Architect',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      drawer: const CustomDrawer(),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: _careerList.length,
        itemBuilder: (context, index) {
          final career = _careerList[index];
          return Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      career['title']!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      career['description']!,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Yetenekler: ${career['skills']!}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (index < _careerList.length - 1) const SizedBox(height: 12),
            ],
          );
        },
      ),
    );
  }
}
