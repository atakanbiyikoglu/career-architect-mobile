enum MessageRole { user, ai }

class Message {
  const Message({
    required this.role,
    required this.content,
    this.isMarkdown = false,
  });

  final MessageRole role;
  final String content;
  final bool isMarkdown;
}
