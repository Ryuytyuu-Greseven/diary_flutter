import 'package:diary/src/book/pages/single_page.dart';
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
    final singleBookData =
        ModalRoute.of(context)!.settings.arguments as dynamic;

    final bgColor =
        int.parse('0xFF' + singleBookData['bookConfig']['color'].split('#')[1]);
    final titleColor = int.parse(
        '0xFF' + singleBookData['titleConfig']['color'].split('#')[1]);
    final textStyle = TextStyle(
        color: Color(titleColor),
        fontFamily: singleBookData['titleConfig']['font']);

    print('Selected Book ${singleBookData['pages'][0]}');
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   icon: Icons.arrow_back,
        //   color: Colors.white,
        //   onPressed: () => {},
        // ),
        title: Text(singleBookData['title']),
        backgroundColor: Colors.black,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 25),
      ),
      body: Container(
        color: Color(bgColor),
        alignment: Alignment.center,
        child: SinglePage(pageDetails: singleBookData?['pages'][0])
      ),
    );
  }
}
