library mercado_pago;

class MercadoObject {

  bool isSuccessful;
  Map data;
  int errorCode;

  MercadoObject({
    this.isSuccessful, this.data, this.errorCode
  });
}