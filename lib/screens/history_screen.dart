import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../providers/chat_provider.dart';
import 'history_detail_screen.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  bool _loading = true;
  List<Map<String, dynamic>> _items = const [];
  Map<String, dynamic>? _participant;
  Map<String, dynamic>? _recommendation;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    if (mounted) {
      setState(() => _loading = true);
    }

    try {
      final participantId = ref.read(chatProvider.notifier).participantId;
      if (participantId == null || participantId.isEmpty) {
        _items = const [];
        _participant = null;
        _recommendation = null;
        return;
      }

      final client = Supabase.instance.client;
      final participantResponse = await client
          .from('participants')
          .select(
            'id, student_name, school, department, current_goal, experiment_group',
          )
          .eq('id', participantId)
          .maybeSingle();

      final recommendationResponse = await client
          .from('recommendations')
          .select('generated_text, source_model, created_at')
          .eq('participant_id', participantId)
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      final response = await client
          .from('test_results')
          .select('id, test_type, created_at, raw_scores')
          .eq('participant_id', participantId)
          .order('created_at', ascending: false);

      _participant = participantResponse;
      _recommendation = recommendationResponse;
      final fetched = List<Map<String, dynamic>>.from(response);
      // Deduplicate by `id`, preserving order
      final seen = <dynamic>{};
      final deduped = <Map<String, dynamic>>[];
      for (final item in fetched) {
        final id = item['id'];
        if (id == null) continue;
        if (seen.contains(id)) continue;
        seen.add(id);
        deduped.add(item);
      }

      // Group test results that belong to the same analysis run (same created_at)
      // so RIASEC and OCEAN parts show as a single history row.
      final groupedMap = <String, List<Map<String, dynamic>>>{};
      for (final item in deduped) {
        final key = (item['created_at'] ?? '').toString();
        if (!groupedMap.containsKey(key)) groupedMap[key] = [];
        groupedMap[key]!.add(item);
      }

      final groupedList = <Map<String, dynamic>>[];
      for (final entry in groupedMap.entries) {
        final items = entry.value;
        // Combine test types into a single label
        final types = items
            .map((e) => (e['test_type'] ?? '').toString())
            .where((t) => t.isNotEmpty)
            .toSet()
            .toList();
        final combinedType = types.isEmpty ? 'Analiz' : types.join(' + ');
        final first = items.first;
        groupedList.add({
          'created_at': first['created_at'],
          'test_type': combinedType,
          'raw_items': items,
        });
      }

      // Preserve descending order by created_at as original
      _items = groupedList;
    } catch (_) {
      _items = const [];
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  String _formatDate(dynamic value) {
    if (value == null) return 'Tarih bilgisi yok';
    final text = value.toString();
    if (text.isEmpty) return 'Tarih bilgisi yok';
    return text.replaceFirst('T', ' ').split('.').first;
  }

  @override
  Widget build(BuildContext context) {
    final participantName =
        (_participant?['student_name'] ?? 'Kayıtlı Kullanıcı').toString();
    final school = (_participant?['school'] ?? '').toString();
    final department = (_participant?['department'] ?? '').toString();
    final currentGoal = (_participant?['current_goal'] ?? '').toString();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: Text(
          '$participantName • Geçmiş Analizlerim',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: const Color(0xFF1A1A2E),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _loadHistory,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A2E),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.asset(
                          'assets/logo.png',
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'TÜBİTAK 2209-A',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              participantName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Son analizler ve PDF çıktıları burada görüntülenir.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                height: 1.35,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Kayda dokunarak detay ve PDF dışa aktarma ekranını açabilirsiniz.',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                height: 1.35,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              [
                                if (school.isNotEmpty) school,
                                if (department.isNotEmpty) department,
                                if (currentGoal.isNotEmpty) currentGoal,
                              ].join(' • '),
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                height: 1.35,
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
            if (_loading)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_items.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.history_rounded,
                          size: 56,
                          color: Color(0xFF94A3B8),
                        ),
                        SizedBox(height: 14),
                        Text(
                          'Henüz analiz kaydı yok.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Testi tamamladıktan sonra analiz geçmişin burada görünecek.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF94A3B8),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                sliver: SliverList.separated(
                  itemCount: _items.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    final testType = (item['test_type'] ?? 'Analiz').toString();
                    final createdAt = _formatDate(item['created_at']);
                    final generatedText =
                        (_recommendation?['generated_text'] ?? '').toString();
                    final sourceModel =
                        (_recommendation?['source_model'] ?? 'rule_based')
                            .toString();

                    return Card(
                      elevation: 1,
                      color: Colors.white,
                      shadowColor: Colors.black12,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        leading: Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE2E8F0),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.assessment_rounded,
                            color: Color(0xFF1A1A2E),
                          ),
                        ),
                        title: Text(
                          '$participantName • $testType',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                createdAt,
                                style: const TextStyle(
                                  color: Color(0xFF64748B),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                sourceModel,
                                style: const TextStyle(
                                  color: Color(0xFF94A3B8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          final rawItems =
                              (item['raw_items'] as List?) ?? [item];
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => HistoryDetailScreen(
                                participantName: participantName,
                                school: school,
                                department: department,
                                currentGoal: currentGoal,
                                testType: testType,
                                createdAt: createdAt,
                                sourceModel: sourceModel,
                                reportText: generatedText,
                                testResults: rawItems
                                    .cast<Map<String, dynamic>>(),
                              ),
                            ),
                          );
                        },
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
