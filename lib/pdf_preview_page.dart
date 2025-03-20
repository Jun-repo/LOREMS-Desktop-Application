import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:giccenroquezon/components/appbar_printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:reorderables/reorderables.dart';

class PdfPreviewPage extends StatefulWidget {
  final Map<int, Map<String, dynamic>>
      clientData; // Updated to match DatabaseHelper output

  const PdfPreviewPage({
    super.key,
    required this.clientData,
  });

  @override
  State<PdfPreviewPage> createState() => _PdfPreviewPageState();
}

class _PdfPreviewPageState extends State<PdfPreviewPage> {
  // Updated available fields to match DatabaseHelper columns
  final List<Map<String, String>> availableFields = [
    // Client fields
    {'key': 'applicant_firstname', 'header': 'First Name'},
    {'key': 'applicant_middlename', 'header': 'Middle Name'},
    {'key': 'applicant_lastname', 'header': 'Last Name'},
    {'key': 'applicant_suffix', 'header': 'Suffix'},
    {'key': 'applicant_maidenname', 'header': 'Maiden Name'},
    {'key': 'gender', 'header': 'Gender'},
    {'key': 'birth_date', 'header': 'Birth Date'},
    {'key': 'status', 'header': 'Status'},
    {'key': 'spouse', 'header': 'Spouse'},
    {'key': 'applicant_address', 'header': 'Sitio Address'},
    {'key': 'barangay_address', 'header': 'Barangay Address'},
    {'key': 'municipality_address', 'header': 'Municipality Address'},
    // Land Property fields
    {'key': 'lot_number', 'header': 'Lot Number'},
    {'key': 'identical_number', 'header': 'Identical Number'},
    {'key': 'survey_claimant', 'header': 'Survey Claimant'},
    {'key': 'area_sqm', 'header': 'Area (sqm)'},
    {'key': 'sitio', 'header': 'Sitio'},
    {'key': 'property_barangay', 'header': 'Property Barangay'},
    {'key': 'property_municipality', 'header': 'Property Municipality'},
    {'key': 'remarks', 'header': 'Remarks'},
    {'key': 'application_number', 'header': 'Application Number'},
    {'key': 'patent_number', 'header': 'Patent Number'},
    {'key': 'bundle_number', 'header': 'Bundle Number'},
    {'key': 'lot_status', 'header': 'Lot Status'},
    {'key': 'pla_received_date', 'header': 'PLA Received Date'},
    {
      'key': 'tpla_to_penro_transmitted_date',
      'header': 'TPLA Transmitted Date'
    },
    {'key': 'return_from_penro', 'header': 'Return from PENRO'},
    {'key': 'rod_received_date', 'header': 'ROD Received Date'},
    {'key': 'date_applied_received', 'header': 'Date Applied Received'},
    {'key': 'date_approved', 'header': 'Date Approved'},
    {'key': 'serial_number', 'header': 'Serial Number'},
    {'key': 'land_investigator', 'header': 'Land Investigator'},
  ];

  final List<String> _selectedKeysOrdered = [];

