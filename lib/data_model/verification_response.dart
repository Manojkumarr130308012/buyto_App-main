import 'dart:convert';

class verify {
  String? userId;
  String? gstNumber;

  verify({this.userId, this.gstNumber});

  Map<String, dynamic> toJson() {
    return {'user_id': userId, 'gst_number': gstNumber};
  }

  factory verify.fromJSon(Map<String, dynamic> json) {
    return verify(userId: json['user_id'], gstNumber: json['gst_number']);
  }
}

class bankdetailsverify {
  String? userId;
  String? accountNumber;
  String? beneficiaryName;
  String? bankName;
  String? ifscCode;
  String? uploadImage;

  bankdetailsverify(
      {this.userId,
      this.accountNumber,
      this.beneficiaryName,
      this.bankName,
      this.ifscCode,
      this.uploadImage});

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'account_no': accountNumber,
      'benificiary_name': beneficiaryName,
      'bank_name': bankName,
      'ifsc_code': ifscCode,
      'reference_image': uploadImage
    };
  }

  factory bankdetailsverify.fromJSon(Map<String, dynamic> json) {
    return bankdetailsverify(
        userId: json['user_id'],
        accountNumber: json['account_no'],
        beneficiaryName: json['benificiary_name'],
        bankName: json['bank_name'],
        ifscCode: json['ifsc_code'],
        uploadImage: json['reference_image']);
  }
}

class documentverify {
  String? userId;
  String? verificationDoc;
  String? docImage;

  documentverify({this.userId, this.verificationDoc, this.docImage});

  Map<String, dynamic> toJSon() {
    return {
      'user_id': userId,
      'verification_document': verificationDoc,
      'document_image': docImage
    };
  }

  factory documentverify.fromJSon(Map<String, dynamic> json) {
    return documentverify(
        userId: json['user_id'],
        verificationDoc: json['verification_document'],
        docImage: json['document_image']);
  }
}
