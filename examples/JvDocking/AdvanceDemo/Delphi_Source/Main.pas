unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Menus, ComCtrls, ToolWin, JvDockControlForm, JvDockTree,
  JvDockVCStyle, JvDockDelphiStyle, JvDockVIDStyle, JvDockVSNetStyle,
  JvDockSupportClass, IniFiles{$IFDEF VER150}, XPMan{$ENDIF};

type
  TMainForm = class(TForm)
    MainMenu1: TMainMenu;
    DockForm_Menu: TMenuItem;
    DelphiStyle: TMenuItem;
    VCStyle: TMenuItem;
    VIDStyle: TMenuItem;
    ToolBar1: TToolBar;
    btnDelphi: TToolButton;
    btnVC: TToolButton;
    btnVID: TToolButton;
    ShowWindow_Menu: TMenuItem;
    DockInfo_Menu: TMenuItem;
    SaveToFile: TMenuItem;
    LoadFromFile: TMenuItem;
    SaveToReg: TMenuItem;
    LoadFromReg: TMenuItem;
    N24: TMenuItem;
    DockOption_Menu: TMenuItem;
    TopDocked: TMenuItem;
    BottomDocked: TMenuItem;
    LeftDocked: TMenuItem;
    RightDocked: TMenuItem;
    AllDocked: TMenuItem;
    N31: TMenuItem;
    lbDockServer1: TJvDockServer;
    JvDockDelphiStyle1: TJvDockDelphiStyle;
    JvDockVCStyle1: TJvDockVCStyle;
    JvDockVIDStyle1: TJvDockVIDStyle;
    StatusBar1: TStatusBar;
    btnVSNet: TToolButton;
    VSNETStyle: TMenuItem;
    PopupMenu2: TPopupMenu;
    ClientDockorFloat: TMenuItem;
    ClientHide: TMenuItem;
    ClientTopDocked: TMenuItem;
    ClientBottomDocked: TMenuItem;
    ClientLeftDocked: TMenuItem;
    ClientRightDocked: TMenuItem;
    N20: TMenuItem;
    N21: TMenuItem;
    ClientEachOtherDocked: TMenuItem;
    ClientAllDocked: TMenuItem;
    Memo1: TMemo;
    JvDockVSNetStyle1: TJvDockVSNetStyle;
    procedure DelphiStyleClick(Sender: TObject);
    procedure VCStyleClick(Sender: TObject);
    procedure VIDStyleClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bsToolWindow1Click(Sender: TObject);
    procedure bsToolWindow2Click(Sender: TObject);
    procedure SaveToFileClick(Sender: TObject);
    procedure LoadFromFileClick(Sender: TObject);
    procedure SaveToRegClick(Sender: TObject);
    procedure LoadFromRegClick(Sender: TObject);
    procedure TopDockedClick(Sender: TObject);
    procedure BottomDockedClick(Sender: TObject);
    procedure LeftDockedClick(Sender: TObject);
    procedure RightDockedClick(Sender: TObject);
    procedure AllDockedClick(Sender: TObject);
    procedure DefaultClick(Sender: TObject);
    procedure DelphiDockStyleClick(Sender: TObject);
    procedure VCDockStyleClick(Sender: TObject);
    procedure VIDDockStyleClick(Sender: TObject);
    procedure DockForm4Click(Sender: TObject);
    procedure PopupMenu2Popup(Sender: TObject);
    procedure ClientTopDockedClick(Sender: TObject);
    procedure ClientBottomDockedClick(Sender: TObject);
    procedure ClientLeftDockedClick(Sender: TObject);
    procedure ClientRightDockedClick(Sender: TObject);
    procedure ClientEachOtherDockedClick(Sender: TObject);
    procedure ClientAllDockedClick(Sender: TObject);
    procedure ClientDockorFloatClick(Sender: TObject);
    procedure ClientHideClick(Sender: TObject);
  private
    { Private declarations }
    FForm1Count,
    FForm2Count,
    FForm3Count,
    FForm4Count: Integer;
    procedure AddItemToShowDockMenu(AForm: TForm);
    procedure ShowDockWindowMenuClick(Sender: TObject);
    procedure ShowDockStatus(Sender:TObject);
  public
    { Public declarations }
  end;

