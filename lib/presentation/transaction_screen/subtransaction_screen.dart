// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Subtransaction {
  final String tid;
  final double amount;
  final String refId;
  final String date;
  final bool transactionType;
  final bool isFullPayment;
  final String description; // New field

  Subtransaction({
    required this.tid,
    required this.amount,
    required this.refId,
    required this.date,
    required this.transactionType,
    required this.isFullPayment,
    required this.description, // New field
  });
}

class SubtransactionScreen extends StatefulWidget {
  final String transactionId;

  SubtransactionScreen({required this.transactionId});

  @override
  _SubtransactionScreenState createState() => _SubtransactionScreenState();
}

class _SubtransactionScreenState extends State<SubtransactionScreen> {
  List<Subtransaction> _subtransactions = [];

  @override
  void initState() {
    super.initState();
    _fetchSubtransactions(widget.transactionId);
  }

  Future<void> _addSubtransaction({
    required String refId,
    required String date,
    required double amount,
    required bool transactionType, // Use required for transactionType
    required bool isFullPayment, // Use required for isFullPayment
    required String description,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5000/transaction/sub/create'),
        body: {
          'ref_id': refId,
          'date': date,
          'amount': amount.toString(),
          'transaction_type': transactionType.toString(),
          'is_full_payment': isFullPayment.toString(),
          'description': description,
        },
      );

      if (response.statusCode == 201) {
        // Subtransaction added successfully
        print('Subtransaction added successfully');
        // Refresh the subtransactions list
        _fetchSubtransactions(widget.transactionId);
      } else {
        // Failed to add subtransaction
        print('Failed to add subtransaction: ${response.statusCode}, ${response
            .body}');
      }
    } catch (e) {
      // Catch any exceptions that occur during the HTTP request
      print('Failed to add subtransaction: $e');
    }
  }

  Future<void> _fetchSubtransactions(String tid) async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:5000/transaction/sub/all/$tid'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        List<Subtransaction> subtransactions = data.map((sub) {
          String tid = sub['tid'] ?? '';
          String date = sub['date'] ?? '';
          double amount = double.parse(sub['amount'].toString());
          bool transactionType = sub['transaction_type'] == true;
          bool isFullPayment = sub['is_fullpayment'] == true;
          String description = sub['description'] ?? '';

          Subtransaction subtransaction = Subtransaction(
            tid: tid,
            amount: amount,
            refId: sub['ref_id'] ?? '',
            date: date,
            transactionType: transactionType,
            isFullPayment: isFullPayment,
            description: description,
          );

          return subtransaction;
        }).toList();

        for(int i = 0 ; i < subtransactions.length; i++){
          print(subtransactions[i].transactionType);
        }

        setState(() {
          _subtransactions = subtransactions;
        });
      } else {
        throw Exception('Failed to fetch subtransactions');
      }
    } catch (e) {
      print('Error fetching subtransactions: $e');
    }
  }

  Future<void> _deleteSubtransaction(String tid) async {
    try {
      final response = await http.delete(
        Uri.parse('http://10.0.2.2:5000/transaction/sub/delete/$tid'),
      );

      if (response.statusCode == 200) {
        // Subtransaction deleted successfully
        print('Subtransaction deleted successfully');
        // Refresh the subtransactions list
        _fetchSubtransactions(widget.transactionId);
      } else {
        // Failed to delete subtransaction
        print(
            'Failed to delete subtransaction: ${response.statusCode}, ${response
                .body}');
      }
    } catch (e) {
      // Catch any exceptions that occur during the HTTP request
      print('Failed to delete subtransaction: $e');
    }
  }

  Widget _buildAddSubtransactionDialog(BuildContext context, String tid) {
    TextEditingController amountController = TextEditingController();
    TextEditingController dateController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    bool isFullPayment = false;
    bool transactionType = false;

    return AlertDialog(
      title: Text('Add Subtransaction', style: TextStyle(color: Colors.white)),
      content: SingleChildScrollView( // Wrap content in SingleChildScrollView
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
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
            SizedBox(height: 16),
            TextField(
              controller: dateController,
              decoration: InputDecoration(
                labelText: 'Date (yyyy-mm-dd)',
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
            SizedBox(height: 16),
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
              keyboardType: TextInputType.text,
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text(
                  'Transaction Type: ',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(width: 8),
                InkWell(
                  onTap: () {
                    setState(() {
                      transactionType = true;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: transactionType == true ? Color(0xFF1D1F2C) : Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.white),
                    ),
                    child: Text(
                      'Take',
                      style: TextStyle(color: transactionType == true ? Colors.white : Colors.white),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                InkWell(
                  onTap: () {
                    setState(() {
                      transactionType = false;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: transactionType == false ? Color(0xFF1D1F2C) : Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.white),
                    ),
                    child: Text(
                      'Give',
                      style: TextStyle(color: transactionType == false ? Colors.white : Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text(
                  'Full Payment: ',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(width: 8),
                InkWell(
                  onTap: () {
                    setState(() {
                      isFullPayment = true;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isFullPayment == true ? Color(0xFF1D1F2C) : Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.white),
                    ),
                    child: Text(
                      'Yes',
                      style: TextStyle(color: isFullPayment == true ? Colors.white : Colors.white),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                InkWell(
                  onTap: () {
                    setState(() {
                      isFullPayment = false;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isFullPayment == false ? Color(0xFF1D1F2C) : Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.white),
                    ),
                    child: Text(
                      'No',
                      style: TextStyle(color: isFullPayment == false ? Colors.white : Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel', style: TextStyle(color: Colors.white)),
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF1D1F2C)),
          ),
          onPressed: () {
            double? amount = double.tryParse(amountController.text);
            if (amount == null || amount <= 0.0) {
              // Show an error message for invalid amount
              return;
            }
            String date = dateController.text;

            // Add the subtransaction
            _addSubtransaction(
              refId: tid,
              date: date,
              amount: amount,
              transactionType: transactionType,
              isFullPayment: isFullPayment,
              description: descriptionController.text,
            );
            Navigator.pop(context);
          },
          child: Text('Add', style: TextStyle(color: Colors.white)),
        ),
      ],
      backgroundColor: Color(0xFF1D1F2C),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subtransactions', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF1D1F2C),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: _subtransactions.isEmpty
          ? Center(
        child: Text('No subtransactions found'),
      )
          : ListView.builder(
        itemCount: _subtransactions.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.tealAccent[400]!),
              borderRadius: BorderRadius.circular(8),
              color: Color(0xFF1D1F2C),
            ),
            child: ListTile(
              title: Text(
                'Amount: ${_subtransactions[index].amount.toString()}',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date: ${_subtransactions[index].date.toString()}',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    'Transaction Type: ${_subtransactions[index].transactionType ? 'Take' : 'Give'}',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    'Description: ${_subtransactions[index].description}',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                color: Colors.white,
                onPressed: () =>
                    _showDeleteConfirmationDialog(_subtransactions[index].tid),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) =>
                _buildAddSubtransactionDialog(context, widget.transactionId),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showDeleteConfirmationDialog(String tid) {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text('Delete Subtransaction'),
            content: Text(
              'Are you sure you want to delete this subtransaction?',
              style: TextStyle(color: Colors.black), // Set text color to black
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  _deleteSubtransaction(tid);
                  Navigator.pop(context); // Close the dialog
                },
                child: Text('Delete'),
              ),
            ],
          ),
    );
  }
}
