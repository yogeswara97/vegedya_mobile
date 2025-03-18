import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vegedya_firebase/pages/point/point_fragment.dart';
import 'package:vegedya_firebase/utils/swipe_navigation.dart';

class PointWidget extends StatefulWidget {
  final FirebaseFirestore db;
  final int points;
  final String? customerId;
  const PointWidget({
    super.key,
    required this.db, 
    required this.points,
    required this.customerId,
  });

  @override
  State<PointWidget> createState() => _PointWidgetState();
}

class _PointWidgetState extends State<PointWidget> {

  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              height: 60,
              color: Color.fromARGB(255, 111, 78, 55),
            ),
            Container(
              height: 60,
            ),
          ],
        ),
        Positioned.fill(
          child: Center(
            child: GestureDetector(
              onTap: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => PointFragment(db: widget.db,)
                //     )
                // );
                swipeNavigation(context, PointFragment(db: widget.db));
              },
              child: Container(
                height: 100,
                width: MediaQuery.of(context).size.width * 0.96,
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 30,
                            height: 30,
                            child: Image.asset('assets/images/no_image/no-image.jpg')
                          ),
                          SizedBox(width: 10),
                          Text(
                            "${widget.points} Points",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Swipe your points",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_right_rounded),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
