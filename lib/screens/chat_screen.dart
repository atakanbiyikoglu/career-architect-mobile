import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/message.dart';
import '../providers/chat_provider.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/custom_drawer.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    _controller.clear();
    final notifier = ref.read(chatProvider.notifier);
    await notifier.handleUserInput(text);
    _scrollToBottom();
    _focusNode.requestFocus();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 120,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatProvider);
    final isTyping = ref.watch(chatTypingProvider);
    final notifier = ref.read(chatProvider.notifier);
    final isTesting =
        notifier.flowState == 'TESTING' || notifier.flowState == 'TEST_INTRO';
    final isFeedback = notifier.flowState == 'FEEDBACK';
    final isAiUnlock = notifier.flowState == 'AI_UNLOCK';
    final isInputDisabled = isTesting || isAiUnlock;

    if (messages.isNotEmpty) _scrollToBottom();

    final isWide = MediaQuery.of(context).size.width > 800;
    final appBarBackground = Colors.white;
    final appBarForeground = const Color(0xFF0F172A);

    Widget chatContent = Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 850),
        child: _ChatBody(
          scrollController: _scrollController,
          messages: messages,
          isTyping: isTyping,
          isTesting: isTesting,
          isAiUnlock: isAiUnlock,
          isFeedback: isFeedback,
          isInputDisabled: isInputDisabled,
          notifier: notifier,
          controller: _controller,
          focusNode: _focusNode,
          onSend: _sendMessage,
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: isWide
          ? null
          : AppBar(
              backgroundColor: appBarBackground,
              foregroundColor: appBarForeground,
              elevation: 1,
              toolbarHeight: 60,
              automaticallyImplyLeading: false,
              leading: Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
              title: const Text(
                'Kariyer Mimarı AI - Analiz Ekranı',
                style: TextStyle(color: Color(0xFF0F172A), fontSize: 16),
              ),
            ),
      drawer: const CustomDrawer(),
      drawerScrimColor: const Color(0x331A1A2E),
      drawerEnableOpenDragGesture: !isWide,
      body: isWide
          ? Row(
              children: [
                const SizedBox(width: 260, child: CustomDrawer()),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        height: 60,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            bottom: BorderSide(color: Colors.grey.shade200),
                          ),
                        ),
                        child: const Text(
                          'Kariyer Mimarı AI - Analiz Ekranı',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ),
                      Expanded(child: chatContent),
                    ],
                  ),
                ),
              ],
            )
          : chatContent,
    );
  }
}

class _ChatBody extends StatelessWidget {
  const _ChatBody({
    required this.scrollController,
    required this.messages,
    required this.isTyping,
    required this.isTesting,
    required this.isAiUnlock,
    required this.isFeedback,
    required this.isInputDisabled,
    required this.notifier,
    required this.controller,
    required this.focusNode,
    required this.onSend,
  });

  final ScrollController scrollController;
  final List<Message> messages;
  final bool isTyping;
  final bool isTesting;
  final bool isAiUnlock;
  final bool isFeedback;
  final bool isInputDisabled;
  final ChatNotifier notifier;
  final TextEditingController controller;
  final FocusNode focusNode;
  final Future<void> Function() onSend;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            itemCount: messages.length + (isTyping ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= messages.length) {
                return isTyping
                    ? const _TypingIndicator()
                    : const SizedBox.shrink();
              }

              final message = messages[index];
              final isLast = index == messages.length - 1;
              final isQuestion =
                  message.role == MessageRole.ai &&
                  message.content.startsWith('Soru ');
              final isTestOptions = isTesting && isLast && isQuestion;
              final isUnlockOptions =
                  isAiUnlock && isLast && message.role == MessageRole.ai;
              final showOptions = isTestOptions || isUnlockOptions;
              final showRating =
                  isFeedback && isLast && message.role == MessageRole.ai;

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: ChatBubble(
                  message: message,
                  showOptions: showOptions,
                  onYes: () => isUnlockOptions
                      ? notifier.handleAiUnlockChoice(true)
                      : notifier.submitAnswer(true),
                  onNo: () => isUnlockOptions
                      ? notifier.handleAiUnlockChoice(false)
                      : notifier.submitAnswer(false),
                  yesLabel: isUnlockOptions
                      ? 'Evet, AI analizini görmek istiyorum'
                      : null,
                  noLabel: isUnlockOptions ? 'Hayır, devam et' : null,
                  showRating: showRating,
                  onRating: notifier.submitFeedback,
                ),
              );
            },
          ),
        ),
        SafeArea(
          top: false,
          child: Container(
            decoration: const BoxDecoration(color: Color(0xFFF8FAFC)),
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                    enabled: !isInputDisabled,
                    minLines: 1,
                    maxLines: 4,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => onSend(),
                    decoration: InputDecoration(
                      hintText: 'Mesajını yaz...',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: const Color(0xFFE6E9EF)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: const Color(0xFFE6E9EF)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 112,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: onSend,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1D4ED8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                    ),
                    child: const Text(
                      'Gönder',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFE9ECF5),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.05),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Text('Analiz ediliyor...'),
        ),
      ],
    );
  }
}
