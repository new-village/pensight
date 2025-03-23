import 'package:flutter/material.dart';
import '../widgets/ruled_background.dart';

class NoteEditor extends StatelessWidget {
  final TextEditingController controller;
  final double fontSize;
  final ValueChanged<String> onContentChanged;
  const NoteEditor({
    Key? key,
    required this.controller,
    required this.fontSize,
    required this.onContentChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: RuledBackground(
        lineHeight: fontSize * 1.5,
        child: TextField(
          controller: controller,
          key: ValueKey(controller),
          textAlignVertical: TextAlignVertical.top,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter your note here...',
            contentPadding: EdgeInsets.all(8),
          ),
          maxLines: null,
          expands: true,
          style: TextStyle(fontSize: fontSize),
          onChanged: onContentChanged,
        ),
      ),
    );
  }
}
