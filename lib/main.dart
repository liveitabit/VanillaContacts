import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: "Contacts",
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const HomePage(),
    routes: {
      '/new-contact': (context) => const NewContactView(),
    },
  ));
}

class Contact {
  final String name;
  const Contact({
    required this.name,
  });
}

class ContactBook {
  ContactBook._sharedInstance();
  static final ContactBook _shared = ContactBook._sharedInstance();
  factory ContactBook() => _shared;

  final List<Contact> _contacts = [];

  int get length => _contacts.length;

  Contact? contact({required int atIndex}) =>
      _contacts.length > atIndex ? _contacts[atIndex] : null;

  void addContact({required Contact contact}) {
    _contacts.add(contact);
  }

  void removeContact({required Contact contact}) {
    _contacts.remove(contact);
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    ContactBook contactBook = ContactBook();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.add))],
      ),
      body: ListView.builder(
        itemCount: contactBook.length,
        itemBuilder: (context, index) {
          final Contact? contact = contactBook.contact(atIndex: index);
          final String contactName = contact != null ? contact.name : '';
          return ListTile(
            title: Text(contactName),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).pushNamed('/new-contact');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class NewContactView extends StatefulWidget {
  const NewContactView({super.key});

  @override
  State<NewContactView> createState() => _NewContactViewState();
}

class _NewContactViewState extends State<NewContactView> {
  late final TextEditingController _textEditingController;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Contact'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _textEditingController,
            decoration: const InputDecoration(
              hintText: "Add a new Contact here...",
            ),
          ),
          TextButton(
            onPressed: () {
              final contact = Contact(name: _textEditingController.text);
              ContactBook().addContact(contact: contact);
              Navigator.of(context).pop();
            },
            child: const Text('Add Contact'),
          ),
        ],
      ),
    );
  }
}
