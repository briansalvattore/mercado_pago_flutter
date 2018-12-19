class MercadoObject {
  bool isSuccessful;
  Map data;
  int errorCode;

  MercadoObject({this.isSuccessful, this.data, this.errorCode});

  @override
  String toString() => 'isSuccessful=$isSuccessful, data=$data, errorCode=$errorCode';
}
