// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:spenzy/presentation/expense_chart_screen/expense_chart_screen.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({Key? key}) : super(key: key);

  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

DateTime _selectedDate = DateTime.now();

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  late String _selectedCategory = 'Food'; // Default category
  late TextEditingController amountController = TextEditingController();
  late TextEditingController descriptionController = TextEditingController();

  void _saveExpense() {
    FirebaseFirestore.instance.collection('expenses').add({
      'date': _selectedDate,
      'amount': double.parse(amountController.text),
      'description': descriptionController.text,
      'category': _selectedCategory,
    }).then((value) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color(0xFF1D1F2C),
            title: Text(
              'Expense Saved',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the alert dialog
                  Navigator.pushReplacement( // Navigate to the ExpenseChartScreen
                    context,
                    MaterialPageRoute(builder: (context) => ExpenseChartScreen()),
                  );
                },
                child: Text(
                  'OK',
                  style: TextStyle(color: Colors.teal),
                ),
              ),
            ],
          );
        },
      );
    }).catchError((error) {
      print('Failed to add expense: $error');
    });
  }

  Future<void> _getPredictedCategory(String description) async {
    var url = Uri.parse('http://10.0.2.2:5000/models/classify');
    try {
      var response = await http.post(url, body: {'string': description});
      if (response.statusCode == 200) {
        print('Response body: ${response.body}');
        var responseBody = json.decode(response.body);
        if (responseBody.containsKey('output')) {
          var output = responseBody['output'];
          if (output is int) {
            int predictedCategoryIndex = output;
            Map<int, String> categoryMapping = {
              0 : 'Miscellaneous' ,
              1 : 'Travel',
              2 : 'Money Transfer',
              3 : 'Food',
              4 : 'Entertainment' ,
              5 : 'Utilities' ,
              6 : 'Shopping' ,
              7 : 'Healthcare' ,
            };
            setState(() {
              _selectedCategory = categoryMapping[predictedCategoryIndex]!;
            });
            if (descriptionController.text.isEmpty) {
              // Update the description only if it's empty
              descriptionController.text = _selectedCategory;
            }
          } else if (output is String) {
            setState(() {
              _selectedCategory = output;
            });
            if (descriptionController.text.isEmpty) {
              // Update the description only if it's empty
              descriptionController.text = _selectedCategory;
            }
          } else {
            print('Invalid output format');
          }
        } else {
          print('Output key not found in response');
        }
      } else {
        // Handle error
        print('Failed to load category: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions
      print('Exception while loading category: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Expense', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF1D1F2C),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: _buildInputDecoration('Amount'),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: descriptionController,
              keyboardType: TextInputType.text,
              onChanged: (value) {
                _getPredictedCategory(value);
              },
              decoration: _buildInputDecoration('Description'),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              items: [
                'Food',
                'Entertainment',
                'Healthcare',
                'Miscellaneous',
                'Money Transfer',
                'Shopping',
                'Travel',
                'Utilities',
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue!;
                });
              },
              dropdownColor: Color(0xFF1D1F2C),
              decoration: _buildInputDecoration('Category'),
            ),

            SizedBox(height: 16), // Add spacing
            TextFormField(
              readOnly: true,
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2015),
                  lastDate: DateTime(2050),
                  builder: (BuildContext context, Widget? child) {
                    return Theme(
                      data: ThemeData.dark(), // Customize the date picker theme
                      child: child!,
                    );
                  },
                );
                if (picked != null && picked != _selectedDate) {
                  setState(() {
                    _selectedDate = picked;
                  });
                }
              },
              decoration: _buildInputDecoration('Date'), // Display the selected date
              controller: TextEditingController(
                text: '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
              ),
            ),
            SizedBox(height: 14),
            ElevatedButton(
              onPressed: _saveExpense,
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.teal),
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(vertical: 25)),
                shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              ),
              child: Text(
                'Save',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String labelText) {
    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      labelText: labelText,
      labelStyle: TextStyle(color: Colors.white),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.teal, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.teal, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.teal, width: 1),
      ),
    );
  }
}