  Future<Uint8List> _generatePdf(PdfPageFormat format) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);

    if (_selectedKeysOrdered.length < 2) {
      pdf.addPage(
        pw.Page(
          pageFormat: format,
          margin: const pw.EdgeInsets.all(0),
          build: (pw.Context context) {
            return pw.FullPage(
              ignoreMargins: true,
              child: pw.Center(
                child: pw.Text(
                  "Select at least 2 fields to preview the PDF.",
                  style: const pw.TextStyle(color: PdfColors.black),
                ),
              ),
            );
          },
        ),
      );
      return pdf.save();
    }

    final tnrData = await rootBundle.load('assets/fonts/times new roman.ttf');
    final timesNewRoman = pw.Font.ttf(tnrData);
    final tnrDataBold =
        await rootBundle.load('assets/fonts/times new roman bold.ttf');
    final timesNewRomanBold = pw.Font.ttf(tnrDataBold);

    final headerImageData =
        await rootBundle.load('assets/icons/denr-logo.webp');
    final headerImage = pw.MemoryImage(headerImageData.buffer.asUint8List());

    final List<String> headers = _selectedKeysOrdered.map((key) {
      final field = availableFields.firstWhere((f) => f['key'] == key);
      return field['header']!;
    }).toList();

    // Build table data considering client and land properties relationship
    List<List<String>> dataRows = [];
    widget.clientData.forEach((clientId, clientRecord) {
      final client = clientRecord['client'];
      final landProperties = clientRecord['land_properties'] as List<dynamic>;

      if (landProperties.isEmpty) {
        // Add client row without land properties
        List<String> row = [];
        for (var key in _selectedKeysOrdered) {
          row.add(client[key]?.toString() ?? '');
        }
        dataRows.add(row);
      } else {
        // Add a row for each land property
        for (var property in landProperties) {
          List<String> row = [];
          for (var key in _selectedKeysOrdered) {
            if (client.containsKey(key)) {
              row.add(client[key]?.toString() ?? '');
            } else if (property.containsKey(key)) {
              row.add(property[key]?.toString() ?? '');
            } else {
              row.add('');
            }
          }
          dataRows.add(row);
        }
      }
    });

    final int count = _selectedKeysOrdered.length;
    double headerFontSize = count <= 4
        ? 12
        : count <= 6
            ? 10
            : count <= 8
                ? 7
                : 5;
    double dataFontSize = count <= 4
        ? 12
        : count <= 6
            ? 10
            : count <= 8
                ? 7
                : 5;

    pdf.addPage(
      pw.MultiPage(
        // Changed to MultiPage to handle multiple rows
        pageFormat: format,
        margin: const pw.EdgeInsets.all(40),
        header: (context) => pw.Column(
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Image(headerImage, width: 70, height: 70),
                pw.Expanded(
                  child: pw.Align(
                    alignment: pw.Alignment.center,
                    child: pw.Column(
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.Text('Republic of the Philippines',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                                font: timesNewRoman, fontSize: 10)),
                        pw.Text(
                            'Department of Environment and Natural Resources',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                                font: timesNewRoman, fontSize: 10)),
                        pw.Text('MIMAROPA Region',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                                font: timesNewRoman, fontSize: 10)),
                        pw.Text(
                            'COMMUNITY ENVIRONMENT AND NATURAL RESOURCES OFFICE',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                                font: timesNewRomanBold,
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold)),
                        pw.Text(
                            'National Highway, Bgy. Alfonxo XIII, Quezon, Palawan',
                            textAlign: pw.TextAlign.center,
                            style: const pw.TextStyle(fontSize: 8)),
                        pw.Text('Contact No: 0917-160-4920',
                            textAlign: pw.TextAlign.center,
                            style: const pw.TextStyle(fontSize: 8)),
                        pw.RichText(
                          textAlign: pw.TextAlign.center,
                          text: pw.TextSpan(
                            children: [
                              pw.TextSpan(
                                  text: 'Email: ',
                                  style: pw.TextStyle(
                                      font: timesNewRoman, fontSize: 8)),
                              pw.TextSpan(
                                  text: 'cenroquezon@denr.gov.ph',
                                  style: pw.TextStyle(
                                      font: timesNewRoman,
                                      fontSize: 8,
                                      color: PdfColors.blue900)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Divider(thickness: 3, color: PdfColors.green),
            pw.SizedBox(height: 10),
          ],
        ),
        build: (context) => [
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.black, width: 0.2),
            children: [
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.green),
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(
                        horizontal: 0, vertical: 8),
                    child: pw.Text('No.',
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: headerFontSize,
                            color: PdfColors.white)),
                  ),
                  ...headers.map((header) => pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(header,
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: headerFontSize,
                                color: PdfColors.white)),
                      )),
                ],
              ),
              ...dataRows.asMap().entries.map((entry) => pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('${entry.key + 1}',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(fontSize: dataFontSize)),
                      ),
                      ...entry.value.map((cell) => pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(cell,
                                textAlign: pw.TextAlign.center,
                                style: pw.TextStyle(fontSize: dataFontSize)),
                          )),
                    ],
                  )),
            ],
          ),
        ],
      ),
    );

    return pdf.save();
  }

  void _toggleField(String fieldKey) {
    setState(() {
      if (_selectedKeysOrdered.contains(fieldKey)) {
        _selectedKeysOrdered.remove(fieldKey);
      } else if (_selectedKeysOrdered.length < 10) {
        _selectedKeysOrdered.add(fieldKey);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("You can select a maximum of 10 fields.")),
        );
      }
    });
  }

  Widget _buildFieldSelectionPanel() {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(8.0),
      color: const Color.fromARGB(255, 38, 38, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Selected Fields',
              style: TextStyle(
                  fontFamily: 'Gilroy',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white38)),
          const SizedBox(height: 8),
          Container(
            height: 150,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white60, width: 0.7),
                borderRadius: BorderRadius.circular(4)),
            child: _selectedKeysOrdered.isNotEmpty
                ? ReorderableWrap(
                    spacing: 8,
                    runSpacing: 8,
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        final item = _selectedKeysOrdered.removeAt(oldIndex);
                        _selectedKeysOrdered.insert(newIndex, item);
                      });
                    },
                    children: _selectedKeysOrdered.map((selectedKey) {
                      final field = availableFields
                          .firstWhere((f) => f['key'] == selectedKey);
                      return Chip(
                        key: ValueKey(selectedKey),
                        label: Text(field['header']!,
                            style: const TextStyle(
                                fontFamily: 'Gilroy',
                                color: Colors.white,
                                fontSize: 10)),
                        backgroundColor: Colors.blue.shade700,
                        shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                color: Colors.white38, width: 0.5),
                            borderRadius: BorderRadius.circular(2)),
                      );
                    }).toList(),
                  )
                : const Center(
                    child: Text('No fields selected',
                        style: TextStyle(
                            fontFamily: 'Gilroy', color: Colors.white70))),
          ),
          const SizedBox(height: 16),
          const Text('Available Fields',
              style: TextStyle(
                  fontFamily: 'Gilroy',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white38)),
          const SizedBox(height: 8),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 3,
              children: availableFields.map((field) {
                final fieldKey = field['key']!;
                final isSelected = _selectedKeysOrdered.contains(fieldKey);
                return GestureDetector(
                  onTap: () => _toggleField(fieldKey),
                  child: Card(
                    color: isSelected
                        ? const Color.fromARGB(255, 13, 136, 69)
                        : Colors.transparent,
                    shape: RoundedRectangleBorder(
                        side:
                            const BorderSide(color: Colors.white38, width: 0.5),
                        borderRadius: BorderRadius.circular(2)),
                    child: Center(
                      child: Text(field['header']!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Gilroy',
                              fontSize: 12,
                              color: Colors.white70,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal)),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppbarPrinting(title: 'Printing'),
      body: Row(
        children: [
          _buildFieldSelectionPanel(),
          const VerticalDivider(width: 1),
          Expanded(
            child: Container(
              color: const Color.fromARGB(255, 38, 38, 40),
              child: Theme(
                data: Theme.of(context).copyWith(
                  scaffoldBackgroundColor:
                      const Color.fromARGB(255, 38, 38, 40),
                  canvasColor: const Color.fromARGB(255, 38, 38, 40),
                  appBarTheme: const AppBarTheme(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white),
                ),
                child: PdfPreview(
                  key: ValueKey(_selectedKeysOrdered.join(',')),
                  build: (format) => _generatePdf(format),
                  pageFormats: const {
                    'A4': PdfPageFormat.a4,
                    'Letter': PdfPageFormat.letter,
                    'Legal': PdfPageFormat.legal
                  },
                  pdfPreviewPageDecoration: const BoxDecoration(
                      color: Color.fromARGB(255, 245, 245, 255)),
                  actionBarTheme: const PdfActionBarTheme(
                      backgroundColor: Color.fromARGB(255, 26, 26, 28)),
                  initialPageFormat: PdfPageFormat.legal,
                  allowSharing: true,
                  allowPrinting: true,
                  canChangePageFormat: true,
                  canDebug: false,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
