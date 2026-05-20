import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../models/message.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.message,
    this.showOptions = false,
    this.onYes,
    this.onNo,
    this.yesLabel,
    this.noLabel,
    this.showRating = false,
    this.onRating,
    this.onExportPdf,
    this.onShowPrompt,
  });

  final Message message;
  final bool showOptions;
  final VoidCallback? onYes;
  final VoidCallback? onNo;
  final String? yesLabel;
  final String? noLabel;
  final bool showRating;
  final ValueChanged<int>? onRating;
  final VoidCallback? onExportPdf;
  final VoidCallback? onShowPrompt;

  bool get _isUser => message.role == MessageRole.user;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isNarrow = width < 600;
    final userMaxWidth = width * (isNarrow ? 0.90 : 0.78);
    final aiMaxWidth = width * (isNarrow ? 0.86 : 0.68);
    final aiPadding = isNarrow
        ? const EdgeInsets.only(left: 14, right: 10)
        : const EdgeInsets.only(left: 28, right: 20);
    final bubbleColor = _isUser
        ? const Color(0xFF1A1A2E)
        : const Color(0xFFF4F4F9);
    final textColor = _isUser ? Colors.white : const Color(0xFF1A1A2E);
    final borderRadius = BorderRadius.only(
      topLeft: const Radius.circular(15),
      topRight: const Radius.circular(15),
      bottomLeft: Radius.circular(_isUser ? 15 : 0),
      bottomRight: Radius.circular(_isUser ? 0 : 15),
    );

    final content = message.isMarkdown
        ? MarkdownBody(
            data: message.content,
            styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                .copyWith(
                  p: TextStyle(color: textColor, fontSize: 15.5, height: 1.45),
                ),
          )
        : Text(
            message.content,
            style: TextStyle(color: textColor, height: 1.45, fontSize: 15.5),
          );

    final bubble = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bubbleColor,
        borderRadius: borderRadius,
        boxShadow: _isUser
            ? [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ]
            : [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.04),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
      ),
      child: content,
    );

    final bubbleRow = _isUser
        ? Align(
            alignment: Alignment.centerRight,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: userMaxWidth),
              child: bubble,
            ),
          )
        : Padding(
            padding: aiPadding,
            child: SizedBox(
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12, top: 2),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset(
                        'assets/logo.png',
                        width: 28,
                        height: 28,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: aiMaxWidth),
                        child: bubble,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );

    return Column(
      crossAxisAlignment: _isUser
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        bubbleRow,
        if (showOptions)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              children: [
                OutlinedButton(
                  onPressed: onYes,
                  style: OutlinedButton.styleFrom(
                    shape: const StadiumBorder(),
                    side: const BorderSide(color: Color(0xFF22C55E)),
                    foregroundColor: const Color(0xFF22C55E),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                  ),
                  child: Text(yesLabel ?? 'Evet, katılıyorum'),
                ),
                const SizedBox(width: 10),
                OutlinedButton(
                  onPressed: onNo,
                  style: OutlinedButton.styleFrom(
                    shape: const StadiumBorder(),
                    side: const BorderSide(color: Color(0xFFEF4444)),
                    foregroundColor: const Color(0xFFEF4444),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                  ),
                  child: Text(noLabel ?? 'Hayır, katılmıyorum'),
                ),
              ],
            ),
          ),
        if (showRating)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Wrap(
              spacing: 8,
              children: List.generate(5, (index) {
                final score = index + 1;
                return OutlinedButton.icon(
                  onPressed: () => onRating?.call(score),
                  icon: const Icon(Icons.star, color: Colors.amber, size: 16),
                  label: Text('$score'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(40, 36),
                    visualDensity: VisualDensity.compact,
                    shape: const StadiumBorder(),
                    side: const BorderSide(color: Color(0xFF1A1A2E)),
                    foregroundColor: const Color(0xFF1A1A2E),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                  ),
                );
              }),
            ),
          ),
        if (showRating && (onExportPdf != null || onShowPrompt != null))
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Wrap(
              spacing: 10,
              runSpacing: 8,
              children: [
                if (onExportPdf != null)
                  Tooltip(
                    message: 'PDF indir ve paylaş',
                    child: Semantics(
                      button: true,
                      label: 'PDF indir ve paylaş',
                      child: ElevatedButton.icon(
                        onPressed: onExportPdf,
                        icon: const Icon(Icons.picture_as_pdf_outlined),
                        label: const Text('PDF İndir'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A1A2E),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          shape: const StadiumBorder(),
                        ),
                      ),
                    ),
                  ),
                if (onShowPrompt != null)
                  Tooltip(
                    message: 'Kullanılan promptu göster ve panoya kopyala',
                    child: Semantics(
                      button: true,
                      label: 'Promptu göster',
                      child: OutlinedButton.icon(
                        onPressed: onShowPrompt,
                        icon: const Icon(Icons.code),
                        label: const Text('Promptu Göster'),
                        style: OutlinedButton.styleFrom(
                          shape: const StadiumBorder(),
                          side: const BorderSide(color: Color(0xFF1A1A2E)),
                          foregroundColor: const Color(0xFF1A1A2E),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
