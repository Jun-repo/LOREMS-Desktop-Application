// class Client {
//   final int? id;
//   final String applicantFirstname;
//   final String? applicantMiddlename;
//   final String applicantLastname;
//   final String? applicantSuffix;
//   final String? applicantMaidenname;
//   final String? gender;
//   final String? birthDate;
//   final String? status;
//   final String? spouse;
//   final String? sitioAddress;
//   final String? barangayAddress;
//   final String? municipalityAddress;

//   Client({
//     this.id,
//     required this.applicantFirstname,
//     this.applicantMiddlename,
//     required this.applicantLastname,
//     this.applicantSuffix,
//     this.applicantMaidenname,
//     this.gender,
//     this.birthDate,
//     this.status,
//     this.spouse,
//     this.sitioAddress,
//     this.barangayAddress,
//     this.municipalityAddress,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'applicant_firstname': applicantFirstname,
//       'applicant_middlename': applicantMiddlename,
//       'applicant_lastname': applicantLastname,
//       'applicant_suffix': applicantSuffix,
//       'applicant_maidenname': applicantMaidenname,
//       'gender': gender,
//       'birth_date': birthDate,
//       'status': status,
//       'spouse': spouse,
//       'applicant_address': sitioAddress,
//       'barangay_address': barangayAddress,
//       'municipality_address': municipalityAddress,
//     };
//   }

//   factory Client.fromMap(Map<String, dynamic> map) {
//     return Client(
//       id: map['id'],
//       applicantFirstname: map['applicant_firstname'],
//       applicantMiddlename: map['applicant_middlename'],
//       applicantLastname: map['applicant_lastname'],
//       applicantSuffix: map['applicant_suffix'],
//       applicantMaidenname: map['applicant_maidenname'],
//       gender: map['gender'],
//       birthDate: map['birth_date'],
//       status: map['status'],
//       spouse: map['spouse'],
//       sitioAddress: map['applicant_address'],
//       barangayAddress: map['barangay_address'],
//       municipalityAddress: map['municipality_address'],
//     );
//   }
// }
