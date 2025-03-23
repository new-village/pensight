import 'package:flutter/material.dart';
import '../models/note.dart';

class NoteList extends StatelessWidget {
  final List<Note> notes;
  final ValueChanged<int> onNoteTap;
  final ValueChanged<int> onNoteRemove;
  final ValueChanged<int> onNoteRename;

  const NoteList({
    Key? key,
    required this.notes,
    required this.onNoteTap,
    required this.onNoteRemove,
    required this.onNoteRename,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          right: BorderSide(
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      child: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final cardColor = Theme.of(context).brightness == Brightness.dark
              ? Colors.deepOrange[700]
              : Colors.deepOrange[100];
          return Dismissible(
            key: ValueKey(notes[index].id),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            onDismissed: (direction) => onNoteRemove(index),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: Transform.rotate(
                  angle: -0.02,
                  child: Card(
                    color: cardColor,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: InkWell(
                      onTap: () => onNoteTap(index),
                      onLongPress: () => onNoteRename(index),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          notes[index].title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
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
    );
  }
}
