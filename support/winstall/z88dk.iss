; z88dk setup sript, by Marcello Zaniboni (www.geocities.com/marcellozaniboni)
; This script works with Inno Setup Compiler (www.jrsoftware.org/isinfo.php);
; if you want to run it, edit SourceDir and OutputDir properly.
;
[Setup]
InternalCompressLevel=max
SolidCompression=true
MinVersion=4.90.3000,4.0.1381
AppCopyright=z88dk.org
AppName=z88dk 1.6
AppVerName=z88dk 1.6
InfoAfterFile=setup\read_after.txt
InfoBeforeFile=setup\read_before.txt
WizardImageFile=setup\icons\z88dk_Image.bmp
DefaultGroupName=z88dk 1.6
OutputDir=C:\z88dk\setup
OutputBaseFilename=z88dk-1.6-setup
ShowLanguageDialog=auto
AppID=z88dk_1.6_uninstall
AppPublisher=http://www.z88dk.org
AppPublisherURL=http://www.z88dk.org
AppSupportURL=http://www.z88dk.org
AppVersion=1.6
DefaultDirName={pf}\z88dk
AppComments=created by z88dk setup
UninstallDisplayName=z88dk - setup
SetupIconFile=setup\icons\z88dk.ico
SourceDir=C:\z88dk
VersionInfoVersion=1.6
VersionInfoCompany=z88dk
VersionInfoDescription=z88dk setup
VersionInfoTextVersion=1.6 beta
ChangesEnvironment=true
AppUpdatesURL=http://www.z88dk.org
AppContact=http://www.z88dk.org
WizardSmallImageFile=setup\icons\z88dk_SmallImage.bmp
LicenseFile=LICENSE
DisableStartupPrompt=false
FlatComponentsList=false
[Components]
Name: z88dk; Description: The z80 C cross compiler; Types: custom compact full; Flags: fixed
Name: doc; Description: Compiler documentation; Types: custom full
Name: examples; Description: Examples; Types: custom full
Name: optdoc; Description: Additional compiler documentation; Types: custom full
Name: source; Description: Compiler source files; Types: custom full
Name: support; Description: Source code for old support programs (to allow conversion into a form suitable for loading into emulators or simulators); Types: custom full
[Files]
; Mandatory files
Source: setup\setup_ext\deploy_z88dk.exe; DestDir: {tmp}; Flags: deleteafterinstall; Components: z88dk
Source: setup\setup_ext\cfgs\*; DestDir: {tmp}; Flags: deleteafterinstall; Components: z88dk
Source: LICENSE; DestDir: {app}; Components: z88dk
Source: noarch\EXTENSIONS; DestDir: {app}; Components: z88dk
Source: bin\*; DestDir: {app}\bin; Components: z88dk
Source: lib\config\*; DestDir: {app}\lib\config; Components: z88dk
Source: noarch\include\*; DestDir: {app}\include; Components: z88dk
Source: noarch\include\net\*; DestDir: {app}\include\net; Components: z88dk
Source: noarch\include\oz\*; DestDir: {app}\include\oz; Components: z88dk
Source: noarch\include\oz700\*; DestDir: {app}\include\oz700; Components: z88dk
Source: noarch\include\rex\*; DestDir: {app}\include\rex; Components: z88dk
Source: noarch\include\sys\*; DestDir: {app}\include\sys; Components: z88dk
Source: noarch\lib\*; DestDir: {app}\lib
Source: noarch\lib\clibs\*; DestDir: {app}\lib\clibs
Source: noarch\lib\config\*; DestDir: {app}\lib\config
; Optional files
Source: noarch\examples\*; DestDir: {app}\examples; Components: examples
Source: noarch\examples\ace\*; DestDir: {app}\examples\ace; Components: examples
Source: noarch\examples\console\*; DestDir: {app}\examples\console; Components: examples
Source: noarch\examples\embedded\*; DestDir: {app}\examples\embedded; Components: examples
Source: noarch\examples\graphics\*; DestDir: {app}\examples\graphics; Components: examples
Source: noarch\examples\rex\*; DestDir: {app}\examples\rex; Components: examples
Source: noarch\examples\sam\*; DestDir: {app}\examples\sam; Components: examples
Source: noarch\examples\sound\*; DestDir: {app}\examples\sound; Components: examples
Source: noarch\examples\spectrum\*; DestDir: {app}\examples\spectrum; Components: examples
Source: noarch\examples\ticalc\*; DestDir: {app}\examples\ticalc; Components: examples
Source: noarch\examples\vz\*; DestDir: {app}\examples\vz; Components: examples
Source: noarch\examples\z88\*; DestDir: {app}\examples\z88; Components: examples
Source: noarch\examples\zx81\*; DestDir: {app}\examples\zx81; Components: examples
Source: noarch\examples\zxvgs\*; DestDir: {app}\examples\zxvgs; Components: examples
Source: noarch\src\*; DestDir: {app}\src; Components: source
Source: noarch\libsrc\*; DestDir: {app}\libsrc; Components: source
Source: noarch\doc\*; DestDir: {app}\doc; Components: doc
Source: noarch\doc\netman\*; DestDir: {app}\doc\netman; Components: doc
Source: noarch\support\*; DestDir: {app}\support; Components: support
Source: noarch\www\*; DestDir: {app}\www; Components: optdoc
Source: noarch\www\pics\*; DestDir: {app}\www\pics; Components: optdoc
Source: noarch\www\old\*; DestDir: {app}\www\old; Components: optdoc
[Registry]
; Win NT platforms
Root: HKCU; Subkey: Environment; ValueType: string; ValueName: Z80_OZFILES; ValueData: {app}\lib\; Flags: uninsdeletevalue; MinVersion: 0,4.0.1381
Root: HKCU; Subkey: Environment; ValueType: string; ValueName: ZCCCFG; ValueData: {app}\lib\config\; Flags: uninsdeletevalue; MinVersion: 0,4.0.1381
; Win ME platform
Root: HKLM; Subkey: SYSTEM\CurrentControlSet\Control\SessionManager\Environment; ValueType: string; ValueName: Z80_OZFILES; ValueData: {app}\lib\; MinVersion: 4.90.3000,0; Flags: uninsdeletekey
Root: HKLM; Subkey: SYSTEM\CurrentControlSet\Control\SessionManager\Environment; ValueType: string; ValueName: ZCCCFG; ValueData: {app}\lib\config\; MinVersion: 4.90.3000,0; Flags: uninsdeletekey
[Run]
Filename: {tmp}\deploy_z88dk.exe; WorkingDir: {tmp}; Flags: hidewizard; Parameters: """{app}"""; StatusMsg: Please wait a little bit...
