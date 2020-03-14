import 'package:expenses/helpers/custom_colors.dart';
import 'package:flutter/material.dart';

class TransactionForm extends StatefulWidget {
  final void Function(String, double) onSubmit;

  TransactionForm(this.onSubmit);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final TextEditingController titleController = TextEditingController();

  final TextEditingController valueController = TextEditingController();

  void _submitForm() {
    final title = titleController.text;
    final value = double.tryParse(this.valueController.text) ?? 0.0;

    if (title.isEmpty || value <= 0) return;

    this.widget.onSubmit(title, value);
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
                controller: this.titleController,
                decoration: InputDecoration(labelText: 'Título'),
                onSubmitted: (_) => this._submitForm(),
              ),
              TextField(
                controller: this.valueController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: "Valor (R\$)"),
                onSubmitted: (_) => this._submitForm(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                    child: Text('Nova Transação'),
                    textColor: CustomColors.colorPrimary,
                    onPressed: this._submitForm,
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
