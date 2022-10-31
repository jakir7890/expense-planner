import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/transations.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transction;
  final Function deleteTx;

  TransactionList(this.transction, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return transction.isEmpty
          ? Column(
              children: [
                Text(
                  "No transaction added yet".toUpperCase(),
                  style: TextStyle(
                      fontFamily: 'Ubuntu', fontWeight: FontWeight.w700),
                ),
                Spacer(),
                Container(
                  height: 200,
                  child: Image.asset(
                    "assets/images/waiting.png",
                    fit: BoxFit.cover,
                  ),
                ),
                Spacer(
                  flex: 4,
                )
              ],
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  elevation: 5,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: FittedBox(
                            child: Text('\$${transction[index].amount}')),
                      ),
                    ),
                    title: Text(
                      '${transction[index].title}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    subtitle:
                        Text(DateFormat.yMMMd().format(transction[index].date)),
                    trailing: Container(
                      height: 50,
                      width: 50,
                      child: Card(
                        elevation: 3,
                        child: IconButton(
                          onPressed:() => deleteTx(transction[index].id),
                          icon: Icon(
                            Icons.delete,
                            color: Theme.of(context).errorColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              itemCount: transction.length,
            );
    
  }
}
