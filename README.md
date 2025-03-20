# LOREMS (Land Origin & Resource Evaluation Management System) Guide

## Overview
This document provides the installation and setup guide for the LOREMS desktop application, details on the application packages used, and instructions on creating and configuring MSI and EXE installers.

---

## System Requirements
- **Operating System:** Windows 10/11 (64-bit recommended)
- **Processor:** Intel Core i3 or higher
- **RAM:** 4GB minimum (8GB recommended)
- **Storage:** 500MB free space
- **Additional Requirements:** .NET Framework 4.8 or later

---

## Installation Steps

### Navigate to Installer Folder
Navigate to the main `installer` folder and choose the installer type:

#### For .EXE Installer
1. Open the folder named **exe_file**.
2. Inside, locate **LOREMS.exe**.
3. Double-click **LOREMS.exe** to start the installation.
4. If prompted by Windows Defender, click "More info > Run anyway".
5. Follow the on-screen instructions and select the installation directory.
6. Click "Install" and wait for the process to complete.
7. Once installed, click "Finish" to close the installer.

#### For .MSI Installer (Preferred for Enterprise Installations)
1. Open the folder named **msi_file**.
2. Inside, locate **giccenroquezon.msi** (or the designated MSI file).
3. Right-click the MSI file and select "Install".
4. Follow the installation wizard and choose the preferred settings.
5. Click "Next", then "Install".
6. Wait for the installation to finish, then click "Finish".

---

## First-Time Setup
1. Open the LOREMS desktop application.
2. The app will prompt you to browse and select the existing database from your local storage.
   - If you do not have a database, create a new one.
3. After selecting the database, click **Continue**.
4. **IMPORTANT:** The user account is default and unchangeable as set by the developer.
   - **Login Credentials:**
     - Username: `admin`
     - Password: `admin123`
5. Click **Login** to access the system.

---

## Support & Developer Contact
If you forget your login credentials, please contact the developer directly:
- **Name:** AMADEO T. AMASAN III
- **Phone:** +63992061931 (Philippines, DITO SIM)
- **Email:** emcallcompany@gmail.com

---

## Compatibility & Recommendations
- **Compatible with:** Windows 10/11 (64-bit preferred)
- **Recommended Database Location:** A secure local storage folder with backup.
- **Security Tip:** Since the default user account cannot be changed, keep your login credentials secure.
- **Performance Tip:** Regularly optimize your database for smooth operation.

---

## Developer Code Access
Access the source code for this program on GitHub:  
[https://github.com/Jun-repo/LOREMS-Desktop-Application.git](https://github.com/Jun-repo/LOREMS-Desktop-Application.git)

---

## Application Packages Used
Below is the `pubspec.yaml` configuration for the Flutter project:

```yaml
name: giccenroquezon
description: "A new Flutter project."
publish_to: 'none' # Remove this line if you wish to publish to pub.dev

version: 1.0.0+1

environment:
  sdk: ^3.5.4

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  pager: ^0.0.6
  infinite_scroll_pagination: ^4.1.0
  pdf: ^3.11.3
  printing: ^5.14.2
  sqflite: ^2.4.1
  path: ^1.9.0
  sqflite_common_ffi: ^2.3.4+4
  intl: ^0.20.2
  bitsdojo_window: ^0.1.6
  reorderables: ^0.6.0
  custom_refresh_indicator: ^4.0.1
  window_size: ^0.1.0
  url_launcher: ^6.3.1
  sqlite3: ^2.7.5
  path_provider: ^2.1.5
  graphview: ^1.2.0
  flutter_sliding_box: ^1.1.5
  timeline_list: ^0.1.1
  animated_tree_view: ^2.3.0
  timeline_tile: ^2.0.0
  file_picker: ^9.2.1
  shared_preferences: ^2.5.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0
  msix: ^3.16.8

flutter:
  uses-material-design: true

  assets:
    - assets/
    - assets/icons/
    - assets/images/
    - assets/fonts/

  fonts:
    - family: Gilroy
      fonts:
        - asset: assets/fonts/Gilroy-ExtraBold.otf
        - asset: assets/fonts/Gilroy-Light.otf
          weight: 700
    - family: BebasNeue
      fonts:
        - asset: assets/fonts/BebasNeue-Regular.otf
        - asset: assets/fonts/BebasNeue-Regular.ttf
          weight: 700
    - family: TimesNewRoman
      fonts:
        - asset: assets/fonts/times new roman bold.ttf
        - asset: assets/fonts/times new roman.ttf
          weight: 700
    - family: Babell
      fonts:
        - asset: assets/fonts/Babell Bold.ttf
          weight: 700

msix_config:
  display_name: EnviroSort
  publisher_display_name: AMADEO AMASAN  III
  identity_name: abc
  msix_version: 1.0.0.0
  languages: en-us
  logo_path: C:\Users\emcal\Desktop\app_icon.ico
  certificate_path: C:\Users\emcal\Documents\CERTIFICATE.pfx
  certificate_password: passw0rd
Guide on Creating MSI and EXE Installers
Creating an .EXE Installer
Preparation:
Ensure your application is compiled and all necessary files are present.
Create a folder (e.g., exe_file) and place LOREMS.exe inside.
Packaging:
Use tools like Inno Setup or NSIS to package your application into an installer.
Configuration:
Configure the installer script to include the installation path, desktop shortcuts, and any additional components.
Building:
Run the Inno Setup or NSIS compiler to create your .exe installer file.
Testing:
Test the installer on a clean machine to ensure it installs and runs as expected.
Creating an .MSI Installer
Preparation:
Make sure your application files are compiled and organized.
Create a folder (e.g., msi_file) and place your MSI package file (e.g., giccenroquezon.msi) inside.
Tooling:
Use tools such as the WiX Toolset or Advanced Installer to create MSI installers.
Configuration:
Configure the installer with the necessary installation directories, registry settings, shortcuts, and other parameters.
Building:
Build the MSI installer using the selected tool.
Testing:
Test the MSI installer on a test machine to ensure that installation, uninstallation, and updates work properly.
Configuring Package Files and App Icon
Configuring Windows Folder Files
Configuration Files:
If your installer package requires configuration files to be placed in specific Windows system folders (e.g., C:\ProgramData\YourApp), ensure that your installer script has the correct permissions and paths.
Installer Script Example (Inno Setup):
pascal
Copy
Edit
[Files]
Source: "config\settings.ini"; DestDir: "{commonappdata}\YourApp"; Flags: ignoreversion
Adjust the file paths accordingly to ensure that configuration files are deployed in the correct locations.
Changing the App Icon (app_icon.ico)
Locate the Icon:
Locate the app_icon.ico file on your development machine.
Replace the Icon:
Replace the existing app_icon.ico with your new icon file.
Update Configuration:
Update the path in your configuration (e.g., msix_config in your pubspec.yaml for MSIX installers) to reflect the new icon location:
yaml
Copy
Edit
msix_config:
  display_name: EnviroSort
  publisher_display_name: AMADEO AMASAN  III
  identity_name: abc
  msix_version: 1.0.0.0
  languages: en-us
  logo_path: C:\Path\to\new_app_icon.ico
  certificate_path: C:\Users\emcal\Documents\CERTIFICATE.pfx
  certificate_password: passw0rd
Rebuild Installer:
Rebuild your installer after updating the icon configuration to ensure that the new icon is applied.
Testing Configuration
After making configuration changes, test your installer on a Windows environment to confirm that:
All configuration files are copied to the correct locations.
The new app icon is displayed properly in the installer and on the installed application.
Thank you for choosing LOREMS!
