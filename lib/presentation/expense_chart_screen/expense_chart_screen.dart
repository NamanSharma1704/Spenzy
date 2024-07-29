// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spenzy/presentation/add_expense_screen/add_expense_screen.dart';
import 'package:spenzy/presentation/add_expense_screen/category_data.dart';
import 'package:spenzy/core/app_export.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class _ChartData {
  final String category;
  final double amount;
  final Color color;

  _ChartData(this.category, this.amount, this.color);
}
class CategoryItem {
  final String name;
  final Color color;
  final IconData icon;

  CategoryItem(this.name, this.color, this.icon);
}

class ExpenseChartScreen extends StatelessWidget {
  const ExpenseChartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.blueGray900,
      appBar: AppBar(
        title: Text(
          'Expense Chart',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF1D1F2C),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddExpenseScreen()),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 1),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 6.0),
              child: Text(
                "EXPENSES",
                style: CustomTextStyles.displayMediumWallpoet.copyWith(color: appTheme.whiteA700),
              ),
            ),

            const SizedBox(height: 10),
            Center(
              child: _buildPieChart(),
            ),
            const SizedBox(height: 10),
            _buildCategoryList(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 50.0,
        color: Color(0xFF1D1F2C),
        child: _buildRowWithImages(context),
      ),
    );
  }

  Widget _buildPieChart() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('expenses').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show loading indicator while fetching data
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        List<DocumentSnapshot> documents = snapshot.data!.docs;
        Map<String, double> categoryAmounts = {};

        for (var document in documents) {
          String? category = document['category']; // Use String? to indicate that category can be null
          double amount = document['amount'] ?? 0; // Use 0 as default value if amount is null

          if (category != null) { // Check if category is not null
            if (categoryAmounts.containsKey(category)) {
              categoryAmounts[category] = (categoryAmounts[category] ?? 0) + amount; // Use 0 as default value if categoryAmounts[category] is null
            } else {
              categoryAmounts[category] = amount;
            }
          }
        }

        List<_ChartData> data = categoryAmounts.entries.map((entry) {
          String category = entry.key;
          double amount = entry.value;
          Color color = categoryData[category]?['color'] ?? Colors.blue[400]; // Use assigned color or default to blue
          return _ChartData(category, amount, color);
        }).toList();

        return SfCircularChart(
          series: <CircularSeries<_ChartData, String>>[
            PieSeries<_ChartData, String>(
              dataSource: data,
              xValueMapper: (_ChartData sales, _) => sales.category,
              yValueMapper: (_ChartData sales, _) => sales.amount,
              pointColorMapper: (_ChartData sales, _) => sales.color, // Set point color based on category
              dataLabelSettings: DataLabelSettings(
                isVisible: true,
                labelPosition: ChartDataLabelPosition.outside,
                textStyle: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCategoryList() {
    Map<int, String> categories = {
      0 : 'Miscellaneous' ,
      1 : 'Travel',
      2 : 'Money Transfer',
      3 : 'Food',
      4 : 'Entertainment' ,
      5 : 'Utilities' ,
      6 : 'Shopping' ,
      7 : 'Healthcare' ,
    };

    Map<String, Map<String, dynamic>> categoryData = {
      'Food': {'icon': Icons.fastfood, 'color': Colors.orange[400]},
      'Entertainment': {'icon': Icons.movie, 'color': Colors.purple[400]},
      'Healthcare': {'icon': Icons.local_hospital, 'color': Colors.teal[400]},
      'Miscellaneous': {'icon': Icons.category, 'color': Colors.grey[400]},
      'Money Transfer': {'icon': Icons.monetization_on, 'color': Colors.lightGreen[400]},
      'Shopping': {'icon': Icons.shopping_cart, 'color': Colors.amberAccent[400]},
      'Travel': {'icon': Icons.flight, 'color': Colors.lightBlueAccent[400]},
      'Utilities': {'icon': Icons.receipt, 'color': Colors.green[400]},
    };

    List<Widget> rows = [];
    for (int i = 0; i < categories.length; i += 2) {
      if (i + 1 < categories.length) {
        rows.add(Row(
          children: [
            Expanded(
              child: ListTile(
                leading: Icon(categoryData[categories[i]]?['icon'], color: categoryData[categories[i]]?['color']),
                title: Text(
                  categories[i]!,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Expanded(
              child: ListTile(
                leading: Icon(categoryData[categories[i + 1]]?['icon'], color: categoryData[categories[i + 1]]?['color']),
                title: Text(
                  categories[i + 1]!,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ));
      } else {
        // If there's only one item left, add it to a row with an empty container to maintain alignment
        rows.add(Row(
          children: [
            Expanded(
              child: ListTile(
                leading: Icon(categoryData[categories[i]]?['icon'], color: categoryData[categories[i]]?['color']),
                title: Text(
                  categories[i]!,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Expanded(child: Container()),
          ],
        ));
      }
    }
    return Column(
      children: rows,
    );
}

void onTapImgIconsRs(BuildContext context) {
  Navigator.pushNamed(context, AppRoutes.borrowedMoneyScreen);
}
void onTapImgIconsHome(BuildContext context) {
  if (ModalRoute.of(context)!.settings.name != AppRoutes.expenseChartScreen) {
    Navigator.pushNamed(context, AppRoutes.expenseChartScreen);
  }
  }
  void onTapImgIconsList(BuildContext context) {
      Navigator.pushNamed(context, AppRoutes.listScreen);
  }

  void onTapImgIconsMaleUserFortyEight(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.profileScreen);
  }

Widget _buildRowWithImages(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 60.0), // Adjust the horizontal padding as needed
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            onTapImgIconsRs(context);
          },
          child: CustomImageView(
            imagePath: ImageConstant.imgIcons8Rupees48,
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
      ].map((widget) => Flexible(child: widget)).toList(),
    ),
  );
}

void main() {
  runApp(MaterialApp(
    home: ExpenseChartScreen(),
  ));
}
}
