library mercado_pago;

import 'package:http/http.dart' as http;

import 'dart:convert';
import 'dart:async';

import 'package:mercado_pago/mercado_object.dart';

/*
 * Auth https://www.mercadopago.com/mpe/account/credentials
 */
class MercadoPago {

  static const _base_url = 'https://api.mercadopago.com';

  static const _public_key = 'TEST-98041829-8c47-4c6a-9c23-7b6e1855f31d';
  static const _access_token = 'TEST-3029117202042245-103104-2fd0688859e43720378e5ed1043114f4__LC_LB__-182447115';
  
  static Future<MercadoObject> newUser({String firstname, String lastName, String email}) async {
    final url = '$_base_url/v1/customers?access_token=$_access_token';

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
      responseObject.data = {
        'id': jsonBody['id']
      };
    }
    else {
      int errorCode = int.tryParse(jsonBody["cause"][0]["code"]) ?? 404;

      if (errorCode == 101) {
        errorCode = 409;
      }
      
      responseObject.isSuccessful = false;
      responseObject.errorCode = errorCode;
    }

    return responseObject;
  }

  static Future<MercadoObject> newCard({
    String code,
    String year,
    int month,
    String card,
    String docNumber,
    String docType,
  }) async {
    final url = '$_base_url/v1/card_tokens?public_key=$_public_key';

    var body = {
      'security_code': code,
      'expiration_year': year,
      'expiration_month': month,
      'card_number': card,
      'cardholder': {
        'identification': {
          'number': docNumber,
          'type': docType
        },
        'name': 'WIBO-CARD'
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
    }
    else {
      responseObject.isSuccessful = false;
      responseObject.errorCode = 404;
    }

    return responseObject;
  }
}