import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:makdeck/models/Cart/cart_service.dart';
import 'package:makdeck/models/Cart/order_model.dart';
import 'package:makdeck/screens/Cart/order_confirm_screen.dart';
import 'package:makdeck/services/authentication/user_authentication.dart';
import 'package:makdeck/services/firebase/cloud_database.dart';
import 'package:makdeck/services/users/user_firebasedatabase.dart';
import 'package:makdeck/utils/ui/colors.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

// ignore: must_be_immutable
class AddressPaymentScreen extends StatefulWidget {
  final double totalPrice;

  const AddressPaymentScreen({Key? key, required this.totalPrice})
      : super(key: key);

  @override
  State<AddressPaymentScreen> createState() => _AddressPaymentScreenState();
}

class _AddressPaymentScreenState extends State<AddressPaymentScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController pincode = TextEditingController();
  TextEditingController useremail = TextEditingController();

  String orderid = "";
  String state = "Delhi";
  String userid = "";

  double totalMRP = 0;
  double totalOrigialPrice = 0;
  double discount = 0;

  PaymentMethod _paymentMethod = PaymentMethod.cashOnDelivery;
  String stringPaymentMethod = "Cash On Delivery";

  @override
  void initState() {
    super.initState();

    for (var i = 0; i < CartService.cartProducts.length; i++) {
      totalMRP += CartService.cartProducts[i].price;
      totalOrigialPrice += CartService.cartProducts[i].originalPrice;
      discount = totalOrigialPrice - totalMRP;
    }
  }

  final List<String> _dropDownItems = [
    "Andhra Pradesh",
    "Arunachal Pradesh",
    "Assam",
    "Bihar",
    "Chhattisgarh",
    "Goa",
    "Gujarat",
    "Haryana",
    "Himachal Pradesh",
    "Jammu and Kashmir",
    "Jharkhand",
    "Karnataka",
    "Kerala",
    "Madhya Pradesh",
    "Maharashtra",
    "Manipur",
    "Meghalaya",
    "Mizoram",
    "Nagaland",
    "Odisha",
    "Punjab",
    "Rajasthan",
    "Sikkim",
    "Tamil Nadu",
    "Telangana",
    "Tripura",
    "Uttarakhand",
    "Uttar Pradesh",
    "West Bengal",
    "Andaman and Nicobar Islands",
    "Chandigarh",
    "Dadra and Nagar Haveli",
    "Daman and Diu",
    "Delhi",
    "Lakshadweep",
    "Puducherry"
  ];

  Widget _buildTextContainer(
      {required TextEditingController editingController,
      required String message,
      bool isAddress = false,
      bool isNumber = false}) {
    if (isNumber == true) {
      return Container(
        padding: const EdgeInsets.all(10),
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextField(
          keyboardType: TextInputType.number,
          controller: editingController,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(20),
            fillColor: Colors.white10,
            filled: true,
            label: Text(message),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.black)),
          ),
        ),
      );
    } else if (isAddress == true) {
      return Container(
        padding: const EdgeInsets.all(10),
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextField(
          keyboardType: TextInputType.multiline,
          maxLines: 5,
          controller: editingController,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(20),
            fillColor: Colors.white10,
            filled: true,
            label: Text(message),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.black)),
          ),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.all(10),
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        keyboardType: TextInputType.text,
        controller: editingController,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(20),
          fillColor: Colors.white10,
          filled: true,
          label: Text(message),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.black)),
        ),
      ),
    );
  }

  void showDeliveryDetailsModal(BuildContext context, double deviceWidth) {
    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Center(
                child: Column(mainAxisSize: MainAxisSize.min,
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: const Icon(Icons.close),
                          iconSize: 40,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      _buildTextContainer(
                          editingController: name, message: "Full Name"),
                      _buildTextContainer(
                          editingController: phone,
                          message: "Contact Number",
                          isNumber: true),
                      _buildTextContainer(
                          editingController: useremail,
                          message: "Email Address"),
                      _buildTextContainer(
                          editingController: address,
                          message: "Address",
                          isAddress: true),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: _buildTextContainer(
                                  editingController: pincode,
                                  isNumber: true,
                                  message: "Pincode"),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              child: _buildTextContainer(
                                  editingController: city, message: "City"),
                            ),
                          ]),
                      StatefulBuilder(
                        builder: (BuildContext context, setState) {
                          return Container(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            height: 80,
                            child: DropdownButton<String>(
                                value: state,
                                isExpanded: true,
                                items: _dropDownItems.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Text(
                                        value,
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    if (value != null) {
                                      state = value;
                                    }
                                  });
                                }),
                          );
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              if (name.text != "" &&
                                  name.text != "" &&
                                  phone.text != "" &&
                                  city.text != "" &&
                                  pincode.text != "" &&
                                  useremail.text != "") {
                                setState(() {
                                  orderid =
                                      Random().nextInt(99999999).toString();
                                  Navigator.of(context).pop();
                                });
                              }
                            },
                            child: const Text(
                              "Submit",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                "Cancel",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              )),
                        ],
                      )
                    ]),
              ),
            ),
          );
        });
  }

  Future<void> _sendEmail({required OrderModel order}) async {
    final String message = """
    Customer Name : ${name.text}\n
    Payment Typpe : $stringPaymentMethod\n
    Order ID: ${order.orderid}\n
    UID: ${order.userUID}\n
    Contact Number: ${order.userPhone}\n
    Email: ${order.userEmail}\n
    Address: ${order.userAddress}\n
    City: ${order.city}\n
    State: ${order.state}\n
    Pincode: ${order.pincode}\n
    ordered items: ${order.cartproducts[0].productName}\n
        """;
    final String subject = "New Makdeck Order ${order.orderid}";
    const serviceId = "service_r4mpu7g";
    const templateId = "template_bhmc6yy";
    const userId = "vC0JQHuSqw7P55afw";
    final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
    await http.post(url,
        headers: {
          'origin': 'http://localhost',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "service_id": serviceId,
          "template_id": templateId,
          "user_id": userId,
          'template_params': {
            "from_name": order.userEmail,
            "user_message": message,
            "user_subject": subject,
          }
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Address & Payment'),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            Icons.navigate_before,
            color: Colors.white,
            size: 40,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                  onTap: () {
                    showDeliveryDetailsModal(
                        context, MediaQuery.of(context).size.width);
                  },
                  child: ListTile(
                    subtitle: Text(address.text),
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      "Add Delivery Details",
                      style: TextStyle(fontSize: 20, color: kPrimaryColor),
                    ),
                    trailing: Icon(
                      Icons.navigate_next,
                      size: 40,
                      color: kPrimaryColor,
                    ),
                  )),
              const Divider(),
              Text(
                "Payment Method",
                style: TextStyle(fontSize: 20, color: kPrimaryColor),
              ),
              StatefulBuilder(
                builder: (BuildContext context, setState) {
                  return Column(
                    children: [
                      ListTile(
                        title: const Text('Cash on Delivery'),
                        minVerticalPadding: 0,
                        contentPadding: EdgeInsets.zero,
                        leading: Radio<PaymentMethod>(
                          value: PaymentMethod.cashOnDelivery,
                          onChanged: (value) {
                            setState(
                              () {
                                _paymentMethod = value!;
                                if (_paymentMethod ==
                                    PaymentMethod.cashOnDelivery) {
                                  stringPaymentMethod = "Cash on Delivery";
                                }
                              },
                            );
                          },
                          groupValue: _paymentMethod,
                        ),
                      ),
                      ListTile(
                        title: const Text('Prepaid'),
                        contentPadding: EdgeInsets.zero,
                        subtitle:
                            const Text("We will contact you about the payment"),
                        leading: Radio<PaymentMethod>(
                          value: PaymentMethod.prepaid,
                          onChanged: (value) {
                            setState(
                              () {
                                _paymentMethod = value!;
                                if (_paymentMethod == PaymentMethod.prepaid) {
                                  stringPaymentMethod = "Prepaid";
                                }
                              },
                            );
                          },
                          groupValue: _paymentMethod,
                        ),
                      ),
                    ],
                  );
                },
              ),
              const Divider(),
              const Text(
                "PRICE DETAILS",
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Total MRP"),
                      Text("₹ " + totalOrigialPrice.toString()),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Discount on MRP"),
                      Text(
                        "- " "₹ " + discount.toString(),
                        style: TextStyle(color: kPrimaryColor),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Total Amount"),
                      Text(
                        "₹ " + totalMRP.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        height: MediaQuery.of(context).size.height / 10,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: kPrimaryColor, boxShadow: const [
          BoxShadow(
              color: Colors.black26, offset: Offset(0, -1), blurRadius: 6),
        ]),
        child: Center(
          child: GestureDetector(
            onTap: () {
              if (address.text == "" &&
                  name.text == "" &&
                  phone.text == "" &&
                  city.text == "" &&
                  pincode.text == "" &&
                  useremail.text == "") {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Error"),
                      content: const Text("Please fill all delivery details"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("OK"),
                        )
                      ],
                    );
                  },
                );
                return;
              }

              OrderModel orderModel = OrderModel(
                  orderid: orderid,
                  cartproducts: CartService.cartProducts,
                  userUID: FirebaseAuthentication.getUserUid,
                  userEmail: useremail.text,
                  userPhone: phone.text,
                  userAddress: address.text,
                  paymentAmount: totalMRP,
                  trackingID: "",
                  orderStatus: "Pending",
                  orderDate: DateTime.now().toIso8601String(),
                  orderTime: DateTime.now().toIso8601String(),
                  paymentMethod: "_paymentMethod",
                  pincode: pincode.text,
                  city: city.text,
                  state: state);

              SimpleFontelicoProgressDialog _dialog =
                  SimpleFontelicoProgressDialog(
                      context: context, barrierDimisable: false);
              _dialog.show(message: 'Confirming Order...');

              UserDataBase().addOrdertoUser(
                  order: orderModel, uid: FirebaseAuthentication.getUserUid);
              CloudDatabase().addOrdertoFirebase(
                  order: orderModel, uid: FirebaseAuthentication.getUserUid);
              _sendEmail(order: orderModel);
              _dialog.hide();

              CartService.cartProducts.clear();

              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return OrderConfirmScreen(
                  orderId: orderid,
                );
              }));
            },
            child: const Text(
              'CONFIRM ORDER',
              style: TextStyle(
                  fontSize: 30,
                  letterSpacing: 1.2,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
