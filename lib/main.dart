import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;
  void _toggleDarkMode() => setState(() => _isDarkMode = !_isDarkMode);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Peninsight',
      theme: _isDarkMode
          ? ThemeData.dark().copyWith(
              primaryColor: Colors.deepOrange,
              colorScheme: ColorScheme.dark(primary: Colors.deepOrange),
            )
          : ThemeData(
              primarySwatch: Colors.deepOrange,
              brightness: Brightness.light,
            ),
      home: NotesPage(
        isDarkMode: _isDarkMode,
        onToggleDarkMode: _toggleDarkMode,
      ),
    );
  }
}

// 追加: Noteクラスを定義（付箋名とメモを分離して管理）
class Note {
  String title;
  String content;
  Note({required this.title, this.content = ''});
}

class NotesPage extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleDarkMode;
  const NotesPage(
      {super.key, required this.isDarkMode, required this.onToggleDarkMode});
  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  // 変更: _notes の型を List<Note> に変更
  final List<Note> _notes = [];
  int? _selectedNoteIndex;
  bool _showSidebar = true;
  bool _isFabExpanded = false;
  double _fontSize = 26; // 初期フォントサイズ
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // 付箋削除後の選択インデックス更新用ユーティリティ
  void _updateSelectedNoteAfterRemoval(int removedIndex) {
    if (_selectedNoteIndex == removedIndex) {
      _selectedNoteIndex = null;
      _controller.clear();
    } else if (_selectedNoteIndex != null &&
        _selectedNoteIndex! > removedIndex) {
      _selectedNoteIndex = _selectedNoteIndex! - 1;
    }
  }

  // 変更: _addNote は新規のNoteオブジェクトを追加する
  void _addNote() {
    setState(() {
      _notes.add(Note(title: 'New Note ${_notes.length + 1}'));
      _selectedNoteIndex = _notes.length - 1;
      _controller.text = _notes.last.content;
    });
  }

  void _showManagementMenu() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('管理メニュー'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text('ダークモード'),
              trailing: Switch(
                value: widget.isDarkMode,
                onChanged: (value) {
                  widget.onToggleDarkMode();
                  Navigator.of(context).pop();
                },
              ),
            ),
            // フォントサイズ調整スライダー
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  const Text('フォントサイズ:'),
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        showValueIndicator: ShowValueIndicator.always,
                      ),
                      child: Slider(
                        min: 12,
                        max: 30,
                        divisions: 18,
                        value: _fontSize,
                        label: _fontSize.toStringAsFixed(0),
                        onChanged: (value) {
                          setState(() {
                            _fontSize = value;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 変更: _renameNote は付箋名 (title) のみ変更する
  void _renameNote(int index) {
    final controller = TextEditingController(text: _notes[index].title);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('付箋の名前を変更'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: '新しい名前',
          ),
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

  Widget _buildSubButton(
      {required IconData icon,
      required String label,
      required VoidCallback onPressed}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[800] : Colors.white,
            borderRadius: BorderRadius.circular(4),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
          ),
          child: Text(label,
              style: TextStyle(
                  fontSize: 12, color: isDark ? Colors.white : Colors.black)),
        ),
        FloatingActionButton.small(onPressed: onPressed, child: Icon(icon)),
      ],
    );
  }

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
                  Container(
                    width: 250,
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      border: Border(
                          right: BorderSide(
                              color: Theme.of(context).dividerColor)),
                    ),
                    child: ListView.builder(
                      itemCount: _notes.length,
                      itemBuilder: (context, index) {
                        final cardColor = Theme.of(context).brightness ==
                                Brightness.dark
                            ? Colors
                                .deepOrange[700] // 変更: ダークモード時はテーマカラーに合わせた暗めの色
                            : Colors
                                .deepOrange[100]; // 変更: ライトモード時はテーマカラーに合わせた明るい色
                        return Dismissible(
                          key: ValueKey(_notes[index].title),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            child:
                                const Icon(Icons.delete, color: Colors.white),
                          ),
                          onDismissed: (direction) {
                            setState(() {
                              _notes.removeAt(index);
                              _updateSelectedNoteAfterRemoval(index);
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: double.infinity, // 付箋の幅を親の幅に合わせる
                              child: Transform.rotate(
                                angle: -0.02,
                                child: Card(
                                  color: cardColor,
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: InkWell(
                                    onTap: () => setState(() {
                                      _selectedNoteIndex = index;
                                      _controller.text = _notes[index].content;
                                    }),
                                    onLongPress: () => _renameNote(index),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Text(
                                        _notes[index].title,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight:
                                              _selectedNoteIndex == index
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                Expanded(
                  child: _selectedNoteIndex != null
                      ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: RuledBackground(
                            lineHeight: _fontSize * 1.5,
                            child: TextField(
                              controller: _controller,
                              key: ValueKey(_selectedNoteIndex),
                              textAlignVertical: TextAlignVertical.top,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter your note here...',
                                contentPadding: EdgeInsets.all(8),
                              ),
                              maxLines: null,
                              expands: true,
                              style: TextStyle(fontSize: _fontSize),
                              onChanged: (value) {
                                if (_selectedNoteIndex != null) {
                                  _notes[_selectedNoteIndex!].content = value;
                                }
                              },
                            ),
                          ),
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
                                    Text(
                                      'Peninsight',
                                      style: TextStyle(
                                        fontSize: 48,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepOrange,
                                      ),
                                    ),
                                    const SizedBox(height: 40),
                                    // Use Wrap so that cards automatically wrap when screen is narrow
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
                                                  BorderRadius.circular(16)),
                                          color: instructionCardColor,
                                          child: Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: const [
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
                                                  style:
                                                      TextStyle(fontSize: 18),
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
                                                  BorderRadius.circular(16)),
                                          color: instructionCardColor,
                                          child: Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: const [
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
                                                  style:
                                                      TextStyle(fontSize: 18),
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
                                                  BorderRadius.circular(16)),
                                          color: instructionCardColor,
                                          child: Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: const [
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
                                                  style:
                                                      TextStyle(fontSize: 18),
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
                  _buildSubButton(
                    icon: Icons.note_add,
                    label: 'ページの追加',
                    onPressed: () {
                      _addNote();
                      _toggleFab();
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildSubButton(
                    icon: Icons.settings,
                    label: '管理画面の追加',
                    onPressed: () {
                      _showManagementMenu();
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
                  child: Icon(_isFabExpanded ? Icons.view_sidebar : Icons.menu),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RuledBackground extends StatelessWidget {
  final double lineHeight;
  final Widget child;
  const RuledBackground(
      {super.key, required this.lineHeight, required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _RuledPainter(lineHeight), child: child);
  }
}

class _RuledPainter extends CustomPainter {
  final double lineHeight;
  _RuledPainter(this.lineHeight);

  @override
  void paint(Canvas canvas, Size size) {
    const double topPadding = 8; // TextFieldのcontentPadding.top と合わせる
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 1;
    for (double y = topPadding + lineHeight; y < size.height; y += lineHeight) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
