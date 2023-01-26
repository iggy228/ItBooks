import 'package:dio/dio.dart';
import 'package:it_book/src/models/book.dart';
import 'package:it_book/src/models/book_detail.dart';

class ItBookRepository {
  final baseUrl = 'https://api.itbook.store/1.0/';

  Future<List<Book>> searchBooks(String search) async {
    try {
      final Response<Map<String, dynamic>> response =
          await Dio().get('$baseUrl/search/$search');
      return response.data?['books']
          .map<Book>((element) => Book.fromMap(element))
          .toList();
    } on DioError {
      rethrow;
    }
  }

  Future<List<Book>> getNewBooks() async {
    try {
      final Response<Map<String, dynamic>> response =
          await Dio().get('$baseUrl/new');
      return response.data?['books']
          .map<Book>((element) => Book.fromMap(element))
          .toList();
    } on DioError {
      rethrow;
    }
  }

  Future<BookDetail> getBookByIsbn(String isbn) async {
    try {
      final Response<Map<String, dynamic>> response =
          await Dio().get('$baseUrl/books/$isbn');
      return BookDetail.fromMap(response.data!);
    } on DioError {
      rethrow;
    }
  }
}
