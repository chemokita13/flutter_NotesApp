import 'package:flutter/material.dart'; // Material Design
import 'package:flutter_application_1/second_page.dart'; // Second page
import 'package:http/http.dart'; // HTTP Requests
import 'package:m_toast/m_toast.dart'; // Toasts notifications
import 'dart:convert'; // JSON convert

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Notes app',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MainPage(title: 'Flutter Notes app'),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});

  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  ShowMToast toast = ShowMToast(); // Toasts notifications instance

  final GlobalKey<FormState> _nameKey = GlobalKey<FormState>(); // Form Key

  // name and password variables
  String _name = '';
  String _password = '';

  // token variable
  String _token = '';

  fetchAPI() async {
    final response = await post(Uri.parse('https://private-r.fly.dev/auth'),
        body: {
          'username': _name,
          'password': _password
        }); // HTTP POST request to API for login and token

    /// Check if the widget is still mounted to avoid warnings
    if (!mounted) return;

    if (response.statusCode != 201) {
      toast.errorToast(context,
          message: "Something went wrong", alignment: Alignment.topCenter);
      return;
    }

    _token = jsonDecode(
        response.body)["access_token"]; // Get token from response body<String>

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NotesPage(
                token: _token))); // Navigate to second page (main Notes page)

    toast.successToast(context,
        message: "All went good",
        alignment: Alignment.topCenter); // Show success toast

    return;
  }

  void _changeNameForm(String value) {
    setState(() {
      _name = value;
    });
  }

  void _changePasswordForm(String value) {
    setState(() {
      _password = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
            child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text("Login"),
              TextFormField(
                key: _nameKey,
                decoration: const InputDecoration(
                  hintText: 'Enter your name',
                ),
                onChanged: (value) => _changeNameForm(value),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter your password',
                ),
                onChanged: (value) => _changePasswordForm(value),
              ),
            ],
          ),
        )),
        floatingActionButton: FloatingActionButton(
            onPressed: fetchAPI, child: const Icon(Icons.arrow_forward))
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
