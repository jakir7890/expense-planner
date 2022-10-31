import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;
  NewTransaction(this.addTx);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime selectedDate;

  void _submitData() {
    if (_amountController.text.isEmpty) {
      return;
    }

    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || selectedDate == null) {
      return;
    }

    widget.addTx(enteredTitle, enteredAmount, selectedDate);

    Navigator.of(context).pop();
  }

  void presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2022),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                onSubmitted: (_) => _submitData(),
                controller: _titleController,
                decoration: InputDecoration(hintText: "Title"),
              ),
              TextField(
                onSubmitted: (_) => _submitData(),
                keyboardType: TextInputType.number,
                // keyboardType: TextInputType.numberWithOptions(decimal: true),
                controller: _amountController,
                decoration: InputDecoration(hintText: "Amount"),
              ),
              Container(
                height: 60,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(selectedDate == null
                          ? 'No Date Chosen!'
                          : 'Picked Date:  ${DateFormat.yMd().format(selectedDate)}'),
                    ),
                    TextButton(
                        onPressed: presentDatePicker,
                        child: Text(
                          'Chose Date',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
              ),
              ElevatedButton(
                  onPressed: _submitData,
                  child: Text(
                    "Add Transaction",
                    style:
                        TextStyle(color: Theme.of(context).bottomAppBarColor),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