const
  BoolStr: array[Boolean] of string =
    ('FALSE', 'TRUE');

var
  MainForm: TMainForm;

implementation

uses
  frmDelphiStyle, frmVCStyle, frmVIDStyle, frmVSNetStyle, JvDockSupportProc;

{$R *.DFM}

procedure TMainForm.DelphiStyleClick(Sender: TObject);
var Form: TForm1;
begin
  Form := TForm1.Create(Application);
  Form.Caption := Form.Caption + ' _ ' + IntToStr(FForm1Count);
  Inc(FForm1Count);
  AddItemToShowDockMenu(Form);
  ShowDockStatus(JvDockDelphiStyle1);
end;

procedure TMainForm.VCStyleClick(Sender: TObject);
var Form: TForm2;
begin
  Form := TForm2.Create(Application);
  Form.Caption := Form.Caption + ' _ ' + IntToStr(FForm2Count);
  Inc(FForm2Count);
  AddItemToShowDockMenu(Form);
  ShowDockStatus(JvDockVCStyle1);
end;

procedure TMainForm.VIDStyleClick(Sender: TObject);
var Form: TForm3;
begin
  Form := TForm3.Create(Self);
  Form.Caption := Form.Caption + ' _ ' + IntToStr(FForm3Count);
  Inc(FForm3Count);
  AddItemToShowDockMenu(Form);
  ShowDockStatus(JvDockVIDStyle1);
end;

procedure TMainForm.DockForm4Click(Sender: TObject);
var Form: TForm4;
begin
  Form := TForm4.Create(Self);
  Form.Caption := Form.Caption + ' _ ' + IntToStr(FForm4Count);
  Inc(FForm4Count);
  AddItemToShowDockMenu(Form);
  ShowDockStatus(JvDockVSNetStyle1);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FForm1Count := 0;
  FForm2Count := 0;
  FForm3Count := 0;
  FForm4Count := 0;
  TopDocked.Checked := lbDockServer1.TopDock;
  BottomDocked.Checked := lbDockServer1.BottomDock;
  LeftDocked.Checked := lbDockServer1.LeftDock;
  RightDocked.Checked := lbDockServer1.RightDock;
  AllDocked.Checked := lbDockServer1.EnableDock;
  Memo1.WordWrap := True;
  Caption := Caption + ' (docking is set to ' + lbDockServer1.DockStyle.ClassName + ')';
end;

procedure TMainForm.AddItemToShowDockMenu(AForm: TForm);
var
  AMenuItem: TMenuItem;
begin
  AMenuItem := NewItem(AForm.Caption, 0, True, True,
    ShowDockWindowMenuClick, 0, '');
  ShowWindow_Menu.Add(AMenuItem);
  AMenuItem.Tag := Integer(AForm);
  AForm.Tag := Integer(AMenuItem);
end;

procedure TMainForm.ShowDockWindowMenuClick(Sender: TObject);
var MenuItem: TMenuItem;
  Form: TForm;
begin
  MenuItem := TMenuItem(Sender);
  Form := TForm(MenuItem.Tag);
  if MenuItem.Checked then
  begin
    if GetFormVisible(Form) then
    begin
      HideDockForm(Form);
      MenuItem.Checked := False;
    end else
      ShowDockForm(Form);
  end else
  begin
    ShowDockForm(Form);
    MenuItem.Checked := True;
  end;
end;

procedure TMainForm.bsToolWindow1Click(Sender: TObject);
begin
  case TMenuItem(Sender).Tag of
    1: SetTabDockHostBorderStyle(bsDialog);
    2: SetTabDockHostBorderStyle(bsNone);
    3: SetTabDockHostBorderStyle(bsSingle);
    4: SetTabDockHostBorderStyle(bsSizeable);
    5: SetTabDockHostBorderStyle(bsSizeToolWin);
    6: SetTabDockHostBorderStyle(bsToolWindow);
  end;
