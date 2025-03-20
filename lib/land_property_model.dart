// class LandProperty {
//   final int? id;
//   final int clientId;
//   final String? lotNumber;
//   final String? identicalNumber;
//   final String? surveyClaimant;
//   final double? areaSqm;
//   final String? sitio;
//   final String? propertyBarangay;
//   final String? propertyMunicipality;
//   final String? remarks;
//   final String? applicationNumber;
//   final String? receivedDate;
//   final String? returnDate;
//   final String? patentNumber;
//   final String? signedDate;
//   final String? transmittedDate;
//   final String? dateIssued;
//   final String? bundleNumber;
//   final String? lotStatus;

//   LandProperty(
//       {this.id,
//       required this.clientId,
//       this.lotNumber,
//       this.identicalNumber,
//       this.surveyClaimant,
//       this.areaSqm,
//       this.sitio,
//       this.propertyBarangay,
//       this.propertyMunicipality,
//       this.remarks,
//       this.applicationNumber,
//       this.receivedDate,
//       this.returnDate,
//       this.patentNumber,
//       this.signedDate,
//       this.transmittedDate,
//       this.dateIssued,
//       this.bundleNumber,
//       this.lotStatus});

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'client_id': clientId,
//       'lot_number': lotNumber,
//       'identical_number': identicalNumber,
//       'survey_claimant': surveyClaimant,
//       'area_sqm': areaSqm,
//       'sitio': sitio,
//       'property_barangay': propertyBarangay,
//       'property_municipality': propertyMunicipality,
//       'remarks': remarks,
//       'application_number': applicationNumber,
//       'received_date': receivedDate,
//       'return_date': returnDate,
//       'patent_number': patentNumber,
//       'signed_date': signedDate,
//       'transmitted_date': transmittedDate,
//       'date_issued': dateIssued,
//       'bundle_number': bundleNumber,
//       'lot_status': lotStatus,
//     };
//   }

//   factory LandProperty.fromMap(Map<String, dynamic> map) {
//     return LandProperty(
//       id: map['id'],
//       clientId: map['client_id'],
//       lotNumber: map['lot_number'],
//       identicalNumber: map['identical_number'],
//       surveyClaimant: map['survey_claimant'],
//       areaSqm: map['area_sqm'] is int
//           ? (map['area_sqm'] as int).toDouble()
//           : map['area_sqm'],
//       sitio: map['sitio'],
//       propertyBarangay: map['property_barangay'],
//       propertyMunicipality: map['property_municipality'],
//       remarks: map['remarks'],
//       applicationNumber: map['application_number'],
//       receivedDate: map['received_date'],
//       returnDate: map['return_date'],
//       patentNumber: map['patent_number'],
//       signedDate: map['signed_date'],
//       transmittedDate: map['transmitted_date'],
//       dateIssued: map['date_issued'],
//       bundleNumber: map['bundle_number'],
//       lotStatus: map['lot_status'],
//     );
//   }
// }
