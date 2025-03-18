import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vegedya_firebase/Model/Product.dart';
import 'package:vegedya_firebase/pages/home/fragment/product/product_detail.dart';
import 'package:vegedya_firebase/widgets/loading_widgets.dart';

class CustomSearchDelegate extends SearchDelegate {
  final FirebaseFirestore db;

  CustomSearchDelegate({required this.db});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(
          Icons.clear,
          color: Colors.black,
          size: 25,
        ),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back_ios_new,
        color: Colors.black,
        size: 25,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return Center(child: Text('Enter a search term.'));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: db.collection('products')
                .where('name', isGreaterThanOrEqualTo: query.toLowerCase())
                .where('name', isLessThanOrEqualTo: '${query.toLowerCase()}\uf8ff')
                .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: MainLoading());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No products found.'));
        }

        var products = snapshot.data!.docs.map((doc) {
          return Product.fromMap(doc.data() as Map<String, dynamic>, doc.id, doc.reference);
        }).toList();

        return ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            var product = products[index];
            return ListTile(
              title: Text(product.name),
              subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
              // leading: Image.network(product.fullImagePath, width: 50, height: 50, fit: BoxFit.cover),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductPage(
                      product_id: product.id,
                      db: db,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: db.collection('products')
                .where('name', isGreaterThanOrEqualTo: query.toLowerCase())
                .where('name', isLessThanOrEqualTo: '${query.toLowerCase()}\uf8ff')
                .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: MainLoading());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No suggestions.'));
        }

        var products = snapshot.data!.docs.map((doc) {
          return Product.fromMap(doc.data() as Map<String, dynamic>, doc.id, doc.reference);
        }).toList();

        return ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            var product = products[index];
            return ListTile(
              title: Text(product.name),
              subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
              // leading: Image.network(product.fullImagePath, width: 50, height: 50, fit: BoxFit.cover),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductPage(
                      product_id: product.id,
                      db: db,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
