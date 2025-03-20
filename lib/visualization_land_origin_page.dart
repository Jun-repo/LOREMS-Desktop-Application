// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import 'package:giccenroquezon/database_helper.dart';

class VisualizationLandOriginPage extends StatefulWidget {
  final Function(String)? onSearch;
  final String? initialQuery;
  const VisualizationLandOriginPage(
      {super.key, this.onSearch, this.initialQuery});

  @override
  VisualizationLandOriginPageState createState() =>
      VisualizationLandOriginPageState();
}

class VisualizationLandOriginPageState
    extends State<VisualizationLandOriginPage> {
  Graph graph = Graph()..isTree = true; // Mutable graph instance
  final BuchheimWalkerConfiguration builderConfig =
      BuchheimWalkerConfiguration();
  final TextEditingController _searchController = TextEditingController();

  // We no longer need "expanded" and "subdivisions" since we fetch the full tree.
  String? selectedLot;
  Map<String, dynamic>? searchedLand;
  Map<String, dynamic>? parentLand; // Immediate parent chain (if any)
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _configureGraphLayout();
    // Trigger search if an initial query is provided
    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      _fetchLandData(widget.initialQuery!);
    }
  }

  /// Configure the tree layout.
  void _configureGraphLayout() {
    builderConfig
      ..siblingSeparation = 20
      ..levelSeparation = 30
      ..subtreeSeparation = 20
      ..orientation = BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM;
  }

  /// Fetch the searched land property using a query (by lot number or client name).
  Future<void> _fetchLandData(String query) async {
    setState(() {
      isLoading = true;
      graph = Graph()..isTree = true; // Reset graph
      searchedLand = null;
      parentLand = null;
    });

    final db = await DatabaseHelper.instance.database;

    // Fetch the searched land property using aliases for keys.
    final searchResult = await db.rawQuery('''
      SELECT 
        lp.${DatabaseHelper.columnLandPropertyId} AS landPropertyId,
        lp.${DatabaseHelper.columnLotNumber} AS lotNumber,
        lp.${DatabaseHelper.columnAreaSqm} AS areaSqm,
        lp.${DatabaseHelper.columnParentLandPropertyId} AS parentId,
        c.${DatabaseHelper.columnApplicantFirstname} AS firstName,
        c.${DatabaseHelper.columnApplicantLastname} AS lastName
      FROM ${DatabaseHelper.tableLandProperty} lp
      LEFT JOIN ${DatabaseHelper.tableClients} c 
        ON lp.${DatabaseHelper.columnClientIdRef} = c.${DatabaseHelper.columnClientId}
      WHERE lp.${DatabaseHelper.columnLotNumber} LIKE ? 
         OR c.${DatabaseHelper.columnApplicantFirstname} LIKE ? 
         OR c.${DatabaseHelper.columnApplicantLastname} LIKE ?
    ''', ['%$query%', '%$query%', '%$query%']);

    if (searchResult.isNotEmpty) {
      // Create a mutable copy of the searched land.
      searchedLand = Map<String, dynamic>.from(searchResult.first);

      // If there is a parent, fetch its full ancestry (chain).
      if (searchedLand!['parentId'] != null) {
        parentLand = await _fetchParentLand(searchedLand!['parentId']);
      }

      // Build the complete tree starting at the top-most ancestor.
      Map<String, dynamic> root;
      if (parentLand != null) {
        root = _getRoot(parentLand!);
      } else {
        root = searchedLand!;
      }
      // Make a mutable copy and fetch all descendants recursively from the root.
      root = await _fetchFullTree(root);

      // Build the graph from the full tree.
      graph = Graph()..isTree = true;
      _buildGraphFromTree(root);
    }

    setState(() {
      isLoading = false;
    });
  }

  /// Recursively fetch the parent (origin) of a land property.
  Future<Map<String, dynamic>?> _fetchParentLand(dynamic parentId) async {
    final db = await DatabaseHelper.instance.database;
    final parentResult = await db.query(
      DatabaseHelper.tableLandProperty,
      where: '${DatabaseHelper.columnLandPropertyId} = ?',
      whereArgs: [parentId],
    );
    if (parentResult.isNotEmpty) {
      final parent = Map<String, dynamic>.from(parentResult.first);
      // Set the keys to match the aliases.
      parent['lotNumber'] = parent[DatabaseHelper.columnLotNumber];
      parent['areaSqm'] = parent[DatabaseHelper.columnAreaSqm];
      final parentOwnerResult = await db.query(
        DatabaseHelper.tableClients,
        where: '${DatabaseHelper.columnClientId} = ?',
        whereArgs: [parent[DatabaseHelper.columnClientIdRef]],
      );
      parent['firstName'] = parentOwnerResult.isNotEmpty
          ? parentOwnerResult.first[DatabaseHelper.columnApplicantFirstname]
          : null;
      parent['lastName'] = parentOwnerResult.isNotEmpty
          ? parentOwnerResult.first[DatabaseHelper.columnApplicantLastname]
          : null;
      // Recursively fetch the parent's parent if available.
      if (parent[DatabaseHelper.columnParentLandPropertyId] != null) {
        parent['origin'] = await _fetchParentLand(
            parent[DatabaseHelper.columnParentLandPropertyId]);
      }
      return parent;
    }
    return null;
  }

  /// Get the top-most ancestor from a chain.
  Map<String, dynamic> _getRoot(Map<String, dynamic> node) {
    Map<String, dynamic> current = node;
    while (current.containsKey('origin') && current['origin'] != null) {
      current = current['origin'];
    }
    return current;
  }

  /// Recursively fetch all descendants for a given node and attach them in 'children'.
  /// Returns a mutable copy of the node.
  Future<Map<String, dynamic>> _fetchFullTree(Map<String, dynamic> node) async {
    // Make a mutable copy of the node.
    node = Map<String, dynamic>.from(node);
    final db = await DatabaseHelper.instance.database;
    final childrenResult = await db.query(
      DatabaseHelper.tableLandProperty,
      where: '${DatabaseHelper.columnParentLandPropertyId} = ?',
      whereArgs: [node[DatabaseHelper.columnLandPropertyId]],
    );

    List<Map<String, dynamic>> children = [];
    for (var child in childrenResult) {
      // Convert child map to use aliases.
      final childMap = Map<String, dynamic>.from(child);
      childMap['lotNumber'] = childMap[DatabaseHelper.columnLotNumber];
      childMap['areaSqm'] = childMap[DatabaseHelper.columnAreaSqm];

      final clientResult = await db.query(
        DatabaseHelper.tableClients,
        where: '${DatabaseHelper.columnClientId} = ?',
        whereArgs: [childMap[DatabaseHelper.columnClientIdRef]],
      );
      childMap['firstName'] = clientResult.isNotEmpty
          ? clientResult.first[DatabaseHelper.columnApplicantFirstname]
          : null;
      childMap['lastName'] = clientResult.isNotEmpty
          ? clientResult.first[DatabaseHelper.columnApplicantLastname]
          : null;

      // Recursively fetch descendants for this child.
      final fullChild = await _fetchFullTree(childMap);
      children.add(fullChild);
    }
    // Add children to the mutable node.
    node['children'] = children;
    return node;
  }

  /// Build a styled, clickable card widget for each node.
  /// The [highlight] parameter, if true, changes the card's appearance.
  /// The [parentLot] parameter, if provided, displays the parent's lot number.
  Widget _buildCard(String lotNumber, String area, String owner,
      {bool highlight = false, String? parentLot}) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedLot = lotNumber;
          // Optionally, perform an action when the card is tapped.
        });
      },
      child: Card(
        color: highlight
            ? const Color.fromARGB(255, 26, 26, 26)
            : const Color.fromARGB(255, 48, 48, 51),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: highlight
                ? Colors.green
                : const Color.fromARGB(255, 60, 60, 63),
            width: 1.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Lot No: $lotNumber",
                style: const TextStyle(color: Colors.white70, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              if (parentLot != null)
                Text(
                  "Parent Lot: $parentLot",
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              Text(
                "Area: $area sqm",
                style: const TextStyle(color: Colors.white70, fontSize: 12),
                textAlign: TextAlign.center,
              ),
              Text(
                "Owner: $owner",
                style: const TextStyle(color: Colors.white70, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Recursively build the graph from the full tree structure.
  /// The optional [parentLot] parameter is passed to child nodes.
  Node _buildGraphFromTree(Map<String, dynamic> nodeData, {String? parentLot}) {
    final owner =
        "${nodeData['firstName'] ?? ''} ${nodeData['lastName'] ?? ''}".trim();
    // Determine if this node is the searched land by comparing its ID.
    bool highlight = false;
    var currentId = nodeData['landPropertyId'] ??
        nodeData[DatabaseHelper.columnLandPropertyId];
    if (searchedLand != null && currentId == searchedLand!['landPropertyId']) {
      highlight = true;
    }
    // Build the current card, passing the parent's lot if provided.
    final currentGraphNode = Node(
      _buildCard(
        nodeData['lotNumber'] as String,
        nodeData['areaSqm']?.toString() ?? 'Unknown',
        owner.isEmpty ? "Unknown" : owner,
        highlight: highlight,
        parentLot: parentLot,
      ),
    );
    // Always add the current node to the graph.
    graph.addNode(currentGraphNode);
    // Process children recursively, passing the current node's lot number as their parent.
    if (nodeData.containsKey('children') && nodeData['children'] is List) {
      for (var child in nodeData['children'] as List) {
        final childGraphNode = _buildGraphFromTree(child,
            parentLot: nodeData['lotNumber'] as String);
        graph.addEdge(currentGraphNode, childGraphNode);
      }
    }
    return currentGraphNode;
  }

  /// Node builder for GraphView.
  Widget _nodeBuilder(Node node) {
    return node.key as Widget;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          "Visual Land Origin",
          style: TextStyle(
              color: Colors.white, fontSize: 14, fontFamily: 'Gilroy'),
        ),
        backgroundColor: const Color.fromARGB(255, 24, 24, 27),
      ),
      body: Container(
        color: const Color.fromARGB(255, 24, 24, 27),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 250,
                    height: 40,
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "Search by name or lot number...",
                        hintStyle: const TextStyle(
                            color: Colors.white54,
                            fontSize: 14,
                            fontFamily: 'Gilroy'),
                        prefixIcon: const Icon(Icons.search_outlined,
                            color: Color.fromARGB(255, 232, 232, 234),
                            size: 18),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 48, 48, 51),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Gilroy'),
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          _fetchLandData(value);
                          widget.onSearch?.call(value);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 48, 48, 51),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: IconButton(
                        icon: const Icon(Icons.search,
                            color: Color.fromARGB(255, 232, 232, 234),
                            size: 18),
                        tooltip: 'Search',
                        onPressed: () {
                          final query = _searchController.text;
                          if (query.isNotEmpty) {
                            _fetchLandData(query);
                            widget.onSearch?.call(query);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : (searchedLand == null || graph.nodes.isEmpty)
                      ? const Center(
                          child: Text(
                            "No nodes to display.",
                            style: TextStyle(color: Colors.white70),
                          ),
                        )
                      : InteractiveViewer(
                          constrained: false,
                          boundaryMargin: const EdgeInsets.all(20),
                          minScale: 0.01,
                          maxScale: 10.0,
                          child: GraphView(
                            graph: graph,
                            algorithm: BuchheimWalkerAlgorithm(
                                builderConfig, TreeEdgeRenderer(builderConfig)),
                            builder: _nodeBuilder,
                            paint: Paint()
                              ..color = Colors.blueAccent
                              ..strokeWidth = 0.7
                              ..style = PaintingStyle.stroke,
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
