import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_online_shop/models/address_model.dart';
import 'package:flutter_online_shop/services/db/user_db_helper.dart';
import 'package:flutter_online_shop/utils/constant.dart';
import 'package:flutter_online_shop/utils/size_config.dart';
import 'package:flutter_online_shop/widget/default_button.dart';
import 'package:logger/logger.dart';
import 'package:string_validator/string_validator.dart';

class EditAddressScreen extends StatelessWidget {
  final String addressIdToEdit;

  const EditAddressScreen({Key key, this.addressIdToEdit}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(screenPadding)),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(height: getProportionateScreenHeight(30)),
                  addressIdToEdit == null
                      ? AddressDetailsForm(
                          addressToEdit: null,
                        )
                      : FutureBuilder<Address>(
                          future: UserDatabaseHelper()
                              .getAddressFromId(addressIdToEdit),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final address = snapshot.data;
                              return AddressDetailsForm(addressToEdit: address);
                            } else if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return AddressDetailsForm(
                              addressToEdit: null,
                            );
                          },
                        ),
                  SizedBox(height: getProportionateScreenHeight(40)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AddressDetailsForm extends StatefulWidget {
  final Address addressToEdit;
  AddressDetailsForm({
    Key key,
    this.addressToEdit,
  }) : super(key: key);

  @override
  _AddressDetailsFormState createState() => _AddressDetailsFormState();
}

class _AddressDetailsFormState extends State<AddressDetailsForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController titleFieldController = TextEditingController();

  final TextEditingController receiverFieldController = TextEditingController();

  final TextEditingController addressLine1FieldController =
      TextEditingController();

  final TextEditingController addressLine2FieldController =
      TextEditingController();

  final TextEditingController cityFieldController = TextEditingController();

  final TextEditingController districtFieldController = TextEditingController();

  final TextEditingController stateFieldController = TextEditingController();

  final TextEditingController landmarkFieldController = TextEditingController();

  final TextEditingController pincodeFieldController = TextEditingController();

  final TextEditingController phoneFieldController = TextEditingController();

  @override
  void dispose() {
    titleFieldController.dispose();
    receiverFieldController.dispose();
    addressLine1FieldController.dispose();
    addressLine2FieldController.dispose();
    cityFieldController.dispose();
    stateFieldController.dispose();
    districtFieldController.dispose();
    landmarkFieldController.dispose();
    pincodeFieldController.dispose();
    phoneFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final form = Form(
      key: _formKey,
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: getProportionateScreenHeight(20)),
              buildTitleField(),
              SizedBox(height: getProportionateScreenHeight(30)),
              buildReceiverField(),
              SizedBox(height: getProportionateScreenHeight(30)),
              buildAddressLine1Field(),
              SizedBox(height: getProportionateScreenHeight(30)),
              buildAddressLine2Field(),
              SizedBox(height: getProportionateScreenHeight(30)),
              buildCityField(),
              SizedBox(height: getProportionateScreenHeight(30)),
              buildDistrictField(),
              SizedBox(height: getProportionateScreenHeight(30)),
              buildStateField(),
              SizedBox(height: getProportionateScreenHeight(30)),
              buildLandmarkField(),
              SizedBox(height: getProportionateScreenHeight(30)),
              buildPincodeField(),
              SizedBox(height: getProportionateScreenHeight(30)),
              buildPhoneField(),
              SizedBox(height: getProportionateScreenHeight(30)),
              DefaultButton(
                text: "Lưu địa chỉ",
                press: widget.addressToEdit == null
                    ? saveNewAddressButtonCallback
                    : saveEditedAddressButtonCallback,
              ),
            ],
          ),
          Positioned(
            right: 0,
            top: getProportionateScreenHeight(20),
            child: Container(
              width: 10,
              height: SizeConfig.screenHeight * 1.145,
              color: kPrimaryColor,
            ),
          ),
        ],
      ),
    );
    if (widget.addressToEdit != null) {
      titleFieldController.text = widget.addressToEdit.title;
      receiverFieldController.text = widget.addressToEdit.receiver;
      addressLine1FieldController.text = widget.addressToEdit.addresLine1;
      addressLine2FieldController.text = widget.addressToEdit.addressLine2;
      cityFieldController.text = widget.addressToEdit.city;
      districtFieldController.text = widget.addressToEdit.district;
      stateFieldController.text = widget.addressToEdit.state;
      landmarkFieldController.text = widget.addressToEdit.landmark;
      pincodeFieldController.text = widget.addressToEdit.pincode;
      phoneFieldController.text = widget.addressToEdit.phone;
    }
    return form;
  }

  Widget buildTitleField() {
    return TextFormField(
      controller: titleFieldController,
      keyboardType: TextInputType.name,
      maxLength: 8,
      decoration: InputDecoration(
        enabledBorder: outlineTextField,
        focusedBorder: outlineTextField,
        hintText: "Nhập tiêu đề",
        labelText: "Tiêu đề",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) {
        if (titleFieldController.text.isEmpty) {
          return FIELD_REQUIRED_MSG;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildReceiverField() {
    return TextFormField(
      controller: receiverFieldController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        enabledBorder: outlineTextField,
        focusedBorder: outlineTextField,
        hintText: "Nhập Họ & Tên người nhận",
        labelText: "Họ & Tên",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) {
        if (receiverFieldController.text.isEmpty) {
          return FIELD_REQUIRED_MSG;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildAddressLine1Field() {
    return TextFormField(
      controller: addressLine1FieldController,
      keyboardType: TextInputType.streetAddress,
      decoration: InputDecoration(
        enabledBorder: outlineTextField,
        focusedBorder: outlineTextField,
        hintText: "Nhập địa chỉ thường trú",
        labelText: "Địa chỉ thường trú",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) {
        if (addressLine1FieldController.text.isEmpty) {
          return FIELD_REQUIRED_MSG;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildAddressLine2Field() {
    return TextFormField(
      controller: addressLine2FieldController,
      keyboardType: TextInputType.streetAddress,
      decoration: InputDecoration(
        enabledBorder: outlineTextField,
        focusedBorder: outlineTextField,
        hintText: "Nhập địa chỉ dự phòng",
        labelText: "Địa chỉ dự phòng",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) {
        if (addressLine2FieldController.text.isEmpty) {
          return FIELD_REQUIRED_MSG;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildCityField() {
    return TextFormField(
      controller: cityFieldController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        enabledBorder: outlineTextField,
        focusedBorder: outlineTextField,
        hintText: "Nhập Tỉnh\\Thành phố",
        labelText: "Tỉnh\\Thành Phố",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) {
        if (cityFieldController.text.isEmpty) {
          return FIELD_REQUIRED_MSG;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildDistrictField() {
    return TextFormField(
      controller: districtFieldController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        enabledBorder: outlineTextField,
        focusedBorder: outlineTextField,
        hintText: "Nhập Quận\\Huyện",
        labelText: "Quận\\Huyện",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) {
        if (districtFieldController.text.isEmpty) {
          return FIELD_REQUIRED_MSG;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildStateField() {
    return TextFormField(
      controller: stateFieldController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        enabledBorder: outlineTextField,
        focusedBorder: outlineTextField,
        hintText: "Nhập Phường\\Xã",
        labelText: "Phường\\Xã",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) {
        if (stateFieldController.text.isEmpty) {
          return FIELD_REQUIRED_MSG;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildPincodeField() {
    return TextFormField(
      controller: pincodeFieldController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        enabledBorder: outlineTextField,
        focusedBorder: outlineTextField,
        hintText: "Nhập mã PIN",
        labelText: "PINCODE",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) {
        if (pincodeFieldController.text.isEmpty) {
          return FIELD_REQUIRED_MSG;
        } else if (!isNumeric(pincodeFieldController.text)) {
          return "Yêu cầu chỉ nhập kí tự";
        } else if (pincodeFieldController.text.length != 6) {
          return "Mã PIN yêu cầu đủ 6 kí tự";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildLandmarkField() {
    return TextFormField(
      controller: landmarkFieldController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        enabledBorder: outlineTextField,
        focusedBorder: outlineTextField,
        hintText: "Nhập số nhà",
        labelText: "Số nhà",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) {
        if (landmarkFieldController.text.isEmpty) {
          return FIELD_REQUIRED_MSG;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildPhoneField() {
    return TextFormField(
      controller: phoneFieldController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        enabledBorder: outlineTextField,
        focusedBorder: outlineTextField,
        hintText: "Nhập số điện thoại",
        labelText: "Số điện thoại",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) {
        if (phoneFieldController.text.isEmpty) {
          return FIELD_REQUIRED_MSG;
        } else if (phoneFieldController.text.length != 10) {
          return "Tối đa 10 kí tự";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Future<void> saveNewAddressButtonCallback() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      final Address newAddress = generateAddressObject();
      bool status = false;
      String snackbarMessage;
      try {
        status =
            await UserDatabaseHelper().addAddressForCurrentUser(newAddress);
        if (status == true) {
          snackbarMessage = "Lưu địa chỉ thành công";
        } else {
          throw "Thao tác thất bại,vui lòng thử lại";
        }
      } on FirebaseException catch (e) {
        Logger().w("Firebase Exception: $e");
        snackbarMessage = "Thao tác thất bại,vui lòng thử lại";
      } catch (e) {
        Logger().w("Unknown Exception: $e");
        snackbarMessage = "Thao tác thất bại,vui lòng thử lại";
      } finally {
        Logger().i(snackbarMessage);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(snackbarMessage),
          ),
        );
      }
    }
  }

  Future<void> saveEditedAddressButtonCallback() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      final Address newAddress =
          generateAddressObject(id: widget.addressToEdit.id);

      bool status = false;
      String snackbarMessage;
      try {
        status =
            await UserDatabaseHelper().updateAddressForCurrentUser(newAddress);
        if (status == true) {
          snackbarMessage = "Lưu địa chỉ thành công";
        } else {
          throw "Thao tác thất bại,vui lòng thử lại";
        }
      } on FirebaseException catch (e) {
        Logger().w("Firebase Exception: $e");
        snackbarMessage = "Thao tác thất bại,vui lòng thử lại";
      } catch (e) {
        Logger().w("Unknown Exception: $e");
        snackbarMessage = "Thao tác thất bại,vui lòng thử lại";
      } finally {
        Logger().i(snackbarMessage);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(snackbarMessage),
          ),
        );
      }
    }
  }

  Address generateAddressObject({String id}) {
    return Address(
      id: id,
      title: titleFieldController.text,
      receiver: receiverFieldController.text,
      addresLine1: addressLine1FieldController.text,
      addressLine2: addressLine2FieldController.text,
      city: cityFieldController.text,
      district: districtFieldController.text,
      state: stateFieldController.text,
      landmark: landmarkFieldController.text,
      pincode: pincodeFieldController.text,
      phone: phoneFieldController.text,
    );
  }
}
