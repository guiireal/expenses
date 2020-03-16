import 'package:flutter/material.dart';
import 'package:expenses/models/Transaction.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransaction;

  Chart(this.recentTransaction);

  List<Map<String, Object>> get groupedTransactions {
    return List.generate(7, (index) {
      final DateTime weekDay = DateTime.now().subtract(Duration(days: index));

      double totalSum = 0.0;

      for (int i = 0; i < this.recentTransaction.length; i++) {
        bool sameDay = this.recentTransaction[i].date.day == weekDay.day;
        bool sameMonth = this.recentTransaction[i].date.month == weekDay.month;
        bool sameYear = this.recentTransaction[i].date.year == weekDay.year;
        if (sameDay && sameMonth && sameYear)
          totalSum += this.recentTransaction[i].value;
      }

      return {
        'day': DateFormat.E().format(weekDay)[0],
        'value': totalSum,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Row(
        children: this.groupedTransactions.map((transaction) {
          return Text("${transaction['day']}: ${transaction['value']}");
        }).toList(),
      ),
    );
  }
}
