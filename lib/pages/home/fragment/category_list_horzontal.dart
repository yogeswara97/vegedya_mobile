import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vegedya_firebase/Model/Category.dart';
import 'package:vegedya_firebase/pages/home/fragment/product/product_list_page.dart';

class CategoryListHorizontal extends StatelessWidget {
  const CategoryListHorizontal({
    super.key,
    required this.db,
  });

  final FirebaseFirestore db;

  Future<int> getProductCount(String categoryId) async {
    QuerySnapshot query = await db
        .collection('products')
        .where('category', isEqualTo: db.collection('categories').doc(categoryId))
        .where('inActive', isEqualTo: true)
        .get();
    return query.size;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 5),
      height: 180,
      color: Colors.white,
      child: StreamBuilder(
        stream: db
            .collection('categories')
            .where('inActive', isEqualTo: true)
            .orderBy('created_at', descending: false)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5, // You can adjust this to the number of loading placeholders you want
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          color: Colors.grey[300], // Placeholder color
                          width: 150,
                          height: 150,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5, top: 5),
                        child: Text(
                          'Loading...',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Colors.grey, // Loading text color
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          if (snapshots.hasError) {
            print('Error: ${snapshots.error}');
            return const Center(
              child: Text("ERROR "),
            );
          }
          var _data = snapshots.data!.docs
              .map((doc) => Category.fromMap(
                  doc.data() as Map<String, dynamic>, doc.id, doc.reference))
              .toList();
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _data.length,
            itemBuilder: (context, index) {
              var item = _data[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductListPage(
                        db: db,
                        categoryId: item.id,
                        categoryName: item.name,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Stack(
                          children: [
                            Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                width: 150,
                                height: 150,
                                color: Colors.grey[300], // Shimmer placeholder color
                              ),
                            ),
                            Image.network(
                              item.image,
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                    width: 150,
                                    height: 150,
                                    color: Colors.grey[300], // Shimmer placeholder color
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 150,
                                  height: 150,
                                  color: Colors.red, // Gambar fallback jika ada error
                                  child: Icon(Icons.error, color: Colors.white),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5, top: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.name,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 17),
                            ),
                            SizedBox(width: 10,),
                            FutureBuilder<int>(
                              future: getProductCount(item.id),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Text(
                                    'Loading...',
                                    style: TextStyle(fontSize: 15, color: Colors.red),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text(
                                    'Error',
                                    style: TextStyle(fontSize: 15, color: Colors.red),
                                  );
                                } else {
                                  return Text(
                                    '${snapshot.data} items',
                                    style: TextStyle(fontSize: 15, color: Colors.red),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
