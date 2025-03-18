import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vegedya_firebase/Model/CartItem.dart';
import 'package:vegedya_firebase/pages/home/fragment/cart/waiting_payment.dart';
import 'package:vegedya_firebase/pages/navigation/bottom_navigation.dart';
import 'package:vegedya_firebase/widgets/calculate_total_widget.dart';
import 'package:vegedya_firebase/widgets/refresh_indicator_widget.dart';
import 'package:vegedya_firebase/widgets/silver_gap_widget.dart';

class CartPage extends StatefulWidget {
  final FirebaseFirestore db;
  final String? customerId;
  const CartPage({super.key, required this.db, required this.customerId});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double subTotalPrice = 0.0;
  double tax = 0.0;
  double grandTotal = 0.0;
  late List<CartItem> _cartItems;

  // Fungsi untuk menghitung subtotal harga
  double _calculateSubTotalPrice(List<CartItem> cartItems) {
    return cartItems.fold(
        0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  // Fungsi untuk menghitung pajak
  double _calculateTax(double subTotalPrice) {
    const double taxRate = 0.10;
    double tax = subTotalPrice * taxRate;
    return double.parse(tax.toStringAsFixed(2));
  }

  // Fungsi untuk menghitung total keseluruhan
  double _calculateGrandTotal(double subTotalPrice, double tax) {
    return subTotalPrice + tax;
  }

  // Fungsi untuk memperbarui kuantitas item di cart
  void updateItemQuantity(
      CartItem item, int newQuantity, setStateItem, setStateTotal) {
    if (newQuantity > 0) {
      item.documentReference.update({'quantity': newQuantity}).then((_) {
        setStateItem(() {
          item.quantity = newQuantity;
        });
        setStateTotal(() {
          subTotalPrice = _calculateSubTotalPrice(_cartItems);
          tax = _calculateTax(subTotalPrice);
          grandTotal = _calculateGrandTotal(subTotalPrice, tax);
        });
        print('Quantity updated to $newQuantity for item ${item.name}');
      }).catchError((error) {
        print('Failed to update quantity: $error');
      });
    } else {
      _showDeleteConfirmationDialog(item, setStateItem, setStateTotal);
    }
  }

  // Fungsi untuk refresh data
  Future<void> _refreshData() async {
    setState(() {});
  }

  // Menampilkan dialog konfirmasi
  void _showConfirmationDialog() {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Checkout'),
          content:
              const Text('Are you sure you want to proceed with the checkout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'No',
                style: TextStyle(
                  color: Color.fromARGB(255, 111, 78, 55),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _processCheckout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 111, 78, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Yes',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(CartItem cartItem, setStateItem, setStateTotal){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Item'),
          content:
              const Text('Are you sure you want to remove this item from your cart?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'No',
                style: TextStyle(
                  color: Color.fromARGB(255, 111, 78, 55),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                _deleteCartItem(cartItem,setStateItem,setStateTotal);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 111, 78, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Yes',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _deleteCartItem(CartItem item, setState, setStateTotal){
    item.documentReference.delete().then((_) {
      setState(() {
        _cartItems.remove(item);
      });
      setStateTotal(() {
        subTotalPrice = _calculateSubTotalPrice(_cartItems);
        tax = _calculateTax(subTotalPrice);
      });
      print('Item ${item.name} deleted from cart');
    }).catchError((error) {
      print('Failed to delete item: $error');
    });
  }

  // Proses checkout
  Future<void> _processCheckout() async {
    try {
      // Step 1: Tampilkan harga subtotal dan item di cart
      print(subTotalPrice);
      for (var item in _cartItems) {
        print(
            'Item: ${item.name}, Quantity: ${item.quantity}, Price: ${item.price}');
      }

      // Step 2: Tambahkan order ke Firestore
      final orderRef = widget.db.collection('orders').doc();
      final orderId = orderRef.id;
      await orderRef.set({
        'customerId': widget.customerId,
        'status': 'waiting',
        'subTotalPrice': subTotalPrice,
        'tax': tax,
        'totalPrice': grandTotal,
        'orderDate': FieldValue.serverTimestamp(),
      });

      // Hitung total point dari semua item di _cartItems
      int totalPoint = 0;
      for (var item in _cartItems) {
        totalPoint += item.point ; // Jumlahkan point berdasarkan quantity
      }

      // Step 3: Tambahkan item ke dalam order di Firestore
      for (var item in _cartItems) {
        await orderRef.collection('items').add({
          'productId': item.id,
          'name': item.name,
          'price': item.price,
          'quantity': item.quantity,
          'totalPrice': item.price * item.quantity,
          'image': item.image,
          'point': item.point * item.quantity
        });
      }
      print('total poin : ${totalPoint}');

    

      // Step 4: Hapus semua item dari cart setelah order
      final cartItemsRef = widget.db
          .collection('carts')
          .doc(widget.customerId)
          .collection('items');
      final cartItemsSnapshot = await cartItemsRef.get();
      for (var doc in cartItemsSnapshot.docs) {
        await doc.reference.delete();
      }

      Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WaitingPayment(
          db: widget.db,
          orderId: orderId, 
          customerId: widget.customerId, 
          point: totalPoint,
        ),
      ),
    );
      
    } catch (e) {
      print('Error processing order: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
      ),
      body: RefreshIndicatorWidget(
        onRefresh: _refreshData,
        child: StreamBuilder(
          stream: widget.db
              .collection('carts')
              .doc(widget.customerId)
              .collection('items')
              .snapshots(),
          builder: (context, snapshots) {
            if (snapshots.connectionState == ConnectionState.waiting) {
              return Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.white,
                  size: 200,
                ),
              );
            } else if (snapshots.hasError) {
              return const Center(child: Text("ERROR"));
            } else if (!snapshots.hasData || snapshots.data!.docs.isEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BottomNavigationPage(
                      initialIndex: 0,
                      customerId: widget.customerId,
                    ),
                  ),
                );
              });
              return Container();
            }

            _cartItems = snapshots.data!.docs
                .map((doc) => CartItem.fromMap(
                    doc.data() as Map<String, dynamic>, doc.id, doc.reference))
                .toList();
            subTotalPrice = _calculateSubTotalPrice(_cartItems);
            tax = _calculateTax(subTotalPrice);
            grandTotal = _calculateGrandTotal(subTotalPrice, tax);

            return StatefulBuilder(
              builder: (context, setStateTotal) {
                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: const Text(
                          'Order Detail',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                    const SilverGapWidget(),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          var item = _cartItems[index];
                          return StatefulBuilder(
                            builder: (context, setStateItem) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image.network(
                                                item.image,
                                                width: 90,
                                                height: 90,
                                                fit: BoxFit.cover,
                                                loadingBuilder: (context, child, loadingProgress) {
                                                  if (loadingProgress == null) return child;
                                                  return Shimmer.fromColors(
                                                    baseColor: Colors.grey[300]!,
                                                    highlightColor: Colors.grey[100]!,
                                                    child: Container(
                                                      width: 90,
                                                      height: 90,
                                                      color: Colors.grey[300], // Shimmer placeholder color
                                                    ),
                                                  );
                                                },
                                                errorBuilder: (context, error, stackTrace) {
                                                  return Container(
                                                    width: 90,
                                                    height: 90,
                                                    color: Colors.red, // Gambar fallback jika ada error
                                                    child: Icon(Icons.error, color: Colors.white),
                                                  );
                                                },
                                              ),
                                            ),
                                            SizedBox(width: 10,),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item.name,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                Text(
                                                  '\$${item.price}',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.red
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Row(
                                              
                                              children: [
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons
                                                        .remove_circle_outline,
                                                    color: Color.fromARGB(
                                                        255, 111, 78, 55),
                                                  ),
                                                  onPressed: () {
                                                    updateItemQuantity(
                                                        item,
                                                        item.quantity - 1,
                                                        setStateItem,
                                                        setStateTotal);
                                                  },
                                                ),
                                                SizedBox(
                                                  width: 30,
                                                  child: Center(
                                                    child: Text(
                                                      item.quantity.toString(),
                                                      style: TextStyle(
                                                        fontSize: 20
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.add_circle,
                                                    color: Color.fromARGB(
                                                        255, 111, 78, 55),
                                                  ),
                                                  onPressed: () {
                                                    updateItemQuantity(
                                                        item,
                                                        item.quantity + 1,
                                                        setStateItem,
                                                        setStateTotal);
                                                  },
                                                ),
                                              ],
                                            ),
                                            IconButton(
                                              onPressed: (){
                                                _showDeleteConfirmationDialog(item, setStateItem, setStateTotal);
                                              }, 
                                              icon:Icon(
                                                Icons.delete_outline_outlined,
                                              )
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    Divider(color: Colors.grey[300]),
                                  ],
                                ),
                              );
                            
                            },
                          );
                        },
                        childCount: _cartItems.length,
                      ),
                    ),
                    const SilverGapWidget(),
                    SliverToBoxAdapter(
                      child: calculateTotalWidget(
                        subTotalPrice: subTotalPrice,
                        tax: tax,
                        grandTotal: grandTotal,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: () {
                              _showConfirmationDialog();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 111, 78, 55),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Checkout',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
