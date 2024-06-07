import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';

import '../custom/btn.dart';
import '../custom/toast_component.dart';
import '../my_theme.dart';

class Raise_Tickets extends StatefulWidget {
  const Raise_Tickets({super.key});

  @override
  State<Raise_Tickets> createState() => _Raise_TicketsState();
}

class _Raise_TicketsState extends State<Raise_Tickets> {
  final _formKey = GlobalKey<FormState>();

  final List<String> esclationItems = [
    'Courier Issue',
    'Update Order Status',
    'Request Callback',
    'Dispatch Delay',
    'Returns',
    'Arrange Delivery',
    'Update Order Status',
    'Feedback',
    'GST Related',
    'Refund Related',
    'Finance',
    'App Related',
    'Delivery Dispute',
    'Pickup Related',
    'Verification Pending',
    'Missing Pair/Units'
  ];

  String? selectedValue;
  String? selectedValue1;
  TextEditingController _orderId = TextEditingController();
  TextEditingController _decription = TextEditingController();
  File? _docImage;

  void pickImage(File Image) {
    setState(() {
      _docImage = Image;
    });
  }

  onPressConfirm() async {
    // if ( selectedValue == null) {
    //   ToastComponent.showDialog('Select the Escalation Type',
    //       gravity: Toast.bottom, duration: Toast.lengthLong);
    //   return;
    // } else if (selectedValue1 == "" || selectedValue1 == null) {
    //   ToastComponent.showDialog('Select the Escalation Sub Type',
    //       gravity: Toast.bottom, duration: Toast.lengthLong);
    //   return;
    // } else if (_orderId == "" || _orderId == null) {
    //   ToastComponent.showDialog('Enter the Order ID',
    //       gravity: Toast.bottom, duration: Toast.lengthLong);
    //   return;
    // } else {
    //   ToastComponent.showDialog('Complaint Raised Successfully',
    //       gravity: Toast.bottom, duration: Toast.lengthLong);
    // }
    ToastComponent.showDialog('Complaint Raised Successfully',
        gravity: Toast.bottom, duration: Toast.lengthLong);
  }

  onSelectImage() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    pickImage(File(image!.path));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyTheme.accent_color,
        // centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(CupertinoIcons.arrow_left, color: MyTheme.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: Text(
          'Raise Tickets',
          style: TextStyle(
              fontSize: 16,
              color: MyTheme.white,
              fontWeight: FontWeight.bold),
        ),
        elevation: 0.0,
        titleSpacing: 0,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(padding: EdgeInsets.only(top: 20)),
                Text(
                  'Escalation Type',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
                Padding(padding: EdgeInsets.only(top: 20)),
                DropdownButtonFormField2<String>(
                  isExpanded: true,
                  decoration: InputDecoration(
                    // Add Horizontal padding using menuItemStyleData.padding so it matches
                    // the menu padding when button's width is not specified.
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    // Add more decoration..
                  ),
                  hint: const Text(
                    'Select Escalation Type',
                    style: TextStyle(fontSize: 14),
                  ),
                  items: esclationItems
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
                      return 'Please select Escalation Type.';
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
                    maxHeight: MediaQuery.sizeOf(context).height / 2,
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
                  'Escalation Sub Type',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
                Padding(padding: EdgeInsets.only(top: 20)),
                DropdownButtonFormField2<String>(
                  isExpanded: true,
                  decoration: InputDecoration(
                    // Add Horizontal padding using menuItemStyleData.padding so it matches
                    // the menu padding when button's width is not specified.
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    // Add more decoration..
                  ),
                  hint: const Text(
                    'Select Escalation Sub Type',
                    style: TextStyle(fontSize: 14),
                  ),
                  items: esclationItems
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
                      return 'Please select Escalation Sub Type.';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    //Do something when selected item is changed.
                  },
                  onSaved: (value) {
                    selectedValue1 = value.toString();
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
                    maxHeight: MediaQuery.sizeOf(context).height / 2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 20)),
                Text(
                  'Order ID',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _orderId,
                  decoration: InputDecoration(
                      hintText: 'Order ID',
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
                Padding(padding: EdgeInsets.only(top: 20)),
                Text(
                  'Description',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _decription,
                  decoration: InputDecoration(
                      hintText: 'Description',
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
                        border: Border.all(
                            color: MyTheme.textfield_grey, width: 1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12.0))),
                    child: Btn.basic(
                      minWidth: MediaQuery.of(context).size.width,
                      color: MyTheme.accent_color,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12.0))),
                      child: Text(
                        'Submit Ticket',
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
