import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _openUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication) &&
        context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Bağlantı açılamadı.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 210,
            backgroundColor: const Color(0xFF1A1A2E),
            foregroundColor: Colors.white,
            title: const Text(
              'Hakkında',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsetsDirectional.only(start: 16),
              centerTitle: false,
              background: Padding(
                // push the expanded content below the toolbar/title to avoid overlap
                padding: const EdgeInsets.fromLTRB(16, 96, 16, 24),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/logo.png',
                          width: 64,
                          height: 64,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'TÜBİTAK 2209-A',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Kariyer Mimarı AI',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'İki Faktörlü Psikometrik Analiz Platformu',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            sliver: SliverToBoxAdapter(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 760),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Card(
                        elevation: 2,
                        color: Colors.white,
                        shadowColor: Colors.black12,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'TÜBİTAK 2209-A Projesi',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1A1A2E),
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Proje: İki Faktörlü Psikometrik Modelin Üretken Yapay Zekâ ile Sentezlenmesi',
                                style: TextStyle(color: Color(0xFF475569)),
                              ),
                              SizedBox(height: 12),
                              Text(
                                'Geliştirici: Atakan Bıyıkoğlu',
                                style: TextStyle(color: Color(0xFF475569)),
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Danışman: Doç. Dr. Fatih Yaman',
                                style: TextStyle(color: Color(0xFF475569)),
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Kurum: Kırşehir Ahi Evran Üniversitesi, Kaman Uygulamalı Bilimler Yüksekokulu, Yönetim Bilişim Sistemleri Bölümü',
                                style: TextStyle(color: Color(0xFF475569)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Card(
                        elevation: 1,
                        color: Colors.white,
                        shadowColor: Colors.black12,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Açıklama ve Linkler',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1A1A2E),
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Bu uygulama, ana web projesinin mobil yüzüdür. Ana proje ve geliştirici hesapları aşağıdaki bağlantılardan açılabilir.',
                                style: TextStyle(
                                  color: Color(0xFF475569),
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 14),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: [
                                  OutlinedButton.icon(
                                    onPressed: () => _openUrl(
                                      context,
                                      'https://kariyermimari.tech/',
                                    ),
                                    icon: const Icon(Icons.open_in_new),
                                    label: const Text('Ana Proje'),
                                  ),
                                  OutlinedButton.icon(
                                    onPressed: () => _openUrl(
                                      context,
                                      'https://github.com/atakanbiyikoglu',
                                    ),
                                    icon: const Icon(Icons.code),
                                    label: const Text('GitHub'),
                                  ),
                                  OutlinedButton.icon(
                                    onPressed: () => _openUrl(
                                      context,
                                      'https://www.linkedin.com/in/atakanbiyikoglu',
                                    ),
                                    icon: const Icon(Icons.business),
                                    label: const Text('LinkedIn'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              const Text(
                                'Aydınlatma Metni',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1A1A2E),
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Bu platformdaki verileriniz TÜBİTAK 2209-A araştırma projesi kapsamında, akademik amaçlarla tamamen anonimleştirilerek analiz edilmektedir. Sisteme girdiğiniz bilgiler üçüncü şahıslarla paylaşılmaz.',
                                style: TextStyle(
                                  color: Color(0xFF475569),
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
