import 'package:flutter/material.dart';

import 'home_page.dart';
import 'profile_page.dart';
import 'registered_routes_page.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.deepPurple),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: Colors.deepPurple, size: 30),
                ),
                SizedBox(height: 10),
                Text(
                  'Atakan Bıyıkoğlu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Ana Sayfa'),
            onTap: () => _navigateToPage(context, const HomePage()),
          ),
          ListTile(
            leading: const Icon(Icons.route),
            title: const Text('Kayıtlı Rotalar'),
            onTap: () => _navigateToPage(context, const RegisteredRoutesPage()),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profil'),
            onTap: () => _navigateToPage(context, const ProfilePage()),
          ),
        ],
      ),
    );
  }
}
