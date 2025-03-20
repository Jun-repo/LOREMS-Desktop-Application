// ignore_for_file: deprecated_member_use, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:giccenroquezon/database_helper.dart';

class AddLandPage extends StatefulWidget {
  final int clientId;
  final Map<String, dynamic>? landPropertyData;
  const AddLandPage({super.key, required this.clientId, this.landPropertyData});

  static void navigate(
      BuildContext context, int clientId, Function onLandAdded) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddLandPage(clientId: clientId),
      ),
    ).then((result) {
      if (result == true) onLandAdded();
    });
  }

  @override
  AddLandPageState createState() => AddLandPageState();
}

class AddLandPageState extends State<AddLandPage> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  // FocusNodes for Part 1
  final FocusNode _lotNumberFocus = FocusNode();
  final FocusNode _patentNumberFocus = FocusNode();
  final FocusNode _identicalNumberFocus = FocusNode();
  final FocusNode _serialNumberFocus = FocusNode();
  final FocusNode _bundleNumberFocus = FocusNode();
  final FocusNode _lotStatusFocus = FocusNode();
  final FocusNode _areaSqmFocus = FocusNode();
  final FocusNode _surveyClaimantFocus = FocusNode();
  final FocusNode _landInvestigatorFocus = FocusNode();

  // FocusNodes for Part 2
  final FocusNode _plaReceivedDateFocus = FocusNode();
  final FocusNode _tplaToPenroTransmittedDateFocus = FocusNode();
  final FocusNode _returnFromPenroFocus = FocusNode();
  final FocusNode _rodReceivedDateFocus = FocusNode();
  final FocusNode _propertyMunicipalityFocus = FocusNode();
  final FocusNode _propertyBarangayFocus = FocusNode();
  final FocusNode _applicationNumberFocus = FocusNode();
  final FocusNode _sitioFocus = FocusNode();
  final FocusNode _dateAppliedReceivedFocus = FocusNode();
  final FocusNode _dateApprovedFocus = FocusNode();

  // Controllers
  final TextEditingController _lotNumberController = TextEditingController();
  final TextEditingController _patentNumberController = TextEditingController();
  final TextEditingController _identicalNumberController =
      TextEditingController();
  final TextEditingController _bundleNumberController = TextEditingController();
  final TextEditingController _areaSqmController = TextEditingController();
  final TextEditingController _surveyClaimantController =
      TextEditingController();
  final TextEditingController _sitioController = TextEditingController();
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
  final TextEditingController _serialNumberController = TextEditingController();
  final TextEditingController _landInvestigatorController =
      TextEditingController();

  // Dropdown values
  String? _selectedApplicationNumber;
  String? _selectedLotStatus;
  String? _selectedPropertyMunicipality;
  String? _selectedPropertyBarangay;

  // Dropdown options
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
  final Map<String, List<String>> _applicationNumbersByMunicipality = {
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

  @override
  void dispose() {
    _lotNumberFocus.dispose();
    _patentNumberFocus.dispose();
    _identicalNumberFocus.dispose();
    _serialNumberFocus.dispose();
    _bundleNumberFocus.dispose();
    _lotStatusFocus.dispose();
    _areaSqmFocus.dispose();
    _surveyClaimantFocus.dispose();
    _landInvestigatorFocus.dispose();
    _plaReceivedDateFocus.dispose();
    _tplaToPenroTransmittedDateFocus.dispose();
    _returnFromPenroFocus.dispose();
    _rodReceivedDateFocus.dispose();
    _propertyMunicipalityFocus.dispose();
    _propertyBarangayFocus.dispose();
    _applicationNumberFocus.dispose();
    _sitioFocus.dispose();
    _dateAppliedReceivedFocus.dispose();
    _dateApprovedFocus.dispose();

    _lotNumberController.dispose();
    _patentNumberController.dispose();
    _identicalNumberController.dispose();
    _bundleNumberController.dispose();
    _areaSqmController.dispose();
    _surveyClaimantController.dispose();
    _sitioController.dispose();
    _plaReceivedDateController.dispose();
    _tplaToPenroTransmittedDateController.dispose();
    _returnFromPenroController.dispose();
    _rodReceivedDateController.dispose();
    _dateAppliedReceivedController.dispose();
    _dateApprovedController.dispose();
    _serialNumberController.dispose();
    _landInvestigatorController.dispose();
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

    if (_currentStep == 0) {
      _handlePart1Keys(event);
    } else if (_currentStep == 1) {
      _handlePart2Keys(event);
    }
  }

  void _handlePart1Keys(RawKeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      if (_lotNumberFocus.hasFocus)
        FocusScope.of(context).requestFocus(_patentNumberFocus);
      else if (_patentNumberFocus.hasFocus)
        FocusScope.of(context).requestFocus(_identicalNumberFocus);
      else if (_identicalNumberFocus.hasFocus)
        FocusScope.of(context).requestFocus(_serialNumberFocus);
      else if (_bundleNumberFocus.hasFocus)
        FocusScope.of(context).requestFocus(_lotStatusFocus);
      else if (_lotStatusFocus.hasFocus)
        FocusScope.of(context).requestFocus(_areaSqmFocus);
      else if (_areaSqmFocus.hasFocus)
        FocusScope.of(context).requestFocus(_surveyClaimantFocus);
      else if (_surveyClaimantFocus.hasFocus)
        FocusScope.of(context).requestFocus(_landInvestigatorFocus);
    } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      if (_landInvestigatorFocus.hasFocus)
        FocusScope.of(context).requestFocus(_surveyClaimantFocus);
      else if (_surveyClaimantFocus.hasFocus)
        FocusScope.of(context).requestFocus(_areaSqmFocus);
      else if (_areaSqmFocus.hasFocus)
        FocusScope.of(context).requestFocus(_lotStatusFocus);
      else if (_lotStatusFocus.hasFocus)
        FocusScope.of(context).requestFocus(_bundleNumberFocus);
      else if (_serialNumberFocus.hasFocus)
        FocusScope.of(context).requestFocus(_identicalNumberFocus);
      else if (_identicalNumberFocus.hasFocus)
        FocusScope.of(context).requestFocus(_patentNumberFocus);
      else if (_patentNumberFocus.hasFocus)
        FocusScope.of(context).requestFocus(_lotNumberFocus);
    } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      if (_lotNumberFocus.hasFocus ||
          _patentNumberFocus.hasFocus ||
          _identicalNumberFocus.hasFocus ||
          _serialNumberFocus.hasFocus) {
        FocusScope.of(context).requestFocus(_bundleNumberFocus);
      }
    } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      if (_bundleNumberFocus.hasFocus ||
          _lotStatusFocus.hasFocus ||
          _areaSqmFocus.hasFocus ||
          _surveyClaimantFocus.hasFocus ||
          _landInvestigatorFocus.hasFocus) {
        FocusScope.of(context).requestFocus(_serialNumberFocus);
      }
    }
  }

  void _handlePart2Keys(RawKeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      if (_plaReceivedDateFocus.hasFocus) {
        FocusScope.of(context).requestFocus(_tplaToPenroTransmittedDateFocus);
      } else if (_tplaToPenroTransmittedDateFocus.hasFocus)
        FocusScope.of(context).requestFocus(_returnFromPenroFocus);
      else if (_returnFromPenroFocus.hasFocus)
        FocusScope.of(context).requestFocus(_rodReceivedDateFocus);
      else if (_propertyMunicipalityFocus.hasFocus)
        FocusScope.of(context).requestFocus(_propertyBarangayFocus);
      else if (_propertyBarangayFocus.hasFocus)
        FocusScope.of(context).requestFocus(_applicationNumberFocus);
      else if (_applicationNumberFocus.hasFocus)
        FocusScope.of(context).requestFocus(_sitioFocus);
      else if (_sitioFocus.hasFocus)
        FocusScope.of(context).requestFocus(_dateAppliedReceivedFocus);
      else if (_dateAppliedReceivedFocus.hasFocus)
        FocusScope.of(context).requestFocus(_dateApprovedFocus);
    } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      if (_dateApprovedFocus.hasFocus)
        FocusScope.of(context).requestFocus(_dateAppliedReceivedFocus);
      else if (_dateAppliedReceivedFocus.hasFocus)
        FocusScope.of(context).requestFocus(_sitioFocus);
      else if (_sitioFocus.hasFocus)
        FocusScope.of(context).requestFocus(_applicationNumberFocus);
      else if (_applicationNumberFocus.hasFocus)
        FocusScope.of(context).requestFocus(_propertyBarangayFocus);
      else if (_propertyBarangayFocus.hasFocus)
        FocusScope.of(context).requestFocus(_propertyMunicipalityFocus);
      else if (_rodReceivedDateFocus.hasFocus)
        FocusScope.of(context).requestFocus(_returnFromPenroFocus);
      else if (_returnFromPenroFocus.hasFocus)
        FocusScope.of(context).requestFocus(_tplaToPenroTransmittedDateFocus);
      else if (_tplaToPenroTransmittedDateFocus.hasFocus)
        FocusScope.of(context).requestFocus(_plaReceivedDateFocus);
    } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      if (_plaReceivedDateFocus.hasFocus ||
          _tplaToPenroTransmittedDateFocus.hasFocus ||
          _returnFromPenroFocus.hasFocus ||
          _rodReceivedDateFocus.hasFocus) {
        FocusScope.of(context).requestFocus(_propertyMunicipalityFocus);
      }
    } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      if (_propertyMunicipalityFocus.hasFocus ||
          _propertyBarangayFocus.hasFocus ||
          _applicationNumberFocus.hasFocus ||
          _sitioFocus.hasFocus ||
          _dateAppliedReceivedFocus.hasFocus ||
          _dateApprovedFocus.hasFocus) {
        FocusScope.of(context).requestFocus(_rodReceivedDateFocus);
      }
    }
  }

  Future<void> _showPreviewDialog() async {
    if (_formKey.currentState!.validate()) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color.fromARGB(255, 36, 36, 38),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(
                  color: Color.fromARGB(255, 13, 136, 69), width: 0.7),
            ),
            title: const Text('Preview Land Property',
                style: TextStyle(color: Colors.white)),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPreviewItem('Lot Number', _lotNumberController.text),
                  _buildPreviewItem(
                      'Patent Number', _patentNumberController.text),
                  _buildPreviewItem(
                      'Identical Number', _identicalNumberController.text),
                  _buildPreviewItem(
                      'Serial Number', _serialNumberController.text),
                  _buildPreviewItem(
                      'Bundle Number', _bundleNumberController.text),
                  _buildPreviewItem('Lot Status', _selectedLotStatus ?? ''),
                  _buildPreviewItem('Area (sqm)', _areaSqmController.text),
                  _buildPreviewItem(
                      'Survey Claimant', _surveyClaimantController.text),
                  _buildPreviewItem(
                      'Name of Investigator', _landInvestigatorController.text),
                  _buildPreviewItem(
                      'PLA Received Date', _plaReceivedDateController.text),
                  _buildPreviewItem('TPLA to PENRO Transmitted Date',
                      _tplaToPenroTransmittedDateController.text),
                  _buildPreviewItem(
                      'Return From PENRO', _returnFromPenroController.text),
                  _buildPreviewItem(
                      'ROD Received Date', _rodReceivedDateController.text),
                  _buildPreviewItem('Property Municipality',
                      _selectedPropertyMunicipality ?? ''),
                  _buildPreviewItem(
                      'Property Barangay', _selectedPropertyBarangay ?? ''),
                  _buildPreviewItem(
                      'Application Number', _selectedApplicationNumber ?? ''),
                  _buildPreviewItem('Sitio', _sitioController.text),
                  _buildPreviewItem('Date Applied/Received',
                      _dateAppliedReceivedController.text),
                  _buildPreviewItem(
                      'Date Approved', _dateApprovedController.text),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: const Text('Edit', style: TextStyle(color: Colors.red)),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: const Text('Confirm',
                    style: TextStyle(color: Colors.green)),
                onPressed: () {
                  Navigator.pop(context);
                  _saveLandProperty();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Widget _buildPreviewItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ',
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _saveLandProperty() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> newLandProperty = {
        DatabaseHelper.columnClientIdRef: widget.clientId,
        DatabaseHelper.columnApplicationNumber:
            _selectedApplicationNumber ?? '',
        DatabaseHelper.columnLotNumber: _lotNumberController.text,
        DatabaseHelper.columnPatentNumber: _patentNumberController.text,
        DatabaseHelper.columnIdenticalNumber: _identicalNumberController.text,
        DatabaseHelper.columnSerialNumber: _serialNumberController.text,
        DatabaseHelper.columnBundleNumber: _bundleNumberController.text,
        DatabaseHelper.columnLotStatus: _selectedLotStatus ?? '',
        DatabaseHelper.columnAreaSqm:
            double.tryParse(_areaSqmController.text) ?? 0.0,
        DatabaseHelper.columnSurveyClaimant: _surveyClaimantController.text,
        DatabaseHelper.columnLandInvestigator: _landInvestigatorController.text,
        DatabaseHelper.columnPlaReceivedDate: _plaReceivedDateController.text,
        DatabaseHelper.columnTplaToPenroTransmittedDate:
            _tplaToPenroTransmittedDateController.text,
        DatabaseHelper.columnReturnFromPenro: _returnFromPenroController.text,
        DatabaseHelper.columnRodReceivedDate: _rodReceivedDateController.text,
        DatabaseHelper.columnSitio: _sitioController.text,
        DatabaseHelper.columnPropertyBarangay: _selectedPropertyBarangay ?? '',
        DatabaseHelper.columnPropertyMunicipality:
            _selectedPropertyMunicipality ?? '',
        DatabaseHelper.columnDateAppliedReceived:
            _dateAppliedReceivedController.text,
        DatabaseHelper.columnDateApproved: _dateApprovedController.text,
      };

      await DatabaseHelper.instance.insertLandProperty(newLandProperty);
      Navigator.pop(context, true);
    }
  }

  Widget _buildLandPropertyFormPart1() {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: _handleKeyEvent,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                TextFormField(
                  controller: _lotNumberController,
                  focusNode: _lotNumberFocus,
                  decoration: customInputDecoration("Lot Number",
                      hasValue: _lotNumberController.text.isNotEmpty),
                  style: const TextStyle(
                      color: Colors.white, fontFamily: 'Gilroy', fontSize: 16),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter Lot Number'
                      : null,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _patentNumberController,
                  focusNode: _patentNumberFocus,
                  decoration: customInputDecoration("Patent Number",
                      hasValue: _patentNumberController.text.isNotEmpty),
                  style: const TextStyle(
                      color: Colors.white, fontFamily: 'Gilroy', fontSize: 16),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _identicalNumberController,
                  focusNode: _identicalNumberFocus,
                  decoration: customInputDecoration("Identical Number",
                      hasValue: _identicalNumberController.text.isNotEmpty),
                  style: const TextStyle(
                      color: Colors.white, fontFamily: 'Gilroy', fontSize: 16),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _serialNumberController,
                  focusNode: _serialNumberFocus,
                  decoration: customInputDecoration("Serial Number",
                      hasValue: _serialNumberController.text.isNotEmpty),
                  style: const TextStyle(
                      color: Colors.white, fontFamily: 'Gilroy', fontSize: 16),
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
                  controller: _bundleNumberController,
                  focusNode: _bundleNumberFocus,
                  decoration: customInputDecoration("Bundle Number",
                      hasValue: _bundleNumberController.text.isNotEmpty),
                  style: const TextStyle(
                      color: Colors.white, fontFamily: 'Gilroy', fontSize: 16),
                  onChanged: (_) => setState(() {}),
                ),
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
                  decoration: customInputDecoration("Lot Status",
                      hasValue: _selectedLotStatus != null),
                  dropdownColor: Colors.black,
                  onChanged: (value) =>
                      setState(() => _selectedLotStatus = value),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _areaSqmController,
                  focusNode: _areaSqmFocus,
                  decoration: customInputDecoration("Area (sqm)",
                      hasValue: _areaSqmController.text.isNotEmpty),
                  style: const TextStyle(
                      color: Colors.white, fontFamily: 'Gilroy', fontSize: 16),
                  keyboardType: TextInputType.number,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _surveyClaimantController,
                  focusNode: _surveyClaimantFocus,
                  decoration: customInputDecoration("Survey Claimant",
                      hasValue: _surveyClaimantController.text.isNotEmpty),
                  style: const TextStyle(
                      color: Colors.white, fontFamily: 'Gilroy', fontSize: 16),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _landInvestigatorController,
                  focusNode: _landInvestigatorFocus,
                  decoration: customInputDecoration("Name of Investigator",
                      hasValue: _landInvestigatorController.text.isNotEmpty),
                  style: const TextStyle(
                      color: Colors.white, fontFamily: 'Gilroy', fontSize: 16),
                  onChanged: (_) => setState(() {}),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLandPropertyFormPart2() {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: _handleKeyEvent,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                TextFormField(
                  controller: _plaReceivedDateController,
                  focusNode: _plaReceivedDateFocus,
                  decoration: customInputDecoration("PLA Received Date",
                          hasValue: _plaReceivedDateController.text.isNotEmpty)
                      .copyWith(
                    suffixIcon:
                        const Icon(Icons.calendar_today, color: Colors.white),
                  ),
                  style: const TextStyle(
                      color: Colors.white, fontFamily: 'Gilroy', fontSize: 16),
                  readOnly: true,
                  onTap: () => _showDateDialog(
                      "PLA Received Date", _plaReceivedDateController),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _tplaToPenroTransmittedDateController,
                  focusNode: _tplaToPenroTransmittedDateFocus,
                  decoration: customInputDecoration(
                          "TPLA to PENRO Transmitted Date",
                          hasValue: _tplaToPenroTransmittedDateController
                              .text.isNotEmpty)
                      .copyWith(
                    suffixIcon:
                        const Icon(Icons.calendar_today, color: Colors.white),
                  ),
                  style: const TextStyle(
                      color: Colors.white, fontFamily: 'Gilroy', fontSize: 16),
                  readOnly: true,
                  onTap: () => _showDateDialog("TPLA to PENRO Transmitted Date",
                      _tplaToPenroTransmittedDateController),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _returnFromPenroController,
                  focusNode: _returnFromPenroFocus,
                  decoration: customInputDecoration("Return From PENRO",
                          hasValue: _returnFromPenroController.text.isNotEmpty)
                      .copyWith(
                    suffixIcon:
                        const Icon(Icons.calendar_today, color: Colors.white),
                  ),
                  style: const TextStyle(
                      color: Colors.white, fontFamily: 'Gilroy', fontSize: 16),
                  readOnly: true,
                  onTap: () => _showDateDialog(
                      "Return From PENRO", _returnFromPenroController),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _rodReceivedDateController,
                  focusNode: _rodReceivedDateFocus,
                  decoration: customInputDecoration("ROD Received Date",
                          hasValue: _rodReceivedDateController.text.isNotEmpty)
                      .copyWith(
                    suffixIcon:
                        const Icon(Icons.calendar_today, color: Colors.white),
                  ),
                  style: const TextStyle(
                      color: Colors.white, fontFamily: 'Gilroy', fontSize: 16),
                  readOnly: true,
                  onTap: () => _showDateDialog(
                      "ROD Received Date", _rodReceivedDateController),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _dateAppliedReceivedController,
                  focusNode: _dateAppliedReceivedFocus,
                  decoration: customInputDecoration("Date Applied/Received",
                          hasValue:
                              _dateAppliedReceivedController.text.isNotEmpty)
                      .copyWith(
                    suffixIcon:
                        const Icon(Icons.calendar_today, color: Colors.white),
                  ),
                  style: const TextStyle(
                      color: Colors.white, fontFamily: 'Gilroy', fontSize: 16),
                  readOnly: true,
                  onTap: () => _showDateDialog(
                      "Date Applied/Received", _dateAppliedReceivedController),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _dateApprovedController,
                  focusNode: _dateApprovedFocus,
                  decoration: customInputDecoration("Date Approved",
                          hasValue: _dateApprovedController.text.isNotEmpty)
                      .copyWith(
                    suffixIcon:
                        const Icon(Icons.calendar_today, color: Colors.white),
                  ),
                  style: const TextStyle(
                      color: Colors.white, fontFamily: 'Gilroy', fontSize: 16),
                  readOnly: true,
                  onTap: () =>
                      _showDateDialog("Date Approved", _dateApprovedController),
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
                  decoration: customInputDecoration("Property Municipal",
                      hasValue: _selectedPropertyMunicipality != null),
                  dropdownColor: Colors.black,
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
                  decoration: customInputDecoration("Property Barangay",
                      hasValue: _selectedPropertyBarangay != null),
                  dropdownColor: Colors.black,
                  onChanged: (value) =>
                      setState(() => _selectedPropertyBarangay = value),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _selectedApplicationNumber,
                  focusNode: _applicationNumberFocus,
                  items: (_selectedPropertyMunicipality != null
                          ? _applicationNumbersByMunicipality[
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
                  decoration: customInputDecoration("Application Number",
                      hasValue: _selectedApplicationNumber != null),
                  dropdownColor: Colors.black,
                  onChanged: (value) =>
                      setState(() => _selectedApplicationNumber = value),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _sitioController,
                  focusNode: _sitioFocus,
                  decoration: customInputDecoration("Sitio",
                      hasValue: _sitioController.text.isNotEmpty),
                  style: const TextStyle(
                      color: Colors.white, fontFamily: 'Gilroy', fontSize: 16),
                  onChanged: (_) => setState(() {}),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLandPropertyNavigation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => setState(() => _currentStep = 0),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              color: _currentStep == 0
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
          onTap: () => setState(() => _currentStep = 1),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              color: _currentStep == 1
                  ? const Color.fromARGB(255, 13, 136, 69)
                  : const Color.fromARGB(255, 60, 60, 62),
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8)),
            ),
            child: const Text('Part 2',
                style: TextStyle(
                    color: Colors.white, fontFamily: 'Gilroy', fontSize: 16)),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(225, 36, 36, 38),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 900,
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: const Color.fromARGB(225, 36, 36, 38),
              borderRadius: BorderRadius.circular(24.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back,
                            color: Color.fromARGB(255, 13, 136, 69)),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: Text(
                          'Add Land Property',
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Gilroy'),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text('Land Property Information',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const SizedBox(height: 10),
                  _buildLandPropertyNavigation(),
                  const SizedBox(height: 20),
                  if (_currentStep == 0) _buildLandPropertyFormPart1(),
                  if (_currentStep == 1) _buildLandPropertyFormPart2(),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 150,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _currentStep == 0
                              ? () => Navigator.pop(context)
                              : () => setState(() => _currentStep -= 1),
                          style: ElevatedButton.styleFrom(
                            elevation: 8,
                            backgroundColor:
                                const Color.fromARGB(255, 60, 60, 62),
                            foregroundColor: Colors.white54,
                            padding: const EdgeInsets.all(18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                              side: const BorderSide(
                                  color: Color.fromARGB(255, 13, 136, 69),
                                  width: 0.7),
                            ),
                          ),
                          child: Text(_currentStep == 0 ? 'Cancel' : 'Back',
                              style: const TextStyle(
                                  color: Colors.white, fontFamily: 'Gilroy')),
                        ),
                      ),
                      SizedBox(
                        width: 150,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _currentStep == 1
                              ? _showPreviewDialog
                              : () => setState(() => _currentStep += 1),
                          style: ElevatedButton.styleFrom(
                            elevation: 8,
                            backgroundColor:
                                const Color.fromARGB(255, 60, 60, 62),
                            foregroundColor: Colors.white54,
                            padding: const EdgeInsets.all(18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                              side: const BorderSide(
                                  color: Color.fromARGB(255, 13, 136, 69),
                                  width: 0.7),
                            ),
                          ),
                          child: Text(_currentStep == 1 ? 'Preview' : 'Next',
                              style: const TextStyle(
                                  color: Colors.white, fontFamily: 'Gilroy')),
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
}
