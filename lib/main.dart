import 'package:flutter/material.dart';

void main() {
  // This ensures the Flutter engine is ready before the app starts
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NotesApp());
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Simple Notes',
      // Using a modern Material 3 theme
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const NotesScreen(),
    );
  }
}

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  // Controller to handle text input
  final TextEditingController _controller = TextEditingController();
  
  // Our "In-Memory" storage (Python: notes = [])
  final List<String> _notes = [];

  // Logic to add a note
  void _addNote() {
    final String text = _controller.text.trim();
    
    if (text.isNotEmpty) {
      // setState is what tells Flutter to refresh the screen
      setState(() {
        _notes.insert(0, text); // Adds new note to the TOP of the list
        _controller.clear();    // Empties the text box
      });
    }
  }

  // Logic to remove a note
  void _deleteNote(int index) {
    setState(() {
      _notes.removeAt(index);
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Good practice: cleans up memory when app closes
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Simple Notes'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Input Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Write a note...',
                      border: OutlineInputBorder(),
                    ),
                    // Allows pressing "Enter" on keyboard to save
                    onSubmitted: (_) => _addNote(),
                  ),
                ),
                const SizedBox(width: 12),
                FloatingActionButton(
                  onPressed: _addNote,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),

          // List Section
          Expanded(
            child: _notes.isEmpty
                ? const Center(
                    child: Text(
                      'No notes yet. Type something above!',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _notes.length,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 1,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          title: Text(_notes[index]),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                            onPressed: () => _deleteNote(index),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}