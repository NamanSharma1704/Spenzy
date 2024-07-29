// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TransactionItem {
  final String description;
  final double amount;

  TransactionItem({required this.description, required this.amount});

  factory TransactionItem.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    return TransactionItem(
      description: snapshot['description'],
      amount: snapshot['amount'],
    );
  }
}

class CategoryTransactionsScreen extends StatelessWidget {
  final String category;

  const CategoryTransactionsScreen({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions for $category', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF1D1F2C),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: Color(0xFF1D1F2C),
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('expenses').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            List<TransactionItem> transactions = [];

            for (var document in snapshot.data!.docs) {
              String? docCategory = document['category'];

              if (docCategory != null && docCategory.toLowerCase() == category.toLowerCase()) {
                transactions.add(TransactionItem.fromDocumentSnapshot(document));
              }
            }

            double totalAmount = transactions.fold(0, (sum, item) => sum + item.amount);

            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: transactions.length,
                    separatorBuilder: (BuildContext context, int index) => SizedBox(height: 8.0),
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0XFF2CDA9D)),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Card(
                          margin: EdgeInsets.zero,
                          color: Color(0xFF1D1F2C),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            leading: Icon(Icons.monetization_on, color: Colors.white),
                            title: Text(
                              transactions[index].description,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Courgette',
                              ),
                            ),
                            subtitle: Text(
                              'Amount: ${transactions[index].amount.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                                fontFamily: 'Courgette',
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0XFF2CDA9D)),
                    borderRadius: BorderRadius.circular(8.0),
                    color: Color(0xFF2CDA9D),
                  ),
                  padding: EdgeInsets.all(16.0),
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Courgette',
                        ),
                      ),
                      Text(
                        '\$$totalAmount',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Courgette',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
