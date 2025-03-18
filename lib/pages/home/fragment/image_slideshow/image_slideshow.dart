import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vegedya_firebase/Model/Banner.dart';
import 'package:vegedya_firebase/pages/home/fragment/image_slideshow/sildeshow_detail.dart';
import 'package:vegedya_firebase/utils/swipe_navigation.dart';

class ImageSlide extends StatelessWidget {
  final FirebaseFirestore db;
  const ImageSlide({
    super.key, required this.db,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: db
              .collection('banners')
              .where('inActive', isEqualTo: true)
              .snapshots(),
      builder: (context, snapshot){
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

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          // return Center(
          //   child: Text("No images available"), // Jika tidak ada data
          // );
          return Image.asset(
            "assets/images/slider/banner_default.jpg", // Menggunakan URL dari Firestore
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Center(child: Text("Error loading image $error")); // Penanganan error saat gagal memuat gambar
            },
          );
        }

        var banners = snapshot.data!.docs
              .map((doc) => BannerModel.fromMap(
                  doc.data() as Map<String, dynamic>, doc.id))
              .toList();

        var sliderImages = banners.map((banner) => banner.image).toList();

        return ImageSlideshow(
          width: double.infinity,
          height: 220,
          initialPage: 0,
          indicatorColor: Colors.yellow,
          indicatorBackgroundColor: Colors.grey,
          onPageChanged: (value) {
            print('Page changed: $value');
          },
          autoPlayInterval: 8000,
          isLoop: true,
          children: sliderImages.map((imageUrl){
            return GestureDetector(
              onTap: () {
                // Find the clicked banner to retrieve its ID
                var banner = banners.firstWhere((b) => b.image == imageUrl);
                print("Image clicked: $imageUrl, ID: ${banner.id}");
                // Navigator.push(
                //   context, 
                //   MaterialPageRoute(builder: (context) => SildeshowDetail(imageUrl: imageUrl, bannerId: banner.id, db: db,))
                // );
                swipeNavigation(context, SildeshowDetail(imageUrl: imageUrl, bannerId: banner.id, db: db,));
              },
              child: Image.network(
                imageUrl, // Menggunakan URL dari Firestore
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
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
                },
                errorBuilder: (context, error, stackTrace) {
                  return Center(child: Text("Error loading image")); // Penanganan error saat gagal memuat gambar
                },
              ),
            );
          }).toList(),
        );
      },
    );
  }
}




