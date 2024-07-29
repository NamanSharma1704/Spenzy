// ignore_for_file: prefer_const_constructors,avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:spenzy/core/utils/image_constant.dart';
import 'package:spenzy/presentation/transaction_screen/transaction_screen.dart';
import 'package:spenzy/routes/app_routes.dart';
import 'package:spenzy/theme/theme_helper.dart';
import 'package:spenzy/widgets/custom_image_view.dart';
import 'package:http/http.dart' as http;

// Model class to represent borrowed money details
class BorrowedMoney {
  final String uid;
  final String personName;
  final DateTime returnDate;

  BorrowedMoney(this.uid, this.personName, this.returnDate);
}

class BorrowedMoneyPage extends StatefulWidget {
  const BorrowedMoneyPage({Key? key}) : super(key: key);

  @override
  _BorrowedMoneyPageState createState() => _BorrowedMoneyPageState();
}

class _BorrowedMoneyPageState extends State<BorrowedMoneyPage> {
  late List<BorrowedMoney> borrowedMoneyList = [];

  @override
  void initState() {
    super.initState();
    // Fetch borrowed money list
    _fetchBorrowedMoneyList();
  }

  void _fetchBorrowedMoneyList() async {
    var url = Uri.parse('http://10.0.2.2:5000/people/all');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          borrowedMoneyList = data
              .map((item) => BorrowedMoney(item['uid'], item['name'], DateTime.now()))
              .toList();
        });
      } else {
        // Handle error
        print('Failed to fetch borrowed money list: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions
      print('Exception while fetching borrowed money list: $e');
    }
  }

  Future<void> _addPersonToApi(String name, String selectedGender) async {
    var url = Uri.parse('http://10.0.2.2:5000/people/create');
    try {
      var body = {'name': name, 'gender': selectedGender};
      var response = await http.post(url, body: body);
      if (response.statusCode == 201) {
        // Update the list by fetching it again
        _fetchBorrowedMoneyList();
      } else {
        // Handle error
        print('Failed to add person: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions
      print('Exception while adding person: $e');
    }
  }

  Future<void> _deletePersonApi(String uid) async {
    var url = Uri.parse('http://10.0.2.2:5000/people/delete/$uid');
    try {
      var response = await http.delete(url);
      if (response.statusCode == 200) {
        print('Person deleted successfully');
      } else {
        // Handle error
        print('Failed to delete person: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions
      print('Exception while deleting person: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Transactions',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF1D1F2C),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _addPersonDialog(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: borrowedMoneyList.length,
              itemBuilder: (context, index) {
                BorrowedMoney borrowedMoney = borrowedMoneyList[index];
                return Card(
                  elevation: 2,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  color: Color(0xFF232534),
                  // Use the background color for the Card
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: appTheme.tealA400, width: 1),
                      // Add border color
                      borderRadius: BorderRadius.circular(
                          8), // Add border radius
                    ),
                    child: ListTile(
                      title: Text(
                        borrowedMoney.personName,
                        style: TextStyle(color: Colors.white),
                      ),
                      leading: Icon(Icons.person, color: Colors.white),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.white),
                            onPressed: () {
                              _removePersonDialog(context, borrowedMoney.uid);
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TransactionScreen(uid: borrowedMoney.uid),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 50.0,
        color: Color(0xFF1D1F2C),
        child: _buildRowWithImages(context),
      ),
    );
  }

  void _addPersonDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    String selectedGender = 'Male'; // Default gender

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Person', style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Enter name',
                  hintStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: appTheme.tealA400),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: appTheme.tealA400),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                dropdownColor: Color(0XFF272938),
                value: selectedGender,
                items: ['Male', 'Female']
                    .map((String gender) {
                  return DropdownMenuItem<String>(
                    value: gender,
                    child: Text(gender, style: TextStyle(color: Colors.white)),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedGender = newValue;
                    });
                  }
                },
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: appTheme.tealA400),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: appTheme.tealA400),
                  ),
                ),
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
                String name = nameController.text;
                if (name.isNotEmpty) {
                  _addPersonToApi(name, selectedGender);
                }
                Navigator.pop(context);
              },
              child: Text('Add', style: TextStyle(color: Colors.white)),
            ),
          ],
          backgroundColor: Color(0XFF272938),
        );
      },
    );
  }

  void _removePersonDialog(BuildContext context, String uid) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remove Person'),
          content: Text(
            'Are you sure you want to remove this person?',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _removePersonFromList(uid);
                _deletePersonApi(uid);
                Navigator.pop(context);
              },
              child: Text('Remove'),
            ),
          ],
        );
      },
    );
  }

  void _removePersonFromList(String uid) {
    setState(() {
      borrowedMoneyList.removeWhere((person) => person.uid == uid);
    });
  }

  void onTapImgIconsHome(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.expenseChartScreen);
  }

  void onTapImgIconsList(BuildContext context) async {
    if (ModalRoute.of(context)!.settings.name != AppRoutes.listScreen) {
      Navigator.pushNamed(context, AppRoutes.listScreen);
    }
  }

  void onTapImgIconsMaleUserFortyEight(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.profileScreen);
  }

  Widget _buildRowWithImages(BuildContext context) {
    final currentPage = ModalRoute.of(context)!.settings.name;
    List<Widget> icons = [
      GestureDetector(
        onTap: () {
          onTapImgIconsHome(context);
        },
        child: CustomImageView(
          imagePath: ImageConstant.imgIcons8Home482,
          height: 28,
          width: 28,
        ),
      ),
      GestureDetector(
        onTap: () {
          onTapImgIconsMaleUserFortyEight(context);
        },
        child: CustomImageView(
          imagePath: ImageConstant.imgIcons8MaleUser48,
          height: 28,
          width: 28,
        ),
      ),
      GestureDetector(
        onTap: () {
          onTapImgIconsList(context);
        },
        child: CustomImageView(
          imagePath: ImageConstant.imgIcons8List481,
          height: 28,
          width: 28,
        ),
      ),
    ];

    if (currentPage == AppRoutes.expenseChartScreen) {
      icons.removeAt(0);
    } else if (currentPage == AppRoutes.profileScreen) {
      icons.removeAt(1);
    } else if (currentPage == AppRoutes.listScreen) {
      icons.removeAt(2);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: icons,
      ),
    );
  }
}
