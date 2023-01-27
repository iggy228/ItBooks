import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:it_book/src/layouts/main_layout.dart';
import 'package:it_book/src/models/book_detail.dart';
import 'package:it_book/src/repositories/it_book_repository.dart';

class BookDetailScreen extends StatefulWidget {
  final String? isbn;

  const BookDetailScreen({Key? key, this.isbn}) : super(key: key);

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  String? error;
  BookDetail? book;

  void getBook() async {
    setState(() {
      error = null;
    });

    if (widget.isbn == null) {
      context.goNamed('home');
      return;
    }

    try {
      final result = await ItBookRepository().getBookByIsbn(widget.isbn!);

      setState(() {
        book = result;
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

    getBook();
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Builder(builder: (context) {
        if (error != null) {
          return Text(error!);
        }
        if (book != null) {
          return ListView(
            children: <Widget>[
              Image.network(book!.image),
              const SizedBox(height: 16),
              Text(
                book!.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                book!.subtitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 24),
              Text(book!.desc),
              const SizedBox(height: 16),
              Text(book!.price,
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {},
                child: Text('Buy on this page'),
              ),
            ],
          );
        }
        return const SizedBox.expand();
      }),
    );
  }
}
