// Copyright (c) 2018, codegrue. All rights reserved. Use of this source code
// is governed by the MIT license that can be found in the LICENSE file.
class MercadoObject {
  bool isSuccessful;
  Map data;
  int errorCode;

  MercadoObject({this.isSuccessful, this.data, this.errorCode});

  @override
  String toString() => 'isSuccessful=$isSuccessful, data=$data, errorCode=$errorCode';
}
