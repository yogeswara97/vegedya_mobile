import 'package:flutter/material.dart';

class NoItemsWidget extends StatelessWidget {
  final String text;

  NoItemsWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(16.0), 
        child: Column(
          mainAxisSize: MainAxisSize.min, // Mengatur ukuran kolom sesuai dengan ukuran konten
          children: [
            Container(
              width: 180, // Ukuran lebar gambar
              height: 150,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/images/no_image/no-image.jpg',
                  fit: BoxFit
                      .cover, // Mengatur cara gambar di-crop dan ditampilkan dalam kontainer
                ),
              ),
            ),
            SizedBox(height: 10), // Jarak antara gambar dan teks
            Text(
              text,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
