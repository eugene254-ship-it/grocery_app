import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ImageSlider extends StatefulWidget {
  const ImageSlider({Key? key}) : super(key: key);

  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int index = 0;
  int dataLength = 0;

  Future<List<QueryDocumentSnapshot>> getSliderImageFromDb() async {
    var _firestore = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await _firestore.collection('slider').get();
    setState(() {
      dataLength = snapshot.docs.length;
    });
    return snapshot.docs;
  }

  @override
  void initState() {
    super.initState();
    getSliderImageFromDb();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (dataLength != 0)
          FutureBuilder<List<QueryDocumentSnapshot>>(
            future: getSliderImageFromDb(),
            builder: (_, snapshot) {
              return snapshot.data == null
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CarouselSlider.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index, realIndex) {
                          DocumentSnapshot sliderImage = snapshot.data![index];
                          Map<String, dynamic> getImage =
                              sliderImage.data() as Map<String, dynamic>;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Image.network(
                              getImage['image'],
                              fit: BoxFit.fill,
                            ),
                          );
                        },
                        options: CarouselOptions(
                          initialPage: 0,
                          autoPlay: true,
                          height: 150,
                          onPageChanged: (int i, carouselPageChangedReason) {
                            setState(() {
                              index = i;
                            });
                          },
                        ),
                      ),
                    );
            },
          ),
        if (dataLength != 0)
          DotsIndicator(
            dotsCount: dataLength,
            position: index.toDouble(),
            decorator: DotsDecorator(
              size: const Size.square(5.0),
              activeSize: const Size(18.0, 5.0),
              activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              activeColor: const Color(0xFF84c225),
            ),
          ),
      ],
    );
  }
}
