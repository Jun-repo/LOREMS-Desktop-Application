import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:giccenroquezon/components/appbar_printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:reorderables/reorderables.dart';

class PrintClientNarrativePage extends StatefulWidget {
  final Map<String, dynamic> client;
  final List<Map<String, dynamic>> landProperties;

  const PrintClientNarrativePage({
    super.key,
    required this.client,
    required this.landProperties,
  });

  static Future<void> navigate(
    BuildContext context,
    Map<String, dynamic> client,
    List<Map<String, dynamic>> landProperties,
  ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PrintClientNarrativePage(
            client: client, landProperties: landProperties),
      ),
    );
  }

  @override
  PrintClientNarrativePageState createState() =>
      PrintClientNarrativePageState();
}

class PrintClientNarrativePageState extends State<PrintClientNarrativePage> {
  late List<bool> _selectedLandProperties;
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, String>> availableLandColumns = [
    {'key': 'lot_number', 'header': 'Lot Number'},
    {'key': 'identical_number', 'header': 'Identical Number'},
    {'key': 'survey_claimant', 'header': 'Survey Claimant'},
    {'key': 'area_sqm', 'header': 'Area (sqm)'},
    {'key': 'sitio', 'header': 'Sitio'},
    {'key': 'property_barangay', 'header': 'Property Barangay'},
    {'key': 'property_municipality', 'header': 'Property Municipality'},
    {'key': 'remarks', 'header': 'Remarks'},
    {'key': 'lot_status', 'header': 'Lot Status'},
    {'key': 'bundle_number', 'header': 'Bundle Number'},
    {'key': 'application_number', 'header': 'Application Number'},
    {'key': 'patent_number', 'header': 'Patent Number'},
    {'key': 'serial_number', 'header': 'Serial Number'},
    {'key': 'pla_received_date', 'header': 'PLA Received Date'},
    {'key': 'tpla_to_penro_transmitted_date', 'header': 'Transmitted to PENRO'},
    {'key': 'return_from_penro', 'header': 'Return From PENRO'},
    {'key': 'rod_received_date', 'header': 'ROD Received Date'},
    {'key': 'date_applied_received', 'header': 'Date Applied/Received'},
    {'key': 'date_approved', 'header': 'Date Approved'},
    {'key': 'land_investigator', 'header': 'Land Investigator'},
  ];

  late List<String> _selectedLandColumnsOrdered;

