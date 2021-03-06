import 'dart:math';

import 'package:expenses/components/TransactionList.dart';
import 'package:flutter/material.dart';
import 'package:expenses/components/TransactionForm.dart';
import 'package:expenses/models/Transaction.dart';
import 'package:flutter/services.dart';

import 'components/Chart.dart';

void main() => runApp(ExpensesApp());

class ExpensesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.teal,
        accentColor: Colors.teal,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              button:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = [
    Transaction(
        id: 't1',
        title: 'Conta de Luz',
        value: 63.72,
        date: DateTime.now().subtract(Duration(days: 1))),
    Transaction(
        id: 't2',
        title: 'Conta de Internet',
        value: 89.99,
        date: DateTime.now().subtract(Duration(days: 2))),
    Transaction(
        id: 't3',
        title: 'iFood',
        value: 89.99,
        date: DateTime.now().subtract(Duration(days: 2))),
    Transaction(
        id: 't4',
        title: 'Uber',
        value: 25.12,
        date: DateTime.now().subtract(Duration(days: 3))),
    Transaction(
        id: 't5',
        title: 'Boleto Faculdade 12/12',
        value: 599.99,
        date: DateTime.now().subtract(Duration(days: 4))),
  ];
  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return this._transactions.where((transaction) {
      return transaction.date.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));
    }).toList();
  }

  void _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
    );
    setState(() {
      this._transactions.add(newTransaction);
    });

    Navigator.of(this.context).pop();
  }

  void _deleteTransaction(String id) {
    setState(() {
      this._transactions.removeWhere((transaction) => transaction.id == id);
    });
  }

  void _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return TransactionForm(this._addTransaction);
        });
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text('Despesas Pessoais'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => this._openTransactionFormModal(context),
        )
      ],
    );

    final availableHeight = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Exibir Gráfico'),
                Switch(
                  value: this._showChart,
                  onChanged: (value) {
                    setState(() {
                      this._showChart = value;
                    });
                  },
                ),
              ],
            ),
            if (this._showChart)
              Container(
                height: availableHeight * 0.3,
                child: Chart(this._recentTransactions),
              ),
            if (!this._showChart)
              Container(
                height: availableHeight * 0.7,
                child: TransactionList(
                  this._transactions,
                  this._deleteTransaction,
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => this._openTransactionFormModal(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
