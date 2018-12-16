import 'package:flutter/material.dart';

import 'package:mercado_pago/mercado_page.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Mercado Pago Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Mercado Pago Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                MercadoPago.newUser(
                  firstname: 'Brian',
                  lastName: 'Castillo',
                  email: 'brian@castillo4.com'
                ).then((responseObject) {

                  if (responseObject.isSuccessful) {
                    print('user created with id = [ ${responseObject.data} ]');
                  }
                  else {
                    print('catchError with errorCode = [ ${responseObject.errorCode} ]');
                  }
                });
              },
              child: Text('New User'),
            ),
            
            RaisedButton(
              onPressed: () {
                MercadoPago.newCard(
                  code: '333',
                  year: '2020',
                  month: 9,
                  card: '4009175332806176',
                  docNumber: '85695236',
                  docType: 'DNI'
                ).then((responseObject) {

                  
                });
              },
              child: Text('New Card'),
            )
          ],
        ),
      ),
    );
  }
}