end;

procedure TMainForm.bsToolWindow2Click(Sender: TObject);
begin
  case TMenuItem(Sender).Tag of
    1: SetConjoinDockHostBorderStyle(bsDialog);
    2: SetConjoinDockHostBorderStyle(bsNone);
    3: SetConjoinDockHostBorderStyle(bsSingle);
    4: SetConjoinDockHostBorderStyle(bsSizeable);
    5: SetConjoinDockHostBorderStyle(bsSizeToolWin);
    6: SetConjoinDockHostBorderStyle(bsToolWindow);
  end;
end;

procedure TMainForm.SaveToFileClick(Sender: TObject);
begin
  SaveDockTreeToFile(ExtractFilePath(Application.ExeName) + 'DockInfo.ini');
end;

procedure TMainForm.LoadFromFileClick(Sender: TObject);
begin
  LoadDockTreeFromFile(ExtractFilePath(Application.ExeName) + 'DockInfo.ini');
end;

procedure TMainForm.SaveToRegClick(Sender: TObject);
begin
  SaveDockTreeToReg(HKEY_CURRENT_USER, '\Software\DockInfo');
end;

procedure TMainForm.LoadFromRegClick(Sender: TObject);
begin
  LoadDockTreeFromReg(HKEY_CURRENT_USER, '\Software\DockInfo');
end;

procedure TMainForm.TopDockedClick(Sender: TObject);
begin
  TopDocked.Checked := not TopDocked.Checked;
  lbDockServer1.TopDock := TopDocked.Checked;
end;

procedure TMainForm.BottomDockedClick(Sender: TObject);
begin
  BottomDocked.Checked := not BottomDocked.Checked;
  lbDockServer1.BottomDock := BottomDocked.Checked;
end;

procedure TMainForm.LeftDockedClick(Sender: TObject);
begin
  LeftDocked.Checked := not LeftDocked.Checked;
  lbDockServer1.LeftDock := LeftDocked.Checked;
end;

procedure TMainForm.RightDockedClick(Sender: TObject);
begin
  RightDocked.Checked := not RightDocked.Checked;
  lbDockServer1.RightDock := RightDocked.Checked;
end;

procedure TMainForm.AllDockedClick(Sender: TObject);
begin
  AllDocked.Checked := not AllDocked.Checked;
  lbDockServer1.EnableDock := AllDocked.Checked;
end;

procedure TMainForm.DefaultClick(Sender: TObject);
begin
  lbDockServer1.DockStyle := nil;
end;

procedure TMainForm.DelphiDockStyleClick(Sender: TObject);
begin
  lbDockServer1.DockStyle := JvDockDelphiStyle1;
end;

procedure TMainForm.VCDockStyleClick(Sender: TObject);
begin
  lbDockServer1.DockStyle := JvDockVCStyle1;
end;

procedure TMainForm.VIDDockStyleClick(Sender: TObject);
begin
  lbDockServer1.DockStyle := JvDockVIDStyle1;
end;


procedure TMainForm.PopupMenu2Popup(Sender: TObject);
var DockClient: TJvDockClient;
begin
  if PopupMenu2.PopupComponent is TForm then
  begin
    DockClient := FindDockClient(TForm(PopupMenu2.PopupComponent));
    if DockClient <> nil then
    begin
      ClientTopDocked.Checked := DockClient.TopDock;
      ClientBottomDocked.Checked := DockClient.BottomDock;
      ClientLeftDocked.Checked := DockClient.LeftDock;
      ClientRightDocked.Checked := DockClient.RightDock;
      ClientEachOtherDocked.Checked := DockClient.EachOtherDock;
      ClientAllDocked.Checked := DockClient.EnableDock;
      if DockClient.DockState = JvDockState_Floating then
        ClientDockorFloat.Caption := 'Dock'
      else ClientDockorFloat.Caption := 'Float';
    end;
  end;
