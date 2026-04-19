import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/chat_provider.dart';
import '../screens/about_screen.dart';
import '../screens/history_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Drawer(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      backgroundColor: Color(0xFF0F172A),
      child: SafeArea(child: DrawerContent()),
    );
  }
}

class DrawerContent extends ConsumerWidget {
  const DrawerContent({super.key});

  void _closeDrawerIfPossible(BuildContext context) {
    if (Navigator.of(context).canPop()) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('assets/logo.png', width: 48, height: 48),
                const SizedBox(height: 24),
                const Text(
                  'TÜBİTAK 2209-A',
                  style: TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Kariyer Mimarı AI',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'İki Faktörlü Psikometrik Analiz Platformu',
                  style: TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E293B),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.add, size: 20),
                    label: const Text(
                      'Yeni Analiz',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () {
                      _closeDrawerIfPossible(context);
                      ref.read(chatProvider.notifier).clearAndRestart();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.history, color: Color(0xFF94A3B8)),
                title: const Text(
                  'Geçmiş Analizlerim',
                  style: TextStyle(color: Color(0xFFCBD5E1), fontSize: 15),
                ),
                onTap: () {
                  _closeDrawerIfPossible(context);
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const HistoryScreen()),
                  );
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(
                  Icons.info_outline,
                  color: Color(0xFF94A3B8),
                ),
                title: const Text(
                  'Hakkında',
                  style: TextStyle(color: Color(0xFFCBD5E1), fontSize: 15),
                ),
                onTap: () {
                  _closeDrawerIfPossible(context);
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AboutScreen()),
                  );
                },
              ),
              const SizedBox(height: 8),
              const Text(
                '© 2026 Kırşehir Ahi Evran Üniversitesi',
                style: TextStyle(color: Color(0xFF64748B), fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
