import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:giccenroquezon/add_land_page.dart';
import 'package:giccenroquezon/add_new_client_page.dart';
import 'package:giccenroquezon/components/appbar_component.dart';
import 'package:giccenroquezon/components/searchfield.dart';
import 'package:giccenroquezon/database_helper.dart';
import 'package:giccenroquezon/edit_client_page.dart';
import 'package:giccenroquezon/edit_land_page.dart';
import 'package:giccenroquezon/pdf_preview_page.dart';
import 'package:giccenroquezon/print_client_narrative_page.dart';
import 'package:giccenroquezon/sub_dividing_land_page.dart';
import 'package:giccenroquezon/visualization_land_origin_page.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with TickerProviderStateMixin {
  // Updated types to match DatabaseHelper.getClientsGroupedById()
  Map<int, Map<String, dynamic>> _clients = {};
  List<Map<String, dynamic>> _groupedClients = [];

  Map<String, dynamic>? selectedClient;
  Map<String, dynamic>? selectedLandProperty;
  final ScrollController _landPropertyScrollController = ScrollController();
  final GlobalKey<VisualizationLandOriginPageState> inheritanceKey =
      GlobalKey<VisualizationLandOriginPageState>();

  int currentPage = 0;
  int itemsPerPage = 20;

  int get totalItems => _filteredClients.length;
  int get totalPages => (totalItems / itemsPerPage).ceil();

  List<bool> selectedItems = [];
  List<bool> hoveredItems = [];
  int? selectedIndex;

  bool selectAll = false;
  late AnimationController _rotationController;
  bool _refreshSuccess = false;
  bool isRefreshing = false;

  final Color defaultCardColor = const Color.fromARGB(225, 36, 36, 38);
  final Color hoverCardColor = const Color.fromARGB(225, 46, 46, 48);
  final Color activeCardColor = const Color.fromARGB(225, 64, 64, 66);

  String _searchQuery = '';
  String? _rodFilterStatus; // "None" or "Patented/Approved"
  String? _rodFilterYear; // Selected year for filtering
  final GlobalKey _filterButtonKey = GlobalKey();

  double getTotalAreaForClient(Map<String, dynamic> client) {
    double total = 0;
    for (var land in client['land_properties'] ?? []) {
      total += (land[DatabaseHelper.columnAreaSqm] ?? 0).toDouble();
    }
    return total;
  }

  List<Map<String, dynamic>> getLandPropertiesForSelectedClient() {
    if (selectedClient == null) return [];
    return selectedClient!['land_properties'] as List<Map<String, dynamic>>;
  }

  List<Map<String, dynamic>> get _filteredClients {
    List<Map<String, dynamic>> filtered = _groupedClients;

    // Apply search query filter
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((client) {
        bool clientMatch = _clientMatchesQuery(client['client'], query);
        bool landMatch = (client['land_properties'] as List<dynamic>)
            .any((land) => _landMatchesQuery(land, query));
        return clientMatch || landMatch;
      }).toList();
    }

    // Apply ROD filter
    if (_rodFilterStatus == "Patented/Approved" && _rodFilterYear != null) {
      filtered = filtered.where((client) {
        return (client['land_properties'] as List<dynamic>).any((land) {
          final rodDate =
              land[DatabaseHelper.columnRodReceivedDate]?.toString();
          return rodDate != null &&
              rodDate.isNotEmpty &&
              rodDate.split('-')[0] == _rodFilterYear &&
              land[DatabaseHelper.columnLotStatus]?.toString().toLowerCase() ==
                  "patented/approved";
        });
      }).toList();
    } else if (_rodFilterStatus == "None") {
      // No additional filtering beyond search query
    }

    return filtered;
  }

  bool _clientMatchesQuery(Map<String, dynamic> client, String query) {
    final firstName = client[DatabaseHelper.columnApplicantFirstname]
            ?.toString()
            .toLowerCase() ??
        '';
    final middleName = client[DatabaseHelper.columnApplicantMiddlename]
            ?.toString()
            .toLowerCase() ??
        '';
    final lastName = client[DatabaseHelper.columnApplicantLastname]
            ?.toString()
            .toLowerCase() ??
        '';
    final barangay = client[DatabaseHelper.columnBarangayAddress]
            ?.toString()
            .toLowerCase() ??
        '';
    final municipal = client[DatabaseHelper.columnMunicipalityAddress]
            ?.toString()
            .toLowerCase() ??
        '';

    final fullName = '$firstName $lastName'.trim().toLowerCase();
    final fullNameWithMiddle =
        '$firstName $middleName $lastName'.trim().toLowerCase();

    return firstName.contains(query) ||
        lastName.contains(query) ||
        fullName.contains(query) ||
        fullNameWithMiddle.contains(query) ||
        municipal.contains(query) ||
        barangay.contains(query);
  }

  bool _landMatchesQuery(Map<String, dynamic> land, String query) {
    final lotNo =
        land[DatabaseHelper.columnLotNumber]?.toString().toLowerCase() ?? '';
    final bundleNo =
        land[DatabaseHelper.columnBundleNumber]?.toString().toLowerCase() ?? '';
    final appNo = land[DatabaseHelper.columnApplicationNumber]
            ?.toString()
            .toLowerCase() ??
        '';
    final patentNo =
        land[DatabaseHelper.columnPatentNumber]?.toString().toLowerCase() ?? '';
    final surveyClaimant =
        land[DatabaseHelper.columnSurveyClaimant]?.toString().toLowerCase() ??
            '';
    final lotStatus =
        land[DatabaseHelper.columnLotStatus]?.toString().toLowerCase() ?? '';
    final sitio =
        land[DatabaseHelper.columnSitio]?.toString().toLowerCase() ?? '';
    final propertyBarangay =
        land[DatabaseHelper.columnPropertyBarangay]?.toString().toLowerCase() ??
            '';
    final proMun = land[DatabaseHelper.columnPropertyMunicipality]
            ?.toString()
            .toLowerCase() ??
        '';

    final combinedAddress = '$sitio $propertyBarangay $proMun'.toLowerCase();

    return lotNo.contains(query) ||
        bundleNo.contains(query) ||
        appNo.contains(query) ||
        patentNo.contains(query) ||
        surveyClaimant.contains(query) ||
        lotStatus.contains(query) ||
        sitio.contains(query) ||
        propertyBarangay.contains(query) ||
        proMun.contains(query) ||
        combinedAddress.contains(query);
  }

  @override
  void initState() {
    super.initState();
    _loadClients();
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _rodFilterStatus = "None";
  }

  Future<void> _loadClients() async {
    final groupedClients =
        await DatabaseHelper.instance.getClientsGroupedById();
    setState(() {
      _clients = groupedClients;
      _groupedClients = groupedClients.values.toList();
      selectedItems =
          List<bool>.generate(_groupedClients.length, (index) => false);
      hoveredItems =
          List<bool>.generate(_groupedClients.length, (index) => false);
      // Reset selections if they exist
      if (selectedClient != null) {
        selectedClient = _groupedClients.firstWhere(
          (client) =>
              client['client'][DatabaseHelper.columnClientId] ==
              selectedClient!['client'][DatabaseHelper.columnClientId],
          orElse: () => selectedClient!,
        );
      }
    });
  }

  void _printSelectedClients() {
    Map<int, Map<String, dynamic>> selectedClients = {};
    for (int i = 0; i < _groupedClients.length; i++) {
      if (selectedItems[i]) {
        final clientId =
            _groupedClients[i]['client'][DatabaseHelper.columnClientId];
        selectedClients[clientId] = _groupedClients[i];
      }
    }

    if (selectedClients.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PdfPreviewPage(clientData: selectedClients),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No clients selected for printing")),
      );
    }
  }

  void _deleteSelectedClients() async {
    List<int> clientIdsToDelete = [];
    for (int i = 0; i < _groupedClients.length; i++) {
      if (selectedItems[i]) {
        clientIdsToDelete
            .add(_groupedClients[i]['client'][DatabaseHelper.columnClientId]);
      }
    }

    if (clientIdsToDelete.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No clients selected for deletion.")),
      );
      return;
    }

    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 38, 38, 40),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        titlePadding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
        title: Row(
          children: [
            const Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 16),
                child: Text('Confirm Delete',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Gilroy',
                        color: Colors.white60)),
              ),
            ),
            IconButton(
                onPressed: () => Navigator.pop(context, false),
                icon: const Icon(Icons.close,
                    color: Color.fromARGB(255, 13, 136, 69))),
          ],
        ),
        contentPadding: EdgeInsets.zero,
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(color: Colors.grey, thickness: 0.5),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                  'Are you sure you want to delete the selected clients?\nThis action cannot be undone.',
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Gilroy',
                      color: Colors.white38)),
            ),
            SizedBox(height: 8),
            Divider(color: Colors.grey, thickness: 0.5),
          ],
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      side: const BorderSide(color: Colors.white38, width: 1),
                      backgroundColor: const Color.fromARGB(255, 60, 60, 62),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => Navigator.pop(context, false),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text('Cancel',
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Gilroy',
                              color: Colors.white70)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      side: const BorderSide(color: Colors.white38, width: 1),
                      backgroundColor: Colors.red.withOpacity(0.5),
                      foregroundColor: Colors.white.withOpacity(0.5),
                    ),
                    onPressed: () => Navigator.pop(context, true),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text('Delete',
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Gilroy',
                              color: Colors.white70)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (confirmed == true) {
      for (var id in clientIdsToDelete) {
        await DatabaseHelper.instance.deleteClient(id);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selected clients deleted.")),
      );

      await _loadClients();
      _resetSelectedClientIfInvalid();
    }
  }

  void _resetSelectedClientIfInvalid() {
    setState(() {
      if (selectedClient != null) {
        final clientId =
            selectedClient!['client'][DatabaseHelper.columnClientId];
        final exists = _groupedClients.any(
          (client) =>
              client['client'][DatabaseHelper.columnClientId] == clientId,
        );
        if (!exists) {
          selectedClient = null;
          selectedLandProperty = null;
        }
      }
      if (_groupedClients.isEmpty) {
        selectedClient = null;
        selectedLandProperty = null;
      }
    });
  }

  Future<void> _showYearInputDialog(BuildContext context) async {
    final TextEditingController yearController = TextEditingController();
    final year = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 28, 28, 29),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: Color.fromARGB(255, 13, 136, 69), // Border color
            width: 0.7, // Border width
          ),
        ),
        title: const Text(
          "Enter ROD Year",
          style: TextStyle(
            color: Colors.white60,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.bold,
          ),
        ),
        content: TextField(
          controller: yearController,
          keyboardType: TextInputType.number,
          maxLength: 4,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "e.g., 2023",
            hintStyle: const TextStyle(color: Colors.white38),
            counterText: "", // Hides the character counter
            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(8), // Border radius for all states
              borderSide: const BorderSide(
                color: Color.fromARGB(255, 60, 60, 62), // Default border color
                width: 1.0, // Default border width
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(8), // Border radius when enabled
              borderSide: const BorderSide(
                color: Color.fromARGB(
                    255, 60, 60, 62), // Border color when enabled
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(8), // Border radius when focused
              borderSide: const BorderSide(
                color: Color.fromARGB(
                    255, 13, 136, 69), // Border color when focused
                width: 1.0,
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                const Text("Cancel", style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () {
              final input = yearController.text;
              if (input.length == 4 && int.tryParse(input) != null) {
                Navigator.pop(context, input);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Please enter a valid 4-digit year")),
                );
              }
            },
            child: const Text("OK", style: TextStyle(color: Colors.white70)),
          ),
        ],
      ),
    );

    if (year != null) {
      setState(() {
        _rodFilterYear = year;
        _rodFilterStatus = "Patented/Approved";
        currentPage = 0; // Reset to first page
      });
    }
  }

  @override
  void dispose() {
    _landPropertyScrollController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppbarComponent(
          title:
              'Land Origin and Resources Evaluation Management System\nLOREMS (DENR Quezon, Palawan)'),
      body: Column(
        children: [
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration:
                const BoxDecoration(color: Color.fromARGB(255, 22, 22, 24)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 10),
                Row(
                  children: [
                    SearchField(
                      hintText: 'Search clients...',
                      onSearch: (query) {
                        setState(() {
                          _searchQuery = query;
                          currentPage = 0;
                        });
                      },
                    ),
                    const SizedBox(width: 5),
                    Tooltip(
                      message: "Filter by ROD Received Date",
                      child: ElevatedButton.icon(
                        key: _filterButtonKey, // Assign the GlobalKey here
                        onPressed: () {
                          // Get the button's position and size
                          final RenderBox renderBox = _filterButtonKey
                              .currentContext!
                              .findRenderObject() as RenderBox;
                          final Offset buttonPosition =
                              renderBox.localToGlobal(Offset.zero);
                          final Size buttonSize = renderBox.size;

                          // Define margin (e.g., 8 pixels on all sides)
                          const double margin = 8.0;

                          // Calculate the position for the menu with margin
                          final RelativeRect position = RelativeRect.fromLTRB(
                            buttonPosition.dx + margin, // Left with margin
                            buttonPosition.dy +
                                buttonSize.height +
                                margin, // Below with margin
                            MediaQuery.of(context).size.width -
                                (buttonPosition.dx + buttonSize.width) +
                                margin, // Right with margin
                            margin, // Bottom with margin (relative to screen bottom)
                          );

                          showMenu(
                            context: context,
                            position: position,
                            items: [
                              PopupMenuItem<String>(
                                value: "None",
                                child: const Text(
                                  "None",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onTap: () {
                                  setState(() {
                                    _rodFilterStatus = "None";
                                    _rodFilterYear = null;
                                    currentPage = 0;
                                  });
                                },
                              ),
                              PopupMenuItem<String>(
                                value: "Patented/Approved",
                                child: const Text(
                                  "Patented/Approved",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onTap: () {
                                  _showYearInputDialog(context);
                                },
                              ),
                            ],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(
                                color: Color.fromARGB(255, 13, 136, 69),
                                width: 0.7,
                              ),
                            ),
                            color: const Color.fromRGBO(44, 44, 46, 5),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 8,
                          backgroundColor:
                              const Color.fromARGB(255, 60, 60, 62),
                          foregroundColor: Colors.white54,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                            side: const BorderSide(
                              color: Color.fromARGB(255, 13, 136, 69),
                              width: 0.7,
                            ),
                          ),
                        ),
                        icon: const Icon(
                          Icons.filter_list,
                          size: 18,
                          color: Color.fromARGB(255, 0, 236, 35),
                        ),
                        label: const Text(
                          'Filter',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Gilroy',
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 50),
                    Tooltip(
                      message: "Refresh All Data",
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          setState(() {
                            _rotationController
                                .repeat(); // Start rotation animation
                            isRefreshing = true;
                          });
                          await _loadClients(); // Reload all client data
                          setState(() {
                            // Reset all relevant state variables to initial values
                            _searchQuery = '';
                            currentPage = 0;
                            selectedClient = null;
                            selectedLandProperty = null;
                            selectedIndex = null;
                            selectAll = false;
                            selectedItems = List<bool>.generate(
                                _groupedClients.length, (index) => false);
                            hoveredItems = List<bool>.generate(
                                _groupedClients.length, (index) => false);
                            _rotationController
                                .stop(); // Stop rotation animation
                            isRefreshing = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Home page refreshed")),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 8,
                          backgroundColor:
                              const Color.fromARGB(255, 60, 60, 62),
                          foregroundColor: Colors.white54,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                            side: const BorderSide(
                              color: Color.fromARGB(255, 13, 136, 69),
                              width: 0.7,
                            ),
                          ),
                        ),
                        icon: RotationTransition(
                          turns: _rotationController,
                          child: const Icon(
                            Icons.refresh,
                            size: 18,
                            color: Color.fromARGB(255, 0, 236, 35),
                          ),
                        ),
                        label: const Text(
                          'Refresh',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Gilroy',
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Tooltip(
                      message: "Go to Visualization Land Origin",
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VisualizationLandOriginPage(
                                key: inheritanceKey,
                                initialQuery: "your search query",
                              ),
                            ),
                          );
                        },
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
                              width: 0.7,
                            ),
                          ),
                        ),
                        icon: const Icon(
                          Icons.account_tree,
                          size: 18,
                          color: Color.fromARGB(255, 0, 236, 35),
                        ),
                        label: const Text(
                          ' Land Origin',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Gilroy',
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Tooltip(
                      message: "Add New Client",
                      child: ElevatedButton.icon(
                        onPressed: () => AddNewClientPage.navigate(
                          context,
                          (clientData) {
                            _loadClients();
                            if (kDebugMode) {
                              print('New client saved: $clientData');
                            }
                          },
                          client: {},
                        ),
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
                        icon: const Icon(
                          Icons.person_add,
                          size: 18,
                          color: Color.fromARGB(255, 0, 236, 35),
                        ),
                        label: const Text('Add New Client',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Gilroy',
                                fontSize: 13)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Tooltip(
                      message: "Printing",
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (_clients.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PdfPreviewPage(clientData: _clients),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'No client data available for printing')),
                            );
                          }
                        },
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
                        icon: const Icon(
                          Icons.print,
                          size: 18,
                          color: Color.fromARGB(255, 0, 236, 35),
                        ),
                        label: const Text('Print',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Gilroy',
                                fontSize: 13)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              color: const Color.fromARGB(255, 22, 22, 24),
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 28, 28, 30),
                          borderRadius: BorderRadius.circular(24)),
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: Card(
                              elevation: 8,
                              color: const Color.fromARGB(225, 36, 36, 38),
                              margin: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 4),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16.0),
                                    topRight: Radius.circular(16.0),
                                    bottomLeft: Radius.circular(4),
                                    bottomRight: Radius.circular(4)),
                                side: BorderSide(
                                    color: Color.fromARGB(255, 60, 60, 62),
                                    width: 1.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                child: Row(
                                  children: [
                                    const SizedBox(width: 5),
                                    Expanded(
                                      flex: 1,
                                      child: Transform.scale(
                                        scale: 1.0,
                                        child: Checkbox(
                                          value: selectAll,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              selectAll = value ?? false;
                                              for (int i = 0;
                                                  i < selectedItems.length;
                                                  i++) {
                                                selectedItems[i] = selectAll;
                                              }
                                            });
                                          },
                                          activeColor: Colors.green,
                                          side:
                                              WidgetStateBorderSide.resolveWith(
                                                  (states) => states.contains(
                                                          WidgetState.selected)
                                                      ? const BorderSide(
                                                          color: Colors.green,
                                                          width: 0.7)
                                                      : const BorderSide(
                                                          color: Colors.grey,
                                                          width: 0.7)),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(3.0)),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      flex: 20,
                                      child: Row(
                                        children: [
                                          const Expanded(
                                              flex: 5,
                                              child: Text('Clients Name',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: Colors.white,
                                                      fontSize: 13,
                                                      fontFamily: 'Gilroy'))),
                                          const Expanded(
                                              flex: 4,
                                              child: Text('Lot Number',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: Colors.white,
                                                      fontSize: 13,
                                                      fontFamily: 'Gilroy'))),
                                          const SizedBox(width: 20),
                                          const Expanded(
                                              flex: 3,
                                              child: Text('T-Land(Area sqm.)',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: Colors.white,
                                                      fontSize: 13,
                                                      fontFamily: 'Gilroy'))),
                                          const SizedBox(width: 10),
                                          PopupMenuButton<String>(
                                            icon: const Icon(Icons.open_in_new,
                                                color: Colors.white54,
                                                size: 20),
                                            splashRadius: 4,
                                            onSelected: (String value) async {
                                              if (value == 'Delete') {
                                                _deleteSelectedClients();
                                              } else if (value == 'Print') {
                                                _printSelectedClients();
                                              }
                                            },
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                side: const BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 13, 136, 69),
                                                    width: 0.4)),
                                            color: const Color.fromRGBO(
                                                44, 44, 46, 5),
                                            itemBuilder: (BuildContext
                                                    context) =>
                                                <Map<String, IconData>>[
                                              {'Print': Icons.print},
                                              {'Delete': Icons.delete},
                                            ]
                                                    .map((item) =>
                                                        PopupMenuItem<String>(
                                                          value:
                                                              item.keys.first,
                                                          child: Row(children: [
                                                            Icon(
                                                                item.values
                                                                    .first,
                                                                color: const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    13,
                                                                    136,
                                                                    69),
                                                                size: 18),
                                                            const SizedBox(
                                                                width: 10),
                                                            Text(
                                                                item.keys.first,
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white))
                                                          ]),
                                                        ))
                                                    .toList(),
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: _filteredClients.isEmpty
                                ? const Center(
                                    child: Text('No clients found.',
                                        style:
                                            TextStyle(color: Colors.white54)))
                                : CustomRefreshIndicator(
                                    onRefresh: () async {
                                      setState(() {
                                        currentPage = 0;
                                        _refreshSuccess = false;
                                        _rotationController.repeat();
                                      });
                                      await _loadClients();
                                      setState(() {
                                        _rotationController.stop();
                                        _refreshSuccess = true;
                                      });
                                      await Future.delayed(
                                          const Duration(seconds: 1));
                                      setState(() => _refreshSuccess = false);
                                    },
                                    builder: (context, child, controller) {
                                      final isDragging = controller.isDragging;
                                      final isArmed = controller.isArmed;
                                      final isLoading = controller.isLoading;
                                      return Stack(
                                        children: [
                                          AnimatedBuilder(
                                            animation: controller,
                                            builder: (context, _) =>
                                                Transform.translate(
                                                    offset: Offset(0,
                                                        60 * controller.value),
                                                    child: child),
                                          ),
                                          Positioned(
                                            top: 30,
                                            left: 0,
                                            right: 0,
                                            child: Center(
                                              child: AnimatedSwitcher(
                                                duration: const Duration(
                                                    milliseconds: 300),
                                                transitionBuilder:
                                                    (child, animation) =>
                                                        ScaleTransition(
                                                            scale: animation,
                                                            child: child),
                                                child: _refreshSuccess
                                                    ? Container(
                                                        key: const ValueKey(
                                                            'success'),
                                                        width: 60,
                                                        height: 60,
                                                        decoration: BoxDecoration(
                                                            color: const Color(
                                                                0xFF1A1A1A),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30),
                                                            border: Border.all(
                                                                color: const Color(
                                                                    0xFF0D8845),
                                                                width: 1.5)),
                                                        child: const Icon(
                                                            Icons.check_circle,
                                                            color: Color(
                                                                0xFF0D8845),
                                                            size: 30),
                                                      )
                                                    : (isDragging ||
                                                            isArmed ||
                                                            isLoading)
                                                        ? Container(
                                                            key: ValueKey<bool>(
                                                                isLoading),
                                                            width: 60,
                                                            height: 60,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: const Color(
                                                                  0xFF1A1A1A),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            0.3),
                                                                    blurRadius:
                                                                        10,
                                                                    spreadRadius:
                                                                        2)
                                                              ],
                                                              border: Border.all(
                                                                  color: const Color(
                                                                      0xFF0D8845),
                                                                  width: 1.5),
                                                            ),
                                                            child: Stack(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              children: [
                                                                if (isDragging &&
                                                                    !isLoading)
                                                                  CircularProgressIndicator(
                                                                      value: controller
                                                                          .value
                                                                          .clamp(0.0,
                                                                              1.0),
                                                                      strokeWidth:
                                                                          2,
                                                                      color: const Color(
                                                                          0xFF0D8845)),
                                                                if (isLoading)
                                                                  RotationTransition(
                                                                      turns:
                                                                          _rotationController,
                                                                      child: const Icon(
                                                                          Icons
                                                                              .refresh,
                                                                          color: Color(
                                                                              0xFF0D8845),
                                                                          size:
                                                                              30)),
                                                                if (!isLoading &&
                                                                    controller
                                                                            .value <
                                                                        1.0)
                                                                  Transform.translate(
                                                                      offset: Offset(
                                                                          0,
                                                                          10 *
                                                                              (1 -
                                                                                  controller
                                                                                      .value)),
                                                                      child: const Icon(
                                                                          Icons
                                                                              .arrow_downward,
                                                                          color: Color(
                                                                              0xFF0D8845),
                                                                          size:
                                                                              24)),
                                                              ],
                                                            ),
                                                          )
                                                        : const SizedBox
                                                            .shrink(),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: ListView.builder(
                                            physics: const BouncingScrollPhysics(
                                                decelerationRate:
                                                    ScrollDecelerationRate
                                                        .normal,
                                                parent:
                                                    AlwaysScrollableScrollPhysics()),
                                            itemCount: itemsPerPage,
                                            itemBuilder: (context, index) {
                                              int itemIndex =
                                                  currentPage * itemsPerPage +
                                                      index;
                                              if (itemIndex >= totalItems) {
                                                return const SizedBox();
                                              }
                                              final client =
                                                  _filteredClients[itemIndex];
                                              final isLargeArea =
                                                  getTotalAreaForClient(
                                                          client) >
                                                      120000;
                                              final textColor = isLargeArea
                                                  ? Colors.red
                                                  : const Color.fromARGB(
                                                      255, 94, 237, 5);
                                              Color cardColor =
                                                  defaultCardColor;
                                              if (selectedClient != null &&
                                                  selectedClient!['client'][
                                                          DatabaseHelper
                                                              .columnClientId] ==
                                                      client['client'][
                                                          DatabaseHelper
                                                              .columnClientId]) {
                                                cardColor = activeCardColor;
                                              }
                                              return MouseRegion(
                                                onEnter: (_) => setState(() =>
                                                    hoveredItems[itemIndex] =
                                                        true),
                                                onExit: (_) => setState(() =>
                                                    hoveredItems[itemIndex] =
                                                        false),
                                                child: Card(
                                                  elevation: 6,
                                                  color: cardColor,
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 1.5,
                                                      horizontal: 4),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                      side: const BorderSide(
                                                          color: Color.fromARGB(
                                                              255, 60, 60, 62),
                                                          width: 0.4)),
                                                  child: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        if (selectedClient ==
                                                            client) {
                                                          // Deselect the client if it's already selected
                                                          selectedClient = null;
                                                          selectedLandProperty =
                                                              null;
                                                          selectedIndex = null;
                                                        } else {
                                                          // Select the new client
                                                          selectedClient =
                                                              client;
                                                          final landProperties =
                                                              getLandPropertiesForSelectedClient();
                                                          if (landProperties
                                                              .isNotEmpty) {
                                                            selectedIndex = 0;
                                                            selectedLandProperty =
                                                                landProperties
                                                                    .first;
                                                          } else {
                                                            selectedIndex =
                                                                null;
                                                            selectedLandProperty =
                                                                null;
                                                          }
                                                        }
                                                      });
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 20,
                                                          vertical: 10),
                                                      child: Row(
                                                        children: [
                                                          const SizedBox(
                                                              width: 5),
                                                          Expanded(
                                                            flex: 1,
                                                            child:
                                                                Transform.scale(
                                                              scale: 1.0,
                                                              child: Checkbox(
                                                                value: (selectedItems
                                                                            .length >
                                                                        itemIndex)
                                                                    ? selectedItems[
                                                                        itemIndex]
                                                                    : false,
                                                                onChanged:
                                                                    (bool?
                                                                        value) {
                                                                  setState(() {
                                                                    selectedItems[
                                                                            itemIndex] =
                                                                        value ??
                                                                            false;
                                                                    selectAll = selectedItems.every(
                                                                        (element) =>
                                                                            element);
                                                                  });
                                                                },
                                                                activeColor:
                                                                    Colors
                                                                        .green,
                                                                side: WidgetStateBorderSide.resolveWith((states) => states.contains(
                                                                        WidgetState
                                                                            .selected)
                                                                    ? const BorderSide(
                                                                        color: Colors
                                                                            .green,
                                                                        width:
                                                                            0.7)
                                                                    : const BorderSide(
                                                                        color: Colors
                                                                            .grey,
                                                                        width:
                                                                            0.7)),
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            3.0)),
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 10),
                                                          Expanded(
                                                            flex: 20,
                                                            child: Row(
                                                              children: [
                                                                Builder(
                                                                  builder:
                                                                      (context) {
                                                                    final clientData =
                                                                        client[
                                                                            'client'];
                                                                    final String
                                                                        lastName =
                                                                        clientData[DatabaseHelper.columnApplicantLastname] ??
                                                                            '';
                                                                    final String
                                                                        firstName =
                                                                        clientData[DatabaseHelper.columnApplicantFirstname] ??
                                                                            '';
                                                                    final String
                                                                        suffix =
                                                                        clientData[DatabaseHelper.columnApplicantSuffix] ??
                                                                            '';
                                                                    final String
                                                                        middleName =
                                                                        clientData[DatabaseHelper.columnApplicantMiddlename] ??
                                                                            '';
                                                                    final String
                                                                        middleInitial =
                                                                        middleName.isNotEmpty
                                                                            ? '${middleName[0]}.'
                                                                            : '';
                                                                    final String
                                                                        fullName =
                                                                        '${lastName.isNotEmpty ? ' $lastName ' : ''}$firstName ${suffix.isNotEmpty ? ' $suffix ' : ''}${middleInitial.isNotEmpty ? ' $middleInitial' : ''}';
                                                                    return Expanded(
                                                                        flex: 5,
                                                                        child: Text(
                                                                            fullName,
                                                                            style: TextStyle(
                                                                                color: textColor,
                                                                                fontSize: 14,
                                                                                fontFamily: 'Gilroy')));
                                                                  },
                                                                ),
                                                                Expanded(
                                                                  flex: 4,
                                                                  child: Text(
                                                                    (client['land_properties']
                                                                                as List)
                                                                            .isNotEmpty
                                                                        ? client['land_properties'][0][DatabaseHelper.columnLotNumber] ??
                                                                            ''
                                                                        : '',
                                                                    style: TextStyle(
                                                                        color:
                                                                            textColor,
                                                                        fontSize:
                                                                            14,
                                                                        fontFamily:
                                                                            'Gilroy'),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    width: 20),
                                                                Expanded(
                                                                  flex: 3,
                                                                  child: Text(
                                                                    NumberFormat
                                                                            .decimalPattern()
                                                                        .format(
                                                                            getTotalAreaForClient(client)),
                                                                    style: TextStyle(
                                                                        color:
                                                                            textColor,
                                                                        fontSize:
                                                                            14,
                                                                        fontFamily:
                                                                            'Gilroy'),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    width: 10),
                                                                PopupMenuButton<
                                                                    String>(
                                                                  icon: const Icon(
                                                                      Icons
                                                                          .open_in_new,
                                                                      color: Colors
                                                                          .white54,
                                                                      size: 20),
                                                                  splashRadius:
                                                                      4,
                                                                  shadowColor:
                                                                      cardColor,
                                                                  onSelected:
                                                                      (String
                                                                          value) async {
                                                                    if (value ==
                                                                        'Add Land') {
                                                                      int clientId = client[
                                                                              'client']
                                                                          [
                                                                          DatabaseHelper
                                                                              .columnClientId];
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => AddLandPage(clientId: clientId))).then(
                                                                          (result) {
                                                                        if (result ==
                                                                            true) {
                                                                          _loadClients();
                                                                        }
                                                                      });
                                                                    } else if (value ==
                                                                        'Edit') {
                                                                      Navigator
                                                                          .push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              EditClientPage(
                                                                            client:
                                                                                client['client'],
                                                                            onClientUpdated:
                                                                                (updatedClientData) async {
                                                                              await _loadClients();
                                                                              setState(() {
                                                                                selectedClient = _groupedClients.firstWhere(
                                                                                  (c) => c['client'][DatabaseHelper.columnClientId] == updatedClientData[DatabaseHelper.columnClientId],
                                                                                  orElse: () => selectedClient!,
                                                                                );
                                                                              });
                                                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Client updated.")));
                                                                            },
                                                                          ),
                                                                        ),
                                                                      );
                                                                    } else if (value ==
                                                                        'Delete') {
                                                                      bool?
                                                                          confirmed =
                                                                          await showDialog<
                                                                              bool>(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (context) =>
                                                                                AlertDialog(
                                                                          backgroundColor: const Color
                                                                              .fromARGB(
                                                                              255,
                                                                              38,
                                                                              38,
                                                                              40),
                                                                          shape:
                                                                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                                                                          titlePadding: const EdgeInsets
                                                                              .fromLTRB(
                                                                              0,
                                                                              16,
                                                                              0,
                                                                              0),
                                                                          title:
                                                                              Row(
                                                                            children: [
                                                                              const Expanded(child: Padding(padding: EdgeInsets.only(left: 16), child: Text('Confirm Delete', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Gilroy', color: Colors.white60)))),
                                                                              IconButton(onPressed: () => Navigator.pop(context, false), icon: const Icon(Icons.close, color: Color.fromARGB(255, 13, 136, 69))),
                                                                            ],
                                                                          ),
                                                                          contentPadding:
                                                                              EdgeInsets.zero,
                                                                          content:
                                                                              const Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Divider(color: Colors.grey, thickness: 0.5),
                                                                              SizedBox(height: 8),
                                                                              Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('Are you sure you want to delete this client?\nThis action cannot be undone.', style: TextStyle(fontSize: 18, fontFamily: 'Gilroy', color: Colors.white38))),
                                                                              SizedBox(height: 8),
                                                                              Divider(color: Colors.grey, thickness: 0.5),
                                                                            ],
                                                                          ),
                                                                          actionsPadding: const EdgeInsets
                                                                              .fromLTRB(
                                                                              16,
                                                                              8,
                                                                              16,
                                                                              16),
                                                                          actions: [
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                Expanded(
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                                                                    child: ElevatedButton(
                                                                                      style: ElevatedButton.styleFrom(
                                                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                                                                        side: const BorderSide(color: Colors.white38, width: 1),
                                                                                        backgroundColor: const Color.fromARGB(255, 60, 60, 62),
                                                                                        foregroundColor: Colors.white,
                                                                                      ),
                                                                                      onPressed: () => Navigator.pop(context, false),
                                                                                      child: const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text('Cancel', style: TextStyle(fontSize: 18, fontFamily: 'Gilroy', color: Colors.white70))),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                const SizedBox(width: 4),
                                                                                Expanded(
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                                                                    child: ElevatedButton(
                                                                                      style: ElevatedButton.styleFrom(
                                                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                                                                        side: const BorderSide(color: Colors.white38, width: 1),
                                                                                        backgroundColor: Colors.red.withOpacity(0.5),
                                                                                        foregroundColor: Colors.white.withOpacity(0.5),
                                                                                      ),
                                                                                      onPressed: () => Navigator.pop(context, true),
                                                                                      child: const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text('Delete', style: TextStyle(fontSize: 18, fontFamily: 'Gilroy', color: Colors.white70))),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      );
                                                                      if (confirmed ==
                                                                          true) {
                                                                        int clientId =
                                                                            client['client'][DatabaseHelper.columnClientId];
                                                                        await DatabaseHelper
                                                                            .instance
                                                                            .deleteClient(clientId);
                                                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                                            content:
                                                                                Text("Client deleted.")));
                                                                        _loadClients();
                                                                      }
                                                                    } else if (value ==
                                                                        'Print') {
                                                                      final landProperties =
                                                                          getLandPropertiesForSelectedClient();
                                                                      if (selectedClient !=
                                                                          null) {
                                                                        PrintClientNarrativePage.navigate(
                                                                            context,
                                                                            selectedClient!['client'],
                                                                            landProperties);
                                                                      }
                                                                    }
                                                                  },
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              4),
                                                                      side: const BorderSide(
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              13,
                                                                              136,
                                                                              69),
                                                                          width:
                                                                              0.4)),
                                                                  color: const Color
                                                                      .fromRGBO(
                                                                      44,
                                                                      44,
                                                                      46,
                                                                      5),
                                                                  itemBuilder: (BuildContext context) => <Map<
                                                                          String,
                                                                          IconData>>[
                                                                    {
                                                                      'Print': Icons
                                                                          .print
                                                                    },
                                                                    {
                                                                      'Add Land':
                                                                          Icons
                                                                              .add_box_rounded
                                                                    },
                                                                    {
                                                                      'Edit': Icons
                                                                          .edit
                                                                    },
                                                                    {
                                                                      'Delete':
                                                                          Icons
                                                                              .delete
                                                                    },
                                                                  ]
                                                                      .map((item) =>
                                                                          PopupMenuItem<
                                                                              String>(
                                                                            value:
                                                                                item.keys.first,
                                                                            child:
                                                                                Row(children: [
                                                                              Icon(item.values.first, color: const Color.fromARGB(255, 13, 136, 69), size: 18),
                                                                              Text(item.keys.first, style: const TextStyle(color: Colors.white))
                                                                            ]),
                                                                          ))
                                                                      .toList(),
                                                                ),
                                                                const SizedBox(
                                                                    width: 5),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 2),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              IconButton(
                                                icon: const Icon(
                                                    Icons.arrow_back,
                                                    color: Color.fromARGB(
                                                        255, 13, 136, 69)),
                                                onPressed: currentPage > 0
                                                    ? () => setState(
                                                        () => currentPage--)
                                                    : null,
                                              ),
                                              Text(
                                                  'Page ${currentPage + 1} of $totalPages',
                                                  style: const TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 150, 150, 164))),
                                              IconButton(
                                                icon: const Icon(
                                                    Icons.arrow_forward,
                                                    color: Color.fromARGB(
                                                        255, 13, 136, 69)),
                                                onPressed:
                                                    currentPage < totalPages - 1
                                                        ? () => setState(
                                                            () => currentPage++)
                                                        : null,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                          _buildTotalClientsLabel(),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      padding: const EdgeInsets.all(26.0),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 28, 28, 30),
                        border: Border.all(
                            color: const Color.fromARGB(255, 60, 60, 62),
                            width: 0.4),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: selectedClient == null
                          ? const Center(
                              child: Text('Select a record to view details',
                                  style: TextStyle(color: Colors.white54)))
                          : SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildSectionTitle('Personal Information'),
                                  _buildInfoRow(
                                      'First Name',
                                      selectedClient!['client'][DatabaseHelper
                                              .columnApplicantFirstname] ??
                                          ''),
                                  _buildInfoRow(
                                      'Middle Name',
                                      selectedClient!['client'][DatabaseHelper
                                              .columnApplicantMiddlename] ??
                                          ''),
                                  _buildInfoRow(
                                      'Last Name',
                                      selectedClient!['client'][DatabaseHelper
                                              .columnApplicantLastname] ??
                                          ''),
                                  _buildInfoRow(
                                      'Extension Name',
                                      selectedClient!['client'][DatabaseHelper
                                              .columnApplicantSuffix] ??
                                          ''),
                                  _buildInfoRow(
                                      'Maiden Name',
                                      (selectedClient!['client'][DatabaseHelper
                                                      .columnApplicantMaidenname]
                                                  ?.toString()
                                                  .trim()
                                                  .isEmpty ??
                                              true)
                                          ? 'N/A'
                                          : selectedClient!['client'][
                                                  DatabaseHelper
                                                      .columnApplicantMaidenname]
                                              .toString()),
                                  const SizedBox(height: 5),
                                  const Divider(
                                      height: 5,
                                      thickness: 0.2,
                                      color: Colors.white54),
                                  _buildInfoRow(
                                      'Gender',
                                      selectedClient!['client']
                                              [DatabaseHelper.columnGender] ??
                                          ''),
                                  _buildInfoRow(
                                      'Birth Date',
                                      selectedClient!['client'][
                                              DatabaseHelper.columnBirthDate] ??
                                          ''),
                                  _buildInfoRow(
                                      'Status',
                                      selectedClient!['client']
                                              [DatabaseHelper.columnStatus] ??
                                          ''),
                                  _buildInfoRow(
                                      'Spouse',
                                      selectedClient!['client']
                                              [DatabaseHelper.columnSpouse] ??
                                          ''),
                                  const SizedBox(height: 5),
                                  const Divider(
                                      height: 5,
                                      thickness: 0.2,
                                      color: Colors.white54),
                                  _buildInfoRow(
                                      'Sitio Address',
                                      selectedClient!['client'][DatabaseHelper
                                              .columnSitioAddress] ??
                                          ''),
                                  _buildInfoRow(
                                      'Barangay Address',
                                      selectedClient!['client'][DatabaseHelper
                                              .columnBarangayAddress] ??
                                          ''),
                                  _buildInfoRow(
                                      'Municipality Address',
                                      selectedClient!['client'][DatabaseHelper
                                              .columnMunicipalityAddress] ??
                                          ''),
                                  const SizedBox(height: 5),
                                  const Divider(
                                      height: 5,
                                      thickness: 0.2,
                                      color: Colors.white54),
                                  const SizedBox(height: 30),
                                  _buildSectionTitle(
                                      'Land Property Information'),
                                  const SizedBox(height: 5),
                                  SizedBox(
                                    height: 40,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount:
                                          getLandPropertiesForSelectedClient()
                                              .length,
                                      itemBuilder: (context, index) {
                                        final property =
                                            getLandPropertiesForSelectedClient()[
                                                index];
                                        final bool isSelected =
                                            selectedIndex == index;
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4.0),
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Card(
                                                color: isSelected
                                                    ? const Color.fromARGB(
                                                        255, 40, 40, 42)
                                                    : Colors.transparent,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                    side: BorderSide(
                                                        color: isSelected
                                                            ? const Color
                                                                .fromARGB(
                                                                255, 84, 84, 86)
                                                            : Colors
                                                                .transparent,
                                                        width: 0.7)),
                                                elevation: 0,
                                                child: InkWell(
                                                  onTap: () => setState(() {
                                                    selectedLandProperty =
                                                        property;
                                                    selectedIndex = index;
                                                  }),
                                                  splashColor:
                                                      const Color.fromARGB(
                                                          30, 118, 118, 118),
                                                  hoverColor:
                                                      const Color.fromARGB(
                                                          15, 87, 87, 87),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 12,
                                                        vertical: 8),
                                                    child: Text(
                                                        property[DatabaseHelper
                                                                .columnLotNumber] ??
                                                            'N/A',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: isSelected
                                                                ? Colors.white
                                                                : const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    45,
                                                                    114,
                                                                    255))),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  const Divider(
                                      height: 5,
                                      thickness: 0.5,
                                      color: Colors.white54),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Tooltip(
                                        message: "Refresh Data",
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.refresh,
                                            size: 18,
                                            color:
                                                Color.fromARGB(255, 0, 236, 35),
                                          ),
                                          onPressed: () {
                                            if (selectedClient != null &&
                                                selectedLandProperty != null) {
                                              setState(
                                                  () => isRefreshing = true);
                                              final startTime = DateTime.now();
                                              _loadClients().then((_) async {
                                                final elapsed = DateTime.now()
                                                    .difference(startTime);
                                                const minDuration =
                                                    Duration(seconds: 2);
                                                if (elapsed < minDuration) {
                                                  await Future.delayed(
                                                      minDuration - elapsed);
                                                }
                                                setState(() {
                                                  final int clientId =
                                                      selectedClient!['client'][
                                                          DatabaseHelper
                                                              .columnClientId];
                                                  final updatedClient =
                                                      _groupedClients.firstWhere(
                                                          (client) =>
                                                              client['client'][
                                                                  DatabaseHelper
                                                                      .columnClientId] ==
                                                              clientId);
                                                  if (updatedClient
                                                      .isNotEmpty) {
                                                    final updatedLandProperty =
                                                        (updatedClient[
                                                                    'land_properties']
                                                                as List<
                                                                    dynamic>)
                                                            .firstWhere(
                                                      (land) =>
                                                          land[DatabaseHelper
                                                              .columnLandPropertyId] ==
                                                          selectedLandProperty![
                                                              DatabaseHelper
                                                                  .columnLandPropertyId],
                                                      orElse: () =>
                                                          selectedLandProperty!,
                                                    );
                                                    selectedLandProperty =
                                                        updatedLandProperty;
                                                  }
                                                  isRefreshing = false;
                                                });
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(const SnackBar(
                                                        content: Text(
                                                            "Selected land property refreshed"),
                                                        duration: Duration(
                                                            seconds: 2)));
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                      Tooltip(
                                        message: "Sub-Divide Land",
                                        child: IconButton(
                                          icon: const Icon(Icons.call_split,
                                              size: 18),
                                          color: const Color.fromARGB(
                                              255, 0, 236, 35),
                                          onPressed: () {
                                            if (selectedLandProperty != null) {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          SubDividingLandPage(
                                                              landPropertyData:
                                                                  selectedLandProperty!)));
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          "Please select a land property to subdivide")));
                                            }
                                          },
                                        ),
                                      ),
                                      Tooltip(
                                        message: "Add Land",
                                        child: IconButton(
                                          icon: const Icon(Icons.add, size: 18),
                                          color: const Color.fromARGB(
                                              255, 0, 236, 35),
                                          onPressed: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => AddLandPage(
                                                      clientId: selectedClient![
                                                              'client'][
                                                          DatabaseHelper
                                                              .columnClientId]))).then(
                                              (_) => _loadClients()),
                                        ),
                                      ),
                                      Tooltip(
                                        message: "Edit Land",
                                        child: IconButton(
                                          icon: const Icon(
                                              Icons.edit_note_outlined,
                                              size: 18),
                                          color: const Color.fromARGB(
                                              255, 0, 236, 35),
                                          onPressed: () {
                                            if (selectedLandProperty != null) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditLandPage(
                                                    clientId: selectedClient![
                                                            'client'][
                                                        DatabaseHelper
                                                            .columnClientId],
                                                    landPropertyData:
                                                        selectedLandProperty!,
                                                    onLandPropertyUpdated:
                                                        (updatedLandProperty) async {
                                                      await _loadClients();
                                                      setState(() {
                                                        final int clientId =
                                                            selectedClient![
                                                                    'client'][
                                                                DatabaseHelper
                                                                    .columnClientId];
                                                        final updatedClient = _groupedClients
                                                            .firstWhere((client) =>
                                                                client['client']
                                                                    [
                                                                    DatabaseHelper
                                                                        .columnClientId] ==
                                                                clientId);
                                                        if (updatedClient
                                                            .isNotEmpty) {
                                                          final updatedLandProperty =
                                                              (updatedClient[
                                                                          'land_properties']
                                                                      as List<
                                                                          dynamic>)
                                                                  .firstWhere(
                                                            (land) =>
                                                                land[DatabaseHelper
                                                                    .columnLandPropertyId] ==
                                                                selectedLandProperty![
                                                                    DatabaseHelper
                                                                        .columnLandPropertyId],
                                                            orElse: () =>
                                                                selectedLandProperty!,
                                                          );

                                                          selectedLandProperty =
                                                              updatedLandProperty;
                                                        }
                                                        isRefreshing = false;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                      Tooltip(
                                        message: "Delete Land",
                                        child: IconButton(
                                          icon: const Icon(Icons.delete,
                                              size: 18),
                                          color: const Color.fromARGB(
                                              255, 0, 236, 35),
                                          onPressed: () async {
                                            if (selectedLandProperty != null) {
                                              bool? confirm =
                                                  await showDialog<bool>(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                  backgroundColor:
                                                      const Color.fromARGB(
                                                          255, 38, 38, 40),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16.0)),
                                                  titlePadding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 16, 0, 0),
                                                  title: Row(
                                                    children: [
                                                      const Expanded(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 16),
                                                          child: Text(
                                                            'Confirm Delete',
                                                            style: TextStyle(
                                                                fontSize: 24,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily:
                                                                    'Gilroy',
                                                                color: Colors
                                                                    .white60),
                                                          ),
                                                        ),
                                                      ),
                                                      IconButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context, false),
                                                        icon: const Icon(
                                                            Icons.close,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    13,
                                                                    136,
                                                                    69)),
                                                      ),
                                                    ],
                                                  ),
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  content: const Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Divider(
                                                          color: Colors.grey,
                                                          thickness: 0.5),
                                                      SizedBox(height: 8),
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 16),
                                                        child: Text(
                                                          'Are you sure you want to delete this property?\nThis action cannot be undone.',
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontFamily:
                                                                  'Gilroy',
                                                              color: Colors
                                                                  .white38),
                                                        ),
                                                      ),
                                                      SizedBox(height: 8),
                                                      Divider(
                                                          color: Colors.grey,
                                                          thickness: 0.5),
                                                    ],
                                                  ),
                                                  actionsPadding:
                                                      const EdgeInsets.fromLTRB(
                                                          16, 8, 16, 16),
                                                  actions: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Expanded(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        16),
                                                            child:
                                                                ElevatedButton(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            4)),
                                                                side: const BorderSide(
                                                                    color: Colors
                                                                        .white38,
                                                                    width: 1),
                                                                backgroundColor:
                                                                    const Color
                                                                        .fromARGB(
                                                                        255,
                                                                        60,
                                                                        60,
                                                                        62),
                                                                foregroundColor:
                                                                    Colors
                                                                        .white,
                                                              ),
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                      context,
                                                                      false),
                                                              child:
                                                                  const Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            8),
                                                                child: Text(
                                                                  'Cancel',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      fontFamily:
                                                                          'Gilroy',
                                                                      color: Colors
                                                                          .white70),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 4),
                                                        Expanded(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        16),
                                                            child:
                                                                ElevatedButton(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            4)),
                                                                side: const BorderSide(
                                                                    color: Colors
                                                                        .white38,
                                                                    width: 1),
                                                                backgroundColor:
                                                                    Colors.red
                                                                        .withOpacity(
                                                                            0.5),
                                                                foregroundColor:
                                                                    Colors.white
                                                                        .withOpacity(
                                                                            0.5),
                                                              ),
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                      context,
                                                                      true),
                                                              child:
                                                                  const Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            8),
                                                                child: Text(
                                                                  'Delete',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      fontFamily:
                                                                          'Gilroy',
                                                                      color: Colors
                                                                          .white70),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              );

                                              if (confirm == true) {
                                                final dynamic propId =
                                                    selectedLandProperty?[
                                                        'land_property_id'];
                                                if (propId == null) {
                                                  if (kDebugMode) {
                                                    print(
                                                        "Error: Land Property ID is null. Cannot perform deletion.");
                                                  }
                                                  return;
                                                }
                                                final int propertyId =
                                                    propId as int;
                                                await DatabaseHelper.instance
                                                    .deleteLandProperty(
                                                        propertyId);

                                                await DatabaseHelper.instance
                                                    .deleteLandProperty(
                                                        propertyId);
                                                await _loadClients();
                                                setState(() =>
                                                    selectedLandProperty =
                                                        null);
                                              }
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(
                                      height: 5,
                                      thickness: 0.5,
                                      color: Colors.white54),
                                  if (selectedLandProperty != null)
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 20),
                                            _buildLotNumberRow(
                                                'Lot Status',
                                                selectedLandProperty![
                                                        DatabaseHelper
                                                            .columnLotStatus] ??
                                                    ''),
                                            const SizedBox(height: 10),
                                            _buildInfoRow(
                                                'Bundle Number',
                                                selectedLandProperty![
                                                        DatabaseHelper
                                                            .columnBundleNumber] ??
                                                    ''),
                                            _buildInfoRow(
                                                'Lot Number',
                                                selectedLandProperty![
                                                        DatabaseHelper
                                                            .columnLotNumber] ??
                                                    ''),
                                            _buildInfoRow(
                                                'Identical Number',
                                                selectedLandProperty![DatabaseHelper
                                                        .columnIdenticalNumber] ??
                                                    ''),
                                            _buildInfoRow(
                                                'Survey Claimant',
                                                selectedLandProperty![DatabaseHelper
                                                        .columnSurveyClaimant] ??
                                                    ''),
                                            const Divider(
                                                height: 5,
                                                thickness: 0.2,
                                                color: Colors.white54),
                                            _buildInfoRow(
                                                'Area (sqm)',
                                                NumberFormat.decimalPattern()
                                                    .format(selectedLandProperty![
                                                            DatabaseHelper
                                                                .columnAreaSqm] ??
                                                        0)),
                                            const Divider(
                                                height: 5,
                                                thickness: 0.2,
                                                color: Colors.white54),
                                            _buildInfoRow(
                                                'Sitio',
                                                selectedLandProperty![
                                                        DatabaseHelper
                                                            .columnSitio] ??
                                                    ''),
                                            _buildInfoRow(
                                                'Property Barangay',
                                                selectedLandProperty![DatabaseHelper
                                                        .columnPropertyBarangay] ??
                                                    ''),
                                            _buildInfoRow(
                                                'Property Municipality',
                                                selectedLandProperty![DatabaseHelper
                                                        .columnPropertyMunicipality] ??
                                                    ''),
                                            _buildInfoRow(
                                                'Remarks',
                                                selectedLandProperty![
                                                        DatabaseHelper
                                                            .columnRemarks] ??
                                                    ''),
                                            const Divider(
                                                height: 5,
                                                thickness: 0.2,
                                                color: Colors.white54),
                                            _buildInfoRow(
                                                'Application Number',
                                                selectedLandProperty![DatabaseHelper
                                                        .columnApplicationNumber] ??
                                                    ''),
                                            _buildInfoRow(
                                                'Patent Number',
                                                selectedLandProperty![
                                                        DatabaseHelper
                                                            .columnPatentNumber] ??
                                                    ''),
                                            _buildInfoRow(
                                                'Serial Number',
                                                selectedLandProperty![
                                                        DatabaseHelper
                                                            .columnSerialNumber] ??
                                                    ''),
                                            const Divider(
                                                height: 5,
                                                thickness: 0.2,
                                                color: Colors.white54),
                                            const SizedBox(height: 10),
                                            const Text(
                                                'Date Recieved, Transmit and Return',
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontFamily: 'Gilroy',
                                                    fontSize: 15)),
                                            const SizedBox(height: 5),
                                            _buildInfoRow(
                                                'PLA Received ',
                                                selectedLandProperty![DatabaseHelper
                                                        .columnPlaReceivedDate] ??
                                                    ''),
                                            _buildInfoRow(
                                                'Transmitted to PENRO',
                                                selectedLandProperty![DatabaseHelper
                                                        .columnTplaToPenroTransmittedDate] ??
                                                    ''),
                                            _buildInfoRow(
                                                'Return From PENRO',
                                                selectedLandProperty![DatabaseHelper
                                                        .columnReturnFromPenro] ??
                                                    ''),
                                            const SizedBox(height: 5),
                                            const Divider(
                                                height: 5,
                                                thickness: 0.2,
                                                color: Colors.white54),
                                            _buildInfoRow(
                                                'ROD Received Date',
                                                selectedLandProperty![DatabaseHelper
                                                        .columnRodReceivedDate] ??
                                                    ''),
                                            const Divider(
                                                height: 5,
                                                thickness: 0.2,
                                                color: Colors.white54),
                                            _buildInfoRow(
                                                'Date Applied/Received',
                                                selectedLandProperty![DatabaseHelper
                                                        .columnDateAppliedReceived] ??
                                                    ''),
                                            _buildInfoRow(
                                                'Date Approved',
                                                selectedLandProperty![
                                                        DatabaseHelper
                                                            .columnDateApproved] ??
                                                    ''),
                                            _buildInfoRow(
                                                'Name of Investigator',
                                                selectedLandProperty![DatabaseHelper
                                                        .columnLandInvestigator] ??
                                                    ''),
                                          ],
                                        ),
                                        if (isRefreshing)
                                          AnimatedOpacity(
                                            opacity: isRefreshing ? 1.0 : 0.0,
                                            duration:
                                                const Duration(seconds: 2),
                                            child:
                                                const CircularProgressIndicator(
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                                Color>(
                                                            Color.fromARGB(255,
                                                                13, 136, 69)),
                                                    strokeWidth: 4),
                                          ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                color: Color.fromARGB(255, 13, 136, 69),
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Gilroy')),
        const Divider(
            color: Color.fromARGB(255, 13, 136, 69),
            thickness: 0.5,
            height: 16),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 2,
              child: Text(label,
                  style: const TextStyle(
                      color: Colors.grey, fontSize: 13, fontFamily: 'Gilroy'))),
          Expanded(
              flex: 3,
              child: Text(value,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontFamily: 'Gilroy'))),
        ],
      ),
    );
  }

  Widget _buildLotNumberRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 1,
              child: Text(label,
                  style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontFamily: 'Gilroy'))),
          Expanded(
              flex: 3,
              child: Text(value,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 45, 114, 255),
                      fontSize: 18,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.end)),
        ],
      ),
    );
  }

  Widget _buildTotalClientsLabel() {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Text('Total Clients: ${_groupedClients.length}',
            style: const TextStyle(
                color: Colors.white24, fontSize: 10, fontFamily: 'Gilroy')),
      ),
    );
  }
}
