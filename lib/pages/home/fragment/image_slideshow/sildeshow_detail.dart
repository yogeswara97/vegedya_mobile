import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vegedya_firebase/Model/Banner.dart';

class SildeshowDetail extends StatelessWidget {
  final String imageUrl;
  final String bannerId;
  final FirebaseFirestore db;

  const SildeshowDetail({
    super.key,
    required this.imageUrl,
    required this.bannerId,
    required this.db,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: db.collection('banners').doc(bannerId).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: double.infinity,
                height: 220,
                color: Colors.white, // Tempat untuk shimmer efek
              ),
            );
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: Text("No banner data available"), // Jika tidak ada data
            );
          }

          // Parse the banner data
          var banner = BannerModel.fromMap(
            snapshot.data!.data() as Map<String, dynamic>,
            snapshot.data!.id,
          );

          return SingleChildScrollView(
            child: Column(
              children: [
                Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 220,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: double.infinity,
                        height: 220,
                        color: Colors.white,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Center(child: Text("Error loading image")); 
                  },
                ),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        '${banner.title}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30
                        ),
                      ),
                      SizedBox(height: 3,),
                      Text('${banner.createdAt}'),
                      Html(data: banner.description ?? "No description available"),
                    ],
                  ), 
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
