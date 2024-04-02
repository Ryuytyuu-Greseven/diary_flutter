import 'package:flutter/material.dart';

import 'package:flutter_html/flutter_html.dart';

class SinglePage extends StatelessWidget {
  final dynamic pageDetails;
  const SinglePage({required this.pageDetails});

  @override
  Widget build(BuildContext context) {
    print('Page Details ${pageDetails}');

    // return Text(pageDetails?['text']);

    // var document =
    //     parse('<body>Hello world! <a href="www.html5rocks.com">HTML5 rocks!');
    // print(document.outerHtml);
    // data: '<div>This is a div element.</div>',

    var html = Html(
      data: pageDetails?['text'],

      style: {'div': Style(margin: Margins.only(left: 0, top: 1.0))},
      // shrinkWrap: true,
    );

    // return Text('Loading soon...');
    return html;
  }
}
