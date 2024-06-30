import 'package:flutter/material.dart';
import 'package:swipable_stack/swipable_stack.dart';

class Encounters extends StatefulWidget {
  const Encounters({super.key});

  @override
  State<Encounters> createState() => _EncountersState();
}

class _EncountersState extends State<Encounters> {
  var currentIndex = 0;
  final List<String> _images = [
    'images/borealis.jpg',
    'images/DayGZax.jpg',
    // Add more image URLs or paths as needed
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SwipableStack(
            itemCount: _images.length,
            builder: (context, properties) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(60.0),
                child: Transform.scale(
                  scaleX: 0.95,
                  child: Image.asset(
                    _images[properties.index],
                    fit: BoxFit.fill,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              );
            },
            onSwipeCompleted: (index, direction) {
              print('Swiped $direction');
            },
          ),
          /*ClipRRect(
            borderRadius: BorderRadius.circular(60.0),
            child: Transform.scale(
              scaleX: 0.95,
              child: Image.asset(
                'images/borealis.jpg',
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.fill,
              ),
            ),
          ),*/
          Positioned(
            bottom: 20,
            left: 50,
            right: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.red,
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.all(8.0),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        child: Icon(Icons.close),
                      ),
                      SizedBox(width: 4),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(8.0),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.heart_broken),
                      SizedBox(width: 4),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(8.0),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.favorite),
                      SizedBox(width: 4),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
