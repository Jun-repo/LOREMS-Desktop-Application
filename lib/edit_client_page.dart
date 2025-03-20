// ignore_for_file: deprecated_member_use, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'database_helper.dart';

class EditClientPage extends StatefulWidget {
  final Map<String, dynamic> client;
  final Function(Map<String, dynamic> updatedClientData) onClientUpdated;

  const EditClientPage({
    super.key,
    required this.client,
    required this.onClientUpdated,
  });

  @override
  EditClientPageState createState() => EditClientPageState();
}

class EditClientPageState extends State<EditClientPage> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  bool _isLoading = false;

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
  final FocusNode _birthDateFocus = FocusNode();

  // Controllers for client fields
  late TextEditingController _firstnameController;
  late TextEditingController _middlenameController;
  late TextEditingController _lastnameController;
  late TextEditingController _suffixController;
  late TextEditingController _maidennameController;
  String? _selectedGender;
  String? _selectedStatus;
  late TextEditingController _spouseController;
  late TextEditingController _sitioAddressController;
  late TextEditingController _barangayAddressController;
  late TextEditingController _municipalityAddressController;
  late TextEditingController _birthDateController;

  // Dropdown Options
  final List<String> _genderOptions = ['Male', 'Female'];
  final List<String> _statusOptions = [
    'Single',
    'Married',
    'Divorced',
    'Widowed'
  ];
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
  void initState() {
    super.initState();
    // Initialize controllers with existing client data
    _firstnameController = TextEditingController(
        text: widget.client[DatabaseHelper.columnApplicantFirstname] ?? '');
    _middlenameController = TextEditingController(
        text: widget.client[DatabaseHelper.columnApplicantMiddlename] ?? '');
    _lastnameController = TextEditingController(
        text: widget.client[DatabaseHelper.columnApplicantLastname] ?? '');
    _suffixController = TextEditingController(
        text: widget.client[DatabaseHelper.columnApplicantSuffix] ?? '');
    _maidennameController = TextEditingController(
        text: widget.client[DatabaseHelper.columnApplicantMaidenname] ?? '');
    _selectedGender = widget.client[DatabaseHelper.columnGender] ?? '';
    _selectedStatus = widget.client[DatabaseHelper.columnStatus] ?? '';
    _spouseController = TextEditingController(
        text: widget.client[DatabaseHelper.columnSpouse] ?? '');
    _sitioAddressController = TextEditingController(
        text: widget.client[DatabaseHelper.columnSitioAddress] ?? '');
    _barangayAddressController = TextEditingController(
        text: widget.client[DatabaseHelper.columnBarangayAddress] ?? '');
    _municipalityAddressController = TextEditingController(
        text: widget.client[DatabaseHelper.columnMunicipalityAddress] ?? '');
    _birthDateController = TextEditingController(
        text: widget.client[DatabaseHelper.columnBirthDate] ?? '');
  }

  @override
  void dispose() {
    // Dispose FocusNodes
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
    _birthDateFocus.dispose();

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
    _birthDateController.dispose();
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
      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        if (_firstnameFocus.hasFocus) {
          FocusScope.of(context).requestFocus(_middlenameFocus);
        } else if (_middlenameFocus.hasFocus)
          FocusScope.of(context).requestFocus(_lastnameFocus);
        else if (_lastnameFocus.hasFocus)
          FocusScope.of(context).requestFocus(_suffixFocus);
        else if (_genderFocus.hasFocus)
          FocusScope.of(context).requestFocus(_birthDateFocus);
        else if (_birthDateFocus.hasFocus)
          FocusScope.of(context).requestFocus(_statusFocus);
        else if (_statusFocus.hasFocus)
          FocusScope.of(context).requestFocus(_spouseFocus);
        else if (_sitioAddressFocus.hasFocus)
          FocusScope.of(context).requestFocus(_barangayAddressFocus);
        else if (_barangayAddressFocus.hasFocus)
          FocusScope.of(context).requestFocus(_municipalityAddressFocus);
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        if (_municipalityAddressFocus.hasFocus) {
          FocusScope.of(context).requestFocus(_barangayAddressFocus);
        } else if (_barangayAddressFocus.hasFocus)
          FocusScope.of(context).requestFocus(_sitioAddressFocus);
        else if (_spouseFocus.hasFocus)
          FocusScope.of(context).requestFocus(_statusFocus);
        else if (_statusFocus.hasFocus)
          FocusScope.of(context).requestFocus(_birthDateFocus);
        else if (_birthDateFocus.hasFocus)
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
            _birthDateFocus.hasFocus ||
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
            _birthDateFocus.hasFocus ||
            _statusFocus.hasFocus ||
            _spouseFocus.hasFocus) {
          FocusScope.of(context).requestFocus(_suffixFocus);
        }
      }
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
                      validator: (value) =>
                          value!.isEmpty ? 'Last name is required' : null,
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
                      value: _selectedGender!.isEmpty ? null : _selectedGender,
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
                    TextFormField(
                      controller: _birthDateController,
                      focusNode: _birthDateFocus,
                      style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Gilroy',
                          fontSize: 16),
                      decoration: customInputDecoration('Birth Date',
                              hasValue: _birthDateController.text.isNotEmpty)
                          .copyWith(
                              suffixIcon: const Icon(Icons.calendar_today,
                                  color: Colors.white)),
                      readOnly: true,
                      onTap: () =>
                          _showDateDialog('Birth Date', _birthDateController),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: _selectedStatus!.isEmpty ? null : _selectedStatus,
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
        _buildPreviewRow('Birth Date', _birthDateController.text),
        _buildPreviewRow('Status', _selectedStatus ?? ''),
        _buildPreviewRow('Spouse', _spouseController.text),
        _buildPreviewRow('Sitio Address', _sitioAddressController.text),
        _buildPreviewRow('Barangay Address', _barangayAddressController.text),
        _buildPreviewRow(
            'Municipality Address', _municipalityAddressController.text),
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

  Future<void> _saveClient() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      Map<String, dynamic> updatedClient = {
        DatabaseHelper.columnClientId:
            widget.client[DatabaseHelper.columnClientId],
        DatabaseHelper.columnApplicantFirstname: _firstnameController.text,
        DatabaseHelper.columnApplicantMiddlename: _middlenameController.text,
        DatabaseHelper.columnApplicantLastname: _lastnameController.text,
        DatabaseHelper.columnApplicantSuffix: _suffixController.text,
        DatabaseHelper.columnApplicantMaidenname: _maidennameController.text,
        DatabaseHelper.columnGender: _selectedGender ?? '',
        DatabaseHelper.columnBirthDate: _birthDateController.text,
        DatabaseHelper.columnStatus: _selectedStatus ?? '',
        DatabaseHelper.columnSpouse: _spouseController.text,
        DatabaseHelper.columnSitioAddress: _sitioAddressController.text,
        DatabaseHelper.columnBarangayAddress: _barangayAddressController.text,
        DatabaseHelper.columnMunicipalityAddress:
            _municipalityAddressController.text,
      };

      await DatabaseHelper.instance.updateClient(updatedClient);

      setState(() => _isLoading = false);
      _showSuccessDialog();
      widget.onClientUpdated(updatedClient);
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorDialog();
    }
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
                              child: Text('Edit Client',
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
                        if (_currentStep == 1) _buildPreviewForm(),
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
                                        if (_formKey.currentState!.validate()) {
                                          setState(() => _currentStep = 1);
                                        }
                                      },
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
                                      onPressed: () =>
                                          setState(() => _currentStep = 0),
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
                                      onPressed: _saveClient,
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
                                      child: const Text('Save',
                                          style: TextStyle(
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
          content: const Text('Client successfully updated!',
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
          content: const Text("Client update failed. Please try again.",
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