  @override
  void initState() {
    super.initState();
    _selectedLandProperties =
        List<bool>.generate(widget.landProperties.length, (index) => true);
    _selectedLandColumnsOrdered = [
      'lot_number',
      'survey_claimant',
      'area_sqm',
      'lot_status',
      'application_number'
    ];
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleColumn(String columnKey) {
    setState(() {
      if (_selectedLandColumnsOrdered.contains(columnKey)) {
        if (_selectedLandColumnsOrdered.length > 2) {
          _selectedLandColumnsOrdered.remove(columnKey);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("At least 2 columns must be selected.")));
        }
      } else {
        if (_selectedLandColumnsOrdered.length < 6) {
          _selectedLandColumnsOrdered.add(columnKey);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("You can select a maximum of 6 columns.")));
        }
      }
    });
  }

  Widget _buildColumnSelectionPanel() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Colors.grey[850],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Selected Columns',
              style: TextStyle(
                  fontFamily: 'Gilroy',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70)),
          const SizedBox(height: 8),
          _selectedLandColumnsOrdered.isNotEmpty
              ? ReorderableWrap(
                  spacing: 8,
                  runSpacing: 8,
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      final item =
                          _selectedLandColumnsOrdered.removeAt(oldIndex);
                      _selectedLandColumnsOrdered.insert(newIndex, item);
                    });
                  },
                  children: _selectedLandColumnsOrdered.map((selectedKey) {
                    final col = availableLandColumns
                        .firstWhere((f) => f['key'] == selectedKey);
                    return Chip(
                      key: ValueKey(selectedKey),
                      label: Text(col['header']!,
                          style: const TextStyle(
                              fontFamily: 'Gilroy',
                              color: Colors.white,
                              fontSize: 10)),
                      backgroundColor: Colors.blue.shade700,
                      onDeleted: () => _toggleColumn(selectedKey),
                    );
                  }).toList(),
                )
              : const Center(
                  child: Text('No columns selected',
                      style: TextStyle(
                          fontFamily: 'Gilroy', color: Colors.white70))),
          const SizedBox(height: 16),
          const Text('Available Columns',
              style: TextStyle(
                  fontFamily: 'Gilroy',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70)),
          const SizedBox(height: 8),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 3,
            children: availableLandColumns.map((field) {
              final fieldKey = field['key']!;
              final isSelected = _selectedLandColumnsOrdered.contains(fieldKey);
              return GestureDetector(
                onTap: () => _toggleColumn(fieldKey),
                child: Card(
                  color: isSelected
                      ? const Color.fromARGB(255, 13, 136, 69)
                      : Colors.transparent,
                  shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.white38, width: 0.5),
                      borderRadius: BorderRadius.circular(2)),
                  child: Center(
                    child: Text(field['header']!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Gilroy',
                            fontSize: 12,
                            color: isSelected ? Colors.white : Colors.white70,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal)),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Future<Uint8List> _generateNarrativePdf(PdfPageFormat format) async {
    final pdf = pw.Document();
    final headerImageData =
        await rootBundle.load('assets/icons/denr-logo.webp');
    final headerImage = pw.MemoryImage(headerImageData.buffer.asUint8List());

    final client = widget.client;
    final totalLandArea =
        widget.landProperties.fold<double>(0, (sum, property) {
      final area = property['area_sqm'];
      double areaValue = 0;
      if (area is num) {
        areaValue = area.toDouble();
      } else {
        areaValue = double.tryParse(area.toString()) ?? 0;
      }
      return sum + areaValue;
    });

    final clientInfoWidget = pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.SizedBox(height: 10),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.RichText(
                      text: pw.TextSpan(children: [
                    pw.TextSpan(
                        text: "Name: ",
                        style: pw.TextStyle(
                            fontSize: 12, fontWeight: pw.FontWeight.bold)),
                    pw.TextSpan(
                        text:
                            "${client['applicant_firstname'] ?? ''} ${client['applicant_middlename'] ?? ''} ${client['applicant_lastname'] ?? ''} ${client['applicant_suffix'] ?? ''}",
                        style: const pw.TextStyle(fontSize: 12))
                  ])),
                  if ((client['gender']?.toString().toLowerCase() ?? '') !=
                      'male')
                    pw.RichText(
                        text: pw.TextSpan(children: [
                      pw.TextSpan(
                          text: "Maiden Name: ",
                          style: pw.TextStyle(
                              fontSize: 12, fontWeight: pw.FontWeight.bold)),
                      pw.TextSpan(
                          text: client['applicant_maidenname'] ?? '',
                          style: const pw.TextStyle(fontSize: 12))
                    ])),
                  pw.RichText(
                      text: pw.TextSpan(children: [
                    pw.TextSpan(
                        text: "Spouse: ",
                        style: pw.TextStyle(
                            fontSize: 12, fontWeight: pw.FontWeight.bold)),
                    pw.TextSpan(
                        text: client['spouse'] ?? '',
                        style: const pw.TextStyle(fontSize: 12))
                  ])),
                  pw.RichText(
                      text: pw.TextSpan(children: [
                    pw.TextSpan(
                        text: "Gender: ",
                        style: pw.TextStyle(
                            fontSize: 12, fontWeight: pw.FontWeight.bold)),
                    pw.TextSpan(
                        text: client['gender'] ?? '',
                        style: const pw.TextStyle(fontSize: 12))
                  ])),
                  pw.RichText(
                      text: pw.TextSpan(children: [
                    pw.TextSpan(
                        text: "Birth Date: ",
                        style: pw.TextStyle(
                            fontSize: 12, fontWeight: pw.FontWeight.bold)),
                    pw.TextSpan(
                        text: client['birth_date'] ?? '',
                        style: const pw.TextStyle(fontSize: 12))
                  ])),
                  pw.RichText(
                      text: pw.TextSpan(children: [
                    pw.TextSpan(
                        text: "Status: ",
                        style: pw.TextStyle(
                            fontSize: 12, fontWeight: pw.FontWeight.bold)),
                    pw.TextSpan(
                        text: client['status'] ?? '',
                        style: const pw.TextStyle(fontSize: 12))
                  ])),
                ],
              ),
            ),
            pw.SizedBox(width: 170),
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.RichText(
                      text: pw.TextSpan(children: [
                    pw.TextSpan(
                        text: "Sitio: ",
                        style: pw.TextStyle(
                            fontSize: 12, fontWeight: pw.FontWeight.bold)),
                    pw.TextSpan(
                        text: client['sitio_address'] ?? '',
                        style: const pw.TextStyle(fontSize: 12))
                  ])),
                  pw.RichText(
                      text: pw.TextSpan(children: [
                    pw.TextSpan(
                        text: "Barangay: ",
                        style: pw.TextStyle(
                            fontSize: 12, fontWeight: pw.FontWeight.bold)),
                    pw.TextSpan(
                        text: client['barangay_address'] ?? '',
                        style: const pw.TextStyle(fontSize: 12))
                  ])),
                  pw.RichText(
                      text: pw.TextSpan(children: [
                    pw.TextSpan(
                        text: "Municipality: ",
                        style: pw.TextStyle(
                            fontSize: 12, fontWeight: pw.FontWeight.bold)),
                    pw.TextSpan(
                        text: client['municipality_address'] ?? '',
                        style: const pw.TextStyle(fontSize: 12))
                  ])),
                  pw.SizedBox(height: 10),
                  pw.RichText(
                      text: pw.TextSpan(children: [
                    pw.TextSpan(
                        text: "Total Land: ",
                        style: pw.TextStyle(
                            fontSize: 12, fontWeight: pw.FontWeight.bold)),
                    pw.TextSpan(
                        text: totalLandArea.toStringAsFixed(2),
                        style: const pw.TextStyle(fontSize: 12))
                  ])),
                ],
              ),
            ),
          ],
        ),
      ],
    );

    List<Map<String, dynamic>> selectedProperties = [];
    for (int i = 0; i < widget.landProperties.length; i++) {
      if (_selectedLandProperties[i]) {
        selectedProperties.add(widget.landProperties[i]);
      }
    }

    List<String> columnKeys = List.from(_selectedLandColumnsOrdered);
    List<String> headers = columnKeys
        .map((key) => availableLandColumns.firstWhere((f) => f['key'] == key,
            orElse: () => {'header': key})['header']!)
        .toList();

    List<pw.TableRow> tableRows = [
      pw.TableRow(
        decoration: const pw.BoxDecoration(color: PdfColors.grey300),
        children: headers
            .map((header) => pw.Padding(
                padding: const pw.EdgeInsets.all(4),
                child: pw.Text(header,
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 10))))
            .toList(),
      ),
    ];

    for (var prop in selectedProperties) {
      tableRows.add(pw.TableRow(
          children: columnKeys
              .map((key) => pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text(prop[key]?.toString() ?? '',
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 10))))
              .toList()));
    }

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Image(headerImage, width: 70, height: 70),
                pw.Expanded(
                  child: pw.Column(
                    children: [
                      pw.Text('Republic of the Philippines',
                          style: const pw.TextStyle(fontSize: 10),
                          textAlign: pw.TextAlign.center),
                      pw.Text('Department of Environment and Natural Resources',
                          style: const pw.TextStyle(fontSize: 10),
                          textAlign: pw.TextAlign.center),
                      pw.Text('MIMAROPA Region',
                          style: const pw.TextStyle(fontSize: 10),
                          textAlign: pw.TextAlign.center),
                      pw.Text(
                          'COMMUNITY ENVIRONMENT AND NATURAL RESOURCES OFFICE',
                          style: pw.TextStyle(
                              fontSize: 10, fontWeight: pw.FontWeight.bold),
                          textAlign: pw.TextAlign.center),
                      pw.Text(
                          'National Highway, Bgy. Alfonxo XIII, Quezon, Palawan',
                          style: const pw.TextStyle(fontSize: 8),
                          textAlign: pw.TextAlign.center),
                      pw.Text('Contact No: 0917-160-4920',
                          style: const pw.TextStyle(fontSize: 8),
                          textAlign: pw.TextAlign.center),
                      pw.RichText(
                        textAlign: pw.TextAlign.center,
                        text: const pw.TextSpan(children: [
                          pw.TextSpan(
                              text: 'Email: ',
                              style: pw.TextStyle(fontSize: 8)),
                          pw.TextSpan(
                              text: 'cenroquezon@denr.gov.ph',
                              style: pw.TextStyle(
                                  fontSize: 8, color: PdfColors.blue)),
                        ]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Divider(thickness: 3, color: PdfColors.green),
            pw.SizedBox(height: 20),
            clientInfoWidget,
            pw.SizedBox(height: 50),
            pw.Text('Land Property Information',
                style:
                    pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Table(
                border: pw.TableBorder.all(color: PdfColors.black, width: 0.5),
                children: tableRows),
          ],
        ),
      ),
    );

    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppbarPrinting(title: 'Printing'),
      body: Row(
        children: [
          Container(
            width: 320,
            color: Colors.grey[900],
            child: Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              trackVisibility: true,
              thickness: 8.0,
              radius: const Radius.circular(4),
              scrollbarOrientation: ScrollbarOrientation.right,
              child: Theme(
                data: Theme.of(context).copyWith(
                  scrollbarTheme: ScrollbarThemeData(
                    thumbColor: WidgetStateProperty.all(
                      const Color.fromARGB(255, 13, 136, 69),
                    ),
                    trackColor: WidgetStateProperty.all(
                        const Color.fromARGB(255, 83, 83, 90)),
                  ),
                ),
                child: ListView(
                  controller: _scrollController,
                  children: [
                    _buildColumnSelectionPanel(),
                    const Divider(color: Colors.white38),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Select Land Properties',
                          style: TextStyle(
                              fontFamily: 'Gilroy',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white70)),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.landProperties.length,
                      itemBuilder: (context, index) {
                        final prop = widget.landProperties[index];
                        final lotNumber =
                            prop['lot_number'] ?? 'Lot ${index + 1}';
                        return CheckboxListTile(
                          title: Text(lotNumber,
                              style: const TextStyle(color: Colors.white)),
                          value: _selectedLandProperties[index],
                          activeColor: const Color.fromARGB(255, 13, 136, 69),
                          onChanged: (value) => setState(() =>
                              _selectedLandProperties[index] = value ?? false),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: PdfPreview(
              build: (format) => _generateNarrativePdf(format),
              pageFormats: const {
                'A4': PdfPageFormat.a4,
                'Letter': PdfPageFormat.letter,
                'Legal': PdfPageFormat.legal
              },
              pdfPreviewPageDecoration: const BoxDecoration(
                  color: Color.fromARGB(255, 245, 245, 255)),
              actionBarTheme: const PdfActionBarTheme(
                  backgroundColor: Color.fromARGB(255, 26, 26, 28)),
              initialPageFormat: PdfPageFormat.a4,
              allowSharing: true,
              allowPrinting: true,
              canChangePageFormat: true,
              canDebug: false,
            ),
          ),
        ],
      ),
    );
  }
}
