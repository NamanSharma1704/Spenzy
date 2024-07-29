// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spenzy/presentation/add_expense_screen/category_data.dart';
import 'package:spenzy/core/app_export.dart';
import 'package:spenzy/presentation/list_screen/category_transactions_screen.dart';
import 'package:spenzy/widgets/custom_search_view.dart';

class ListScreen extends StatefulWidget {
 const ListScreen({Key? key}) : super(key: key);

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  String searchText = '';
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text('Category List ', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.0),
            CustomSearchView(
              hintText: "Search ",
              prefix: Icon(Icons.search, color: Colors.white),
              onChanged: (value) {
                setState(() {
                  searchText = value.toLowerCase();
                });
              }, controller: searchController,
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF1D1F2C),
                  borderRadius: BorderRadius.circular(13.0),
                  border: Border.all(color: appTheme.tealA400, width: 1.0),
                ),
                child: Column(
                  children: [
                    _buildTopCategoryWidget(),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.0),
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

  Widget _buildTopCategoryWidget() {
    return SizedBox(
      width: 400, // Specify the desired width here
      child: Column(
        children: [
          Text(
            'Top Category',
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('expenses').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              Map<String, double> categoryAmounts = {};

              for (var document in snapshot.data!.docs) {
                String? category = document['category'];

                if (category != null && category.toLowerCase().contains(searchText)) {
                  categoryAmounts[category] = (categoryAmounts[category] ?? 0.0) + 1;
                }
              }

              var sortedCategories = categoryAmounts.entries.toList()
                ..sort((a, b) => b.value.compareTo(a.value));

              List<Widget> rows = [];
              List<Widget> currentRow = [];

              for (var entry in sortedCategories) {
                String category = entry.key;
                IconData icon = categoryData[category]?['icon'] ?? Icons.category;

                currentRow.add(_buildCategoryItem(icon, category));

                if (currentRow.length == 3) {
                  rows.add(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List<Widget>.from(currentRow),
                    ),
                  );
                  rows.add(SizedBox(height: 20));
                  currentRow.clear();
                }
              }

              if (currentRow.isNotEmpty) {
                rows.add(
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List<Widget>.from(currentRow),
                  ),
                );
                rows.add(SizedBox(height: 20));
              }

              return Column(
                children: List<Widget>.from(rows),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(IconData icon, String name) {
    Color color = categoryData[name]?['color'] ?? Colors.grey;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryTransactionsScreen(category: name),
          ),
        );
      },
      child: Column(
        children: [
          Icon(icon, color: color, size: 30),
          SizedBox(height: 5),
          Text(name, style: TextStyle(color: Colors.white)),
          SizedBox(height: 5), // Adjust the height as needed
        ],
      ),
    );
  }

  void onTapImgIconsHome(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.expenseChartScreen);
  }

  void onTapImgIconsRs(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.borrowedMoneyScreen);
  }

  void onTapImgIconsMaleUserFortyEight(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.profileScreen);
  }

  Widget _buildRowWithImages(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
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
            onTapImgIconsRs(context);
          },
          child: CustomImageView(
            imagePath: ImageConstant.imgIcons8Rupees48,
            height: 28,
            width: 28,
          ),
        ),
      ],
    );
  }
}
