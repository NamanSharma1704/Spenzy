import 'package:flutter/material.dart';
import 'package:spenzy/core/app_export.dart';
import 'package:spenzy/widgets/custom_search_view.dart';

class ListScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SizedBox(
          width: SizeUtils.width,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 23.v),
                _buildRowWithListAndEditText(context),
                SizedBox(height: 21.v),
                Padding(
                  padding: EdgeInsets.only(left: 10.h, right: 12.h),
                  child: CustomSearchView(
                    controller: searchController,
                    hintText: "Search text",
                  ),
                ),
                SizedBox(height: 22.v),
                Container(
                  height: 441.v,
                  width: 338.h,
                  decoration: BoxDecoration(
                    color: appTheme.gray900.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(13.h),
                    border: Border.all(color: appTheme.tealA400, width: 1.h),
                  ),
                ),
                SizedBox(height: 13.v),
                _buildRowWithImages(context),
                SizedBox(height: 20.v), // Add some space at the bottom
              ],
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomBar(context),
      ),
    );
  }

  Widget _buildRowWithListAndEditText(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 17.h), // Adjust padding here
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
            ),
            child: Text("List Name"),
          ),
          Expanded( // Wrap TextFormField with Expanded to fill available space
            child: Padding(
              padding: EdgeInsets.only(left: 12.h), // Add some spacing
              child: TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: "Name",
                  hintStyle: theme.textTheme.bodyMedium!,
                  prefix: Container(
                    margin: EdgeInsets.fromLTRB(10.h, 9.v, 9.h, 9.v),
                    child: CustomImageView(
                      imagePath: ImageConstant.imgSave,
                      height: 11.v,
                      width: 13.h,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 6.v), // Adjust padding
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRowWithImages(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 17.h), // Adjust padding here
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgIcons8Home482,
            height: 48.adaptSize,
            width: 48.adaptSize,
            margin: EdgeInsets.only(bottom: 3.v),
            onTap: () {
              onTapImgIconsHome(context);
            },
          ),
          CustomImageView(
            imagePath: ImageConstant.imgIcons8MaleUser48,
            height: 48.adaptSize,
            width: 48.adaptSize,
            margin: EdgeInsets.only(bottom: 1.v),
            onTap: () {
              onTapImgIconsMaleUserFortyEight(context);
            },
          ),
          CustomImageView(
            imagePath: ImageConstant.imgIcons8List481,
            height: 48.adaptSize,
            width: 48.adaptSize,
            margin: EdgeInsets.only(bottom: 3.v),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: appTheme.gray900.withOpacity(0.9)),
    );
  }

  void onTapImgIconsHome(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.expenseChartScreen);
  }

  void onTapImgIconsMaleUserFortyEight(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.profileScreen);
  }
}
