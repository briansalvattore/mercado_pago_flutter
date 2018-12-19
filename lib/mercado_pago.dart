library mercado_pago;

import 'package:http/http.dart' as http;

import 'dart:convert';
import 'dart:async';

class MercadoPago {
  static const _base_url = 'https://api.mercadopago.com';

  final MercadoCredentials _mercadoCredentials;

  String get _publicKey => _mercadoCredentials.publicKey;
  String get _accessToken => _mercadoCredentials.accessToken;

  MercadoPago(this._mercadoCredentials);

  Future<MercadoObject> newUser({
    String firstname, 
    String lastName, 
    String email
  }) async {
    final url = '$_base_url/v1/customers?access_token=$_accessToken';

    var body = {
      'email': email,
      'first_name': firstname,
      'last_name': lastName,
    };

    var response = await http.post(url, body: json.encode(body));

    var jsonBody = json.decode(response.body);

    MercadoObject responseObject = MercadoObject();

    if (response.statusCode == 201) {
      responseObject.isSuccessful = true;
      responseObject.data = {'id': jsonBody['id']};
    } else {
      int errorCode = int.tryParse(jsonBody["cause"][0]["code"]) ?? 404;

      if (errorCode == 101) {
        errorCode = 409;
      }

      responseObject.isSuccessful = false;
      responseObject.errorCode = errorCode;
    }

    return responseObject;
  }

  Future<MercadoObject> newCard({
    String code,
    String year,
    int month,
    String card,
    String docNumber,
    String docType,
    String name,
  }) async {
    final url = '$_base_url/v1/card_tokens?public_key=$_publicKey';

    var body = {
      'security_code': code,
      'expiration_year': year,
      'expiration_month': month,
      'card_number': card,
      'cardholder': {
        'identification': {'number': docNumber, 'type': docType},
        'name': name
      }
    };

    var response = await http.post(url, body: json.encode(body));

    var jsonBody = json.decode(response.body);

    MercadoObject responseObject = MercadoObject();

    if (response.statusCode == 201) {
      responseObject.isSuccessful = true;
      responseObject.data = {
        'id': jsonBody['id'],
        'key': jsonBody['public_key']
      };
    } else {
      responseObject.isSuccessful = false;
      responseObject.errorCode = 404;
    }

    return responseObject;
  }

  Future<MercadoObject> associateCardWithUser({
    String user, 
    String card
  }) async {
    final url = '$_base_url/v1/customers/$user/cards?access_token=$_accessToken';

    var body = {
      'token': card
    };

    var response = await http.post(url, body: json.encode(body));

    var jsonBody = json.decode(response.body);

    MercadoObject responseObject = MercadoObject();

    if (response.statusCode == 201) {
      responseObject.isSuccessful = true;
      responseObject.data = {'id': jsonBody['id']};
    } else {
      responseObject.isSuccessful = false;
      responseObject.errorCode = 404;
    }

    return responseObject;
  }

  Future<MercadoObject> cardsFromUser({
    String user
  }) async {
    final url = '$_base_url/v1/customers/$user/cards?access_token=$_accessToken';

    var response = await http.get(url);

    var jsonBody = json.decode(response.body);

    MercadoObject responseObject = MercadoObject();

    if (response.statusCode == 200) {
      responseObject.isSuccessful = true;
      responseObject.data = {'cards': jsonBody};
    } else {
      responseObject.isSuccessful = false;
      responseObject.errorCode = 404;
    }

    return responseObject;
  }

  Future<MercadoObject> tokenWithCard({
    String code, 
    String card
  }) async {
    final url = '$_base_url/v1/card_tokens?public_key=$_publicKey';

    var body = {
      'security_code': code,
      'cardId': card
    };

    var response = await http.post(url, body: json.encode(body));

    var jsonBody = json.decode(response.body);

    MercadoObject responseObject = MercadoObject();

    if (response.statusCode == 201) {
      responseObject.isSuccessful = true;
      responseObject.data = {'id': jsonBody['id']};
    } else {
      responseObject.isSuccessful = false;
      responseObject.errorCode = 404;
    }

    return responseObject;
  }

  Future<MercadoObject> createPayment({
    double total, 
    String cardToken,
    String description,
    String paymentId,
    String userId,
    String email
  }) async {
    final url = '$_base_url/v1/payments?access_token=$_accessToken';

    var body = {
      'transaction_amount': total,
      'token': cardToken,
      'description': description,
      'installments': 1,
      'payment_method_id': paymentId,
      'payer': {
        'id': userId,
        'email': email
      },
    };

    var response = await http.post(url, body: json.encode(body));

    var jsonBody = json.decode(response.body);

    MercadoObject responseObject = MercadoObject();

    if (response.statusCode == 201) {
      responseObject.isSuccessful = true;
      responseObject.data = jsonBody;
    } else {
      responseObject.isSuccessful = false;
      responseObject.errorCode = 404;
    }

    return responseObject;
  }


}

class MercadoCredentials {
  String publicKey;
  String accessToken;

  MercadoCredentials({this.publicKey, this.accessToken});
}

class MercadoObject {
  bool isSuccessful;
  Map data;
  int errorCode;

  MercadoObject({this.isSuccessful, this.data, this.errorCode});

  @override
  String toString() => data.toString();
}
