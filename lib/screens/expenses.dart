import 'dart:convert';
import 'dart:io';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/widgets/new_expenses/new_expenses.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Expenses extends StatefulWidget {
  @override
  const Expenses({super.key});
  @override
  State<Expenses> createState() {
    return _StateExpenses();
  }
}

class _StateExpenses extends State<Expenses> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  List<Expense> expenseList = [];
  String? emptyList;
  @override
  Widget build(context) {
    Widget mainContent = const Center(
      child: Text("No expenses found. Start adding some!"),
    );
    if (expenseList.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: expenseList,
        onRemoveExpense: _removeExpense,
      );
    }
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter expense tracker"),
        actions: [
          IconButton(
              onPressed: () {
                _openAddExpenseOverlay();
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      body: width < 600
          ? (emptyList == null
              ? (expenseList.isNotEmpty
                  ? Column(
                      children: [
                        Chart(expenses: expenseList),
                        Expanded(child: mainContent),
                      ],
                    )
                  : const Center(
                      child: CupertinoActivityIndicator(),
                    ))
              : Center(
                  child: Text(emptyList ?? 'sagar'),
                ))
          : emptyList == null
              ? (expenseList.isNotEmpty
                  ? (Row(
                      children: [
                        Expanded(child: Chart(expenses: expenseList)),
                        Expanded(child: mainContent),
                      ],
                    ))
                  : const Center(
                      child: CupertinoActivityIndicator(),
                    ))
              : Center(
                  child: Text(emptyList ?? 'sagar'),
                ),
    );
  }

  void _openAddExpenseOverlay() async {
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        elevation: 16,
        showDragHandle: false,
        builder: (ctx) {
          return NewExpenses(
            onAddExpense: _addExpense,
            updateData: getData(),
          );
        });
  }

  void _addExpense(Expense expense) {
    setState(() {
      expenseList.add(expense);
    });
  }

  Future<void> getData() async {
    try {
      final url = Uri.https(
          "new-learning-6b8f4-default-rtdb.asia-southeast1.firebasedatabase.app",
          "new_expenses.json");
      final response = await http.get(url);
      if (response.body == 'null') {
        setState(() {
          emptyList = "this is empty list";
        });
      }
      final Map<String, dynamic> data = jsonDecode(response.body);

      // print(data);
      expenseList.clear();
      for (var item in data.entries) {
        Map<String, Category> categoryMap = {
          "food": Category.food,
          "leisure": Category.leisure,
          "travel": Category.travel,
          "work": Category.work,
        };
        expenseList.add(Expense(
          title: item.value['title'] as String,
          amount: double.parse(item.value['amount'].toString()),
          date: DateTime.parse(item.value['date']),
          category: categoryMap[item.value['category']]!,
          id: item.key,
        ));
        setState(() {
          debugPrint("set state is applied here");
        });
      }
    } on SocketException {
      debugPrint("not internet ");
    } catch (e) {
      debugPrint("some exceptions got: $e");
    }
  }

  void _removeExpense(Expense expense) async {
    try {
      final url = Uri.https(
          "new-learning-6b8f4-default-rtdb.asia-southeast1.firebasedatabase.app",
          "new_expenses/${expense.id}.json");
      await http.delete(url);
      expenseList.remove(expense);
      setState(() {
        if (expenseList.isEmpty) {
          emptyList = "This is now empty!";
        }
      });
    } catch (e) {
      if (!mounted) return;
      debugPrint("cant deleted");
    }

    // ScaffoldMessenger.of(context).clearSnackBars();
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //   duration: const Duration(seconds: 3),
    //   content: Text("Expenses deleted"),
    //   action: SnackBarAction(
    //       label: "Undo",
    //       onPressed: () {
    //         setState(() {
    //           expenseList.insert(expenseIndex, expense);
    //         });
    //       }),
    // ));
  }
}
