// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:spenzy/presentation/transaction_screen/subtransaction_screen.dart';

class TransactionScreen extends StatefulWidget {
  final String uid;

  TransactionScreen({required this.uid});

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class ApiTransaction {
  final String tid;
  final String uid;
  final String date;
  final double amount;
  final int? predictedDays;
  final bool isCompleted;
  final String description; // New field

  ApiTransaction({
    required this.tid,
    required this.uid,
    required this.date,
    required this.amount,
    required this.predictedDays,
    required this.isCompleted,
    required this.description, // New field
  });

  Map<String, dynamic> toJson() {
    return {
      'tid': tid,
      'uid': uid,
      'date': date,
      'amount': amount,
      'predictedDays': predictedDays,
      'isCompleted': isCompleted ? 1 : 0,
      'description': description, // New field
    };
  }
}

class _TransactionScreenState extends State<TransactionScreen> {
  List<ApiTransaction> _transactions = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:5000/transaction/get-all/${widget.uid}'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        List<ApiTransaction> transactions = [];

        data.forEach((e) {
          if (e is Map<String, dynamic>) {
            String? tid = e['tid'] as String?;
            if (tid != null) {
              int? predictedDays = e['predicted_days'] as int?;
              print('is_completed value: ${e['is_completed']}'); // Add this line
              transactions.add(ApiTransaction(
                tid: tid,
                uid: e['uid'] as String? ?? '',
                date: e['date'] as String? ?? '',
                amount: double.parse(e['amount'].toString()),
                predictedDays: predictedDays ?? 0,
                // Assign null if predicted_days is null
                isCompleted: e['is_completed'] == true,
                description: e['description'] as String? ?? '', // Populate description
              ));
            }
          }
        });

        setState(() {
          _transactions = transactions;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch transactions');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching transactions: $e');
    }
  }

  Future<void> _addTransactionApi({
    required String uid,
    required String date,
    required double amount,
    required String description, // New parameter
  }) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5000/transaction/create'),
        body: {
          'uid': uid,
          'date': date,
          'amount': amount.toString(),
          'description': description, // Include description in the request body
        },
      );

      if (response.statusCode == 201) {
        // Transaction added successfully
        final responseData = jsonDecode(response.body);
        final String tid = responseData['tid'];
        print('Transaction added successfully. Transaction ID: $tid');

        // Reload transactions
        _fetchTransactions();
      } else {
        // Failed to add transaction
        print('Failed to add transaction: ${response.statusCode}, ${response
            .body}');
      }
    } catch (e) {
      // Catch any exceptions that occur during the HTTP request
      print('Failed to add transaction: $e');
    }
  }

  Future<void> _deleteTransaction(ApiTransaction transaction) async {
    try {
      final response = await http.delete(
        Uri.parse('http://10.0.2.2:5000/transaction/delete/${transaction.tid}'),
      );

      if (response.statusCode == 200) {
        // Transaction deleted successfully
        setState(() {
          _transactions.remove(transaction);
        });
        print('Transaction deleted successfully');
      } else {
        // Failed to delete transaction
        print('Failed to delete transaction: ${response.statusCode}, ${response
            .body}');
      }
    } catch (e) {
      // Catch any exceptions that occur during the HTTP request
      print('Failed to delete transaction: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Transaction Details',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF1D1F2C),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) =>
                    _buildAddTransactionDialog(context, widget.uid),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchTransactions,
        child: _isLoading
            ? Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        )
            : _buildTransactionList(),
      ),
    );
  }

  Widget _buildTransactionList() {
    final activeTransactions = _transactions.where((t) => !t.isCompleted).toList();
    final completedTransactions = _transactions.where((t) => t.isCompleted).toList();
    for(int i = 0; i < activeTransactions.length;i++){
      print(activeTransactions[i].isCompleted);
    }
    return ListView(
      children: [
        if (activeTransactions.isNotEmpty)
          _buildTransactionSection('Active Transactions', activeTransactions),
        if (completedTransactions.isNotEmpty)
          _buildTransactionSection('Completed Transactions', completedTransactions),
      ],
    );
  }

  Widget _buildTransactionSection(String title, List<ApiTransaction> transactions) {
    return Card(
      color: Color(0xFF1D1F2C),
      elevation: 3,
      margin: EdgeInsets.all(8),
      child: ExpansionTile(
        title: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
        initiallyExpanded: true,
        collapsedIconColor: Colors.white,
        backgroundColor: Color(0xFF1D1F2C),
        children: transactions.map((transaction) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      SubtransactionScreen(transactionId: transaction.tid),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.teal, width: 2.0),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                leading: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ),
                title: Text(
                  'Amount: \$${transaction.amount}',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date: ${transaction.date}',
                      style: TextStyle(color: Colors.white),
                    ), // Display date here
                    Text(
                      'Description: ${transaction.description}',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      'Will return in ${transaction.predictedDays} days',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.delete),
                      color: Colors.white,
                      onPressed: () => _deleteTransaction(transaction),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAddTransactionDialog(BuildContext context, String uid) {
    TextEditingController amountController = TextEditingController();
    TextEditingController dateController = TextEditingController();
    TextEditingController descriptionController = TextEditingController(); // Add this controller

    return AlertDialog(
      title: Text('Add Transaction', style: TextStyle(color: Colors.white)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: amountController,
            decoration: InputDecoration(
              labelText: 'Amount',
              labelStyle: TextStyle(color: Colors.white),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            keyboardType: TextInputType.number,
            style: TextStyle(color: Colors.white),
          ),
          TextField(
            controller: dateController,
            decoration: InputDecoration(
              labelText: 'Date (YYYY-MM-DD)',
              labelStyle: TextStyle(color: Colors.white),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            keyboardType: TextInputType.datetime,
            style: TextStyle(color: Colors.white),
          ),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(
              labelText: 'Description',
              labelStyle: TextStyle(color: Colors.white),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel', style: TextStyle(color: Colors.white)),
        ),
        TextButton(
          onPressed: () {
            String amount = amountController.text.trim();
            String date = dateController.text.trim();
            String description = descriptionController.text
                .trim(); // Get description

            if (amount.isEmpty || date.isEmpty ||
                description.isEmpty) { // Check if description is empty
              return;
            }

            double parsedAmount = double.tryParse(amount) ?? 0;
            if (parsedAmount <= 0) {
              return;
            }

            _addTransactionApi(uid: uid,
                date: date,
                amount: parsedAmount,
                description: description); // Pass description

            Navigator.pop(context);
          },
          child: Text('Add', style: TextStyle(color: Colors.white)),
        ),
      ],
      backgroundColor: Color(0xFF1D1F2C),
    );
  }

  void main() {
    runApp(MaterialApp(
      home: TransactionScreen(uid: 'user_id'),
    ));
  }
}