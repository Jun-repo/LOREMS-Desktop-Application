// ignore_for_file: use_build_context_synchronously, deprecated_member_use, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'database_helper.dart';

class SubDividingLandPage extends StatefulWidget {
  final Map<String, dynamic> landPropertyData;

  const SubDividingLandPage({super.key, required this.landPropertyData});

  @override
  SubDividingLandPageState createState() => SubDividingLandPageState();
}

class SubDividingLandPageState extends State<SubDividingLandPage> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  // List to store multiple subdivided lands temporarily
  final List<Map<String, dynamic>> _subdividedLands = [];

  // FocusNodes for Client Info fields
  final FocusNode _firstnameFocus = FocusNode();
  final FocusNode _middlenameFocus = FocusNode();
  final FocusNode _lastnameFocus = FocusNode();
  final FocusNode _suffixFocus = FocusNode();
  final FocusNode _genderFocus = FocusNode();
  final FocusNode _statusFocus = FocusNode();
  final FocusNode _spouseFocus = FocusNode();
  final FocusNode _sitioAddressFocus = FocusNode();
  final FocusNode _barangayAddressFocus = FocusNode();
  final FocusNode _municipalityAddressFocus = FocusNode();

  // FocusNodes for Land Property Part 1
  final FocusNode _bundleNumberFocus = FocusNode();
  final FocusNode _lotNumberFocus = FocusNode();
  final FocusNode _identicalNumberFocus = FocusNode();
  final FocusNode _surveyClaimantFocus = FocusNode();
  final FocusNode _areaSqmFocus = FocusNode();

  // FocusNodes for Land Property Part 2
  final FocusNode _propertyMunicipalityFocus = FocusNode();
  final FocusNode _propertyBarangayFocus = FocusNode();
  final FocusNode _sitioFocus = FocusNode();
  final FocusNode _applicationNumberFocus = FocusNode();
  final FocusNode _applicationExtensionFocus = FocusNode();
  final FocusNode _patentNumberFocus = FocusNode();

  // FocusNodes for Land Property Part 3
  final FocusNode _lotStatusFocus = FocusNode();
  final FocusNode _serialNumberFocus = FocusNode();
  final FocusNode _landInvestigatorFocus = FocusNode();
  final FocusNode _remarksFocus = FocusNode();

  // FocusNodes for Land Property Part 4
  final FocusNode _plaReceivedDateFocus = FocusNode();
  final FocusNode _tplaToPenroTransmittedDateFocus = FocusNode();
  final FocusNode _returnFromPenroFocus = FocusNode();
  final FocusNode _rodReceivedDateFocus = FocusNode();
  final FocusNode _dateAppliedReceivedFocus = FocusNode();
  final FocusNode _dateApprovedFocus = FocusNode();

  // Client Info Controllers
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _middlenameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _suffixController = TextEditingController();
  String? _selectedGender;
  String? _selectedStatus;
  final TextEditingController _spouseController = TextEditingController();
  final TextEditingController _sitioAddressController = TextEditingController();
  final TextEditingController _barangayAddressController =
      TextEditingController();
  final TextEditingController _municipalityAddressController =
      TextEditingController();

  // Land Property Controllers (Part 1)
  final TextEditingController _bundleNumberController = TextEditingController();
  final TextEditingController _lotNumberController = TextEditingController();
  final TextEditingController _identicalNumberController =
      TextEditingController();
  final TextEditingController _surveyClaimantController =
      TextEditingController();
  final TextEditingController _areaSqmController = TextEditingController();

  // Land Property Controllers (Part 2)
  final TextEditingController _sitioController = TextEditingController();
  String? _selectedPropertyMunicipality;
  String? _selectedPropertyBarangay;
  String? _selectedApplicationNumber;
  final TextEditingController _applicationExtensionController =
      TextEditingController();
  final TextEditingController _patentNumberController = TextEditingController();

  // Land Property Controllers (Part 3)
  String? _selectedLotStatus;
  final TextEditingController _serialNumberController = TextEditingController();
  final TextEditingController _landInvestigatorController =
      TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

  // Land Property Controllers (Part 4)
  final TextEditingController _plaReceivedDateController =
      TextEditingController();
  final TextEditingController _tplaToPenroTransmittedDateController =
      TextEditingController();
  final TextEditingController _returnFromPenroController =
      TextEditingController();
  final TextEditingController _rodReceivedDateController =
      TextEditingController();
  final TextEditingController _dateAppliedReceivedController =
      TextEditingController();
  final TextEditingController _dateApprovedController = TextEditingController();

  // Dropdown Options
  final List<String> _genderOptions = ['Male', 'Female'];
  final List<String> _statusOptions = [
    'Single',
    'Married',
    'Divorced',
    'Widowed'
  ];
  final List<String> _lotStatusOptions = [
    'Patended/Approved',
    'Subsisting',
    'Rejected/Cancelled',
    'Case & Conflict'
  ];
  final List<String> _municipalities = ['Quezon', 'Narra', 'Rizal'];
  final Map<String, List<String>> _barangays = {
    'Quezon': [
      "Alfonso XIII",
      "Aramaywan",
      "Berong",
      "Calumpis",
      "Isugod",
      "Quinlogan",
      "Maasin",
      "Panitian",
      "Pinugay",
      "Sowangan",
      "Tabon",
      "Tagusao",
      "Kalatagbak",
      "Malatgao"
    ],
    'Narra': [
      "Antipuluan",
      "Aramaywan",
      "Batang Batang",
      "Bato-Bato",
      "Burirao",
      "Caguisan",
      "Calategas",
      "Dumagueña",
      "Elvita",
      "Estrella Village",
      "Ipilan",
      "Malatgao",
      "Malinao",
      "Narra",
      "Panacan",
      "Panacan 2",
      "Princess Urduja",
      "Sandoval",
      "Tacras",
      "Taritien",
      "Teresa",
      "Bagong Sikat",
      "Pagdanan"
    ],
    'Rizal': [
      "Rizal",
      "Bunog",
      "Campong Ulay",
      "Candawaga",
      "Canipaan",
      "Culasian",
      "Iraan",
      "Latud",
      "Panalingaan",
      "Punta Baja",
      "Taratak"
    ],
  };
  final Map<String, List<String>> _applicationNumberOptions = {
    'Quezon': [
      'FPA - (IV-28)',
      'HPA - (IV-A-10)',
      'MSA - 045317',
      'RPA - (III-7)'
    ],
    'Narra': ['MLA - (IV-27)', 'RFPA - 045315'],
    'Rizal': ['FLA - 045322'],
  };
  final List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  final List<String> _days =
      List.generate(31, (index) => (index + 1).toString());
  final List<String> _years = List.generate(
      101, (index) => (DateTime.now().year - 100 + index).toString());

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _areaSqmController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _firstnameFocus.dispose();
    _middlenameFocus.dispose();
    _lastnameFocus.dispose();
    _suffixFocus.dispose();
    _genderFocus.dispose();
    _statusFocus.dispose();
    _spouseFocus.dispose();
    _sitioAddressFocus.dispose();
    _barangayAddressFocus.dispose();
    _municipalityAddressFocus.dispose();
    _bundleNumberFocus.dispose();
    _lotNumberFocus.dispose();
    _identicalNumberFocus.dispose();
    _surveyClaimantFocus.dispose();
    _areaSqmFocus.dispose();
    _propertyMunicipalityFocus.dispose();
    _propertyBarangayFocus.dispose();
    _sitioFocus.dispose();
    _applicationNumberFocus.dispose();
    _applicationExtensionFocus.dispose();
    _patentNumberFocus.dispose();
    _lotStatusFocus.dispose();
    _serialNumberFocus.dispose();
    _landInvestigatorFocus.dispose();
    _remarksFocus.dispose();
    _plaReceivedDateFocus.dispose();
    _tplaToPenroTransmittedDateFocus.dispose();
    _returnFromPenroFocus.dispose();
    _rodReceivedDateFocus.dispose();
    _dateAppliedReceivedFocus.dispose();
    _dateApprovedFocus.dispose();
    _firstnameController.dispose();
    _middlenameController.dispose();
    _lastnameController.dispose();
    _suffixController.dispose();
    _spouseController.dispose();
    _sitioAddressController.dispose();
    _barangayAddressController.dispose();
    _municipalityAddressController.dispose();
    _bundleNumberController.dispose();
    _lotNumberController.dispose();
    _identicalNumberController.dispose();
    _surveyClaimantController.dispose();
    _areaSqmController.dispose();
    _sitioController.dispose();
    _applicationExtensionController.dispose();
    _patentNumberController.dispose();
    _serialNumberController.dispose();
    _landInvestigatorController.dispose();
    _plaReceivedDateController.dispose();
    _tplaToPenroTransmittedDateController.dispose();
    _returnFromPenroController.dispose();
    _rodReceivedDateController.dispose();
    _dateAppliedReceivedController.dispose();
    _dateApprovedController.dispose();
    super.dispose();
  }

  InputDecoration customInputDecoration(String label, {bool hasValue = false}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
          color: Colors.white38, fontFamily: 'Gilroy', fontSize: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
            color: hasValue
                ? const Color.fromARGB(255, 13, 136, 69)
                : const Color.fromARGB(255, 60, 60, 62),
            width: hasValue ? 0.8 : 0.4),
      ),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
              color: Color.fromARGB(255, 13, 136, 69), width: 0.8)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 0.8)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 0.8)),
    );
  }

  Future<void> _showDateDialog(
      String label, TextEditingController controller) async {
    String? selectedMonth, selectedDay, selectedYear;

    if (controller.text.isNotEmpty) {
      try {
        final parts = controller.text.split(' ');
        selectedMonth = parts[0];
        selectedDay = parts[1].replaceAll(',', '');
        selectedYear = parts[2];
      } catch (_) {}
    }

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color.fromARGB(255, 36, 36, 38),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(
                      color: Color.fromARGB(255, 13, 136, 69), width: 0.7)),
              title: Text('Select $label',
                  style: const TextStyle(color: Colors.white)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: selectedMonth,
                    items: _months
                        .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Gilroy',
                                    fontSize: 16))))
                        .toList(),
                    decoration: customInputDecoration('Month'),
                    dropdownColor: Colors.black,
                    onChanged: (value) =>
                        setDialogState(() => selectedMonth = value),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: selectedDay,
                    items: _days
                        .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Gilroy',
                                    fontSize: 16))))
                        .toList(),
                    decoration: customInputDecoration('Day'),
                    dropdownColor: Colors.black,
                    onChanged: (value) =>
                        setDialogState(() => selectedDay = value),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: selectedYear,
                    items: _years
                        .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Gilroy',
                                    fontSize: 16))))
                        .toList(),
                    decoration: customInputDecoration('Year'),
                    dropdownColor: Colors.black,
                    onChanged: (value) =>
                        setDialogState(() => selectedYear = value),
                  ),
                ],
              ),
              actions: [
                TextButton(
                    child: const Text('Cancel',
                        style: TextStyle(color: Colors.red)),
                    onPressed: () => Navigator.pop(context)),
                TextButton(
                  child:
                      const Text('OK', style: TextStyle(color: Colors.green)),
                  onPressed: () {
                    if (selectedMonth != null &&
                        selectedDay != null &&
                        selectedYear != null) {
                      controller.text =
                          '$selectedMonth $selectedDay, $selectedYear';
                      setState(() {});
                    }
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (event is! RawKeyDownEvent) return;

    switch (_currentStep) {
      case 0:
        _handleClientInfoKeys(event);
        break;
      case 1:
        _handleLandPropertyPart1Keys(event);
        break;
      case 2:
        _handleLandPropertyPart2Keys(event);
        break;
      case 3:
        _handleLandPropertyPart3Keys(event);
        break;
      case 4:
        _handleLandPropertyPart4Keys(event);
        break;
    }
  }

  void _handleClientInfoKeys(RawKeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      if (_firstnameFocus.hasFocus)
        FocusScope.of(context).requestFocus(_middlenameFocus);
      else if (_middlenameFocus.hasFocus)
        FocusScope.of(context).requestFocus(_lastnameFocus);
      else if (_lastnameFocus.hasFocus)
        FocusScope.of(context).requestFocus(_suffixFocus);
      else if (_genderFocus.hasFocus)
        FocusScope.of(context).requestFocus(_statusFocus);
      else if (_statusFocus.hasFocus)
        FocusScope.of(context).requestFocus(_spouseFocus);
      else if (_sitioAddressFocus.hasFocus)
        FocusScope.of(context).requestFocus(_barangayAddressFocus);
      else if (_barangayAddressFocus.hasFocus)
        FocusScope.of(context).requestFocus(_municipalityAddressFocus);
    } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      if (_municipalityAddressFocus.hasFocus)
        FocusScope.of(context).requestFocus(_barangayAddressFocus);
      else if (_barangayAddressFocus.hasFocus)
        FocusScope.of(context).requestFocus(_sitioAddressFocus);
      else if (_spouseFocus.hasFocus)
        FocusScope.of(context).requestFocus(_statusFocus);
      else if (_statusFocus.hasFocus)
        FocusScope.of(context).requestFocus(_genderFocus);
      else if (_suffixFocus.hasFocus)
        FocusScope.of(context).requestFocus(_lastnameFocus);
      else if (_lastnameFocus.hasFocus)
        FocusScope.of(context).requestFocus(_middlenameFocus);
      else if (_middlenameFocus.hasFocus)
        FocusScope.of(context).requestFocus(_firstnameFocus);
    } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      if (_firstnameFocus.hasFocus ||
          _middlenameFocus.hasFocus ||
          _lastnameFocus.hasFocus ||
          _suffixFocus.hasFocus) {
        FocusScope.of(context).requestFocus(_genderFocus);
      } else if (_genderFocus.hasFocus ||
          _statusFocus.hasFocus ||
          _spouseFocus.hasFocus) {
        FocusScope.of(context).requestFocus(_sitioAddressFocus);
      }
    } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      if (_sitioAddressFocus.hasFocus ||
          _barangayAddressFocus.hasFocus ||
          _municipalityAddressFocus.hasFocus) {
        FocusScope.of(context).requestFocus(_spouseFocus);
      } else if (_genderFocus.hasFocus ||
          _statusFocus.hasFocus ||
          _spouseFocus.hasFocus) {
        FocusScope.of(context).requestFocus(_suffixFocus);
      }
    }
  }

  void _handleLandPropertyPart1Keys(RawKeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      if (_bundleNumberFocus.hasFocus)
        FocusScope.of(context).requestFocus(_lotNumberFocus);
      else if (_lotNumberFocus.hasFocus)
        FocusScope.of(context).requestFocus(_identicalNumberFocus);
      else if (_identicalNumberFocus.hasFocus)
        FocusScope.of(context).requestFocus(_surveyClaimantFocus);
      else if (_surveyClaimantFocus.hasFocus)
        FocusScope.of(context).requestFocus(_areaSqmFocus);
    } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      if (_areaSqmFocus.hasFocus)
        FocusScope.of(context).requestFocus(_surveyClaimantFocus);
      else if (_surveyClaimantFocus.hasFocus)
        FocusScope.of(context).requestFocus(_identicalNumberFocus);
      else if (_identicalNumberFocus.hasFocus)
        FocusScope.of(context).requestFocus(_lotNumberFocus);
      else if (_lotNumberFocus.hasFocus)
        FocusScope.of(context).requestFocus(_bundleNumberFocus);
    }
  }

  void _handleLandPropertyPart2Keys(RawKeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      if (_propertyMunicipalityFocus.hasFocus)
        FocusScope.of(context).requestFocus(_propertyBarangayFocus);
      else if (_propertyBarangayFocus.hasFocus)
        FocusScope.of(context).requestFocus(_sitioFocus);
      else if (_sitioFocus.hasFocus)
        FocusScope.of(context).requestFocus(_applicationNumberFocus);
      else if (_applicationNumberFocus.hasFocus)
        FocusScope.of(context).requestFocus(_applicationExtensionFocus);
      else if (_applicationExtensionFocus.hasFocus)
        FocusScope.of(context).requestFocus(_patentNumberFocus);
    } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      if (_patentNumberFocus.hasFocus)
        FocusScope.of(context).requestFocus(_applicationExtensionFocus);
      else if (_applicationExtensionFocus.hasFocus)
        FocusScope.of(context).requestFocus(_applicationNumberFocus);
      else if (_applicationNumberFocus.hasFocus)
        FocusScope.of(context).requestFocus(_sitioFocus);
      else if (_sitioFocus.hasFocus)
        FocusScope.of(context).requestFocus(_propertyBarangayFocus);
      else if (_propertyBarangayFocus.hasFocus)
        FocusScope.of(context).requestFocus(_propertyMunicipalityFocus);
    } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      if (_applicationNumberFocus.hasFocus)
        FocusScope.of(context).requestFocus(_applicationExtensionFocus);
    } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      if (_applicationExtensionFocus.hasFocus)
        FocusScope.of(context).requestFocus(_applicationNumberFocus);
    }
  }

  void _handleLandPropertyPart3Keys(RawKeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      if (_lotStatusFocus.hasFocus)
        FocusScope.of(context).requestFocus(_serialNumberFocus);
      else if (_serialNumberFocus.hasFocus)
        FocusScope.of(context).requestFocus(_landInvestigatorFocus);
      else if (_landInvestigatorFocus.hasFocus)
        FocusScope.of(context).requestFocus(_remarksFocus);
    } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      if (_remarksFocus.hasFocus)
        FocusScope.of(context).requestFocus(_landInvestigatorFocus);
      else if (_landInvestigatorFocus.hasFocus)
        FocusScope.of(context).requestFocus(_serialNumberFocus);
      else if (_serialNumberFocus.hasFocus)
        FocusScope.of(context).requestFocus(_lotStatusFocus);
    }
  }

  void _handleLandPropertyPart4Keys(RawKeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      if (_plaReceivedDateFocus.hasFocus)
        FocusScope.of(context).requestFocus(_tplaToPenroTransmittedDateFocus);
      else if (_tplaToPenroTransmittedDateFocus.hasFocus)
        FocusScope.of(context).requestFocus(_returnFromPenroFocus);
      else if (_returnFromPenroFocus.hasFocus)
        FocusScope.of(context).requestFocus(_rodReceivedDateFocus);
      else if (_rodReceivedDateFocus.hasFocus)
        FocusScope.of(context).requestFocus(_dateAppliedReceivedFocus);
      else if (_dateAppliedReceivedFocus.hasFocus)
        FocusScope.of(context).requestFocus(_dateApprovedFocus);
    } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      if (_dateApprovedFocus.hasFocus)
        FocusScope.of(context).requestFocus(_dateAppliedReceivedFocus);
      else if (_dateAppliedReceivedFocus.hasFocus)
        FocusScope.of(context).requestFocus(_rodReceivedDateFocus);
      else if (_rodReceivedDateFocus.hasFocus)
        FocusScope.of(context).requestFocus(_returnFromPenroFocus);
      else if (_returnFromPenroFocus.hasFocus)
        FocusScope.of(context).requestFocus(_tplaToPenroTransmittedDateFocus);
      else if (_tplaToPenroTransmittedDateFocus.hasFocus)
        FocusScope.of(context).requestFocus(_plaReceivedDateFocus);
    }
  }

  Widget _buildClientForm() {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: _handleKeyEvent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Client Information',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    TextFormField(
                        controller: _firstnameController,
                        focusNode: _firstnameFocus,
                        style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Gilroy',
                            fontSize: 16),
                        decoration: customInputDecoration('First Name',
                            hasValue: _firstnameController.text.isNotEmpty),
                        validator: (value) =>
                            value!.isEmpty ? 'First name is required' : null,
                        onChanged: (_) => setState(() {})),
                    const SizedBox(height: 10),
                    TextFormField(
                        controller: _middlenameController,
                        focusNode: _middlenameFocus,
                        style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Gilroy',
                            fontSize: 16),
                        decoration: customInputDecoration('Middle Name',
                            hasValue: _middlenameController.text.isNotEmpty),
                        onChanged: (_) => setState(() {})),
                    const SizedBox(height: 10),
                    TextFormField(
                        controller: _lastnameController,
                        focusNode: _lastnameFocus,
                        style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Gilroy',
                            fontSize: 16),
                        decoration: customInputDecoration('Last Name',
                            hasValue: _lastnameController.text.isNotEmpty),
                        validator: (value) =>
                            value!.isEmpty ? 'Last name is required' : null,
                        onChanged: (_) => setState(() {})),
                    const SizedBox(height: 10),
                    TextFormField(
                        controller: _suffixController,
                        focusNode: _suffixFocus,
                        style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Gilroy',
                            fontSize: 16),
                        decoration: customInputDecoration('Suffix',
                            hasValue: _suffixController.text.isNotEmpty),
                        onChanged: (_) => setState(() {})),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: _selectedGender,
                      focusNode: _genderFocus,
                      items: _genderOptions
                          .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Gilroy',
                                      fontSize: 16))))
                          .toList(),
                      decoration: customInputDecoration('Gender'),
                      dropdownColor: Colors.black,
                      validator: (value) =>
                          value == null ? 'Select Gender' : null,
                      onChanged: (value) =>
                          setState(() => _selectedGender = value),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: _selectedStatus,
                      focusNode: _statusFocus,
                      items: _statusOptions
                          .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Gilroy',
                                      fontSize: 16))))
                          .toList(),
                      decoration: customInputDecoration('Status'),
                      dropdownColor: Colors.black,
                      validator: (value) =>
                          value == null ? 'Select Status' : null,
                      onChanged: (value) =>
                          setState(() => _selectedStatus = value),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                        controller: _spouseController,
                        focusNode: _spouseFocus,
                        style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Gilroy',
                            fontSize: 16),
                        decoration: customInputDecoration('Spouse',
                            hasValue: _spouseController.text.isNotEmpty),
                        onChanged: (_) => setState(() {})),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: [
                    TextFormField(
                        controller: _sitioAddressController,
                        focusNode: _sitioAddressFocus,
                        style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Gilroy',
                            fontSize: 16),
                        decoration: customInputDecoration('Sitio Address',
                            hasValue: _sitioAddressController.text.isNotEmpty),
                        onChanged: (_) => setState(() {})),
                    const SizedBox(height: 10),
                    TextFormField(
                        controller: _barangayAddressController,
                        focusNode: _barangayAddressFocus,
                        style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Gilroy',
                            fontSize: 16),
                        decoration: customInputDecoration('Barangay Address',
                            hasValue:
                                _barangayAddressController.text.isNotEmpty),
                        onChanged: (_) => setState(() {})),
                    const SizedBox(height: 10),
                    TextFormField(
                        controller: _municipalityAddressController,
                        focusNode: _municipalityAddressFocus,
                        style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Gilroy',
                            fontSize: 16),
                        decoration: customInputDecoration(
                            'Municipality Address',
                            hasValue:
                                _municipalityAddressController.text.isNotEmpty),
                        onChanged: (_) => setState(() {})),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLandPropertyFormPart1() {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: _handleKeyEvent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          TextFormField(
              controller: _bundleNumberController,
              focusNode: _bundleNumberFocus,
              style: const TextStyle(
                  color: Colors.white, fontFamily: 'Gilroy', fontSize: 16),
              decoration: customInputDecoration('Bundle Number',
                  hasValue: _bundleNumberController.text.isNotEmpty),
              onChanged: (_) => setState(() {})),
          const SizedBox(height: 10),
          TextFormField(
              controller: _lotNumberController,
              focusNode: _lotNumberFocus,
              style: const TextStyle(
                  color: Colors.white, fontFamily: 'Gilroy', fontSize: 16),
              decoration: customInputDecoration('Lot Number',
                  hasValue: _lotNumberController.text.isNotEmpty),
              validator: (value) =>
                  value!.isEmpty ? 'Lot number is required' : null,
              onChanged: (_) => setState(() {})),
          const SizedBox(height: 10),
          TextFormField(
              controller: _identicalNumberController,
              focusNode: _identicalNumberFocus,
              style: const TextStyle(
                  color: Colors.white, fontFamily: 'Gilroy', fontSize: 16),
              decoration: customInputDecoration('Identical Number',
                  hasValue: _identicalNumberController.text.isNotEmpty),
              onChanged: (_) => setState(() {})),
          const SizedBox(height: 10),
          TextFormField(
              controller: _surveyClaimantController,
              focusNode: _surveyClaimantFocus,
              style: const TextStyle(
                  color: Colors.white, fontFamily: 'Gilroy', fontSize: 16),
              decoration: customInputDecoration('Survey Claimant',
                  hasValue: _surveyClaimantController.text.isNotEmpty),
              onChanged: (_) => setState(() {})),
          const SizedBox(height: 10),
          TextFormField(
            controller: _areaSqmController,
            focusNode: _areaSqmFocus,
            style: const TextStyle(
                color: Colors.white, fontFamily: 'Gilroy', fontSize: 16),
            decoration: customInputDecoration('Area (SQM)',
                hasValue: _areaSqmController.text.isNotEmpty),
            keyboardType: TextInputType.number,
            validator: (value) => value!.isEmpty
                ? 'Area is required'
                : (double.tryParse(value) == null || double.parse(value) <= 0
                    ? 'Enter a valid area'
                    : null),
            onChanged: (_) => setState(() {}),
          ),
        ],
      ),
    );
  }

  Widget _buildLandPropertyFormPart2() {
    final availableOptions = _selectedPropertyMunicipality != null
        ? _applicationNumberOptions[_selectedPropertyMunicipality] ?? <String>[]
        : <String>[];

    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: _handleKeyEvent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: _selectedPropertyMunicipality,
            focusNode: _propertyMunicipalityFocus,
            items: _municipalities
                .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e,
                        style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Gilroy',
                            fontSize: 16))))
                .toList(),
            decoration: customInputDecoration('Property Municipality'),
            dropdownColor: Colors.black,
            validator: (value) => value == null ? 'Select Municipality' : null,
            onChanged: (value) => setState(() {
              _selectedPropertyMunicipality = value;
              _selectedPropertyBarangay = null;
              _selectedApplicationNumber = null;
            }),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: _selectedPropertyBarangay,
            focusNode: _propertyBarangayFocus,
            items: (_selectedPropertyMunicipality != null
                    ? _barangays[_selectedPropertyMunicipality]
                    : <String>[])
                ?.map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e,
                        style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Gilroy',
                            fontSize: 16))))
                .toList(),
            decoration: customInputDecoration('Property Barangay'),
            dropdownColor: Colors.black,
            validator: (value) => value == null ? 'Select Barangay' : null,
            onChanged: (value) =>
                setState(() => _selectedPropertyBarangay = value),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _sitioController,
            focusNode: _sitioFocus,
            style: const TextStyle(
                color: Colors.white, fontFamily: 'Gilroy', fontSize: 16),
            decoration: customInputDecoration('Sitio',
                hasValue: _sitioController.text.isNotEmpty),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedApplicationNumber,
                  focusNode: _applicationNumberFocus,
                  items: availableOptions
                      .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Gilroy',
                                  fontSize: 16))))
                      .toList(),
                  decoration: customInputDecoration('Application Number'),
                  dropdownColor: Colors.black,
                  onChanged: (value) =>
                      setState(() => _selectedApplicationNumber = value),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 200,
                child: TextFormField(
                  controller: _applicationExtensionController,
                  focusNode: _applicationExtensionFocus,
                  style: const TextStyle(
                      color: Colors.white, fontFamily: 'Gilroy', fontSize: 16),
                  decoration: customInputDecoration('Ext.',
                      hasValue:
                          _applicationExtensionController.text.isNotEmpty),
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _patentNumberController,
            focusNode: _patentNumberFocus,
            style: const TextStyle(
                color: Colors.white, fontFamily: 'Gilroy', fontSize: 16),
            decoration: customInputDecoration('Patent Number',
                hasValue: _patentNumberController.text.isNotEmpty),
            onChanged: (_) => setState(() {}),
          ),
        ],
      ),
    );
  }

  Widget _buildLandPropertyFormPart3() {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: _handleKeyEvent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: _selectedLotStatus,
            focusNode: _lotStatusFocus,
            items: _lotStatusOptions
                .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e,
                        style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Gilroy',
                            fontSize: 16))))
                .toList(),
            decoration: customInputDecoration('Lot Status'),
            dropdownColor: Colors.black,
            onChanged: (value) => setState(() => _selectedLotStatus = value),
          ),
          const SizedBox(height: 10),
          TextFormField(
              controller: _serialNumberController,
              focusNode: _serialNumberFocus,
              style: const TextStyle(
                  color: Colors.white, fontFamily: 'Gilroy', fontSize: 16),
              decoration: customInputDecoration('Serial Number',
                  hasValue: _serialNumberController.text.isNotEmpty),
              onChanged: (_) => setState(() {})),
          const SizedBox(height: 10),
          TextFormField(
              controller: _landInvestigatorController,
              focusNode: _landInvestigatorFocus,
              style: const TextStyle(
                  color: Colors.white, fontFamily: 'Gilroy', fontSize: 16),
              decoration: customInputDecoration('Name of Investigator',
                  hasValue: _landInvestigatorController.text.isNotEmpty),
              onChanged: (_) => setState(() {})),
          const SizedBox(height: 10),
          TextFormField(
              controller: _remarksController,
              focusNode: _remarksFocus,
              style: const TextStyle(
                  color: Colors.white, fontFamily: 'Gilroy', fontSize: 16),
              decoration: customInputDecoration('Remarks',
                  hasValue: _remarksController.text.isNotEmpty),
              maxLines: 2,
              onChanged: (_) => setState(() {})),
        ],
      ),
    );
  }

  Widget _buildLandPropertyFormPart4() {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: _handleKeyEvent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          TextFormField(
              controller: _plaReceivedDateController,
              focusNode: _plaReceivedDateFocus,
              style: const TextStyle(
                  color: Colors.white, fontFamily: 'Gilroy', fontSize: 16),
              decoration: customInputDecoration('PLA Received Date',
                      hasValue: _plaReceivedDateController.text.isNotEmpty)
                  .copyWith(
                      suffixIcon: const Icon(Icons.calendar_today,
                          color: Colors.white)),
              readOnly: true,
              onTap: () => _showDateDialog(
                  'PLA Received Date', _plaReceivedDateController)),
          const SizedBox(height: 10),
          TextFormField(
              controller: _tplaToPenroTransmittedDateController,
              focusNode: _tplaToPenroTransmittedDateFocus,
              style: const TextStyle(
                  color: Colors.white, fontFamily: 'Gilroy', fontSize: 16),
              decoration: customInputDecoration(
                      'TPLA to PENRO Transmitted Date',
                      hasValue:
                          _tplaToPenroTransmittedDateController.text.isNotEmpty)
                  .copyWith(
                      suffixIcon: const Icon(Icons.calendar_today,
                          color: Colors.white)),
              readOnly: true,
              onTap: () => _showDateDialog('TPLA to PENRO Transmitted Date',
                  _tplaToPenroTransmittedDateController)),
          const SizedBox(height: 10),
          TextFormField(
              controller: _returnFromPenroController,
              focusNode: _returnFromPenroFocus,
              style: const TextStyle(
                  color: Colors.white, fontFamily: 'Gilroy', fontSize: 16),
              decoration: customInputDecoration('Return From PENRO',
                      hasValue: _returnFromPenroController.text.isNotEmpty)
                  .copyWith(
                      suffixIcon: const Icon(Icons.calendar_today,
                          color: Colors.white)),
              readOnly: true,
              onTap: () => _showDateDialog(
                  'Return From PENRO', _returnFromPenroController)),
          const SizedBox(height: 10),
          TextFormField(
              controller: _rodReceivedDateController,
              focusNode: _rodReceivedDateFocus,
              style: const TextStyle(
                  color: Colors.white, fontFamily: 'Gilroy', fontSize: 16),
              decoration: customInputDecoration('ROD Received Date',
                      hasValue: _rodReceivedDateController.text.isNotEmpty)
                  .copyWith(
                      suffixIcon: const Icon(Icons.calendar_today,
                          color: Colors.white)),
              readOnly: true,
              onTap: () => _showDateDialog(
                  'ROD Received Date', _rodReceivedDateController)),
          const SizedBox(height: 10),
          TextFormField(
              controller: _dateAppliedReceivedController,
              focusNode: _dateAppliedReceivedFocus,
              style: const TextStyle(
                  color: Colors.white, fontFamily: 'Gilroy', fontSize: 16),
              decoration: customInputDecoration('Date Applied/Received',
                      hasValue: _dateAppliedReceivedController.text.isNotEmpty)
                  .copyWith(
                      suffixIcon: const Icon(Icons.calendar_today,
                          color: Colors.white)),
              readOnly: true,
              onTap: () => _showDateDialog(
                  'Date Applied/Received', _dateAppliedReceivedController)),
          const SizedBox(height: 10),
          TextFormField(
              controller: _dateApprovedController,
              focusNode: _dateApprovedFocus,
              style: const TextStyle(
                  color: Colors.white, fontFamily: 'Gilroy', fontSize: 16),
              decoration: customInputDecoration('Date Approved',
                      hasValue: _dateApprovedController.text.isNotEmpty)
                  .copyWith(
                      suffixIcon: const Icon(Icons.calendar_today,
                          color: Colors.white)),
              readOnly: true,
              onTap: () =>
                  _showDateDialog('Date Approved', _dateApprovedController)),
        ],
      ),
    );
  }

  Widget _buildPreviewForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Divider(height: 5, thickness: 0.3, color: Colors.white54),
        const Text('Client Information',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 45, 114, 255))),
        const SizedBox(height: 10),
        _buildPreviewRow('First Name', _firstnameController.text),
        _buildPreviewRow('Middle Name', _middlenameController.text),
        _buildPreviewRow('Last Name', _lastnameController.text),
        _buildPreviewRow('Suffix', _suffixController.text),
        _buildPreviewRow('Gender', _selectedGender ?? ''),
        _buildPreviewRow('Status', _selectedStatus ?? ''),
        _buildPreviewRow('Spouse', _spouseController.text),
        _buildPreviewRow('Sitio Address', _sitioAddressController.text),
        _buildPreviewRow('Barangay Address', _barangayAddressController.text),
        _buildPreviewRow(
            'Municipality Address', _municipalityAddressController.text),
        const SizedBox(height: 20),
        const Divider(height: 5, thickness: 0.3, color: Colors.white54),
        const Text('Land Property Information',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 45, 114, 255))),
        const SizedBox(height: 10),
        _buildPreviewRow('Bundle Number', _bundleNumberController.text),
        _buildPreviewRow('Lot Number', _lotNumberController.text),
        _buildPreviewRow('Identical Number', _identicalNumberController.text),
        _buildPreviewRow('Survey Claimant', _surveyClaimantController.text),
        _buildPreviewRow('Area (SQM)', _areaSqmController.text),
        _buildPreviewRow(
            'Property Municipality', _selectedPropertyMunicipality ?? ''),
        _buildPreviewRow('Property Barangay', _selectedPropertyBarangay ?? ''),
        _buildPreviewRow('Sitio', _sitioController.text),
        _buildPreviewRow('Application Number',
            '${_selectedApplicationNumber ?? ''}${_applicationExtensionController.text.isNotEmpty ? ' ${_applicationExtensionController.text}' : ''}'),
        _buildPreviewRow('Patent Number', _patentNumberController.text),
        _buildPreviewRow('Lot Status', _selectedLotStatus ?? ''),
        _buildPreviewRow('Serial Number', _serialNumberController.text),
        _buildPreviewRow('Land Investigator', _landInvestigatorController.text),
        _buildPreviewRow('Remarks', _remarksController.text),
        _buildPreviewRow('PLA Received Date', _plaReceivedDateController.text),
        _buildPreviewRow('TPLA to PENRO Transmitted Date',
            _tplaToPenroTransmittedDateController.text),
        _buildPreviewRow('Return From PENRO', _returnFromPenroController.text),
        _buildPreviewRow('ROD Received Date', _rodReceivedDateController.text),
        _buildPreviewRow(
            'Date Applied/Received', _dateAppliedReceivedController.text),
        _buildPreviewRow('Date Approved', _dateApprovedController.text),
        const SizedBox(height: 5),
        const Divider(height: 5, thickness: 0.3, color: Colors.white54),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildPreviewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 200,
              child: Text(label,
                  style: const TextStyle(
                      color: Colors.white54,
                      fontFamily: 'Gilroy',
                      fontSize: 16))),
          Expanded(
              child: Text(value.isEmpty ? 'Not provided' : value,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 13, 136, 69),
                      fontFamily: 'Gilroy',
                      fontSize: 16))),
        ],
      ),
    );
  }

  Widget _buildLandPropertyNavigation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
            onTap: () => setState(() => _currentStep = 1),
            child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                    color: _currentStep == 1
                        ? const Color.fromARGB(255, 13, 136, 69)
                        : const Color.fromARGB(255, 60, 60, 62),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8))),
                child: const Text('Part 1',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Gilroy',
                        fontSize: 16)))),
        GestureDetector(
            onTap: () => setState(() => _currentStep = 2),
            child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                color: _currentStep == 2
                    ? const Color.fromARGB(255, 13, 136, 69)
                    : const Color.fromARGB(255, 60, 60, 62),
                child: const Text('Part 2',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Gilroy',
                        fontSize: 16)))),
        GestureDetector(
            onTap: () => setState(() => _currentStep = 3),
            child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                color: _currentStep == 3
                    ? const Color.fromARGB(255, 13, 136, 69)
                    : const Color.fromARGB(255, 60, 60, 62),
                child: const Text('Part 3',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Gilroy',
                        fontSize: 16)))),
        GestureDetector(
            onTap: () => setState(() => _currentStep = 4),
            child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                    color: _currentStep == 4
                        ? const Color.fromARGB(255, 13, 136, 69)
                        : const Color.fromARGB(255, 60, 60, 62),
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomRight: Radius.circular(8))),
                child: const Text('Part 4',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Gilroy',
                        fontSize: 16)))),
      ],
    );
  }

  String _getFullName() {
    return [
      _firstnameController.text,
      _middlenameController.text,
      _lastnameController.text,
      _suffixController.text
    ].where((e) => e.isNotEmpty).join(' ').trim();
  }

  double _getUpdatedParentArea() {
    double originalArea = double.tryParse(
            widget.landPropertyData['area_sqm']?.toString() ?? '0') ??
        0.0;
    double totalSubdividedArea = _subdividedLands.fold(
            0.0, (sum, land) => sum + (land['area_sqm'] as double)) +
        (double.tryParse(_areaSqmController.text) ?? 0.0);
    return originalArea - totalSubdividedArea;
  }

  bool _isAreaExceeded() {
    double originalArea = double.tryParse(
            widget.landPropertyData['area_sqm']?.toString() ?? '0') ??
        0.0;
    double totalSubdividedArea = _subdividedLands.fold(
            0.0, (sum, land) => sum + (land['area_sqm'] as double)) +
        (double.tryParse(_areaSqmController.text) ?? 0.0);
    return totalSubdividedArea > originalArea;
  }

  void _addSubdivision() {
    if (!_formKey.currentState!.validate()) return;

    final subdivision = {
      'lot_number': _lotNumberController.text,
      'full_name': _getFullName(),
      'area_sqm': double.tryParse(_areaSqmController.text) ?? 0.0,
      'client': {
        DatabaseHelper.columnApplicantFirstname: _firstnameController.text,
        DatabaseHelper.columnApplicantMiddlename: _middlenameController.text,
        DatabaseHelper.columnApplicantLastname: _lastnameController.text,
        DatabaseHelper.columnApplicantSuffix: _suffixController.text,
        DatabaseHelper.columnGender: _selectedGender ?? '',
        DatabaseHelper.columnStatus: _selectedStatus ?? '',
        DatabaseHelper.columnSpouse: _spouseController.text,
        DatabaseHelper.columnSitioAddress: _sitioAddressController.text,
        DatabaseHelper.columnBarangayAddress: _barangayAddressController.text,
        DatabaseHelper.columnMunicipalityAddress:
            _municipalityAddressController.text,
      },
      'land_property': {
        DatabaseHelper.columnBundleNumber: _bundleNumberController.text,
        DatabaseHelper.columnLotNumber: _lotNumberController.text,
        DatabaseHelper.columnIdenticalNumber: _identicalNumberController.text,
        DatabaseHelper.columnSurveyClaimant: _surveyClaimantController.text,
        DatabaseHelper.columnAreaSqm:
            double.tryParse(_areaSqmController.text) ?? 0.0,
        DatabaseHelper.columnSitio: _sitioController.text,
        DatabaseHelper.columnPropertyBarangay: _selectedPropertyBarangay ?? '',
        DatabaseHelper.columnPropertyMunicipality:
            _selectedPropertyMunicipality ?? '',
        DatabaseHelper.columnRemarks: _remarksController.text,
        DatabaseHelper.columnApplicationNumber:
            '${_selectedApplicationNumber ?? ''}${_applicationExtensionController.text.isNotEmpty ? ' ${_applicationExtensionController.text}' : ''}',
        DatabaseHelper.columnPatentNumber: _patentNumberController.text,
        DatabaseHelper.columnLotStatus: _selectedLotStatus ?? '',
        DatabaseHelper.columnPlaReceivedDate: _plaReceivedDateController.text,
        DatabaseHelper.columnTplaToPenroTransmittedDate:
            _tplaToPenroTransmittedDateController.text,
        DatabaseHelper.columnReturnFromPenro: _returnFromPenroController.text,
        DatabaseHelper.columnRodReceivedDate: _rodReceivedDateController.text,
        DatabaseHelper.columnDateAppliedReceived:
            _dateAppliedReceivedController.text,
        DatabaseHelper.columnDateApproved: _dateApprovedController.text,
        DatabaseHelper.columnSerialNumber: _serialNumberController.text,
        DatabaseHelper.columnLandInvestigator: _landInvestigatorController.text,
      }
    };

    setState(() {
      _subdividedLands.add(subdivision);
      _clearForm();
      _currentStep = 0; // Reset to client info for new entry
    });
  }

  void _editSubdivision(int index) {
    final subdivision = _subdividedLands[index];
    _clearForm();

    // Populate client fields
    _firstnameController.text =
        subdivision['client'][DatabaseHelper.columnApplicantFirstname] ?? '';
    _middlenameController.text =
        subdivision['client'][DatabaseHelper.columnApplicantMiddlename] ?? '';
    _lastnameController.text =
        subdivision['client'][DatabaseHelper.columnApplicantLastname] ?? '';
    _suffixController.text =
        subdivision['client'][DatabaseHelper.columnApplicantSuffix] ?? '';
    _selectedGender =
        (subdivision['client'][DatabaseHelper.columnGender] ?? '').isNotEmpty
            ? subdivision['client'][DatabaseHelper.columnGender]
            : null;
    _selectedStatus =
        (subdivision['client'][DatabaseHelper.columnStatus] ?? '').isNotEmpty
            ? subdivision['client'][DatabaseHelper.columnStatus]
            : null;
    _spouseController.text =
        subdivision['client'][DatabaseHelper.columnSpouse] ?? '';
    _sitioAddressController.text =
        subdivision['client'][DatabaseHelper.columnSitioAddress] ?? '';
    _barangayAddressController.text =
        subdivision['client'][DatabaseHelper.columnBarangayAddress] ?? '';
    _municipalityAddressController.text =
        subdivision['client'][DatabaseHelper.columnMunicipalityAddress] ?? '';

    // Populate land property fields
    _bundleNumberController.text =
        subdivision['land_property'][DatabaseHelper.columnBundleNumber] ?? '';
    _lotNumberController.text =
        subdivision['land_property'][DatabaseHelper.columnLotNumber] ?? '';
    _identicalNumberController.text = subdivision['land_property']
            [DatabaseHelper.columnIdenticalNumber] ??
        '';
    _surveyClaimantController.text =
        subdivision['land_property'][DatabaseHelper.columnSurveyClaimant] ?? '';
    _areaSqmController.text =
        (subdivision['land_property'][DatabaseHelper.columnAreaSqm] ?? 0.0)
            .toString();
    _sitioController.text =
        subdivision['land_property'][DatabaseHelper.columnSitio] ?? '';
    _selectedPropertyBarangay = (subdivision['land_property']
                    [DatabaseHelper.columnPropertyBarangay] ??
                '')
            .isNotEmpty
        ? subdivision['land_property'][DatabaseHelper.columnPropertyBarangay]
        : null;
    _selectedPropertyMunicipality = (subdivision['land_property']
                    [DatabaseHelper.columnPropertyMunicipality] ??
                '')
            .isNotEmpty
        ? subdivision['land_property']
            [DatabaseHelper.columnPropertyMunicipality]
        : null;
    _remarksController.text =
        subdivision['land_property'][DatabaseHelper.columnRemarks] ?? '';

    // Handle application number
    String appNum = subdivision['land_property']
            [DatabaseHelper.columnApplicationNumber] ??
        '';
    if (appNum.trim().isNotEmpty) {
      final options = _applicationNumberOptions[_selectedPropertyMunicipality];
      if (options != null && options.contains(appNum)) {
        _selectedApplicationNumber = appNum;
        _applicationExtensionController.text = '';
      } else {
        final parts = appNum.trim().split(' ');
        String baseAppNum = parts.first;
        if (options != null && options.contains(baseAppNum)) {
          _selectedApplicationNumber = baseAppNum;
          _applicationExtensionController.text =
              parts.length > 1 ? parts.sublist(1).join(' ') : '';
        } else {
          _selectedApplicationNumber = null;
          _applicationExtensionController.text = appNum;
        }
      }
    } else {
      _selectedApplicationNumber = null;
      _applicationExtensionController.text = '';
    }

    _patentNumberController.text =
        subdivision['land_property'][DatabaseHelper.columnPatentNumber] ?? '';
    _selectedLotStatus =
        (subdivision['land_property'][DatabaseHelper.columnLotStatus] ?? '')
                .isNotEmpty
            ? subdivision['land_property'][DatabaseHelper.columnLotStatus]
            : null;
    _serialNumberController.text =
        subdivision['land_property'][DatabaseHelper.columnSerialNumber] ?? '';
    _landInvestigatorController.text = subdivision['land_property']
            [DatabaseHelper.columnLandInvestigator] ??
        '';
    _plaReceivedDateController.text = subdivision['land_property']
            [DatabaseHelper.columnPlaReceivedDate] ??
        '';
    _tplaToPenroTransmittedDateController.text = subdivision['land_property']
            [DatabaseHelper.columnTplaToPenroTransmittedDate] ??
        '';
    _returnFromPenroController.text = subdivision['land_property']
            [DatabaseHelper.columnReturnFromPenro] ??
        '';
    _rodReceivedDateController.text = subdivision['land_property']
            [DatabaseHelper.columnRodReceivedDate] ??
        '';
    _dateAppliedReceivedController.text = subdivision['land_property']
            [DatabaseHelper.columnDateAppliedReceived] ??
        '';
    _dateApprovedController.text =
        subdivision['land_property'][DatabaseHelper.columnDateApproved] ?? '';

    setState(() {
      _subdividedLands.removeAt(index);
      _currentStep = 0; // Start editing from client info
    });
  }

  void _clearForm() {
    _firstnameController.clear();
    _middlenameController.clear();
    _lastnameController.clear();
    _suffixController.clear();
    _selectedGender = null;
    _selectedStatus = null;
    _spouseController.clear();
    _sitioAddressController.clear();
    _barangayAddressController.clear();
    _municipalityAddressController.clear();
    _bundleNumberController.clear();
    _lotNumberController.clear();
    _identicalNumberController.clear();
    _surveyClaimantController.clear();
    _areaSqmController.clear();
    _sitioController.clear();
    _selectedPropertyMunicipality = null;
    _selectedPropertyBarangay = null;
    _selectedApplicationNumber = null;
    _applicationExtensionController.clear();
    _patentNumberController.clear();
    _selectedLotStatus = null;
    _serialNumberController.clear();
    _landInvestigatorController.clear();
    _remarksController.clear();
    _plaReceivedDateController.clear();
    _tplaToPenroTransmittedDateController.clear();
    _returnFromPenroController.clear();
    _rodReceivedDateController.clear();
    _dateAppliedReceivedController.clear();
    _dateApprovedController.clear();
  }

  Future<void> _acceptAllChanges() async {
    if (_subdividedLands.isEmpty) {
      Navigator.pop(context);
      return;
    }

    if (_isAreaExceeded()) {
      _showErrorDialog(
          message: "Total subdivided area exceeds the original area.");
      return;
    }

    setState(() => _isLoading = true);
    try {
      for (var subdivision in _subdividedLands) {
        int clientId = await DatabaseHelper.instance
            .insertClient(subdivision['client'] as Map<String, dynamic>);
        final landPropertyMap = Map<String, dynamic>.from(
            subdivision['land_property'] as Map<String, dynamic>)
          ..addAll({
            DatabaseHelper.columnClientIdRef: clientId,
            DatabaseHelper.columnParentLandPropertyId:
                widget.landPropertyData['land_property_id'],
          });
        await DatabaseHelper.instance.insertLandProperty(landPropertyMap);
      }

      double originalArea = double.tryParse(
              widget.landPropertyData['area_sqm']?.toString() ?? '0') ??
          0.0;
      double totalSubdividedArea = _subdividedLands.fold(
          0.0, (sum, land) => sum + (land['area_sqm'] as double));
      if (originalArea > totalSubdividedArea) {
        await DatabaseHelper.instance.updateLandProperty({
          DatabaseHelper.columnLandPropertyId:
              widget.landPropertyData['land_property_id'],
          DatabaseHelper.columnAreaSqm: originalArea - totalSubdividedArea,
        });
      } else if (originalArea == totalSubdividedArea) {
        await DatabaseHelper.instance
            .deleteLandProperty(widget.landPropertyData['land_property_id']);
      }

      setState(() => _isLoading = false);
      _showSuccessDialog();
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorDialog(message: "Error saving subdivisions: $e");
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 36, 36, 38),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(
                  color: Color.fromARGB(255, 13, 136, 69), width: 0.7)),
          title: const Text('Success', style: TextStyle(color: Colors.white)),
          content: const Text('All subdivisions successfully added!',
              style: TextStyle(color: Colors.white70)),
          actions: [
            TextButton(
              child: const Text('OK', style: TextStyle(color: Colors.green)),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(
      {String message = "Subdivisions didn't save. Please try again."}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 36, 36, 38),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(color: Colors.red, width: 0.7)),
          title: const Text('Error', style: TextStyle(color: Colors.white)),
          content: Text(message, style: const TextStyle(color: Colors.white70)),
          actions: [
            TextButton(
                child: const Text('OK', style: TextStyle(color: Colors.red)),
                onPressed: () => Navigator.pop(context)),
          ],
        );
      },
    );
  }

  void _deleteSubdivision(int index) {
    setState(() {
      _subdividedLands.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Construct full name for Original Land Property
    Map<String, dynamic> clientData =
        widget.landPropertyData['client'] ?? widget.landPropertyData;
    String firstName =
        clientData[DatabaseHelper.columnApplicantFirstname] ?? '';
    String middleName =
        clientData[DatabaseHelper.columnApplicantMiddlename] ?? '';
    String lastName = clientData[DatabaseHelper.columnApplicantLastname] ?? '';
    String suffix = clientData[DatabaseHelper.columnApplicantSuffix] ?? '';
    String middleInitial = middleName.isNotEmpty ? '${middleName[0]}.' : '';
    String originalFullName = [firstName, middleInitial, lastName, suffix]
        .where((e) => e.isNotEmpty)
        .join(' ')
        .trim();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 22, 22, 24), // Dark background
      appBar: AppBar(
        title: const Text('Sub-Dividing Land'),
        backgroundColor: const Color.fromARGB(255, 22, 22, 24),
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: const Color.fromARGB(255, 22, 22, 24),
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Side: Original and Subdivided Land Property Info
            Container(
              height: 800, // Fixed height for the left section
              width:
                  MediaQuery.of(context).size.width * 0.4, // Responsive width
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 28, 28, 30),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: const Color.fromARGB(255, 60, 60, 62), width: 0.4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Original Land Property',
                    style: TextStyle(
                      color: Color.fromARGB(255, 13, 136, 69),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Gilroy',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Full Name: $originalFullName',
                    style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontFamily: 'Gilroy'),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Lot Number: ${widget.landPropertyData['lot_number'] ?? 'N/A'}',
                    style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontFamily: 'Gilroy'),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Area (SQM): ${_getUpdatedParentArea().toStringAsFixed(2)}',
                        style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            fontFamily: 'Gilroy'),
                      ),
                      if (_isAreaExceeded())
                        const Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Text(
                            '(Warning: Exceeds Original Area)',
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                                fontFamily: 'Gilroy'),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: Colors.white54, thickness: 0.3),
                  const SizedBox(height: 20),
                  const Text(
                    'Subdivided Lands',
                    style: TextStyle(
                      color: Color.fromARGB(255, 45, 114, 255),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Gilroy',
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (_subdividedLands.isEmpty)
                    const Text(
                      'No subdivisions added yet.',
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontFamily: 'Gilroy'),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: _subdividedLands.length,
                        itemBuilder: (context, index) {
                          final isFirst = index == 0;
                          final isLast = index == _subdividedLands.length - 1;
                          final land = _subdividedLands[index];
                          final client = land['client'] as Map<String, dynamic>;

                          // Construct full name for Subdivided Lands
                          String firstName =
                              client[DatabaseHelper.columnApplicantFirstname] ??
                                  '';
                          String middleName = client[
                                  DatabaseHelper.columnApplicantMiddlename] ??
                              '';
                          String lastName =
                              client[DatabaseHelper.columnApplicantLastname] ??
                                  '';
                          String suffix =
                              client[DatabaseHelper.columnApplicantSuffix] ??
                                  '';
                          String middleInitial =
                              middleName.isNotEmpty ? '${middleName[0]}.' : '';
                          String fullName = [
                            firstName,
                            middleInitial,
                            lastName,
                            suffix
                          ].where((e) => e.isNotEmpty).join(' ').trim();

                          return TimelineTile(
                            alignment: TimelineAlign.start,
                            isFirst: isFirst,
                            isLast: isLast,
                            indicatorStyle: const IndicatorStyle(
                              width: 20,
                              color: Colors.blue,
                              padding: EdgeInsets.all(8),
                            ),
                            endChild: Container(
                              constraints: const BoxConstraints(minHeight: 80),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Lot Number: ${land['lot_number']}',
                                    style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 16,
                                        fontFamily: 'Gilroy'),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Full Name: $fullName',
                                    style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 16,
                                        fontFamily: 'Gilroy'),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Area (SQM): ${land['area_sqm'].toStringAsFixed(2)}',
                                    style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 16,
                                        fontFamily: 'Gilroy'),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton.icon(
                                        icon: const Icon(Icons.edit,
                                            color: Colors.yellow, size: 16),
                                        label: const Text('Edit',
                                            style: TextStyle(
                                                color: Colors.yellow,
                                                fontFamily: 'Gilroy',
                                                fontSize: 14)),
                                        onPressed: () =>
                                            _editSubdivision(index),
                                      ),
                                      const SizedBox(width: 8),
                                      TextButton.icon(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red, size: 16),
                                        label: const Text('Delete',
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontFamily: 'Gilroy',
                                                fontSize: 14)),
                                        onPressed: () =>
                                            _deleteSubdivision(index),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 20),
                  Center(
                    child: SizedBox(
                      width: 200,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _acceptAllChanges,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 13, 136, 69),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24)),
                        ),
                        child: const Text('Accept All Changes',
                            style: TextStyle(
                                color: Colors.white, fontFamily: 'Gilroy')),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Right Side: Form for Client and Land Property Info
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 28, 28, 30),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: const Color.fromARGB(255, 60, 60, 62), width: 0.4),
                ),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (_currentStep == 0) _buildClientForm(),
                              if (_currentStep >= 1 && _currentStep <= 4) ...[
                                const Text('Land Property Information',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                                const SizedBox(height: 10),
                                _buildLandPropertyNavigation(),
                                const SizedBox(height: 20),
                                if (_currentStep == 1)
                                  _buildLandPropertyFormPart1(),
                                if (_currentStep == 2)
                                  _buildLandPropertyFormPart2(),
                                if (_currentStep == 3)
                                  _buildLandPropertyFormPart3(),
                                if (_currentStep == 4)
                                  _buildLandPropertyFormPart4(),
                              ],
                              if (_currentStep == 5) _buildPreviewForm(),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: _currentStep == 0
                                    ? [
                                        SizedBox(
                                            width: 150,
                                            height: 50,
                                            child: ElevatedButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: const Color.fromARGB(
                                                        255, 60, 60, 62),
                                                    foregroundColor:
                                                        Colors.white54,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(
                                                            24),
                                                        side: const BorderSide(
                                                            color: Color.fromARGB(
                                                                255, 13, 136, 69),
                                                            width: 0.7))),
                                                child: const Text('Cancel',
                                                    style: TextStyle(color: Colors.white, fontFamily: 'Gilroy')))),
                                        SizedBox(
                                            width: 150,
                                            height: 50,
                                            child: ElevatedButton(
                                                onPressed: () {
                                                  if (_formKey.currentState!
                                                      .validate())
                                                    setState(
                                                        () => _currentStep = 1);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                            255, 60, 62, 62),
                                                    foregroundColor:
                                                        Colors.white54,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                24),
                                                        side: const BorderSide(
                                                            color: Color.fromARGB(
                                                                255, 13, 136, 69),
                                                            width: 0.7))),
                                                child: const Text('Next',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily: 'Gilroy')))),
                                      ]
                                    : [
                                        SizedBox(
                                            width: 150,
                                            height: 50,
                                            child: ElevatedButton(
                                                onPressed: () => setState(() =>
                                                    _currentStep = _currentStep == 1
                                                        ? 0
                                                        : _currentStep - 1),
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: const Color.fromARGB(
                                                        255, 60, 60, 62),
                                                    foregroundColor:
                                                        Colors.white54,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(
                                                            24),
                                                        side: const BorderSide(
                                                            color: Color.fromARGB(255, 13, 136, 69),
                                                            width: 0.7))),
                                                child: const Text('Back', style: TextStyle(color: Colors.white, fontFamily: 'Gilroy')))),
                                        SizedBox(
                                            width: 150,
                                            height: 50,
                                            child: ElevatedButton(
                                              onPressed: _currentStep == 5
                                                  ? _addSubdivision
                                                  : () => setState(
                                                      () => _currentStep += 1),
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color.fromARGB(
                                                          255, 60, 60, 62),
                                                  foregroundColor:
                                                      Colors.white54,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              24),
                                                      side: const BorderSide(
                                                          color: Color.fromARGB(
                                                              255, 13, 136, 69),
                                                          width: 0.7))),
                                              child: Text(
                                                  _currentStep == 5
                                                      ? 'Add Subdivision'
                                                      : 'Next',
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: 'Gilroy')),
                                            )),
                                      ],
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
