import 'dart:ffi';

import 'package:diary/src/book/pages/single_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

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

    int currentPage = 0;

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
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              color: Color(bgColor),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white70, width: 4)),

          // alignment: Alignment.center,
          child: Column(
            children: [
              Expanded(
                  child: SinglePage(
                      pageDetails: singleBookData?['pages'][currentPage])),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    child: const Text('Previous  Page',
                        style: const TextStyle(color: Colors.white)),
                    onPressed: () {
                      if (currentPage > 1) {
                        setState(() {
                          currentPage -= 1;
                        });
                      }

                      print('Loading Previous Page ${currentPage}');
                    },
                  ),
                  Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    child: const Text(
                      'Next Page',
                      style: const TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      setState(() {
                        currentPage += 1;
                      });
                      print('Loading Next page ${currentPage}');
                    },
                  ),
                ],
              )
            ],
          )),
    );
  }
}
