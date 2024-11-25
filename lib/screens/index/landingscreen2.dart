// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:gap/gap.dart';
// import 'package:ilugan_passenger_mobile_app/screens/authentication/loginscreen.dart';
// import 'package:ilugan_passenger_mobile_app/widgets/widgets.dart';
import 'package:ilugan_passsenger/screens/authentication/loginscreen.dart';
import 'package:ilugan_passsenger/widgets/widgets.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class LandingScreen2 extends StatefulWidget {
  @override
  _LandingScreen2State createState() => _LandingScreen2State();
}

class _LandingScreen2State extends State<LandingScreen2> {
  int activeIndex = 0;
  final _carouselController = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent,
      body: Column(
        children: [
          const Spacer(),
          Center(child: TextContent(name: 'iLugan', fcolor: Colors.white, fontsize: 70,),),

          // Carousel Slider
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: CarouselSlider(
              carouselController: _carouselController,
              options: CarouselOptions(
                height: 390,
                enlargeCenterPage: true,
                autoPlay: true,
                aspectRatio: 16 / 9,
                enableInfiniteScroll: true,
                autoPlayInterval: const Duration(seconds: 6),
                viewportFraction: 0.7,
                onPageChanged: (index, reason) {
                  setState(() {
                    activeIndex = index;
                  });
                },
              ),
              items: [
                _buildCarouselCardWithImage('Welcome to Ilugan',
                  'assets/images/introcardsimages/maps.png',
                    'Find your ride, reserve your seat, and get moving with Ilugan!'),
                _buildCarouselCardWithImage(
                    'Real-time Tracking',
                    'assets/images/introcardsimages/track.png',
                    'Track buses easily in real-time.'),
                _buildCarouselCardWithImage(
                    'Seat Reservation',
                    'assets/images/introcardsimages/reserve.png',
                    'Reserve your seat ahead of time!'),
                _buildCarouselCardWithImage(
                    'Trip History',
                    'assets/images/introcardsimages/history.png',
                    'Review your past trips in detail.'),
                _buildCarouselCardWithImage('Join Us Today!',
                      'assets/images/introcardsimages/people.png',
                    'Get started now and enjoy a smoother ride.'),
              ],
            ),
          ),

          const Gap(15),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: AnimatedSmoothIndicator(
              activeIndex: activeIndex,
              count: 5,
              effect: const ScrollingDotsEffect(
                activeDotColor: Color.fromARGB(255, 32, 32, 32),
                dotHeight: 8,
                dotWidth: 8,
                spacing: 10,
              ),
            ),
          ),

          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => LoginScreen()));
              },
              style: ElevatedButton.styleFrom(
                elevation: 10,
                padding:
                const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                backgroundColor: const Color.fromARGB(255, 230, 230, 33),
                fixedSize: Size(MediaQuery.sizeOf(context).width - 100, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: TextContent(name: 'Get Started',fontsize: 20, fcolor: Colors.black,fontweight: FontWeight.w700,)
            ),
          ),
          const Spacer()
        ],
      ),
    );
  }

 Widget _buildCarouselCardWithImage(
      String title, String imagePath, String description) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           TextContent(name: title, fontsize: 22, fontweight: FontWeight.bold,),
            Image.asset(imagePath, height: 180, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  const Gap(15),
                  TextContent(name: description, fontsize: 15, fontweight: FontWeight.w500,)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
