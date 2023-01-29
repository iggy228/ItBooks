import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:it_book/generated/l10n.dart';
import 'package:it_book/src/layouts/main_layout.dart';
import 'package:it_book/src/models/book.dart';
import 'package:it_book/src/repositories/it_book_repository.dart';
import 'package:it_book/src/widgets/book_list.dart';
import 'package:it_book/src/widgets/paged_book_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _pageSize = 10;
  final searchFieldController = TextEditingController();
  final pagingController = PagingController<int, Book>(firstPageKey: 1);

  List<Book> newBooks = [];
  String? error;

  @override
  void initState() {
    super.initState();
    pagingController.addPageRequestListener((pageKey) {
      fetchSearchedBooks(pageKey);
    });
    getBookList();
  }

  @override
  void dispose() {
    searchFieldController.dispose();
    pagingController.dispose();
    super.dispose();
  }

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

  void fetchSearchedBooks(int page) async {
    try {
      final newResult = await ItBookRepository()
          .searchBooks(searchFieldController.text, page);

      final isLastPage = newResult.books.length < _pageSize;
      if (isLastPage) {
        pagingController.appendLastPage(newResult.books);
      } else {
        final nextPage = page + 1;
        pagingController.appendPage(newResult.books, nextPage);
      }
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    }
  }

  void updatedSearchTerm() {
    pagingController.refresh();

    setState(() {
      error = null;
    });
    if (searchFieldController.text.isNotEmpty) {
      fetchSearchedBooks(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Column(
        children: <Widget>[
          TextField(
            controller: searchFieldController,
            onSubmitted: (_) => updatedSearchTerm(),
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () => updatedSearchTerm(),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Builder(builder: (context) {
            if (error != null) {
              return Text(error!);
            }
            if (searchFieldController.text.isNotEmpty) {
              return Expanded(
                child: PagedBookList(
                  controller: pagingController,
                  title: S
                      .of(context)
                      .searchBookResult(searchFieldController.text),
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
                title: S.of(context).newBooksForReading,
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
