import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionForm extends StatefulWidget {
  final void Function(String, double, DateTime) onSubmit;

  TransactionForm(this.onSubmit);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  void _submitForm() {
    final title = _titleController.text;
    final value = double.tryParse(this._valueController.text) ?? 0.0;

    if (title.isEmpty || value <= 0 || this._selectedDate == null) return;

    this.widget.onSubmit(title, value, this._selectedDate);
  }

  _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((DateTime pickedDate) {
      if (pickedDate != null) {
        setState(() {
          this._selectedDate = pickedDate;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              TextField(
                controller: this._titleController,
                decoration: InputDecoration(labelText: 'Título'),
                onSubmitted: (_) => this._submitForm(),
              ),
              TextField(
                controller: this._valueController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: "Valor (R\$)"),
                onSubmitted: (_) => this._submitForm(),
              ),
              Container(
                height: 70,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(this._selectedDate == null
                          ? 'Nenhuma data selecionada'
                          : "Data Selecionada: ${DateFormat('dd/MM/y').format(this._selectedDate)}"),
                    ),
                    FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      child: Text(
                        'Selecionar Data',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: this._showDatePicker,
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  RaisedButton(
                    color: Theme.of(context).primaryColor,
                    child: Text(
                      'Nova Transação',
                    ),
                    textColor: Theme.of(context).textTheme.button.color,
                    onPressed: this._submitForm,
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
