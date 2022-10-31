import 'package:flutter/services.dart';

import './widgets/new_transaction.dart';
import 'package:flutter/material.dart';
import './widgets/transaction_list.dart';
import './model/transations.dart';
import './widgets/chart.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //   [DeviceOrientation.portraitUp,
  //     DeviceOrientation.portraitDown
  //   ]
  // );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.green, fontFamily: 'Ubuntu'),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransaction = [
    // Transaction(
    //     id: "01", amount: 50.50, title: 'New Shoes', date: DateTime.now()),
    // Transaction(
    //     id: "02",
    //     amount: 50.50,
    //     title: 'Weekly grocercies',
    //     date: DateTime.now()),
  ];

  bool _showChart = false;

  List<Transaction> get _recentTransaction {
    return _userTransaction.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
        title: txTitle,
        amount: txAmount,
        date: chosenDate,
        id: DateTime.now().toString());

    setState(() {
      _userTransaction.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
              onTap: () {},
              behavior: HitTestBehavior.opaque,
              child: NewTransaction(_addNewTransaction));
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransaction.removeWhere((tx) {
        return tx.id == id;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final appBar = AppBar(
      toolbarHeight: 60,
      actionsIconTheme: IconThemeData(size: 40),
      actions: [
        IconButton(
            onPressed: () {
              return _startAddNewTransaction(context);
            },
            icon: Icon(Icons.add))
      ],
      title: const Text("Expense Planner"),
    );

    final txListWidget = Container(
        height: (MediaQuery.of(context).size.height -
                appBar.preferredSize.height -
                MediaQuery.of(context).padding.top) *
            0.7,
        child: TransactionList(_userTransaction, _deleteTransaction));

        final mediaQuery = MediaQuery.of(context);

    return SafeArea(
      child: Scaffold(
        appBar: appBar,
        body: SingleChildScrollView(
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (isLandscape)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Show Chart'),
                      Switch(
                          value: _showChart,
                          onChanged: (val) {
                            setState(() {
                              _showChart = val;
                            });
                          })
                    ],
                  ),
                if (!isLandscape)
                  Container(
                      height: (mediaQuery.size.height -
                              appBar.preferredSize.height -
                              MediaQuery.of(context).padding.top) *
                          0.3,
                      child: Chart(_recentTransaction)),
                if (!isLandscape) txListWidget,
                if (isLandscape)
                  _showChart
                      ? Container(
                          height: (MediaQuery.of(context).size.height -
                                  appBar.preferredSize.height -
                                  MediaQuery.of(context).padding.top) *
                              0.3,
                          child: Chart(_recentTransaction))
                      : txListWidget,
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          // backgroundColor: Colors.purple,
          child: Icon(Icons.add),
          onPressed: () {
            return _startAddNewTransaction(context);
          },
        ),
      ),
    );
  }
}