end;

procedure TMainForm.ClientTopDockedClick(Sender: TObject);
var DockClient: TJvDockClient;
begin
  if PopupMenu2.PopupComponent is TForm then
  begin
    DockClient := FindDockClient(TForm(PopupMenu2.PopupComponent));
    if DockClient <> nil then
    begin
      ClientTopDocked.Checked := not ClientTopDocked.Checked;
      DockClient.TopDock := ClientTopDocked.Checked;
    end;
  end;
end;

procedure TMainForm.ClientBottomDockedClick(Sender: TObject);
var DockClient: TJvDockClient;
begin
  if PopupMenu2.PopupComponent is TForm then
  begin
    DockClient := FindDockClient(TForm(PopupMenu2.PopupComponent));
    if DockClient <> nil then
    begin
      ClientBottomDocked.Checked := not ClientBottomDocked.Checked;
      DockClient.BottomDock := ClientBottomDocked.Checked;
    end;
  end;
end;

procedure TMainForm.ClientLeftDockedClick(Sender: TObject);
var DockClient: TJvDockClient;
begin
  if PopupMenu2.PopupComponent is TForm then
  begin
    DockClient := FindDockClient(TForm(PopupMenu2.PopupComponent));
    if DockClient <> nil then
    begin
      ClientLeftDocked.Checked := not ClientLeftDocked.Checked;
      DockClient.LeftDock := ClientLeftDocked.Checked;
    end;
  end;
end;

procedure TMainForm.ClientRightDockedClick(Sender: TObject);
var DockClient: TJvDockClient;
begin
  if PopupMenu2.PopupComponent is TForm then
  begin
    DockClient := FindDockClient(TForm(PopupMenu2.PopupComponent));
    if DockClient <> nil then
    begin
      ClientRightDocked.Checked := not ClientRightDocked.Checked;
      DockClient.RightDock := ClientRightDocked.Checked;
    end;
  end;
end;

procedure TMainForm.ClientEachOtherDockedClick(Sender: TObject);
var DockClient: TJvDockClient;
begin
  if PopupMenu2.PopupComponent is TForm then
  begin
    DockClient := FindDockClient(TForm(PopupMenu2.PopupComponent));
    if DockClient <> nil then
    begin
      ClientEachOtherDocked.Checked := not ClientEachOtherDocked.Checked;
      DockClient.EachOtherDock := ClientEachOtherDocked.Checked;
    end;
  end;
end;

procedure TMainForm.ClientAllDockedClick(Sender: TObject);
var DockClient: TJvDockClient;
begin
  if PopupMenu2.PopupComponent is TForm then
  begin
    DockClient := FindDockClient(TForm(PopupMenu2.PopupComponent));
    if DockClient <> nil then
    begin
      ClientAllDocked.Checked := not ClientAllDocked.Checked;
      DockClient.EnableDock := ClientAllDocked.Checked;
    end;
  end;
end;

procedure TMainForm.ClientDockorFloatClick(Sender: TObject);
var DockClient: TJvDockClient;
begin
  if PopupMenu2.PopupComponent is TForm then
  begin
    DockClient := FindDockClient(TForm(PopupMenu2.PopupComponent));
    if DockClient <> nil then
      DockClient.RestoreChild;
  end;
end;

procedure TMainForm.ClientHideClick(Sender: TObject);
var DockClient: TJvDockClient;
begin
  if PopupMenu2.PopupComponent is TForm then
  begin
    DockClient := FindDockClient(TForm(PopupMenu2.PopupComponent));
    if DockClient <> nil then
      DockClient.HideParentForm;
  end;
end;

procedure TMainForm.ShowDockStatus(Sender: TObject);
begin
  if lbDockServer1.DockStyle <> Sender then
    ShowMessage('This form type will not be able to dock');
end;

end.
