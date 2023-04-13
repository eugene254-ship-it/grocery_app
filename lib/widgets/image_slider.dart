import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ImageSlider extends StatefulWidget {
  const ImageSlider({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int index = 0;

  Future<List<QueryDocumentSnapshot>> getSliderImageFromDb() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('slider').get();
      return snapshot.docs;
    } catch (e) {
      throw Exception('Error fetching slider images: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder<List<QueryDocumentSnapshot>>(
          future: getSliderImageFromDb(),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Error loading slider images'),
              );
            } else {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: CarouselSlider.builder(
                      itemCount: snapshot.data?.length ?? 0,
                      itemBuilder: (context, index, realIndex) {
                        QueryDocumentSnapshot sliderImage =
                            snapshot.data![index];
                        Map<String, dynamic> getImage =
                            sliderImage.data() as Map<String, dynamic>;
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Image.network(
                            getImage['image'],
                            fit: BoxFit.fill,
                          ),
                        );
                      },
                      options: CarouselOptions(
                        viewportFraction: 1,
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
                  ),
                  DotsIndicator(
                    dotsCount: snapshot.data?.length ?? 0,
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
          },
        ),
      ],
    );
  }
}
