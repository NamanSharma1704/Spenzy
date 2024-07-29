import 'package:flutter/material.dart';
import 'package:spenzy/presentation/login_screen/login_screen.dart';
import 'package:spenzy/presentation/signup_screen/signup_screen.dart';
import 'package:spenzy/presentation/profile_screen/profile_screen.dart';
import 'package:spenzy/presentation/list_screen/list_screen.dart';
import 'package:spenzy/presentation/expense_chart_screen/expense_chart_screen.dart';
import 'package:spenzy/presentation/app_navigation_screen/app_navigation_screen.dart';
import 'package:spenzy/presentation/add_expense_screen/add_expense_screen.dart';
import 'package:spenzy/presentation/reset_password_screen/reset_password_screen.dart';
import 'package:spenzy/presentation/borrowed_money/borrowed_money.dart';
import 'package:spenzy/presentation/transaction_screen/transaction_screen.dart';
import 'package:spenzy/presentation/transaction_screen/subtransaction_screen.dart';

class AppRoutes {
  static const String loginScreen = '/login_screen';
  static const String signupScreen = '/signup_screen';
  static const String profileScreen = '/profile_screen';
  static const String listScreen = '/list_screen';
  static const String expenseChartScreen = '/expense_chart_screen';
  static const String expenseStatScreen = '/expense_stat_screen';
  static const String appNavigationScreen = '/app_navigation_screen';
  static const String addExpenseScreen = '/add_expense_screen';
  static const String resetPasswordScreen = '/create_reset_password_screen';
  static const String borrowedMoneyScreen = '/create_borrowed_money_screen';
  static const String transactionScreen = '/transaction_screen';
  static const String subtransactionScreen = '/subtransaction_screen';


  static Map<String, WidgetBuilder> routes = {
    loginScreen: (context) => LoginScreen(),
    signupScreen: (context) => SignupScreen(),
    profileScreen: (context) => ProfileScreen(),
    listScreen: (context) => ListScreen(),
    expenseChartScreen: (context) => ExpenseChartScreen(),
    appNavigationScreen: (context) => AppNavigationScreen(),
    addExpenseScreen: (context) => AddExpenseScreen(),
    resetPasswordScreen: (context) => ResetPasswordScreen(),
    borrowedMoneyScreen: (context) => BorrowedMoneyPage(),
    transactionScreen: (context) => TransactionScreen(uid:''),
  };
}
