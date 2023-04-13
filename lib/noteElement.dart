import 'package:flutter/material.dart'; // Material Design
import 'package:http/http.dart'; // HTTP Requests
import 'package:m_toast/m_toast.dart'; // Toasts notifications

class Note extends StatefulWidget {
  final String title;
  final String content;
  final String id;
  final String token;
  final Function updateNotes;

  const Note({super.key, required this.title, required this.content, required this.id, required this.token, required this.updateNotes});

  @override
  State<Note> createState() => _NoteState();
}

class _NoteState extends State<Note> {

  void deleteNote () async {
    final response = await delete(Uri.parse('https://private-r.fly.dev/notes/${widget.id}'), headers: {
    'Authorization': 'Bearer ${widget.token}'
  }); // HTTP DELETE request to API for notes

    /// Check if the widget is still mounted to avoid warnings
    if (!mounted) return;

    if (response.statusCode != 200) {
      ShowMToast().errorToast(context, message: "Something went wrong", alignment: Alignment.topCenter);
      return;
    }

    ShowMToast().successToast(context, message: "Note deleted", alignment: Alignment.topCenter);

    widget.updateNotes();

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
        color: Colors.white70,
        border: Border.all(
          color: Colors.red,
          width: 2,
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 2.0),
      child: Column(
        children: [
          Text(widget.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              )),
          const Divider(
            color: Colors.red,
            height: 25,
          ),
          Text(widget.content, textAlign: TextAlign.center),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(onPressed: () => {deleteNote()}, icon: const Icon(Icons.delete)),
              IconButton(onPressed: () => {}, icon: const Icon(Icons.edit))
            ],
          )
        ],
      ),
    );
  }
}
