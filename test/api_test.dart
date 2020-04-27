import 'package:test/test.dart';
import 'package:mercado_pago/mercado_pago.dart';

MercadoPago get mercadoPago {
  List<String> keys = [
    'TEST-98041829-8c47-4c6a-9c23-7b6e1855f31d',
    'TEST-3029117202042245-103104-2fd0688859e43720378e5ed1043114f4__LC_LB__-182447115',
  ];

  MercadoCredentials credentials = MercadoCredentials(
    publicKey: keys[0],
    accessToken: keys[1],
  );

  return MercadoPago(credentials);
}

void main() {
  test('get document types', () async {
    MercadoObject response = await mercadoPago.documentTypes();
    print(response);
  });

  test('create new user', () async {
    MercadoObject response = await mercadoPago.newUser(
      email: 'brian1@mail.com',
      firstname: 'Brian',
      lastName: 'Castillo',
      documentType: 'DNI',
      documentNumber: '12345678',
    );
    print(response);
  });

  test('get user', () async {
    String userId = '555305508-i67KHqcUTewosJ';
    MercadoObject response = await mercadoPago.getUser(userId);
    print(response);
  });

  test('create new card', () async {
    MercadoObject response = await mercadoPago.newCard(
      code: '333',
      year: '2020',
      month: 9,
      card: '4009175332806176',
      documentNumber: '12345678',
      documentType: 'DNI',
      fullName: 'APRO'
    );
    print(response);
  });

  test('associate card with user', () async {
    String cardId = 'ee6bbbee69f60990d0f68ffe108ef1ad';
    String userId = '555305508-i67KHqcUTewosJ';
    MercadoObject response = await mercadoPago.associateCardWithUser(
      user: userId,
      card: cardId,
    );
    print(response);
  });

  test('get cards for user', () async {
    String userId = '555305508-i67KHqcUTewosJ';
    MercadoObject response = await mercadoPago.cardsFromUser(
      user: userId,
    );
    print(response);
  });

  test('create card token for payment', () async {
    String cardId = '1587964933876';
    String cardCVV = '333';
    MercadoObject response = await mercadoPago.tokenWithCard(
      card: cardId,
      code: cardCVV,
    );
    print(response);
  });

  test('simple payment', () async {
    String cardToken= 'ebcc4d445e845f052f702ed7015c4d57';
    String userId = '555305508-i67KHqcUTewosJ';
    MercadoObject response = await mercadoPago.createPayment(
      total: 10.0,
      cardToken: cardToken,
      description: 'test payment',
      paymentMethod: 'visa',
      userId: userId,
      email: 'brian1@mail.com',
    );
    print(response);
  });


}
