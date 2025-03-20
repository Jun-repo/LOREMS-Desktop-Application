import 'package:flutter/material.dart';

class FieldSelectionDialog extends StatefulWidget {
  final List<Map<String, String>> availableFields;
  final Set<String> initialSelection;

  const FieldSelectionDialog({
    super.key,
    required this.availableFields,
    required this.initialSelection,
  });

  @override
  State<FieldSelectionDialog> createState() => _FieldSelectionDialogState();
}

class _FieldSelectionDialogState extends State<FieldSelectionDialog> {
  late Set<String> _selectedKeys;

  @override
  void initState() {
    super.initState();
    _selectedKeys = Set.from(widget.initialSelection);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select fields to print'),
      content: SizedBox(
        width: double.maxFinite,
        child: GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          children: widget.availableFields.map((field) {
            final key = field['key']!;
            final isSelected = _selectedKeys.contains(key);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedKeys.remove(key);
                  } else {
                    _selectedKeys.add(key);
                  }
                });
              },
              child: Card(
                color: isSelected ? Colors.blue.shade100 : Colors.white,
                child: Center(
                  child: Text(
                    field['header']!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(_selectedKeys);
          },
          child: const Text('Proceed'),
        ),
      ],
    );
  }
}
