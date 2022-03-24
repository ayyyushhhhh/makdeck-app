import 'package:makdeck/models/Cart/cart_product.dart';

enum OrderStatus {
  pending,
  processing,
  shipped,
  delivered,
  cancelled,
}

enum PaymentMethod {
  cashOnDelivery,
  prepaid,
}

class OrderModel {
  String orderid;
  List<CartProductModel> cartproducts;
  String userUID;
  String userEmail;
  String userPhone;
  String userAddress;
  double paymentAmount;
  String trackingID;
  String orderStatus;
  String orderDate;
  String orderTime;
  String paymentMethod;
  String pincode;
  String city;
  String state;

  OrderModel({
    required this.orderid,
    required this.cartproducts,
    required this.userUID,
    required this.userEmail,
    required this.userPhone,
    required this.userAddress,
    required this.paymentAmount,
    required this.trackingID,
    required this.orderStatus,
    required this.orderDate,
    required this.orderTime,
    required this.paymentMethod,
    required this.pincode,
    required this.city,
    required this.state,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      orderid: map['orderid'],
      cartproducts: (map['cartproducts'] as List)
          .map((e) => CartProductModel.fromMap(e))
          .toList(),
      userUID: map['userUID'],
      userEmail: map['userEmail'],
      userPhone: map['userPhone'],
      userAddress: map['userAddress'],
      paymentAmount: map['paymentAmount'],
      trackingID: map['trackingID'],
      orderStatus: map['orderStatus'],
      orderDate: map['orderDate'],
      orderTime: map['orderTime'],
      paymentMethod: map['paymentMethod'],
      city: map['city'],
      pincode: map['pincode'],
      state: map['state'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderid': orderid,
      'cartproducts': cartproducts.map((e) => e.toMap()).toList(),
      'userUID': userUID,
      'userEmail': userEmail,
      'userPhone': userPhone,
      'userAddress': userAddress,
      'paymentAmount': paymentAmount,
      'trackingID': trackingID,
      'orderStatus': orderStatus,
      'orderDate': orderDate,
      'orderTime': orderTime,
      'paymentMethod': paymentMethod,
      'city': city,
      'pincode': pincode,
      'state': state,
    };
  }
}
