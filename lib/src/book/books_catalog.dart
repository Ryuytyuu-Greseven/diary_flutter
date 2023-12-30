import 'package:diary/src/api_services/api_service.dart';
import 'package:flutter/material.dart';

class BooksCatalog extends StatefulWidget {
  const BooksCatalog({super.key});

  static const routeName = '/books-catalog';

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //       appBar: AppBar(
  //         title: const Text('Catalog'),
  //       ),
  //       body: Container(
  //           child: ElevatedButton(
  //               onPressed: () {
  //                 Navigator.pushNamed(context, '/login');
  //               },
  //               child: Text('More Information Here'))));
  // }
  @override
  BooksCatalogState createState() => BooksCatalogState();
}

// class BookDiaryMini {
//   String? title;
//   String? year;
//   int? type; // Assuming 1 for Personal Diary and 2 for Story Book
//   Object? bookConfigColor;
//   Object? titleConfigFont;
//   Object? titleConfigColor;

//   BookDiaryMini({
//     this.title,
//     this.year,
//     this.type,
//     this.bookConfigColor,
//     this.titleConfigFont,
//     this.titleConfigColor,
//   });
// }

Widget miniBook(BuildContext context, dynamic singleDiary) {
  // miniBook(context, title);
  final bgColor =
      int.parse('0xFF' + singleDiary['bookConfig']['color'].split('#')[1]);
  final titleColor =
      int.parse('0xFF' + singleDiary['titleConfig']['color'].split('#')[1]);
  final textStyle = TextStyle(
      color: Color(titleColor), fontFamily: singleDiary['titleConfig']['font']);

  return GestureDetector(
      onTap: () {
        // book open logic
      },
      child: Container(
        width: 250,
        height: 320,
        // color: Color.fromARGB(255, 231, 214, 157),
        margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
            color: singleDiary['bookConfig']['color'] != null
                ? Color(bgColor)
                : const Color(0xFFF5DEB3),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 212, 205, 205).withOpacity(0.5),
                spreadRadius: 5, // Spread radius
                blurRadius: 10, // Blur radius
                offset: Offset(8, 12), // Offset
              ),
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(children: [
              Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Color.fromARGB(214, 73, 71, 70),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white, width: 2)),
                    child: Text(
                      singleDiary['type'] == 1 ? 'Personal Book' : 'Story Book',
                      style: TextStyle(
                          color: Colors.white,
                          // fontFamily: Font/*  */,
                          fontSize: 15),
                    ),
                  )),
              Positioned(
                top: -8,
                right: 0,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    singleDiary['year'],
                    style: TextStyle(
                        color: Color(titleColor),
                        fontFamily: singleDiary['titleConfig']['font'],
                        fontSize: 25),
                  ),
                ),
              )
            ]),
            Align(
              alignment: Alignment.center,
              child: Text(
                singleDiary['title'],
                style: TextStyle(
                    color: Color(titleColor),
                    fontFamily: singleDiary['titleConfig']['font'],
                    fontSize: 35),
              ),
            )
            // title tag
          ],
        ),
      ));
}

class BooksCatalogState extends State<BooksCatalog> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  static List selfDiaries = [
    // {'title': 'test book 1'},
    // {'title': 'test book 2'},
  ];

  // api services
  final apiService = ApiService();

  @override
  void initState() {
    super.initState();

    // fetching all the personal diaries
    fetchDairies();
  }

  Future<void> fetchDairies() async {
    final body = {};

    final diariesResponse = await apiService.selfDairies(body);
    print('Self Diaries Response ${diariesResponse['success']}');

    if (diariesResponse != null && diariesResponse['success'] == true) {
      setState(() {
        selfDiaries = diariesResponse['data'];
        print(selfDiaries);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Books'),
        ),
        body: Container(
            // width: 50,
            // margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
            color: Colors.black,
            child: Center(
                child: Container(
              margin: EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: ListView.builder(
                          itemCount: selfDiaries.length,
                          itemBuilder: (context, index) {
                            final singleDiary = selfDiaries[index];
                            return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [miniBook(context, singleDiary)]);
                          })),
                  // Container(
                  //   width: 200,
                  //   color: Colors.yellow,
                  //   child: miniBook(context, {'title': "Yes book"}),
                  // ),
                ],
              ),
            ))));
  }
}

// [
//                 Container(
//                   width: 350,
//                   child: Column(children: [
//                     miniBook(context, 'testing book 1'),
//                     miniBook(context, 'testing book 2'),
//                   ]),
//                 ),
//                 Container(
//                     // width: 50,
//                     child: ListView.builder(
//                   itemCount: 2,
//                   itemBuilder: (context, index) {
//                     final singleDiary = selfDiaries[index];
//                     return miniBook(context, singleDiary.title);
//                   },
//                 )),
//               ],
