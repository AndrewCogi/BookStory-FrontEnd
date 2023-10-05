import 'package:book_story/utils/book_story_app_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:wtf_sliding_sheet/wtf_sliding_sheet.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text('Simple Example'),
      ),
      body: SlidingSheet(
        elevation: 8,
        cornerRadius: 16,
        snapSpec: const SnapSpec(
          // Enable snapping. This is true by default.
          snap: true,
          // Set custom snapping points.
          snappings: [0.3, 0.7, 1.0],
          // Define to what the snappings relate to. In this case,
          // the total available space that the sheet can expand to.
          positioning: SnapPositioning.relativeToAvailableSpace,
        ),
        // The body widget will be displayed under the SlidingSheet
        // and a parallax effect can be applied to it.
        body: Center(
          child: Swiper(
            autoplay: true,
            itemCount: 1,
            pagination: const SwiperPagination(
              alignment: Alignment.topCenter,
              builder: DotSwiperPaginationBuilder(
                  size: 8,
                  activeSize: 10,
                  color: Colors.grey,
                  activeColor: BookStoryAppTheme.nearlyBlue
              ),
            ),
            duration: 1000,
            autoplayDelay: 5000,
            control: const SwiperControl(
                color: Colors.transparent
            ),
            itemBuilder: (BuildContext context,int index){
              return CachedNetworkImage(
                placeholder: null,
                imageUrl: 'https://d1uuv72cpfayuq.cloudfront.net/books/images/1.png',
                fit: BoxFit.contain,
                errorWidget: (context, url, error) => const Icon(Icons.cancel_outlined),
              );
            },
          ),
        ),
        builder: (context, state) {
          // This is the content of the sheet that will get
          // scrolled, if the content is bigger than the available
          // height of the sheet.
          return Container(
            height: 700,
            child: Center(
              child: Text('This is the content of the sheet'),
            ),
          );
        },
      ),
    );
  }
}