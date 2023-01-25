import 'package:flutter/material.dart';
import 'package:it_book/src/models/book.dart';
import 'package:it_book/src/repositories/it_book_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Book> books = [];

  getBookList() async {
    final result = await ItBookRepository().getBooks('mongodb');

    if (result != null) {
      setState(() {
        books = result;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    getBookList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          const TextField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              icon: Icon(Icons.search),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) =>
                  ListTile(title: Text(books[index].title)),
            ),
          ),
        ],
      ),
    );
  }
}
