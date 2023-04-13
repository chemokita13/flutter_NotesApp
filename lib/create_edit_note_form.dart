import 'package:flutter/material.dart';

class NoteForm extends StatefulWidget {
  final Map? note;
  final bool isCreating;

  const NoteForm({super.key, this.note, required this.isCreating});

  @override
  State<NoteForm> createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  // New note variables (or new editState)
  String _title = '';
  String _content = '';
  Map? note;

  @override
  void initState() {
    super.initState();
    // If is not creating, then is editing
    if (!widget.isCreating) {
      // editng note option
      setState(() {
        note = widget.note;
      });
    } else {
      // creating note option
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.isCreating ? 'Create note' : 'Edit note'),
        ),
        body: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Enter your title',
              ),
              initialValue: widget.isCreating ? '' : note!['title'],
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Enter your content',
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () => {}, child: const Icon(Icons.add)));
  }
}
