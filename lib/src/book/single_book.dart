import 'package:flutter/material.dart';

class SingleBook extends StatefulWidget {
  final String bookId;
  final BuildContext globalContext;

  const SingleBook(
      {Key? key, required this.bookId, required this.globalContext})
      : super(key: key);

  @override
  SingleBookState createState() => SingleBookState();
}

class SingleBookState extends State<SingleBook> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('some book name')),
      body: Container(
        alignment: Alignment.center,
        child: Text('Book Part'),
      ),
    );
  }
}
