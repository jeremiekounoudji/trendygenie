import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';

class CarouselWithDots extends StatefulWidget {
  final List<String> imgList;
  final double height;
  final bool autoPlay;
  final Duration autoPlayInterval;
  final Duration autoPlayAnimationDuration;

  const CarouselWithDots({
    super.key,
    required this.imgList,
    this.height = 200.0,
    this.autoPlay = true,
    this.autoPlayInterval = const Duration(seconds: 3),
    this.autoPlayAnimationDuration = const Duration(milliseconds: 800),
  });

  @override
  State<CarouselWithDots> createState() => _CarouselWithDotsState();
}

class _CarouselWithDotsState extends State<CarouselWithDots> {
  int _current = 0;
  late CarouselSliderController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CarouselSliderController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          items: widget.imgList.map((item) => ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            child: Image.network(
              item,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          )).toList(),
          carouselController: _controller,
          options: CarouselOptions(
            height: widget.height,
            viewportFraction: 1.0,
            enlargeCenterPage: false,
            autoPlay: widget.autoPlay,
            autoPlayInterval: widget.autoPlayInterval,
            autoPlayAnimationDuration: widget.autoPlayAnimationDuration,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
        ),
        const SizedBox(height: 12),
        DotsIndicator(
          dotsCount: widget.imgList.length,
          position: _current.toDouble(),
          decorator: DotsDecorator(
            size: const Size.square(8.0),
            activeSize: const Size(20.0, 8.0),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        ),
      ],
    );
  }
} 