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
  static const String _base_url = 'https://api.mercadopago.com';

  final MercadoCredentials _mercadoCredentials;

  // getters of credentials
  String get _publicKey => _mercadoCredentials.publicKey;
  String get _accessToken => _mercadoCredentials.accessToken;

  MercadoPago(this._mercadoCredentials);

  // same process of response
  Future<MercadoObject> _response(
    dynamic response, {
    int customSuccessCode = 201,
  }) async {
    /// decode response
    var jsonBody = json.decode(response.body);

    MercadoObject responseObject = MercadoObject();
    responseObject.isSuccessful = true;
    responseObject.data = jsonBody;

    /// if error
    if (response.statusCode != customSuccessCode) {
      responseObject.isSuccessful = false;

      try {
        responseObject.errorCode = jsonBody["cause"][0]["code"];
      } //
      catch (_) {
        responseObject.errorCode = response.statusCode.toString();
      }
    }

    return responseObject;
  }

  // http get without body
  Future<MercadoObject> _get(
    String url, {
    int customSuccessCode = 201,
  }) async {
    var response = await http.get(url);

    return _response(response, customSuccessCode: customSuccessCode);
  }

  // http post with body
  Future<MercadoObject> _post(
    String url,
    dynamic body, {
    int customSuccessCode = 201,
  }) async {
    var response = await http.post(url, body: json.encode(body));

    return _response(response, customSuccessCode: customSuccessCode);
  }

  Future<MercadoObject> documentTypes() async {
    final url = '$_base_url/v1/identification_types?access_token=$_accessToken';

    return await _get(url, customSuccessCode: 200);
  }

  Future<MercadoObject> newUser({
    @required String firstname,
    @required String lastName,
    @required String email,
    @required String documentType,
    @required String documentNumber,
  }) async {
    final url = '$_base_url/v1/customers?access_token=$_accessToken';

    var body = {
      'email': email,
      'first_name': firstname,
      'last_name': lastName,
      'identification': {
        'type': documentType,
        'number': documentNumber,
      },
    };

    return await _post(url, body);
  }

  Future<MercadoObject> getUser(String userId) async {
    final url = '$_base_url/v1/customers/$userId?access_token=$_accessToken';

    return await _get(url);
  }

  Future<MercadoObject> newCard({
    @required String code,
    @required String year,
    @required int month,
    @required String card,
    @required String documentType,
    @required String documentNumber,
    @required String fullName,
  }) async {
    final url = '$_base_url/v1/card_tokens?public_key=$_publicKey';

    var body = {
      'security_code': code,
      'expiration_year': year,
      'expiration_month': month,
      'card_number': card,
      'cardholder': {
        'identification': {
          'number': documentNumber,
          'type': documentType,
        },
        'name': fullName
      }
    };

    return await _post(url, body);
  }

  Future<MercadoObject> associateCardWithUser({
    @required String user,
    @required String card,
  }) async {
    final url =
        '$_base_url/v1/customers/$user/cards?access_token=$_accessToken';

    var body = {'token': card};

    return await _post(url, body);
  }

  Future<MercadoObject> cardsFromUser({
    @required String user,
  }) async {
    final url =
        '$_base_url/v1/customers/$user/cards?access_token=$_accessToken';

    return await _get(url, customSuccessCode: 200);
  }

  Future<MercadoObject> tokenWithCard({
    @required String code,
    @required String card,
  }) async {
    final url = '$_base_url/v1/card_tokens?public_key=$_publicKey';

    var body = {'security_code': code, 'cardId': card};

    return await _post(url, body);
  }

  Future<MercadoObject> createPayment({
    @required double total,
    @required String cardToken,
    @required String description,
    @required String paymentMethod,
    @required String userId,
    @required String email,
  }) async {
    final url = '$_base_url/v1/payments?access_token=$_accessToken';

    var body = {
      'token': cardToken,
      'transaction_amount': total,
      'description': description,
      'installments': 1,
      'payment_method_id': paymentMethod,
      'payer': {
        'id': userId,
        'email': email,
      },
    };

    return await _post(url, body);
  }
}

typedef RewriteResponse = Map Function(dynamic jsonBody);
