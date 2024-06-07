import 'dart:io';
import 'package:active_ecommerce_flutter/repositories/verification_repository.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import '../custom/btn.dart';
import '../custom/toast_component.dart';
import '../data_model/verification_response.dart';
import '../helpers/shared_value_helper.dart';
import '../my_theme.dart';

class SellerVerify extends StatefulWidget {
  const SellerVerify({super.key});

  @override
  State<SellerVerify> createState() => _SellerVerifyState();
}

class _SellerVerifyState extends State<SellerVerify> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Buyer Verification',
              style: TextStyle(fontSize: 16),
            ),
          ),
          body: Container(
            height: MediaQuery.sizeOf(context).height,
            width: MediaQuery.sizeOf(context).width,
            child: Column(
              children: [
                Container(
                  height: 50,
                  child: TabBar(
                    tabs: [
                      Text('GST'),
                      Text('Verification'),
                      Text('Bank Details'),
                    ],
                  ),
                ),
                Expanded(
                    child: TabBarView(
                  children: [GST(), Verfication(), BankDetails()],
                ))
              ],
            ),
          ),
        ));
  }
}

class GST extends StatefulWidget {
  const GST({super.key});

  @override
  State<GST> createState() => _GSTState();
}

class _GSTState extends State<GST> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _gstController = TextEditingController();

  onPressConfirm() async {
    if (_gstController.text == "") {
      ToastComponent.showDialog('Enter the GST Number',
          gravity: Toast.bottom, duration: Toast.lengthLong);
      return;
    } else {
      final gstResponse =
          // verify(userId: "${user_id.$}", gstNumber: _gstController.text);
          verify(userId: "18", gstNumber: _gstController.text);
      await Verifications().verification(gstResponse);
      _gstController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'GST Number',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _gstController,
                decoration: InputDecoration(
                    hintText: 'GST Number',
                    hintStyle: TextStyle(
                        fontSize: 14.0, color: MyTheme.textfield_grey),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: MyTheme.textfield_grey, width: 0.5),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(6.0),
                          topLeft: Radius.circular(6.0),
                          bottomLeft: Radius.circular(6.0),
                          bottomRight: Radius.circular(6.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: MyTheme.accent_color, width: 0.5),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(6.0),
                            topLeft: Radius.circular(6.0),
                            bottomLeft: Radius.circular(6.0),
                            bottomRight: Radius.circular(6.0))),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0)),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  'To get GST invoice and tax benefits, please provide your GST Number above',
                  style: TextStyle(
                      fontSize: 12, color: MyTheme.medium_grey, height: 1.8),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: MyTheme.textfield_grey, width: 1),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12.0))),
                  child: Btn.basic(
                    minWidth: MediaQuery.of(context).size.width,
                    color: MyTheme.accent_color,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12.0))),
                    child: Text(
                      'Save GST Number',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                    onPressed: () {
                      onPressConfirm();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Verfication extends StatefulWidget {
  const Verfication({super.key});

  @override
  State<Verfication> createState() => _VerficationState();
}

class _VerficationState extends State<Verfication> {
  final _verificationformKey = GlobalKey<FormState>();
  TextEditingController _documentType = TextEditingController();
  File? _docImage;
  final List<String> genderItems = [
    'Gumasta',
    'Udyog Adhar',
    'Municipality Registration',
    'Hawkers License',
    'Shop Establishment License'
  ];
  String? selectedValue;

  void pickImage(File Image) {
    setState(() {
      _docImage = Image;
    });
  }

  onPressConfirm() async {
    if (selectedValue == "") {
      ToastComponent.showDialog('Enter Select the Document Type',
          gravity: Toast.bottom, duration: Toast.lengthLong);
      return;
    } else {
      final documentVerify =
          // verify(userId: "${user_id.$}", gstNumber: _gstController.text);
          documentverify(
              userId: "18",
              verificationDoc: selectedValue.toString(),
              docImage: _docImage.toString());
      await DocumentVerifyRepository().documentVerify(documentVerify);
    }
  }

  onSelectImage() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    pickImage(File(image!.path));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _verificationformKey,
      child: Scaffold(
        body: Container(
          width: MediaQuery.sizeOf(context).width - 30,
          padding: EdgeInsets.only(left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.only(top: 20)),
              Text(
                'Please Select One Document for Verification',
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              Padding(padding: EdgeInsets.only(top: 20)),
              DropdownButtonFormField2<String>(
                isExpanded: true,
                decoration: InputDecoration(
                  // Add Horizontal padding using menuItemStyleData.padding so it matches
                  // the menu padding when button's width is not specified.
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  // Add more decoration..
                ),
                hint: const Text(
                  'Select Your Document',
                  style: TextStyle(fontSize: 14),
                ),
                items: genderItems
                    .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ))
                    .toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Please select Document.';
                  }
                  return null;
                },
                onChanged: (value) {
                  //Do something when selected item is changed.
                },
                onSaved: (value) {
                  selectedValue = value.toString();
                },
                buttonStyleData: const ButtonStyleData(
                  padding: EdgeInsets.only(right: 8),
                ),
                iconStyleData: const IconStyleData(
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black45,
                  ),
                  iconSize: 24,
                ),
                dropdownStyleData: DropdownStyleData(
                  width: MediaQuery.sizeOf(context).width - 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                menuItemStyleData: const MenuItemStyleData(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 10, bottom: 10)),
              Text(
                "Upload Document",
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              Padding(padding: EdgeInsets.only(top: 10, bottom: 10)),
              Container(
                height: MediaQuery.sizeOf(context).height / 4,
                width: MediaQuery.sizeOf(context).width,
                child: _docImage == null
                    ? GestureDetector(
                        onTap: () {
                          onSelectImage();
                        },
                        child: Card(
                          elevation: 5,
                          shadowColor: Colors.lightBlueAccent,
                          color: Colors.grey[120],
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.browse_gallery),
                                Padding(padding: EdgeInsets.only(top: 30)),
                                Text(
                                  'Upload Photo',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    : Image.file(
                        _docImage!,
                      ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: MyTheme.textfield_grey, width: 1),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12.0))),
                  child: Btn.basic(
                    minWidth: MediaQuery.of(context).size.width,
                    color: MyTheme.accent_color,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12.0))),
                    child: Text(
                      'Save Document Details',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                    onPressed: () {
                      onPressConfirm();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BankDetails extends StatefulWidget {
  const BankDetails({super.key});

  @override
  State<BankDetails> createState() => _BankDetailsState();
}

class _BankDetailsState extends State<BankDetails> {
  final _bankformKey = GlobalKey<FormState>();
  TextEditingController _accountNoController = TextEditingController();
  TextEditingController _beneficiaryController = TextEditingController();
  TextEditingController _bankNameController = TextEditingController();
  TextEditingController _ifscController = TextEditingController();
  File? _uploadImage;

  void pickImage(File Image) {
    setState(() {
      _uploadImage = Image;
    });
  }

  onPressConfirm() async {
    // if (_bankformKey.currentState!.validate()) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: Text('${_accountNoController.text}')));
    // }
    if (_accountNoController.text == "") {
      ToastComponent.showDialog('Enter the Account Number',
          gravity: Toast.bottom, duration: Toast.lengthLong);
      return;
    } else if (_beneficiaryController.text == "") {
      ToastComponent.showDialog('Enter the Beneficiary Name',
          gravity: Toast.bottom, duration: Toast.lengthLong);
      return;
    } else if (_bankNameController.text == "") {
      ToastComponent.showDialog('Enter the Bank Name',
          gravity: Toast.bottom, duration: Toast.lengthLong);
      return;
    } else if (_ifscController.text == "") {
      ToastComponent.showDialog('Enter the IFSC Number',
          gravity: Toast.bottom, duration: Toast.lengthLong);
      return;
    } else if (_uploadImage!.path == "") {
      ToastComponent.showDialog('Select the Image',
          gravity: Toast.bottom, duration: Toast.lengthLong);
      return;
    } else {
      final bankResponse =
          // verify(userId: "${user_id.$}", gstNumber: _gstController.text);
          bankdetailsverify(
              userId: "18",
              accountNumber: _accountNoController.text,
              beneficiaryName: _beneficiaryController.text,
              bankName: _bankNameController.text,
              ifscCode: _ifscController.text,
              uploadImage: _uploadImage.toString());
      await BankDetailsRepository().bankVerification(bankResponse);
      _accountNoController.clear();
      _beneficiaryController.clear();
      _bankNameController.clear();
      _ifscController.clear();
    }
  }

  onPressSelectDocument() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    pickImage(File(image!.path));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _bankformKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Account Number',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _accountNoController,
                  decoration: InputDecoration(
                      hintText: 'Account Number',
                      hintStyle: TextStyle(
                          fontSize: 14.0, color: MyTheme.textfield_grey),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: MyTheme.textfield_grey, width: 0.5),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(6.0),
                            topLeft: Radius.circular(6.0),
                            bottomLeft: Radius.circular(6.0),
                            bottomRight: Radius.circular(6.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: MyTheme.accent_color, width: 0.5),
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(6.0),
                              topLeft: Radius.circular(6.0),
                              bottomLeft: Radius.circular(6.0),
                              bottomRight: Radius.circular(6.0))),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0)),
                ),
                SizedBox(height: 20),
                Text(
                  'Beneficiary Name',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _beneficiaryController,
                  decoration: InputDecoration(
                      hintText: 'Beneficiary Name',
                      hintStyle: TextStyle(
                          fontSize: 14.0, color: MyTheme.textfield_grey),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: MyTheme.textfield_grey, width: 0.5),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(6.0),
                            topLeft: Radius.circular(6.0),
                            bottomLeft: Radius.circular(6.0),
                            bottomRight: Radius.circular(6.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: MyTheme.accent_color, width: 0.5),
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(6.0),
                              topLeft: Radius.circular(6.0),
                              bottomLeft: Radius.circular(6.0),
                              bottomRight: Radius.circular(6.0))),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0)),
                ),
                SizedBox(height: 20),
                Text(
                  'Bank Name',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _bankNameController,
                  decoration: InputDecoration(
                      hintText: 'Bank Name',
                      hintStyle: TextStyle(
                          fontSize: 14.0, color: MyTheme.textfield_grey),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: MyTheme.textfield_grey, width: 0.5),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(6.0),
                            topLeft: Radius.circular(6.0),
                            bottomLeft: Radius.circular(6.0),
                            bottomRight: Radius.circular(6.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: MyTheme.accent_color, width: 0.5),
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(6.0),
                              topLeft: Radius.circular(6.0),
                              bottomLeft: Radius.circular(6.0),
                              bottomRight: Radius.circular(6.0))),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0)),
                ),
                SizedBox(height: 20),
                Text(
                  'IFSC Code',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _ifscController,
                  decoration: InputDecoration(
                      hintText: 'IFSC Code',
                      hintStyle: TextStyle(
                          fontSize: 14.0, color: MyTheme.textfield_grey),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: MyTheme.textfield_grey, width: 0.5),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(6.0),
                            topLeft: Radius.circular(6.0),
                            bottomLeft: Radius.circular(6.0),
                            bottomRight: Radius.circular(6.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: MyTheme.accent_color, width: 0.5),
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(6.0),
                              topLeft: Radius.circular(6.0),
                              bottomLeft: Radius.circular(6.0),
                              bottomRight: Radius.circular(6.0))),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0)),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.sizeOf(context).height / 4,
                          width: MediaQuery.sizeOf(context).width,
                          child: _uploadImage == null
                              ? GestureDetector(
                                  onTap: () {
                                    onPressSelectDocument();
                                  },
                                  child: Card(
                                    elevation: 5,
                                    shadowColor: Colors.lightBlueAccent,
                                    color: Colors.grey[120],
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.browse_gallery),
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(top: 30)),
                                          Text(
                                            'Select Passbook or Cancelled Cheque Photo',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : Image.file(
                                  _uploadImage!,
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: MyTheme.textfield_grey, width: 1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12.0))),
                    child: Btn.basic(
                      minWidth: MediaQuery.of(context).size.width,
                      color: MyTheme.accent_color,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12.0))),
                      child: Text(
                        'Save Bank Details',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                      onPressed: () {
                        onPressConfirm();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
