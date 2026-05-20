import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ReportPdfService {
  Future<Uint8List> buildHistoryPdf({
    required String participantName,
    required String school,
    required String department,
    required String currentGoal,
    required String testType,
    required String createdAt,
    required String sourceModel,
    required List<Map<String, dynamic>> testResults,
    required String reportText,
  }) async {
    final fontRegular = pw.Font.helvetica();
    final fontBold = pw.Font.helveticaBold();

    final document = pw.Document();
    final theme = pw.ThemeData.withFont(base: fontRegular, bold: fontBold);

    document.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          theme: theme,
          margin: const pw.EdgeInsets.all(24),
        ),
        build: (context) => [
          pw.Container(
            padding: const pw.EdgeInsets.all(20),
            decoration: pw.BoxDecoration(
              color: PdfColor.fromInt(0xFF1A1A2E),
              borderRadius: pw.BorderRadius.circular(16),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Kariyer Mimarı AI',
                  style: pw.TextStyle(
                    font: fontBold,
                    fontSize: 18,
                    color: PdfColors.white,
                  ),
                ),
                pw.SizedBox(height: 6),
                pw.Text(
                  'Dijital Kariyer Analiz Raporu',
                  style: pw.TextStyle(
                    font: fontBold,
                    fontSize: 26,
                    color: PdfColors.white,
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 18),
          _buildSection(
            title: 'Profil Bilgileri',
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _infoRow('Ad Soyad', participantName),
                _infoRow('Okul', school),
                _infoRow('Bölüm', department),
                _infoRow('Hedef', currentGoal),
                _infoRow('Analiz Türü', testType),
                _infoRow('Tarih', createdAt),
                _infoRow('Kaynak Model', sourceModel),
              ],
            ),
          ),
          pw.SizedBox(height: 14),
          _buildSection(
            title: 'Test Özeti',
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: testResults.isEmpty
                  ? [pw.Text('Gösterilecek test kaydı yok.')]
                  : testResults.map((item) {
                      final testName = (item['test_type'] ?? 'Analiz')
                          .toString();
                      final rawScores = item['raw_scores'];
                      final answerCount = rawScores is List
                          ? rawScores.length
                          : 0;
                      return pw.Padding(
                        padding: const pw.EdgeInsets.only(bottom: 6),
                        child: pw.Text('• $testName - $answerCount cevap'),
                      );
                    }).toList(),
            ),
          ),
          pw.SizedBox(height: 14),
          _buildSection(
            title: 'Analiz Raporu',
            child: pw.Text(
              reportText.isEmpty ? 'Rapor metni boş.' : reportText,
              style: const pw.TextStyle(fontSize: 11.5),
            ),
          ),
        ],
      ),
    );

    return document.save();
  }

  pw.Widget _buildSection({required String title, required pw.Widget child}) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        border: pw.Border.all(color: const PdfColor.fromInt(0xFFE2E8F0)),
        borderRadius: pw.BorderRadius.circular(14),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  pw.Widget _infoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 6),
      child: pw.RichText(
        text: pw.TextSpan(
          style: const pw.TextStyle(fontSize: 11.5, color: PdfColors.black),
          children: [
            pw.TextSpan(
              text: '$label: ',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.TextSpan(text: value.isEmpty ? '-' : value),
          ],
        ),
      ),
    );
  }
}
