import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart';

class SinglePage extends StatelessWidget {
  final dynamic pageDetails;
  const SinglePage({required this.pageDetails});

  @override
  Widget build(BuildContext context) {
    print('Page Details ${pageDetails}');

    // return Text(pageDetails?['text']);
    return Text('Loading soon...');
  }
}
