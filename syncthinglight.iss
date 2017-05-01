; -- Syncthing Light --
; Author: Maxwel Leite (http://needforbits.wordpress.com/)
; Description: Simple package installer for install and runs Syncthing as Windows Service (without tray utility - runs hidden) 
; SRC: https://github.com/maxwelleite/syncthinglight

[Setup]
AppId=SyncthingLight
AppName=Syncthing Light
AppVersion=0.14.27
DefaultDirName={sd}\Syncthing
DefaultGroupName=Syncthing Light     
UninstallDisplayIcon={app}\syncthing.ico
Compression=lzma2/ultra64
;Compression=none
SolidCompression=yes
OutputDir=.
DisableDirPage=yes
DisableProgramGroupPage=yes
PrivilegesRequired=admin 

[Files]
Source: "src\win64\syncthing.exe"; DestDir: "{app}"; DestName: "syncthing.exe"; Flags: ignoreversion; Check: Is64BitInstallMode; BeforeInstall: StopSyncthing
Source: "src\win32\syncthing.exe"; DestDir: "{app}"; Flags: ignoreversion; Check: not Is64BitInstallMode; BeforeInstall: StopSyncthing
Source: "src\syncthing.ico"; DestDir: "{app}"
Source: "src\winsw-syncthing.exe"; DestDir: "{app}"
Source: "src\winsw-syncthing.exe.config"; DestDir: "{app}"
Source: "src\winsw-syncthing.xml"; DestDir: "{app}"
Source: "src\service\winsw-syncthing-install.cmd"; DestDir: "{app}\service"
Source: "src\service\winsw-syncthing-uninstall.cmd"; DestDir: "{app}\service"
Source: "src\service\winsw-syncthing-start.cmd"; DestDir: "{app}\service"
Source: "src\service\winsw-syncthing-stop.cmd"; DestDir: "{app}\service"
Source: "src\service\winsw-syncthing-restart.cmd"; DestDir: "{app}\service"
Source: "src\AUTHORS.txt"; DestDir: "{app}"
Source: "src\LICENSE.txt"; DestDir: "{app}"

[Icons]
Name: "{group}\Syncthing Light WebUI"; Filename: "{app}\syncthing.exe"; Parameters: """-browser-only"""; WorkingDir: "{app}"; IconFilename: "{app}\syncthing.ico"
Name: "{group}\Uninstall Syncthing Light"; Filename: "{uninstallexe}"

[Tasks]
Name: StartAfterInstall; Description: Configure Syncthing as Windows Service

[Run]
Filename: "{cmd}"; Parameters: "/c ""net stop Syncthing""" ; Flags: postinstall waituntilterminated runhidden runascurrentuser; Tasks: StartAfterInstall
Filename: "{app}\winsw-syncthing.exe"; Parameters: "install"; Flags: postinstall waituntilterminated runhidden runascurrentuser; StatusMsg: "Installing Syncthing service..."; Tasks: StartAfterInstall
Filename: "{cmd}"; Parameters: "/c ""net start Syncthing""" ; Flags: postinstall waituntilterminated runhidden runascurrentuser; Tasks: StartAfterInstall
Filename: "{app}\syncthing.exe"; Parameters: "-browser-only"; Description: "Launch Syncthing WEB GUI (https://127.0.0.1:8384)"; Flags: postinstall nowait skipifsilent runhidden

[UninstallRun]
Filename: "{cmd}"; Parameters: "/c ""net stop Syncthing""" ; Flags: waituntilterminated runhidden runascurrentuser
Filename: "{app}\winsw-syncthing.exe"; Parameters: "uninstall"; Flags: waituntilterminated runascurrentuser runhidden

[UninstallDelete]
Type: files; Name: "{app}\winsw-syncthing.wrapper.log"

;[CustomMessages]
;english.DeleteSettings=Delete settings files?

[Code]
procedure TaskKill(FileName: String);
var
  ResultCode: Integer;
begin
    Exec(ExpandConstant('taskkill.exe'), '/f /im ' + '"' + FileName + '"', '', SW_HIDE,
     ewWaitUntilTerminated, ResultCode);
end;

procedure CurPageChanged(CurPageID: Integer);
begin
  if CurPageID = wpFinished then
    WizardForm.RunList.Visible := False;
end;

procedure StopSyncthing();
var
  ResultCode: Integer;
begin
    Exec(ExpandConstant('net.exe'), 'stop Syncthing', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
    TaskKill('syncthing.exe')
end;

// ask for delete config file during uninstall
// src: https://gist.github.com/mistic100/ae4c51f4a80854c14658
procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  case CurUninstallStep of
    usUninstall:
      begin
        if MsgBox(ExpandConstant('Delete settings files?'), mbConfirmation, MB_YESNO or MB_DEFBUTTON2) = IDYES then
          begin
             StopSyncthing;
             DelTree(ExpandConstant('{app}\config'), True, True, True);
          end
      end;
  end;
end; 
