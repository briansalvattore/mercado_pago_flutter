import 'package:meta/meta.dart' show required;

class MercadoCredentials {
  String publicKey;
  String accessToken;

  MercadoCredentials({
    @required this.publicKey, 
    @required this.accessToken
  });
}
