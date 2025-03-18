import 'package:flutter/material.dart';

class NavBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                modalBottomHalal(context);
              },
              child: Container(
                height: 70,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, bottom: 10, left: 10, right: 5),
                        child: Image.asset(
                          "assets/icon/halal_logo_2022.jpg",
                          width: 45,
                          height: 50,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          "Vegedya coffee has been verified halal by MUI",
                          style: TextStyle(fontSize: 12.5),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Icon(Icons.keyboard_arrow_right_rounded),
                      SizedBox(
                        width: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Divider(),
            Container(
              // color: Colors.green,
              height: 70,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, bottom: 10, left: 10, right: 5),
                      child: Image.asset(
                        "assets/icon/logo-kementrian-perdagangan.jpg",
                        height: 65,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        "Dirjen Perlindungan Konsumen dan Tata Tertib Niaga Kementrian Perdagangan Republik Indoneisa",
                        style: TextStyle(fontSize: 12.5),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    )
                  ],
                ),
              ),
            ),
            Divider()
          ],
        ),
      ),
    );
  }

  Future<dynamic> modalBottomHalal(BuildContext context) {
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        context: context,
        isScrollControlled: true, // Mengizinkan modal untuk menggunakan lebih banyak ruang
        builder: (context) {
          // Mengambil tinggi layar dan membatasi tinggi modal sheet
          double screenHeight = MediaQuery.of(context).size.height;
          return Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            height: screenHeight * 0.7, // Modal hanya akan mengambil 70% dari tinggi layar
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag Indicator
                Center(
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Center(
                  child: Text(
                    "Halal Certification",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 111, 78, 55),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: Text(
                    "Vegedya coffee has been verified halal by MUI",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Halal Certificate Section
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Color.fromARGB(255, 111, 78, 55),
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          "assets/icon/halal_logo_2022.jpg",
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Majelis Ulama Indonesia",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "00160233461224",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 111, 78, 55),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20),
                // Halal Description Section
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "• Bebas dari bahan-bahan yang dilarang syariat Islam",
                          style: TextStyle(fontSize: 15),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "• Diproses dan disajikan sesuai dengan standar Islami",
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ),
                // Understand Button
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Color.fromARGB(255, 111, 78, 55),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Text(
                        "I Understand",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
