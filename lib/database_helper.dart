import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = "denr_cenroquezon.db";
  static const _databaseVersion = 2;

  // Custom path variable
  String? _customDatabasePath;

  // Constructor
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Setter for custom path
  void setCustomDatabasePath(String path) {
    _customDatabasePath = path;
  }

  // Get database path (custom or default)
  Future<String> getDatabasePath() async {
    if (_customDatabasePath != null) {
      return _customDatabasePath!;
    }
    // Fallback to default if no custom path is set
    final directory = await getApplicationDocumentsDirectory();
    return join(directory.path, _databaseName);
  }

  // Table names
  static const tableAdmin = 'admin';
  static const tableClients = 'clients';
  static const tableLandProperty = 'land_property';

  // Admin table columns
  static const columnAdminId = 'id';
  static const columnAdminNames = 'names';
  static const columnAdminUsername = 'username';
  static const columnAdminPassword = 'password';
  static const columnAdminPositions = 'positions';

  // Clients table columns
  static const columnClientId = 'id';
  static const columnApplicantFirstname = 'applicant_firstname';
  static const columnApplicantMiddlename = 'applicant_middlename';
  static const columnApplicantLastname = 'applicant_lastname';
  static const columnApplicantSuffix = 'applicant_suffix';
  static const columnApplicantMaidenname = 'applicant_maidenname';
  static const columnGender = 'gender';
  static const columnBirthDate = 'birth_date';
  static const columnStatus = 'status';
  static const columnSpouse = 'spouse';
  static const columnSitioAddress = 'applicant_address';
  static const columnBarangayAddress = 'barangay_address';
  static const columnMunicipalityAddress = 'municipality_address';

  // Land property table columns
  static const columnLandPropertyId = 'id';
  static const columnClientIdRef = 'client_id';
  static const columnParentLandPropertyId = 'parent_land_property_id';
  static const columnLotNumber = 'lot_number';
  static const columnIdenticalNumber = 'identical_number';
  static const columnSurveyClaimant = 'survey_claimant';
  static const columnAreaSqm = 'area_sqm';
  static const columnSitio = 'sitio';
  static const columnPropertyBarangay = 'property_barangay';
  static const columnPropertyMunicipality = 'property_municipality';
  static const columnRemarks = 'remarks';
  static const columnApplicationNumber = 'application_number';
  static const columnPatentNumber = 'patent_number';
  static const columnBundleNumber = 'bundle_number';
  static const columnLotStatus = 'lot_status';
  static const columnPlaReceivedDate = 'pla_received_date';
  static const columnTplaToPenroTransmittedDate =
      'tpla_to_penro_transmitted_date';
  static const columnReturnFromPenro = 'return_from_penro';
  static const columnRodReceivedDate = 'rod_received_date';
  static const columnDateAppliedReceived = 'date_applied_received';
  static const columnDateApproved = 'date_approved';
  static const columnSerialNumber = 'serial_number';
  static const columnLandInvestigator = 'land_investigator';

  // Singleton instance
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = await getDatabasePath();
    if (kDebugMode) {
      print("Database path: $path");
    }
    bool dbExists = await File(path).exists();
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: dbExists ? null : _onCreate, // Only create if it doesn't exist
      onConfigure: _onConfigure,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableAdmin (
        $columnAdminId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnAdminNames TEXT NOT NULL,
        $columnAdminUsername TEXT UNIQUE NOT NULL,
        $columnAdminPassword TEXT NOT NULL,
        $columnAdminPositions TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableClients (
        $columnClientId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnApplicantFirstname TEXT,
        $columnApplicantMiddlename TEXT,
        $columnApplicantLastname TEXT,
        $columnApplicantSuffix TEXT,
        $columnApplicantMaidenname TEXT,
        $columnGender TEXT,
        $columnBirthDate TEXT,
        $columnStatus TEXT,
        $columnSpouse TEXT,
        $columnSitioAddress TEXT,
        $columnBarangayAddress TEXT,
        $columnMunicipalityAddress TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableLandProperty (
        $columnLandPropertyId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnClientIdRef INTEGER,
        $columnParentLandPropertyId INTEGER,
        $columnLotNumber TEXT,
        $columnIdenticalNumber TEXT,
        $columnSurveyClaimant TEXT,
        $columnAreaSqm REAL,
        $columnSitio TEXT,
        $columnPropertyBarangay TEXT,
        $columnPropertyMunicipality TEXT,
        $columnRemarks TEXT,
        $columnApplicationNumber TEXT,
        $columnPatentNumber TEXT,
        $columnBundleNumber TEXT,
        $columnLotStatus TEXT,
        $columnPlaReceivedDate TEXT,
        $columnTplaToPenroTransmittedDate TEXT,
        $columnReturnFromPenro TEXT,
        $columnRodReceivedDate TEXT,
        $columnDateAppliedReceived TEXT,
        $columnDateApproved TEXT,
        $columnSerialNumber TEXT,
        $columnLandInvestigator TEXT,
        FOREIGN KEY($columnClientIdRef) REFERENCES $tableClients($columnClientId) ON DELETE CASCADE,
        FOREIGN KEY($columnParentLandPropertyId) REFERENCES $tableLandProperty($columnLandPropertyId) ON DELETE CASCADE
      )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion == 1 && newVersion == 2) {
      await db.execute('''
        CREATE TABLE land_property_new (
          $columnLandPropertyId INTEGER PRIMARY KEY AUTOINCREMENT,
          $columnClientIdRef INTEGER,
          $columnParentLandPropertyId INTEGER,
          $columnLotNumber TEXT,
          $columnIdenticalNumber TEXT,
          $columnSurveyClaimant TEXT,
          $columnAreaSqm REAL,
          $columnSitio TEXT,
          $columnPropertyBarangay TEXT,
          $columnPropertyMunicipality TEXT,
          $columnRemarks TEXT,
          $columnApplicationNumber TEXT,
          $columnPatentNumber TEXT,
          $columnBundleNumber TEXT,
          $columnLotStatus TEXT,
          $columnPlaReceivedDate TEXT,
          $columnTplaToPenroTransmittedDate TEXT,
          $columnReturnFromPenro TEXT,
          $columnRodReceivedDate TEXT,
          $columnDateAppliedReceived TEXT,
          $columnDateApproved TEXT,
          $columnSerialNumber TEXT,
          $columnLandInvestigator TEXT,
          FOREIGN KEY($columnClientIdRef) REFERENCES $tableClients($columnClientId) ON DELETE CASCADE,
          FOREIGN KEY($columnParentLandPropertyId) REFERENCES land_property_new($columnLandPropertyId) ON DELETE CASCADE
        )
      ''');

      await db.execute('''
        INSERT INTO land_property_new (
          $columnLandPropertyId,
          $columnClientIdRef,
          $columnParentLandPropertyId,
          $columnLotNumber,
          $columnIdenticalNumber,
          $columnSurveyClaimant,
          $columnAreaSqm,
          $columnSitio,
          $columnPropertyBarangay,
          $columnPropertyMunicipality,
          $columnRemarks,
          $columnApplicationNumber,
          $columnPatentNumber,
          $columnBundleNumber,
          $columnLotStatus
        ) SELECT
          $columnLandPropertyId,
          $columnClientIdRef,
          $columnParentLandPropertyId,
          $columnLotNumber,
          $columnIdenticalNumber,
          $columnSurveyClaimant,
          $columnAreaSqm,
          $columnSitio,
          $columnPropertyBarangay,
          $columnPropertyMunicipality,
          $columnRemarks,
          $columnApplicationNumber,
          $columnPatentNumber,
          $columnBundleNumber,
          $columnLotStatus
        FROM $tableLandProperty
      ''');

      await db.execute('DROP TABLE $tableLandProperty');
      await db.execute(
          'ALTER TABLE land_property_new RENAME TO $tableLandProperty');
    }
  }

  Future<int> insertAdmin(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tableAdmin, row);
  }

  Future<List<Map<String, dynamic>>> queryAllAdmins() async {
    Database db = await instance.database;
    return await db.query(tableAdmin);
  }

  Future<int> insertClient(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tableClients, row);
  }

  Future<List<Map<String, dynamic>>> queryAllClients() async {
    Database db = await instance.database;
    return await db.query(tableClients);
  }

  Future<int> updateClient(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnClientId];
    return await db.update(
      tableClients,
      row,
      where: '$columnClientId = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteClient(int id) async {
    Database db = await instance.database;
    return await db.delete(
      tableClients,
      where: '$columnClientId = ?',
      whereArgs: [id],
    );
  }

  Future<int> insertLandProperty(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tableLandProperty, row);
  }

  Future<List<Map<String, dynamic>>> queryAllLandProperties() async {
    Database db = await instance.database;
    return await db.query(tableLandProperty);
  }

  Future<int> updateLandProperty(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnLandPropertyId];
    return await db.update(
      tableLandProperty,
      row,
      where: '$columnLandPropertyId = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteLandProperty(int id) async {
    Database db = await instance.database;
    final landProperty = await db.query(
      tableLandProperty,
      where: '$columnLandPropertyId = ?',
      whereArgs: [id],
    );

    if (landProperty.isEmpty) return 0;

    int clientId = landProperty.first[columnClientIdRef] as int;

    final remainingLands = await db.query(
      tableLandProperty,
      where: '$columnClientIdRef = ?',
      whereArgs: [clientId],
    );

    int rowsDeleted = await db.delete(
      tableLandProperty,
      where: '$columnLandPropertyId = ?',
      whereArgs: [id],
    );

    if (rowsDeleted > 0 && remainingLands.length == 1) {
      await deleteClient(clientId);
    }

    return rowsDeleted;
  }

  Future<void> addDefaultAdmin() async {
    final admins = await queryAllAdmins();
    if (admins.isEmpty) {
      final adminData = {
        columnAdminNames: "Administrator",
        columnAdminUsername: "admin",
        columnAdminPassword: "admin123",
        columnAdminPositions: "Manager",
      };
      await insertAdmin(adminData);
    }
  }

  Future<Map<String, dynamic>?> getLandPropertyById(int id) async {
    final db = await database;
    final maps = await db.query(
      tableLandProperty,
      where: '$columnLandPropertyId = ?',
      whereArgs: [id],
    );
    return maps.isNotEmpty ? maps.first : null;
  }

  Future<List<Map<String, dynamic>>> getChildLandProperties(
      int parentId) async {
    final db = await database;
    final maps = await db.query(
      tableLandProperty,
      where: '$columnParentLandPropertyId = ?',
      whereArgs: [parentId],
    );
    return maps;
  }

  Future<List<Map<String, dynamic>>> queryClientsWithLandProperties() async {
    Database db = await instance.database;
    return await db.rawQuery('''
      SELECT 
        c.$columnClientId,
        c.$columnApplicantFirstname,
        c.$columnApplicantMiddlename,
        c.$columnApplicantLastname,
        c.$columnApplicantSuffix,
        c.$columnApplicantMaidenname,
        c.$columnGender,
        c.$columnBirthDate,
        c.$columnStatus,
        c.$columnSpouse,
        c.$columnSitioAddress,
        c.$columnBarangayAddress,
        c.$columnMunicipalityAddress,
        l.$columnLotNumber AS lot_number,
        l.$columnIdenticalNumber AS identical_number,
        l.$columnSurveyClaimant AS survey_claimant,
        l.$columnAreaSqm AS area_sqm,
        l.$columnSitio AS sitio,
        l.$columnPropertyBarangay AS property_barangay,
        l.$columnPropertyMunicipality AS property_municipality,
        l.$columnRemarks AS remarks,
        l.$columnApplicationNumber AS application_number,
        l.$columnPatentNumber AS patent_number,
        l.$columnBundleNumber AS bundle_number,
        l.$columnLotStatus AS lot_status,
        l.$columnPlaReceivedDate AS pla_received_date,
        l.$columnTplaToPenroTransmittedDate AS tpla_to_penro_transmitted_date,
        l.$columnReturnFromPenro AS return_from_penro,
        l.$columnRodReceivedDate AS rod_received_date,
        l.$columnDateAppliedReceived AS date_applied_received,
        l.$columnDateApproved AS date_approved,
        l.$columnSerialNumber AS serial_number,
        l.$columnLandInvestigator AS land_investigator,
        l.$columnLandPropertyId AS land_property_id,
        l.$columnParentLandPropertyId AS parent_land_property_id
      FROM $tableClients c
      LEFT JOIN $tableLandProperty l ON c.$columnClientId = l.$columnClientIdRef
    ''');
  }

  Future<Map<int, Map<String, dynamic>>> getClientsGroupedById() async {
    final rows = await queryClientsWithLandProperties();
    Map<int, Map<String, dynamic>> groupedClients = {};

    for (var row in rows) {
      int clientId = row[columnClientId];
      if (groupedClients.containsKey(clientId)) {
        if (row['land_property_id'] != null) {
          groupedClients[clientId]!['land_properties'].add({
            'land_property_id': row['land_property_id'],
            'parent_land_property_id': row['parent_land_property_id'],
            'lot_number': row['lot_number'],
            'identical_number': row['identical_number'],
            'survey_claimant': row['survey_claimant'],
            'area_sqm': row['area_sqm'],
            'sitio': row['sitio'],
            'property_barangay': row['property_barangay'],
            'property_municipality': row['property_municipality'],
            'remarks': row['remarks'],
            'application_number': row['application_number'],
            'patent_number': row['patent_number'],
            'bundle_number': row['bundle_number'],
            'lot_status': row['lot_status'],
            'pla_received_date': row['pla_received_date'],
            'tpla_to_penro_transmitted_date':
                row['tpla_to_penro_transmitted_date'],
            'return_from_penro': row['return_from_penro'],
            'rod_received_date': row['rod_received_date'],
            'date_applied_received': row['date_applied_received'],
            'date_approved': row['date_approved'],
            'serial_number': row['serial_number'],
            'land_investigator': row['land_investigator'],
          });
        }
      } else {
        groupedClients[clientId] = {
          'client': {
            'id': row[columnClientId],
            'applicant_firstname': row[columnApplicantFirstname],
            'applicant_middlename': row[columnApplicantMiddlename],
            'applicant_lastname': row[columnApplicantLastname],
            'applicant_suffix': row[columnApplicantSuffix],
            'applicant_maidenname': row[columnApplicantMaidenname],
            'gender': row[columnGender],
            'birth_date': row[columnBirthDate],
            'status': row[columnStatus],
            'spouse': row[columnSpouse],
            'applicant_address': row[columnSitioAddress],
            'barangay_address': row[columnBarangayAddress],
            'municipality_address': row[columnMunicipalityAddress],
          },
          'land_properties': row['land_property_id'] != null
              ? [
                  {
                    'land_property_id': row['land_property_id'],
                    'parent_land_property_id': row['parent_land_property_id'],
                    'lot_number': row['lot_number'],
                    'identical_number': row['identical_number'],
                    'survey_claimant': row['survey_claimant'],
                    'area_sqm': row['area_sqm'],
                    'sitio': row['sitio'],
                    'property_barangay': row['property_barangay'],
                    'property_municipality': row['property_municipality'],
                    'remarks': row['remarks'],
                    'application_number': row['application_number'],
                    'patent_number': row['patent_number'],
                    'bundle_number': row['bundle_number'],
                    'lot_status': row['lot_status'],
                    'pla_received_date': row['pla_received_date'],
                    'tpla_to_penro_transmitted_date':
                        row['tpla_to_penro_transmitted_date'],
                    'return_from_penro': row['return_from_penro'],
                    'rod_received_date': row['rod_received_date'],
                    'date_applied_received': row['date_applied_received'],
                    'date_approved': row['date_approved'],
                    'serial_number': row['serial_number'],
                    'land_investigator': row['land_investigator'],
                  }
                ]
              : [],
        };
      }
    }
    return groupedClients;
  }
}
