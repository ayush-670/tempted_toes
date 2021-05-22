import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:tempted_toes/screens/product_page.dart';
import 'package:tempted_toes/services/firebase_services.dart';
import 'package:tempted_toes/widgets/custom_action_bar.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  FirebaseServices _firebaseServices = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<QuerySnapshot>(
            future: _firebaseServices.usersRef
                .doc(_firebaseServices.getUserId())
                .collection("Cart")
                .get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("Error: ${snapshot.error}"),
                  ),
                );
              }

              // Collection Data ready to display
              if (snapshot.connectionState == ConnectionState.done) {
                // Display the data inside a list view
                return ListView(
                  padding: EdgeInsets.only(
                    top: 108.0,
                    bottom: 12.0,
                  ),
                  children: snapshot.data.docs.map((document) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductPage(
                                productId: document.id,
                              ),
                            ));
                      },
                      child: FutureBuilder(
                        future: _firebaseServices.productsRef
                            .doc(document.id)
                            .get(),
                        builder: (context, productSnap) {
                          if (productSnap.hasError) {
                            return Container(
                              child: Center(
                                child: Text("${productSnap.error}"),
                              ),
                            );
                          }

                          if (productSnap.connectionState ==
                              ConnectionState.done) {
                            Map _productMap = productSnap.data.data();

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16.0,
                                horizontal: 24.0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 90,
                                    height: 90,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(
                                        "${_productMap['images'][0]}",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                      left: 16.0,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: 10.0),
                                          child: Text(
                                            "${_productMap['name']}",
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 4.0,
                                            horizontal: 10.0,
                                          ),
                                          child: Text(
                                            "\₹${_productMap['price']}",
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: Theme.of(context)
                                                    .accentColor,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: Text(
                                            "Size - ${document.data()['size']}",
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),

                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5.0),
                                          child: RaisedButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            color: Colors.black,
                                            child: Text(
                                              'Confirm Order',
                                              style: TextStyle(
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white),
                                            ),
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                          "Order received!"),
                                                      content: Container(
                                                        child: Text(
                                                            "We will contact you shortly for more details"),
                                                      ),
                                                      actions: [
                                                        FlatButton(
                                                          child: Text("Close"),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        )
                                                      ],
                                                    );
                                                  });
                                            },
                                          ),
                                        ),

                                        // Padding(
                                        //   padding: const EdgeInsets.only(left:15.0),
                                        //   child: CustomBtn(
                                        //     text: "Confirm Order",
                                        //     onPressed: () {
                                        //       showDialog(
                                        //           context: context,
                                        //           barrierDismissible: false,
                                        //           builder: (context) {
                                        //             return AlertDialog(
                                        //               title:
                                        //                   Text("Order received!"),
                                        //               content: Container(
                                        //                 child: Text(
                                        //                     "We will contact you shortly for more details"),
                                        //               ),
                                        //               actions: [
                                        //                 FlatButton(
                                        //                   child: Text("Close"),
                                        //                   onPressed: () {
                                        //                     Navigator.pop(
                                        //                         context);
                                        //                   },
                                        //                 )
                                        //               ],
                                        //             );
                                        //           });
                                        //     },
                                        //   ),
                                        // )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return Container(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                      ),
                    );
                  }).toList(),
                );
              }

              // Loading State
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
          CustomActionBar(
            hasBackArrrow: true,
            title: "Cart",
          )
        ],
      ),
    );
  }
}
