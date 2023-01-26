import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:it_book/src/models/book.dart';
import 'package:it_book/src/repositories/it_book_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final searchFieldController = TextEditingController();

  List<Book> newBooks = [];
  List<Book>? searchedBooks;
  String? error;

  void getBookList() async {
    try {
      final result = await ItBookRepository().getNewBooks();

      setState(() {
        newBooks = result;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    }
  }

  void searchBooks() async {
    setState(() {
      error = null;
    });

    try {
      final result =
          await ItBookRepository().searchBooks(searchFieldController.text);

      setState(() {
        searchedBooks = result;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    }
  }

  @override
  void initState() {
    super.initState();

    getBookList();
  }

  @override
  void dispose() {
    searchFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: searchFieldController,
              onSubmitted: (_) => searchBooks(),
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => searchBooks(),
                ),
              ),
            ),
            Builder(builder: (context) {
              if (error != null) {
                return Text(error!);
              }
              if (searchedBooks != null) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: searchedBooks!.length,
                    itemBuilder: (context, index) => ListTile(
                      onTap: () => context.pushNamed('bookDetail', params: {
                        'bookIsbn': searchedBooks![index].isbn13,
                      }),
                      title: Text(searchedBooks![index].title),
                      subtitle: Text(searchedBooks![index].subtitle),
                    ),
                  ),
                );
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: newBooks.length,
                  itemBuilder: (context, index) => ListTile(
                    onTap: () => context.pushNamed('bookDetail', params: {
                      'bookIsbn': newBooks[index].isbn13,
                    }),
                    title: Text(newBooks[index].title),
                    subtitle: Text(newBooks[index].subtitle),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
