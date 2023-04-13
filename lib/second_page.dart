import 'dart:convert'; // JSON convert
import 'package:flutter/material.dart'; // Material Design
import 'package:flutter_application_1/create_edit_note_form.dart';
import 'package:flutter_application_1/noteElement.dart';
import 'package:http/http.dart'; // HTTP Requests
import 'package:m_toast/m_toast.dart'; // Toasts notifications

class NotesPage extends StatelessWidget {
  final String token;

  const NotesPage({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: Scaffold(
            appBar: AppBar(
              title: const Text('Notes'),
            ),
            body: NotesBodyPage(token: token),
            floatingActionButton: FloatingActionButton(
                onPressed: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const NoteForm(isCreating: true)))
                    },
                child: const Icon(Icons.add))));
  }
}

class NotesBodyPage extends StatefulWidget {
  final String token; // Token variable from main page (api)

  const NotesBodyPage(
      {super.key,
      required this.token}); // Constructor that gets token param from main page

  @override
  State<NotesBodyPage> createState() => _NotesBodyPageState();
}

class _NotesBodyPageState extends State<NotesBodyPage> {
  List notes = []; // List of notes

  fetchAPI() async {
    final response = await get(Uri.parse('https://private-r.fly.dev/notes'),
        headers: {
          'Authorization': 'Bearer ${widget.token}'
        }); // HTTP GET request to API for notes

    /// Check if the widget is still mounted to avoid warnings
    if (!mounted) return;

    if (response.statusCode != 200) {
      ShowMToast().errorToast(context,
          message: "Something went wrong", alignment: Alignment.topCenter);
      Navigator.pop(context);
      return;
    }

    List notesFromApi =
        jsonDecode(response.body); // Decode JSON response string => JSON <List>

    /// Update notes state
    setState(() {
      notes = notesFromApi;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchAPI();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            padding: const EdgeInsets.all(10.0),
            margin: const EdgeInsets.all(10.0),
            child: ListView(
              children: [
                for (var i = 0; i < notes.length; i++) // Map notes to TableRow
                  Note(
                    title: notes[i]['title'],
                    content: notes[i]['content'],
                    id: notes[i]['_id'],
                    token: widget.token,
                    updateNotes: fetchAPI,
                  )
              ],
            )));
  }
}
