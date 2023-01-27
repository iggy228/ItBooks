import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:it_book/src/layouts/main_layout.dart';
import 'package:it_book/src/models/book.dart';
import 'package:it_book/src/repositories/it_book_repository.dart';
import 'package:it_book/src/widgets/book_list.dart';

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
    return MainLayout(
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
          const SizedBox(height: 8),
          Builder(builder: (context) {
            if (error != null) {
              return Text(error!);
            }
            if (searchedBooks != null) {
              return Expanded(
                child: BookList(
                  title: 'Results for ${searchFieldController.text}:',
                  books: newBooks,
                  onListItemTap: (index) => context.pushNamed(
                    'bookDetail',
                    params: {
                      'bookIsbn': newBooks[index].isbn13,
                    },
                  ),
                ),
              );
            }
            return Expanded(
              child: BookList(
                title: 'New books for reading: ',
                books: newBooks,
                onListItemTap: (index) => context.pushNamed(
                  'bookDetail',
                  params: {
                    'bookIsbn': newBooks[index].isbn13,
                  },
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
