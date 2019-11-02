// Copyright (c) 2018, codegrue. All rights reserved. Use of this source code
// is governed by the MIT license that can be found in the LICENSE file.
import 'dart:convert';
import 'dart:async';

import 'package:flutter/foundation.dart' show required;
import 'package:http/http.dart' as http;

import 'credentials.dart';
import 'model.dart';

// Core of library
class MercadoPago {

  // base url
  static const _base_url = 'https://api.mercadopago.com';

  final MercadoCredentials _mercadoCredentials;

  // getters of credentials
  String get _publicKey => _mercadoCredentials.publicKey;
  String get _accessToken => _mercadoCredentials.accessToken;

  MercadoPago(this._mercadoCredentials);

  // same process of response
  Future<MercadoObject> _response(dynamic response, {int statusCode = 201, RewriteResponse rewriteResponse}) async {

    /// decode response
    var jsonBody = json.decode(response.body);

    MercadoObject responseObject = MercadoObject();
    responseObject.isSuccessful = true;

    /// if success on body
    if (rewriteResponse != null) {
      responseObject.data = rewriteResponse(jsonBody);
    }
    else {
      responseObject.data = {'id': jsonBody['id']};
    }
    
    /// if error
    if (response.statusCode != statusCode) {
      int errorCode = jsonBody["status"] ?? 404;

      responseObject.isSuccessful = false;
      responseObject.errorCode = errorCode;
      responseObject.data = jsonBody;
    }

    return responseObject;
  }

  // http get without body
  Future<MercadoObject> _get(String url, {int statusCode = 201, RewriteResponse rewriteResponse}) async {
    var response = await http.get(url);

    return _response(response, statusCode: statusCode, rewriteResponse: rewriteResponse);
  }

  // http post with body
  Future<MercadoObject> _post(String url, dynamic body, {int statusCode = 201, RewriteResponse rewriteResponse}) async {
    var response = await http.post(url, body: json.encode(body));

    return _response(response, statusCode: statusCode, rewriteResponse: rewriteResponse);
  }

  Future<MercadoObject> newUser({
    @required String firstname, 
    @required String lastName, 
    @required String email
  }) async {
    final url = '$_base_url/v1/customers?access_token=$_accessToken';

    var body = {
      'email': email,
      'first_name': firstname,
      'last_name': lastName,
    };

    return await _post(url, body);
  }

  Future<MercadoObject> newCard({
    @required String code,
    @required String year,
    @required int month,
    @required String card,
    @required String docNumber,
    @required String docType,
    @required String name,
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

    return await _post(url, body, rewriteResponse: (jsonBody) => {
      'id': jsonBody['id'],
      'key': jsonBody['public_key']
    });
  }

  Future<MercadoObject> associateCardWithUser({
    @required String user, 
    @required String card
  }) async {
    final url = '$_base_url/v1/customers/$user/cards?access_token=$_accessToken';

    var body = {
      'token': card
    };

    return await _post(url, body);
  }

  Future<MercadoObject> cardsFromUser({
    @required String user
  }) async {
    final url = '$_base_url/v1/customers/$user/cards?access_token=$_accessToken';

    return await _get(url, statusCode: 200, rewriteResponse: (jsonBody) => {
      'cards': jsonBody
    });
  }

  Future<MercadoObject> tokenWithCard({
    @required String code, 
    @required String card
  }) async {
    final url = '$_base_url/v1/card_tokens?public_key=$_publicKey';

    var body = {
      'security_code': code,
      'cardId': card
    };
    
    return await _post(url, body);
  }

  Future<MercadoObject> createPayment({
    @required double total, 
    @required String cardToken,
    @required String description,
    @required String paymentMethod,
    @required String userId,
    @required String email
  }) async {
    final url = '$_base_url/v1/payments?access_token=$_accessToken';

    var body = {
      'transaction_amount': total,
      'token': cardToken,
      'description': description,
      'installments': 1,
      'payment_method_id': paymentMethod,
      'payer': {
        'id': userId,
        'email': email
      },
    };

    return await _post(url, body, rewriteResponse: (jsonBody) => jsonBody);
  }
}

typedef RewriteResponse = Map Function(dynamic jsonBody);
