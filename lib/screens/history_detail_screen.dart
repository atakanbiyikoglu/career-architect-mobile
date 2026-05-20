import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:developer' as developer;
import 'package:flutter/services.dart';
import '../services/download_helper.dart';

import '../services/report_pdf_service.dart';

class HistoryDetailScreen extends StatefulWidget {
  const HistoryDetailScreen({
    super.key,
    required this.participantName,
    required this.school,
    required this.department,
    required this.currentGoal,
    required this.testType,
    required this.createdAt,
    required this.sourceModel,
    required this.reportText,
    required this.testResults,
  });

  final String participantName;
  final String school;
  final String department;
  final String currentGoal;
  final String testType;
  final String createdAt;
  final String sourceModel;
  final String reportText;
  final List<Map<String, dynamic>> testResults;

  @override
  State<HistoryDetailScreen> createState() => _HistoryDetailScreenState();
}

class _HistoryDetailScreenState extends State<HistoryDetailScreen> {
  final ReportPdfService _pdfService = ReportPdfService();
  bool _exporting = false;

  // External link helper removed; History detail should not open the web project.

  Future<void> _exportPdf() async {
    setState(() => _exporting = true);
    try {
      final bytes = await _pdfService.buildHistoryPdf(
        participantName: widget.participantName,
        school: widget.school,
        department: widget.department,
        currentGoal: widget.currentGoal,
        testType: widget.testType,
        createdAt: widget.createdAt,
        sourceModel: widget.sourceModel,
        testResults: widget.testResults,
        reportText: widget.reportText,
      );

      final filename =
          'kariyer-analiz-${DateTime.now().toIso8601String().split('T').first}.pdf';
      if (kIsWeb) {
        await downloadFile(bytes, filename);
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('PDF indirildi.')));
      } else {
        await Printing.sharePdf(bytes: bytes, filename: filename);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PDF paylaşım ekranı açıldı.')),
        );
      }
    } catch (e, st) {
      // Log the error for terminal/browser console debugging
      developer.log('PDF export failed', error: e, stackTrace: st);
      if (!mounted) return;
      final message = kIsWeb
          ? 'PDF dışa aktarılamadı — tarayıcıda PDF paylaşımı desteklenmeyebilir.'
          : 'PDF dışa aktarılamadı.';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) {
        setState(() => _exporting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: Text('${widget.participantName} • Analiz'),
        backgroundColor: const Color(0xFF1A1A2E),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 820),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoCard(),
                const SizedBox(height: 14),
                _buildReportCard(),
                const SizedBox(height: 14),
                _buildActionsCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Kayıt Bilgileri',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            _infoRow('Ad Soyad', widget.participantName),
            _infoRow('Okul', widget.school),
            _infoRow('Bölüm', widget.department),
            _infoRow('Hedef', widget.currentGoal),
            _infoRow('Analiz Türü', widget.testType),
            _infoRow('Tarih', widget.createdAt),
            _infoRow('Kaynak Model', widget.sourceModel),
          ],
        ),
      ),
    );
  }

  Widget _buildReportCard() {
    return Card(
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Analiz Raporu',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            SelectableText(
              widget.reportText.isEmpty
                  ? 'Rapor metni bulunamadı.'
                  : widget.reportText,
              style: const TextStyle(height: 1.5, fontSize: 14.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsCard() {
    return Card(
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            ElevatedButton.icon(
              onPressed: _exporting ? null : _exportPdf,
              icon: const Icon(Icons.picture_as_pdf_outlined),
              label: Text(_exporting ? 'Hazırlanıyor...' : 'PDF İndir'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A1A2E),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
            OutlinedButton.icon(
              onPressed: () async {
                // Show prompt dialog and allow copy
                final prompt =
                    '''Katılımcı: ${widget.participantName}\nOkul: ${widget.school}\nBölüm: ${widget.department}\nHedef: ${widget.currentGoal}\nAnaliz Türü: ${widget.testType}\nRapor Özeti:\n${widget.reportText}''';
                await showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Kullanılan Prompt'),
                    content: SingleChildScrollView(
                      child: SelectableText(prompt),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: prompt));
                          Navigator.of(ctx).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Prompt panoya kopyalandı.'),
                            ),
                          );
                        },
                        child: const Text('Kopyala'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text('Kapat'),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.code),
              label: const Text('Promptu Göster'),
            ),
            // 'Ana Projeyi Aç' button removed — not needed in mobile detail view.
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Color(0xFF0F172A), fontSize: 13.5),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            TextSpan(text: value.isEmpty ? '-' : value),
          ],
        ),
      ),
    );
  }
}
