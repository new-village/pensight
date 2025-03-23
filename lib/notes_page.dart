import 'package:flutter/material.dart';
import 'models/note.dart';
import 'widgets/fab_sub_button.dart';
import 'widgets/management_menu.dart';
import 'widgets/note_list.dart';
import 'widgets/note_editor.dart';

class NotesPage extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleDarkMode;
  const NotesPage({
    super.key,
    required this.isDarkMode,
    required this.onToggleDarkMode,
  });

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final List<Note> _notes = [];
  int? _selectedNoteIndex;
  bool _showSidebar = true;
  bool _isFabExpanded = false;
  double _fontSize = 26;
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateSelectedNoteAfterRemoval(int removedIndex) {
    if (_selectedNoteIndex == removedIndex) {
      _selectedNoteIndex = null;
      _controller.clear();
    } else if (_selectedNoteIndex != null &&
        _selectedNoteIndex! > removedIndex) {
      _selectedNoteIndex = _selectedNoteIndex! - 1;
    }
  }

  void _addNote() {
    setState(() {
      _notes.add(Note(title: 'New Note ${_notes.length + 1}'));
      _selectedNoteIndex = _notes.length - 1;
      _controller.text = _notes.last.content;
    });
  }

  void _renameNote(int index) {
    final controller = TextEditingController(text: _notes[index].title);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('付箋の名前を変更'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: '新しい名前'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _notes[index].title = controller.text;
              });
              Navigator.of(context).pop();
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }

  void _toggleFab() => setState(() => _isFabExpanded = !_isFabExpanded);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (_isFabExpanded) setState(() => _isFabExpanded = false);
        },
        child: Stack(
          children: [
            Row(
              children: [
                if (_showSidebar)
                  NoteList(
                    notes: _notes,
                    onNoteTap: (index) {
                      setState(() {
                        _selectedNoteIndex = index;
                        _controller.text = _notes[index].content;
                      });
                    },
                    onNoteRemove: (index) {
                      setState(() {
                        _notes.removeAt(index);
                        _updateSelectedNoteAfterRemoval(index);
                      });
                    },
                    onNoteRename: _renameNote,
                  ),
                Expanded(
                  child: _selectedNoteIndex != null
                      ? NoteEditor(
                          controller: _controller,
                          fontSize: _fontSize,
                          onContentChanged: (value) {
                            if (_selectedNoteIndex != null) {
                              _notes[_selectedNoteIndex!].content = value;
                            }
                          },
                        )
                      : Center(
                          child: SingleChildScrollView(
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final instructionCardColor =
                                    Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.deepOrange[700]
                                        : Colors.deepOrange[100];
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Peninsight',
                                      style: TextStyle(
                                        fontSize: 48,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepOrange,
                                      ),
                                    ),
                                    const SizedBox(height: 40),
                                    Wrap(
                                      alignment: WrapAlignment.center,
                                      spacing: 16,
                                      runSpacing: 16,
                                      children: [
                                        Card(
                                          margin: const EdgeInsets.all(8),
                                          elevation: 6,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          color: instructionCardColor,
                                          child: const Padding(
                                            padding: EdgeInsets.all(
                                              20.0,
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  'ページを作ってみよう',
                                                  style: TextStyle(
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                SizedBox(height: 12),
                                                Text(
                                                  '画面右下のメニューをクリックし、「ページの追加」から新しいページを作成できます。',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Card(
                                          margin: const EdgeInsets.all(8),
                                          elevation: 6,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          color: instructionCardColor,
                                          child: const Padding(
                                            padding: EdgeInsets.all(
                                              20.0,
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  '設定をカスタマイズ',
                                                  style: TextStyle(
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                SizedBox(height: 12),
                                                Text(
                                                  '管理画面でダークモードやフォントサイズを調整できます。',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Card(
                                          margin: const EdgeInsets.all(8),
                                          elevation: 6,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          color: instructionCardColor,
                                          child: const Padding(
                                            padding: EdgeInsets.all(
                                              20.0,
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  '操作方法を覚えよう',
                                                  style: TextStyle(
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                SizedBox(height: 12),
                                                Text(
                                                  '長押しで付箋名を変更、左スワイプで付箋を削除できます。',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: Stack(
        children: [
          if (_isFabExpanded)
            Positioned.fill(
              child: GestureDetector(
                onTap: _toggleFab,
                behavior: HitTestBehavior.translucent,
                child: Container(color: Colors.transparent),
              ),
            ),
          Align(
            alignment: Alignment.bottomRight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (_isFabExpanded) ...[
                  FabSubButton(
                    icon: Icons.note_add,
                    label: 'ページの追加',
                    onPressed: () {
                      _addNote();
                      _toggleFab();
                    },
                  ),
                  const SizedBox(height: 8),
                  FabSubButton(
                    icon: Icons.settings,
                    label: '管理画面の追加',
                    onPressed: () {
                      showManagementMenu(
                          context, widget.isDarkMode, widget.onToggleDarkMode,
                          (value) {
                        setState(() => _fontSize = value);
                      });
                      _toggleFab();
                    },
                  ),
                  const SizedBox(height: 8),
                ],
                FloatingActionButton(
                  onPressed: () {
                    if (_isFabExpanded) {
                      setState(() {
                        _showSidebar = !_showSidebar;
                        _isFabExpanded = false;
                      });
                    } else {
                      _toggleFab();
                    }
                  },
                  child: Icon(_isFabExpanded ? Icons.view_list : Icons.menu),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
