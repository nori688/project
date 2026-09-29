import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_dorm/components/information_card.dart';
import 'package:my_dorm/constant/constant.dart';
import 'package:my_dorm/models/information_model.dart';

class HomeCarousel extends StatefulWidget {
  const HomeCarousel({super.key});

  @override
  State<HomeCarousel> createState() => _HomeCarouselState();
}

class _HomeCarouselState extends State<HomeCarousel> {
  int _selectedIndex = 0;
  PageController pageController =
      PageController(initialPage: 99, viewportFraction: 0.8);
  List<InformationModel> informations = [
    InformationModel('Слив воды', '11 ноября 2023', kGradientBlue),
    InformationModel('Приветственная вечеринка', '12 декабря 2023', kGradientGreen),
    InformationModel('Встреча', '26 декабря 2023', kGradientOrange),
  ];
  Timer? _carouselTimer; // Menyimpan referensi ke Timer

  void setInterval() {
    Duration periodic = const Duration(seconds: 6);
    _carouselTimer = Timer.periodic(periodic, (intervalTime) {
      pageController.nextPage(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutQuint);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setInterval();
  }

  @override
  void dispose() {
    // Membatalkan timer saat widget dihapus
    _carouselTimer?.cancel();
    pageController.dispose(); // Dispose controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //carousel
        SizedBox(
          height: 200,
          child: PageView.builder(
              controller: pageController,
              onPageChanged: (index) {
                setState(() {
                  _selectedIndex = index % informations.length;
                });
                print(_selectedIndex);
              },
              itemBuilder: (context, index) {
                return Padding(
                    padding: const EdgeInsets.all(10),
                    child: InformationCard(
                        gradient:
                            informations[index % informations.length].gradient,
                        title: informations[index % informations.length].title,
                        tanggal:
                            informations[index % informations.length].tanggal));
              }),
        ),
        const SizedBox(
          height: 10,
        ),
        //indicator
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              informations.length,
              (index) => AnimatedContainer(
                margin: const EdgeInsets.only(right: 6),
                height: 5,
                width: (index == _selectedIndex) ? 25 : 12,
                decoration: BoxDecoration(
                    color: (index == _selectedIndex)
                        ? Colors.black.withOpacity(0.75)
                        : Colors.black.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(2.5)),
                duration: const Duration(milliseconds: 450),
                curve: Curves.easeInOutQuint,
              ),
            ))
      ],
    );
  }
}
