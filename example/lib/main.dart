import 'package:flutter/material.dart';

import 'package:mercado_pago/mercado_pago.dart';

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
  /*
  * Auth https://www.mercadopago.com/mpe/account/credentials
  */
  final credentials = MercadoCredentials(
      publicKey: 'TEST-98041829-8c47-4c6a-9c23-7b6e1855f31d',
      accessToken:
          'TEST-3029117202042245-103104-2fd0688859e43720378e5ed1043114f4__LC_LB__-182447115');

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
                MercadoPago(credentials)
                    .newUser(
                        firstname: 'Brian',
                        lastName: 'Castillo',
                        email: 'brian@castillo5.com')
                    .then((responseObject) {
                  if (responseObject.isSuccessful) {
                    print('user created with id = [ ${responseObject.data} ]');
                  } else {
                    print(
                        'catchError with errorCode = [ ${responseObject.errorCode} ]');
                  }
                });
              },
              child: Text('New User'),
            ),
            RaisedButton(
              onPressed: () {
                MercadoPago(credentials)
                    .newCard(
                        code: '333',
                        year: '2020',
                        month: 9,
                        card: '4009175332806176',
                        docNumber: '85695236',
                        docType: 'DNI')
                    .then((responseObject) {
                  print("responseObject => $responseObject");
                });
              },
              child: Text('New Card'),
            ),
            RaisedButton(
              onPressed: () {
                /* MercadoPago(credentials)
                    .associateCardWithUser(
                        user: '387744186-Zw0inDybbSCugR',
                        card: '453c47432aabcf01c7923c6a52060a17')
                    .then((responseObject) {
                  print("responseObject => $responseObject");
                }); */

                MercadoPago(credentials)
                    .getCardsFromUser(user: '387744186-Zw0inDybbSCugR')
                    .then((responseObject) {
                  print("cards => ${responseObject.data}");
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
