// ignore_for_file: use_build_context_synchronously, deprecated_member_use, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'database_helper.dart';

class AddNewClientPage extends StatefulWidget {
  final Function(Map<String, dynamic> clientData)? onClientSaved;

  const AddNewClientPage({super.key, this.onClientSaved});

  static Future<void> navigate(
      BuildContext context, Function(Map<String, dynamic>) onClientSaved,
      {required Map<String, dynamic> client}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddNewClientPage(onClientSaved: onClientSaved),
      ),
    );
  }

  @override
  AddNewClientPageState createState() => AddNewClientPageState();
}

class AddNewClientPageState extends State<AddNewClientPage> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

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
  final TextEditingController _maidennameController = TextEditingController();
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
  String? _selectedPropertyBarangay;
  String? _selectedPropertyMunicipality;
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
    'Patented/Approved',
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
          width: hasValue ? 0.8 : 0.4,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
            color: Color.fromARGB(255, 13, 136, 69), width: 0.8),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red, width: 0.8),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red, width: 0.8),
      ),
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
                    color: Color.fromARGB(255, 13, 136, 69), width: 0.7),
              ),
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
      case 0: // Client Info
        _handleClientInfoKeys(event);
        break;
      case 1: // Land Property Part 1
        _handleLandPropertyPart1Keys(event);
        break;
      case 2: // Land Property Part 2
        _handleLandPropertyPart2Keys(event);
        break;
      case 3: // Land Property Part 3
        _handleLandPropertyPart3Keys(event);
        break;
      case 4: // Land Property Part 4
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
      if (_propertyMunicipalityFocus.hasFocus) {
        FocusScope.of(context).requestFocus(_propertyBarangayFocus);
      } else if (_propertyBarangayFocus.hasFocus)
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
                      onChanged: (_) => setState(() {}),
                    ),
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
                      onChanged: (_) => setState(() {}),
                    ),
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
                      onChanged: (_) => setState(() {}),
                    ),
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
                      onChanged: (_) => setState(() {}),
                    ),
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
                      onChanged: (_) => setState(() {}),
                    ),
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
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _barangayAddressController,
                      focusNode: _barangayAddressFocus,
                      style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Gilroy',
                          fontSize: 16),
                      decoration: customInputDecoration('Barangay Address',
                          hasValue: _barangayAddressController.text.isNotEmpty),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _municipalityAddressController,
                      focusNode: _municipalityAddressFocus,
                      style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Gilroy',
                          fontSize: 16),
                      decoration: customInputDecoration('Municipality Address',
                          hasValue:
                              _municipalityAddressController.text.isNotEmpty),
                      onChanged: (_) => setState(() {}),
                    ),
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
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _lotNumberController,
            focusNode: _lotNumberFocus,
            style: const TextStyle(
                color: Colors.white, fontFamily: 'Gilroy', fontSize: 16),
            decoration: customInputDecoration('Lot Number',
                hasValue: _lotNumberController.text.isNotEmpty),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _identicalNumberController,
            focusNode: _identicalNumberFocus,
            style: const TextStyle(
                color: Colors.white, fontFamily: 'Gilroy', fontSize: 16),
            decoration: customInputDecoration('Identical Number',
                hasValue: _identicalNumberController.text.isNotEmpty),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _surveyClaimantController,
            focusNode: _surveyClaimantFocus,
            style: const TextStyle(
                color: Colors.white, fontFamily: 'Gilroy', fontSize: 16),
            decoration: customInputDecoration('Survey Claimant',
                hasValue: _surveyClaimantController.text.isNotEmpty),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _areaSqmController,
            focusNode: _areaSqmFocus,
            style: const TextStyle(
                color: Colors.white, fontFamily: 'Gilroy', fontSize: 16),
            decoration: customInputDecoration('Area (SQM)',
                hasValue: _areaSqmController.text.isNotEmpty),
            keyboardType: TextInputType.number,
            onChanged: (_) => setState(() {}),
          ),
        ],
      ),
    );
  }

  Widget _buildLandPropertyFormPart2() {
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
                  items: (_selectedPropertyMunicipality != null
                          ? _applicationNumberOptions[
                              _selectedPropertyMunicipality]
                          : <String>[])
                      ?.map((e) => DropdownMenuItem(
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
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _landInvestigatorController,
            focusNode: _landInvestigatorFocus,
            style: const TextStyle(
                color: Colors.white, fontFamily: 'Gilroy', fontSize: 16),
            decoration: customInputDecoration('Name of Investigator',
                hasValue: _landInvestigatorController.text.isNotEmpty),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _remarksController,
            focusNode: _remarksFocus,
            style: const TextStyle(
                color: Colors.white, fontFamily: 'Gilroy', fontSize: 16),
            decoration: customInputDecoration('Remarks',
                hasValue: _remarksController.text.isNotEmpty),
            maxLines: 2,
            onChanged: (_) => setState(() {}),
          ),
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
                    suffixIcon:
                        const Icon(Icons.calendar_today, color: Colors.white)),
            readOnly: true,
            onTap: () => _showDateDialog(
                'PLA Received Date', _plaReceivedDateController),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _tplaToPenroTransmittedDateController,
            focusNode: _tplaToPenroTransmittedDateFocus,
            style: const TextStyle(
                color: Colors.white, fontFamily: 'Gilroy', fontSize: 16),
            decoration: customInputDecoration('TPLA to PENRO Transmitted Date',
                    hasValue:
                        _tplaToPenroTransmittedDateController.text.isNotEmpty)
                .copyWith(
                    suffixIcon:
                        const Icon(Icons.calendar_today, color: Colors.white)),
            readOnly: true,
            onTap: () => _showDateDialog('TPLA to PENRO Transmitted Date',
                _tplaToPenroTransmittedDateController),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _returnFromPenroController,
            focusNode: _returnFromPenroFocus,
            style: const TextStyle(
                color: Colors.white, fontFamily: 'Gilroy', fontSize: 16),
            decoration: customInputDecoration('Return From PENRO',
                    hasValue: _returnFromPenroController.text.isNotEmpty)
                .copyWith(
                    suffixIcon:
                        const Icon(Icons.calendar_today, color: Colors.white)),
            readOnly: true,
            onTap: () => _showDateDialog(
                'Return From PENRO', _returnFromPenroController),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _rodReceivedDateController,
            focusNode: _rodReceivedDateFocus,
            style: const TextStyle(
                color: Colors.white, fontFamily: 'Gilroy', fontSize: 16),
            decoration: customInputDecoration('ROD Received Date',
                    hasValue: _rodReceivedDateController.text.isNotEmpty)
                .copyWith(
                    suffixIcon:
                        const Icon(Icons.calendar_today, color: Colors.white)),
            readOnly: true,
            onTap: () => _showDateDialog(
                'ROD Received Date', _rodReceivedDateController),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _dateAppliedReceivedController,
            focusNode: _dateAppliedReceivedFocus,
            style: const TextStyle(
                color: Colors.white, fontFamily: 'Gilroy', fontSize: 16),
            decoration: customInputDecoration('Date Applied/Received',
                    hasValue: _dateAppliedReceivedController.text.isNotEmpty)
                .copyWith(
                    suffixIcon:
                        const Icon(Icons.calendar_today, color: Colors.white)),
            readOnly: true,
            onTap: () => _showDateDialog(
                'Date Applied/Received', _dateAppliedReceivedController),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _dateApprovedController,
            focusNode: _dateApprovedFocus,
            style: const TextStyle(
                color: Colors.white, fontFamily: 'Gilroy', fontSize: 16),
            decoration: customInputDecoration('Date Approved',
                    hasValue: _dateApprovedController.text.isNotEmpty)
                .copyWith(
                    suffixIcon:
                        const Icon(Icons.calendar_today, color: Colors.white)),
            readOnly: true,
            onTap: () =>
                _showDateDialog('Date Approved', _dateApprovedController),
          ),
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
              color: Color.fromARGB(255, 45, 114, 255),
            )),
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
              color: Color.fromARGB(255, 45, 114, 255),
            )),
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
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              color: _currentStep == 1
                  ? const Color.fromARGB(255, 13, 136, 69)
                  : const Color.fromARGB(255, 60, 60, 62),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
            ),
            child: const Text('Part 1',
                style: TextStyle(
                    color: Colors.white, fontFamily: 'Gilroy', fontSize: 16)),
          ),
        ),
        GestureDetector(
          onTap: () => setState(() => _currentStep = 2),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            color: _currentStep == 2
                ? const Color.fromARGB(255, 13, 136, 69)
                : const Color.fromARGB(255, 60, 60, 62),
            child: const Text('Part 2',
                style: TextStyle(
                    color: Colors.white, fontFamily: 'Gilroy', fontSize: 16)),
          ),
        ),
        GestureDetector(
          onTap: () => setState(() => _currentStep = 3),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            color: _currentStep == 3
                ? const Color.fromARGB(255, 13, 136, 69)
                : const Color.fromARGB(255, 60, 60, 62),
            child: const Text('Part 3',
                style: TextStyle(
                    color: Colors.white, fontFamily: 'Gilroy', fontSize: 16)),
          ),
        ),
        GestureDetector(
          onTap: () => setState(() => _currentStep = 4),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              color: _currentStep == 4
                  ? const Color.fromARGB(255, 13, 136, 69)
                  : const Color.fromARGB(255, 60, 60, 62),
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8)),
            ),
            child: const Text('Part 4',
                style: TextStyle(
                    color: Colors.white, fontFamily: 'Gilroy', fontSize: 16)),
          ),
        ),
      ],
    );
  }

  Future<void> _saveClient() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final clientMap = {
        DatabaseHelper.columnApplicantFirstname: _firstnameController.text,
        DatabaseHelper.columnApplicantMiddlename: _middlenameController.text,
        DatabaseHelper.columnApplicantLastname: _lastnameController.text,
        DatabaseHelper.columnApplicantSuffix: _suffixController.text,
        DatabaseHelper.columnApplicantMaidenname: _maidennameController.text,
        DatabaseHelper.columnGender: _selectedGender ?? '',
        DatabaseHelper.columnStatus: _selectedStatus ?? '',
        DatabaseHelper.columnSpouse: _spouseController.text,
        DatabaseHelper.columnSitioAddress: _sitioAddressController.text,
        DatabaseHelper.columnBarangayAddress: _barangayAddressController.text,
        DatabaseHelper.columnMunicipalityAddress:
            _municipalityAddressController.text,
      };

      int clientId = await DatabaseHelper.instance.insertClient(clientMap);

      final landPropertyMap = {
        DatabaseHelper.columnClientIdRef: clientId,
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
      };

      await DatabaseHelper.instance.insertLandProperty(landPropertyMap);

      final result = {
        'client': clientMap..['id'] = clientId.toString(),
        'land_property': landPropertyMap,
      };

      setState(() => _isLoading = false);
      _showSuccessDialog();
      if (widget.onClientSaved != null) widget.onClientSaved!(result);
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorDialog();
    }
  }

  @override
  void dispose() {
    // Dispose Client Info FocusNodes
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

    // Dispose Land Property Part 1 FocusNodes
    _bundleNumberFocus.dispose();
    _lotNumberFocus.dispose();
    _identicalNumberFocus.dispose();
    _surveyClaimantFocus.dispose();
    _areaSqmFocus.dispose();

    // Dispose Land Property Part 2 FocusNodes
    _propertyMunicipalityFocus.dispose();
    _propertyBarangayFocus.dispose();
    _sitioFocus.dispose();
    _applicationNumberFocus.dispose();
    _applicationExtensionFocus.dispose();
    _patentNumberFocus.dispose();

    // Dispose Land Property Part 3 FocusNodes
    _lotStatusFocus.dispose();
    _serialNumberFocus.dispose();
    _landInvestigatorFocus.dispose();
    _remarksFocus.dispose();

    // Dispose Land Property Part 4 FocusNodes
    _plaReceivedDateFocus.dispose();
    _tplaToPenroTransmittedDateFocus.dispose();
    _returnFromPenroFocus.dispose();
    _rodReceivedDateFocus.dispose();
    _dateAppliedReceivedFocus.dispose();
    _dateApprovedFocus.dispose();

    // Dispose Controllers
    _firstnameController.dispose();
    _middlenameController.dispose();
    _lastnameController.dispose();
    _suffixController.dispose();
    _maidennameController.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(225, 36, 36, 38),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 600,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color.fromARGB(225, 36, 36, 38),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4))
              ],
            ),
            child: Form(
              key: _formKey,
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back,
                                  color: Color.fromARGB(255, 13, 136, 69)),
                              onPressed: () => Navigator.pop(context),
                            ),
                            const Expanded(
                              child: Text('New Client',
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Gilroy'),
                                  textAlign: TextAlign.center),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
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
                          if (_currentStep == 1) _buildLandPropertyFormPart1(),
                          if (_currentStep == 2) _buildLandPropertyFormPart2(),
                          if (_currentStep == 3) _buildLandPropertyFormPart3(),
                          if (_currentStep == 4) _buildLandPropertyFormPart4(),
                        ],
                        if (_currentStep == 5) _buildPreviewForm(),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: _currentStep == 0
                              ? [
                                  SizedBox(
                                    width: 150,
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: () => Navigator.pop(context),
                                      style: ElevatedButton.styleFrom(
                                        elevation: 8,
                                        backgroundColor: const Color.fromARGB(
                                            255, 60, 60, 62),
                                        foregroundColor: Colors.white54,
                                        padding: const EdgeInsets.all(18),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(24),
                                            side: const BorderSide(
                                                color: Color.fromARGB(
                                                    255, 13, 136, 69),
                                                width: 0.7)),
                                      ),
                                      child: const Text('Cancel',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Gilroy')),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 150,
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate())
                                          setState(() => _currentStep = 1);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        elevation: 8,
                                        backgroundColor: const Color.fromARGB(
                                            255, 60, 62, 62),
                                        foregroundColor: Colors.white54,
                                        padding: const EdgeInsets.all(18),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(24),
                                            side: const BorderSide(
                                                color: Color.fromARGB(
                                                    255, 13, 136, 69),
                                                width: 0.7)),
                                      ),
                                      child: const Text('Next',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Gilroy')),
                                    ),
                                  ),
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
                                        elevation: 8,
                                        backgroundColor: const Color.fromARGB(
                                            255, 60, 60, 62),
                                        foregroundColor: Colors.white54,
                                        padding: const EdgeInsets.all(18),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(24),
                                            side: const BorderSide(
                                                color: Color.fromARGB(
                                                    255, 13, 136, 69),
                                                width: 0.7)),
                                      ),
                                      child: const Text('Back',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Gilroy')),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 150,
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: _currentStep == 5
                                          ? _saveClient
                                          : () =>
                                              setState(() => _currentStep += 1),
                                      style: ElevatedButton.styleFrom(
                                        elevation: 8,
                                        backgroundColor: const Color.fromARGB(
                                            255, 60, 60, 62),
                                        foregroundColor: Colors.white54,
                                        padding: const EdgeInsets.all(18),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(24),
                                            side: const BorderSide(
                                                color: Color.fromARGB(
                                                    255, 13, 136, 69),
                                                width: 0.7)),
                                      ),
                                      child: Text(
                                          _currentStep == 5 ? 'Save' : 'Next',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Gilroy')),
                                    ),
                                  ),
                                ],
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
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
                color: Color.fromARGB(255, 13, 136, 69), width: 0.7),
          ),
          title: const Text('Success', style: TextStyle(color: Colors.white)),
          content: const Text('New client successfully added!',
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

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(225, 36, 36, 38),
          title: const Text('Error', style: TextStyle(color: Colors.white)),
          content: const Text("Client didn't save. Please try again.",
              style: TextStyle(color: Colors.white70)),
          actions: [
            TextButton(
                child: const Text('OK', style: TextStyle(color: Colors.red)),
                onPressed: () => Navigator.pop(context)),
          ],
        );
      },
    );
  }
}
