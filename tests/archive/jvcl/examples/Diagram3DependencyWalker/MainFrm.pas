unit MainFrm;
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  JvDiagramShape, Dialogs, ComCtrls, Menus, ImgList, StdCtrls, ExtCtrls,
  ActnList, IniFiles, PersistSettings, DepWalkConsts, ToolWin, Buttons;

type
(*
  // (p3) interposer class for TListBox that implements IPersistSettings (for the skiplist)
  TListBox = class(StdCtrls.TListBox, IUnknown, IPersistSettings)
  private
    {IPersistSettings}
    procedure Load(Storage: TCustomIniFile);
    procedure Save(Storage: TCustomIniFile);
  end;
 *)
  TfrmMain = class(TForm, IUnknown, IPersistSettings)
    StatusBar1: TStatusBar;
    mmMain: TMainMenu;
    File1: TMenuItem;
    SelectFiles1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    dlgSelectFiles: TOpenDialog;
    il32: TImageList;
    New1: TMenuItem;
    vertSplitter: TSplitter;
    pnlDiagram: TPanel;
    pnlSkipList: TPanel;
    lbSkipList: TListBox;
    pnlDiagramTitle: TPanel;
    pnlSkipListTitle: TPanel;
    popSkipList: TPopupMenu;
    Add1: TMenuItem;
    Delete1: TMenuItem;
    Edit1: TMenuItem;
    Sort1: TMenuItem;
    N2: TMenuItem;
    Skiplist1: TMenuItem;
    Add2: TMenuItem;
    Delete2: TMenuItem;
    alMain: TActionList;
    acOpen: TAction;
    acExit: TAction;
    acSortName: TAction;
    acSortLinksTo: TAction;
    acSortLinksFrom: TAction;
    acInvertSort: TAction;
    acAdd: TAction;
    acDelete: TAction;
    acNew: TAction;
    acAbout: TAction;
    byName1: TMenuItem;
    byLinksTo1: TMenuItem;
    LinksFrom1: TMenuItem;
    N3: TMenuItem;
    InvertSort1: TMenuItem;
    popShape: TPopupMenu;
    acUnitStats: TAction;
    Statistics1: TMenuItem;
    Delete3: TMenuItem;
    N4: TMenuItem;
    acDelShape: TAction;
    acReport: TAction;
    Print1: TMenuItem;
    acFind: TAction;
    Find1: TMenuItem;
    cbToolbar: TCoolBar;
    tbStandard: TToolBar;
    tbSelectFiles: TToolButton;
    tbNew: TToolButton;
    ToolButton3: TToolButton;
    tbAddSkip: TToolButton;
    tbDelSkip: TToolButton;
    Actions: TImageList;
    tbReport: TToolButton;
    ToolButton7: TToolButton;
    tbFind: TToolButton;
    tbUnitStats: TToolButton;
    tbAbout: TToolButton;
    ToolButton11: TToolButton;
    tbDelShape: TToolButton;
    ToolButton13: TToolButton;
    acAddToSkipList: TAction;
    Addtoskiplist1: TMenuItem;
    View1: TMenuItem;
    acViewStatusBar: TAction;
    acViewSkipList: TAction;
    SpeedButton1: TSpeedButton;
    StatusBar2: TMenuItem;
    Skiplist2: TMenuItem;
    acViewToolBar: TAction;
    Toolbar1: TMenuItem;
    N6: TMenuItem;
    acRefresh: TAction;
    sb: TScrollBox;
    acSaveBMP: TAction;
    acCopy: TAction;
    popDiagram: TPopupMenu;
    CopyDiagramtoClipboard1: TMenuItem;
    CopyDiagramtoClipboard2: TMenuItem;
    N5: TMenuItem;
    SaveImage1: TMenuItem;
    N7: TMenuItem;
    dlgSaveImage: TSaveDialog;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    acSaveDiagram: TAction;
    acOpenDiagram: TAction;
    acParseUnit: TAction;
    Parseunit1: TMenuItem;
    N8: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure SbMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure acOpenExecute(Sender: TObject);
    procedure acExitExecute(Sender: TObject);
    procedure acArrangeAction(Sender: TObject);
    procedure acInvertSortExecute(Sender: TObject);
    procedure acAddExecute(Sender: TObject);
    procedure acDeleteExecute(Sender: TObject);
    procedure acAboutExecute(Sender: TObject);
    procedure acNewExecute(Sender: TObject);
    procedure alMainUpdate(Action: TBasicAction;
      var Handled: Boolean);
    procedure acUnitStatsExecute(Sender: TObject);
    procedure acDelShapeExecute(Sender: TObject);
    procedure acReportExecute(Sender: TObject);
    procedure acFindExecute(Sender: TObject);
    procedure acAddToSkipListExecute(Sender: TObject);
    procedure acViewStatusBarExecute(Sender: TObject);
    procedure acViewSkipListExecute(Sender: TObject);
    procedure acViewToolBarExecute(Sender: TObject);
    procedure acRefreshExecute(Sender: TObject);
    procedure acSaveBMPExecute(Sender: TObject);
    procedure acCopyExecute(Sender: TObject);
    procedure acSaveDiagramExecute(Sender: TObject);
    procedure acOpenDiagramExecute(Sender: TObject);
    procedure sbMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure acParseUnitExecute(Sender: TObject);
  private
    { Private declarations }
    FPrintFormat: TPrintFormat;
    FFileShapes: TStringlist;
    FInitialDir: string;
    FLeft, FTop: integer;
    FSelected:TJvCustomDiagramShape;

    procedure LoadSettings;
    procedure SaveSettings;
    function FindUnit(const Filename:string;const DefaultExt:string='.pas'):string;
    procedure Clear;
    procedure CreatePrintOut(Strings: TStrings; AFormat: TPrintFormat = pfText);
    function GetFileShape(const Filename: string): TJvBitmapShape;
    procedure ParseUnits(Files, Errors: TStrings);
    procedure ParseUnit(const Filename: string; Errors: TStrings);
    function GetUses(const Filename: string; AUsesIntf, AUsesImpl: TStrings; var ErrorMessage: string): boolean;
    procedure Connect(StartShape, EndShape: TJvCustomDiagramShape; IsInterface: boolean);
    procedure LoadSkipList;
    procedure SaveSkipList;
    function InSkipList(const Filename: string): boolean;
    procedure Arrange(AList: TList);
    procedure DoShapeClick(Sender: TObject);
    procedure SortItems(ATag: integer; AList: TList; InvertedSort: boolean);

    {IPersistSettings}
    procedure Load(Storage: TCustomIniFile);
    procedure Save(Storage: TCustomIniFile);
    procedure CreateDiagramBitmap(Bmp: TBitmap);
    procedure HighlightConnectors(AShape: TJvCustomDiagramShape);
    procedure DoShapeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation
uses
  JCLParseUses, Clipbrd, StatsFrm, ShellAPI, PrintFrm, Registry;


{$R *.dfm}

type
  // (p3) class that changes and restores the screen cursor automatically
  TChangeCursor = class(TInterfacedObject)
  private
    FOldCursor: TCursor;
  public
    constructor Create(NewCursor: TCursor);
    destructor Destroy; override;
  end;

{ TChangeCursor }

constructor TChangeCursor.Create(NewCursor: TCursor);
begin
  inherited Create;
  FOldCursor := Screen.Cursor;
  Screen.Cursor := NewCursor;
end;

destructor TChangeCursor.Destroy;
begin
  Screen.Cursor := FOldCursor;
  inherited;
end;

function WaitCursor: IUnknown;
begin
  Result := TChangeCursor.Create(crHourGlass);
end;

function ChangeCursor(NewCursor: TCursor): IUnknown;
begin
  Result := TChangeCursor.Create(NewCursor);
end;

function YesNo(const ACaption, AMsg: string): boolean;
begin
  Result := MessageBox(GetFocus, PChar(AMsg), PChar(ACaption),
    MB_YESNO or MB_ICONQUESTION or MB_TASKMODAL) = IDYES;
end;

procedure SuspendRedraw(AControl: TWinControl; Suspend: boolean);
begin
  AControl.Perform(WM_SETREDRAW, Ord(not Suspend), 0);
  if not Suspend then
    RedrawWindow(AControl.Handle, nil, 0, RDW_ERASE or RDW_FRAME or RDW_INTERNALPAINT or RDW_INVALIDATE or RDW_UPDATENOW or RDW_ALLCHILDREN);
end;

function GetDelphiLibPath(Version:integer):string;
const
  cLibPath:PChar = '\Software\Borland\Delphi\%d.0\Library';
var ALibPath:string;
begin
  ALibPath := Format(cLibPath,[Version]);
  with TRegistry.Create(KEY_READ) do // defaults to HKCU - just what we want
  try
    if OpenKeyReadOnly(ALibPath) and KeyExists('Search Path') then
      Result := ReadString('Search Path')
    else
      Result := '';
  finally
    Free;
  end;
end;

// (p3) copy Strings.Objects to TList

procedure CopyObjects(Strings: TStrings; AList: TList);
var
  i: integer;
begin
  for i := 0 to Strings.Count - 1 do
    AList.Add(Strings.Objects[i]);
end;

// (p3) returns the number of links that are connected to AShape

function GetNumLinksTo(AShape: TJvCustomDiagramShape): integer;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to AShape.Parent.ControlCount - 1 do
    if (AShape.Parent.Controls[i] is TJvConnector) and
      (TJvConnector(AShape.Parent.Controls[i]).EndConn.Shape = AShape) then
      Inc(Result);
end;

// (p3) returns the number of links that are connected from AShape

function GetNumLinksFrom(AShape: TJvCustomDiagramShape): integer;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to AShape.Parent.ControlCount - 1 do
    if (AShape.Parent.Controls[i] is TJvConnector) and
      (TJvConnector(AShape.Parent.Controls[i]).StartConn.Shape = AShape) then
      Inc(Result);
end;

// (p3) retrievs the shapes that AShape is connected to and store their name and pointers in Strings

procedure UsesUnits(AShape: TJvCustomDiagramShape; Strings: TStrings; const Ext: string = cPascalExt);
var i: integer;
begin
  Strings.Clear;
  for i := 0 to AShape.Parent.ControlCount - 1 do
    if (AShape.Parent.Controls[i] is TJvConnector) and
      (TJvConnector(AShape.Parent.Controls[i]).StartConn.Shape = AShape) then
      with TJvConnector(AShape.Parent.Controls[i]).EndConn do
        Strings.AddObject(ChangeFileExt(Shape.Caption.Text, Ext), Shape);
end;

// (p3) retrievs the shapes that connects to AShape and store their name and pointers in Strings

procedure UsedByUnits(AShape: TJvCustomDiagramShape; Strings: TStrings; const Ext: string = cPascalExt);
var i: integer;
begin
  Strings.Clear;
  for i := 0 to AShape.Parent.ControlCount - 1 do
    if (AShape.Parent.Controls[i] is TJvConnector) and
      (TJvConnector(AShape.Parent.Controls[i]).EndConn.Shape = AShape) then
      with TJvConnector(AShape.Parent.Controls[i]).StartConn do
        Strings.AddObject(ChangeFileExt(Shape.Caption.Text, Ext), Shape);
end;

// (p3) returns the first selected shape that isn't a TJvTextShape or a TJvConnector
// (NOTE: I'm relying on that TJvTextShape has a nil Caption and TJvConnectors cannot be selected)

function GetFirstSelectedShape(Parent: TWInControl): TJvCustomDiagramShape;
var i: integer;
begin
  for i := 0 to Parent.ControlCount - 1 do
    if (Parent.Controls[i] is TJvCustomDiagramShape) and TJvCustomDiagramShape(Parent.Controls[i]).Selected and
    // don't be fooled by captions (they are also TJvCustomDiagramShape):
    not (TJvCustomDiagramShape(Parent.Controls[i]).Caption = nil) then
    begin
      Result := TJvCustomDiagramShape(Parent.Controls[i]);
      Exit;
    end;
  Result := nil;
end;

function NameCompare(Item1, Item2: Pointer): integer;
begin
  Result := CompareText(
    TJvCustomDiagramShape(Item1).Caption.Text,
    TJvCustomDiagramShape(Item2).Caption.Text);
end;

function InvertNameCompare(Item1, Item2: Pointer): integer;
begin
  Result := -NameCompare(Item1, Item2);
end;

function MinLinksToCompare(Item1, Item2: Pointer): integer;
begin
  Result := GetNumLinksTo(Item1) - GetNumLinksTo(Item2);
  if Result = 0 then
    Result := GetNumLinksFrom(Item1) - GetNumLinksFrom(Item2);
  if Result = 0 then
    NameCompare(Item1, Item2);
end;

function MaxLinksToCompare(Item1, Item2: Pointer): integer;
begin
  Result := -MinLinksToCompare(Item1, Item2);
end;

function MinLinksFromCompare(Item1, Item2: Pointer): integer;
begin
  Result := GetNumLinksFrom(Item1) - GetNumLinksFrom(Item2);
  if Result = 0 then
    Result := GetNumLinksTo(Item1) - GetNumLinksTo(Item2);
  if Result = 0 then
    NameCompare(Item1, Item2);
end;

function MaxLinksFromCompare(Item1, Item2: Pointer): integer;
begin
  Result := -MinLinksFromCompare(Item1, Item2);
end;

(*
{ TListBox }

procedure TListBox.Load(Storage: TCustomIniFile);
begin
  Exit;
  if Storage.SectionExists(Name) then
  begin
    Sorted := false;
    Storage.ReadSection(Name, Items);
    Sorted := true;
  end;
end;

procedure TListBox.Save(Storage: TCustomIniFile);
var i: integer;
begin
  Exit;
  Storage.EraseSection(Name);
  for i := 0 to Items.Count - 1 do
    Storage.WriteString(Name, Items[i], '');
end;

*)
{ TfrmMain }

procedure TfrmMain.HighlightConnectors(AShape:TJvCustomDiagramShape);
var i:integer;C:TJvConnector;Changed:boolean;
begin
  Changed := false;
  for i := 0 to AShape.Parent.ControlCount - 1 do
  begin
    if AShape.Parent.Controls[i] is TJvConnector then
    begin
      C := TJvConnector(AShape.Parent.Controls[i]);
      if (C.StartConn.Shape = AShape) or (C.EndConn.Shape = AShape) then
      begin
        Changed := true;
        if C.LineColour = cIntfLineColor then
          C.LineColour := cIntfSelColor
        else if C.LineColour = cImplLineColor then
          C.LineColour := cImplSelColor
        else
          Changed := false;
        if Changed then C.Invalidate;
      end
      else // reset to standard color
      begin
        Changed := true;
        if C.LineColour = cIntfSelColor then
          C.LineColour := cIntfLineColor
        else if C.LineColour = cImplSelColor then
          C.LineColour := cImplLineColor
        else
          Changed := false;
        if Changed then C.Invalidate;
      end;
    end;
  end;
  if Changed then
  begin
    AShape.Parent.Repaint;
//    AShape.BringToFront;
  end;
end;

procedure TfrmMain.DoShapeClick(Sender: TObject);
begin
  TJvBitmapShape(Sender).BringToFront;
  TJvBitmapShape(Sender).Caption.BringToFront;
//  HighlightConnectors(TJvBitmapShape(Sender));
end;

procedure TfrmMain.DoShapeMouseDown(Sender:TObject;Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FSelected := Sender as TJvCustomDiagramShape;
  if Button = mbLeft then
    HighLightConnectors(FSelected);
end;

// (p3) returns an existing or new shape
// Filename is considered unique

function TfrmMain.GetFileShape(const Filename: string): TJvBitmapShape;
var
  i: integer;
  AFilename: string;
begin
  AFilename := FindUnit(Filename);
  i := FFileShapes.IndexOf(AFilename);
  if i < 0 then
  begin
    Result := TJvBitmapShape.Create(self);
    Result.Images := il32;
    Result.ImageIndex := cUnitUsedImageIndex; // always set "used" as default
    Result.Hint := AFilename;
    Result.ShowHint := True;
    Result.OnClick := DoShapeClick;
    Result.OnDblClick := acParseUnitExecute;
    Result.OnMouseDown := DoShapeMouseDown;

    Result.PopupMenu := popShape;
    Result.Top := FTop;
    Result.Left := FLeft;
    Result.Parent := sb;
    Result.Caption := TJvTextShape.Create(self);
    Result.Caption.Parent := sb;
    Result.Caption.Enabled := false;
    Result.Caption.Tag := integer(Result);
    Result.Caption.Text := ChangeFileExt(ExtractFilename(AFilename), '');
    Result.Caption.AlignCaption(taLeftJustify);
    Result.BringToFront;
    i := FFileShapes.AddObject(AFilename, Result);
  end;
  Result := TJvBitmapShape(FFileShapes.Objects[i]);
end;

// (p3) connects two shapes with a single head arrow pointing towards EndShape
// colors differently depending on if it's interface link or an implementation link
procedure TfrmMain.Connect(StartShape, EndShape: TJvCustomDiagramShape; IsInterface: boolean);
var
  arr: TJvSingleHeadArrow;
begin
  arr := TJvSingleHeadArrow.Create(self);
  with arr do
  begin
    if IsInterface then
      LineColour := cIntfLineColor
    else
      LineColour := cImplLineColor;
    // Set the start connection
    StartConn.Side := csRight;
    StartConn.Offset := StartShape.Height div 2;
    StartConn.Shape := StartShape;
    // Set the end connection
    EndConn.Side := csLeft;
    EndConn.Offset := EndShape.Height div 2;
    EndConn.Shape := EndShape;
    // Ensure the size is correct
    SetBoundingRect;
    Parent := sb;
    SendToBack;
  end;
end;

// (p3) Builds a list of all units used by Filename and adds the unit names to AUses
// returns true if no errors, any exception message is added to ErrorMessage but th eprocessing
// is not aborted

function TfrmMain.GetUses(const Filename: string; AUsesIntf, AUsesImpl: TStrings; var ErrorMessage: string): boolean;
var
  UL: TUsesList;
  i: integer;
  P: PChar;
begin
  Result := true;
  try
    with TMemoryStream.Create do
    try
      LoadFromFile(Filename);
      AUsesIntf.Clear;
      AUSesImpl.Clear;
      P := PChar(Memory);
      with TUnitGoal.Create(P) do
      try
        UL := UsesIntf;
        for i := 0 to UL.Count - 1 do
          if not InSkipList(UL.Items[i]) then
            AUsesIntf.Add(UL.Items[i]);
        UL := UsesImpl;
        for i := 0 to UL.Count - 1 do
          if not InSkipList(UL.Items[i]) then
            AUsesImpl.Add(UL.Items[i]);
      finally
        Free;
      end;
    finally
      Free;
    end;
  except
    on E: Exception do
    begin
      Result := false;
      ErrorMessage := E.Message;
    end;
  end;
end;

// (p3) reads a single file's uses. Creates, connects and positions the shapes as necessary

procedure TfrmMain.ParseUnit(const Filename: string; Errors: TStrings);
var
  AUsesIntf, AUsesImpl: TStringlist;
  FS: TJvBitmapShape;
  i: integer;
  AFilename, ErrMsg: string;
begin
  AFilename := FindUnit(Filename); 
  if InSkipList(AFilename) then
    Exit;
  AUsesIntf := TStringlist.Create;
  AUsesImpl := TStringlist.Create;
  FTop := cStartY;
  try
    if not GetUses(AFilename, AUsesIntf, AUsesImpl, ErrMsg) then
      Errors.Add(Format('%s: %s', [AFilename, ErrMsg]));
    // add the actual file
    FS := GetFileShape(AFilename);
    FS.ImageIndex := cUnitParsedImageIndex; // this is a parsed file
    Inc(FLeft, cOffsetX);
    for i := 0 to AUsesIntf.Count - 1 do
    begin
      //add the used unit and connect to the parsed file
      Connect(FS, GetFileShape(AUsesIntf[i]),true);
      Inc(FTop, cOffsetY);
    end;
    for i := 0 to AUsesImpl.Count - 1 do
    begin
      //add the used unit and connect to the parsed file
      Connect(FS, GetFileShape(AUsesImpl[i]),false);
      Inc(FTop, cOffsetY);
    end;
  finally
    AUsesIntf.Free;
    AUsesImpl.Free;
  end;
  Application.ProcessMessages;
end;

// (p3) reads a list of filenames and calls ParseUnit for each

procedure TfrmMain.ParseUnits(Files, Errors: TStrings);
var
  i: integer;
begin
  WaitCursor;
  SuspendRedraw(sb, true);
  try
    for i := 0 to Files.Count - 1 do
    begin
      StatusBar1.Panels[0].Text := Files[i];
      StatusBar1.Update;
      if i > 0 then
        Inc(FLeft, cOffsetX);
      ParseUnit(Files[i], Errors);
    end;
  finally
    SuspendRedraw(sb, false);
  end;
  StatusBar1.Panels[0].Text := Format(SParsedStatusFmt, [Files.Count, FFileShapes.Count]);
end;

// (p3) tries to find Filename and return it's full path and filename
// if it fails, the original Filename is returned instead
function TfrmMain.FindUnit(const Filename: string;const DefaultExt:string='.pas'): string;
begin
  Result := ExpandUNCFileName(Filename);
  if FileExists(Result) then Exit;
  Result := ChangeFileExt(Result,DefaultExt);
  if FileExists(Result) then Exit;
  Result := ExtractFilePath(dlgSelectFiles.FileName) + ExtractFileName(Result);
  if FileExists(Result) then Exit;
  // TODO: check system paths and Delphi paths as well 
  Result := Filename;
end;

// (p3) removes all shapes and links

procedure TfrmMain.Clear;
// var i: integer;
begin
  WaitCursor;
  FFileShapes.Clear;
  TJvCustomDiagramShape.DeleteAllShapes(sb);
  FLeft := cStartX;
  FTop := cStartY;
  FSelected := nil;
  StatusBar1.Panels[0].Text := SStatusReady;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FFileShapes := TStringlist.Create;
  FFileShapes.Sorted := true;
  FFileShapes.Duplicates := dupError;
  FLeft := cStartX;
  FTop := cStartY;
  LoadSettings;
end;

procedure TfrmMain.LoadSkipList;
var
//  i: integer;
  AFilename: string;
begin
  AFilename := ExtractFilePath(Application.Exename) + 'SkipList.txt';
  if FileExists(AFilename) then
  begin
    lbSkipList.Sorted := false;
    lbSkipList.Items.LoadFromFile(AFilename);
{    for i := lbSkipList.Items.Count - 1 downto 0 do
    begin
      lbSkipList.Items[i] := ExtractFileName(ChangeFileExt(lbSkipList.Items[i], ''));
      if lbSkipList.Items[i] = '' then
        lbSkipList.Items.Delete(i);
    end; }
    lbSkipList.Sorted := true;
  end;
end;

procedure TfrmMain.SaveSkipList;
begin
  lbSkipList.Items.SaveToFile(ExtractFilePath(Application.Exename) + 'SkipList.txt');
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  //  Clear;
  SaveSettings;
  FFileShapes.Free;
end;

function TfrmMain.InSkipList(const Filename: string): boolean;
begin
  Result := (lbSkipList.Items.IndexOf(ChangeFileExt(ExtractFileName(Filename), '')) > -1);
end;

// (p3) arranges the shapes in AList into a grid of rows and columns
// tries to make the grid as "square" as possible (Rows = Cols)

procedure TfrmMain.Arrange(AList: TList);
var
  Cols, i: integer;
  FS: TJvCustomDiagramShape;
begin
  if AList.Count = 0 then
    Exit;
  Cols := round(sqrt(AList.Count));
  FLeft := 0;
  FTop := 0;
  for i := 0 to AList.Count - 1 do
  begin
    if (i mod Cols = 0) then // new row or first row
    begin
      FLeft := cStartX;
      if i = 0 then
        Inc(FTop, cStartY)  // first row
      else
        Inc(FTop, cOffsetY);
    end;
    FS := TJvCustomDiagramShape(AList[i]);
    FS.SetBounds(FLeft, FTop, FS.Width, FS.Height);
    Inc(FLeft, cOffsetX);
  end;
end;

function iff(Condition: boolean; TrueValue, FalseValue: integer): integer;
begin
  if Condition then
    Result := TrueValue
  else
    Result := FalseValue;
end;

procedure TfrmMain.SbMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
begin
  Handled := true;
  with sb do
    if (ssShift in Shift) and (HorzScrollBar.IsScrollBarVisible) then
      HorzScrollBar.Position := HorzScrollBar.Position - iff(ssCtrl in Shift, WheelDelta * 3, WheelDelta)
    else if (VertScrollBar.IsScrollBarVisible) then
      VertScrollBar.Position := VertScrollBar.Position - iff(ssCtrl in Shift, WheelDelta * 3, WheelDelta);
end;

procedure TfrmMain.acOpenExecute(Sender: TObject);
var
  Errors: TStringlist; // S: string;
begin
  ForceCurrentDirectory := true;
  dlgSelectFiles.InitialDir := FInitialDir;
  if dlgSelectFiles.Execute then
  begin
    FInitialDir := ExtractFilePath(dlgSelectFiles.Filename);
    Errors := TStringlist.Create;
    try
      ParseUnits(dlgSelectFiles.Files, Errors);
      if Errors.Count > 0 then
      begin
        ShowMessageFmt(SParseErrorsFmt, [Errors.Text]);
        // copy to clipboard as well
        Clipboard.SetTextBuf(PChar(Errors.Text));
      end;
    finally
      Errors.Free;
    end;
  end;
end;

procedure TfrmMain.acExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.SortItems(ATag: integer; AList: TList; InvertedSort: boolean);
begin
  case ATag of
    0:
      if InvertedSort then
        AList.Sort(InvertNameCompare)
      else
        AList.Sort(NameCompare);
    1:
      if InvertedSort then
        AList.Sort(MaxLinksToCompare)
      else
        AList.Sort(MinLinksToCompare);
    2:
      if InvertedSort then
        AList.Sort(MaxLinksFromCompare)
      else
        AList.Sort(MinLinksFromCompare);
  else
    Exit; // no sorting
  end;
end;

procedure TfrmMain.CreatePrintOut(Strings: TStrings; AFormat: TPrintFormat = pfText);
var
  i, j, ATag: integer;
  UsedByStrings, UsesStrings: TStringlist;
  AList: TList;
  AShape: TJvBitmapShape;
begin
  UsedByStrings := TStringlist.Create;
  UsesStrings := TStringlist.Create;
  AList := TList.Create;
  try
    Strings.Clear;
    // (p3) use same sorting as in the current view (defaults to "by Name"):
    CopyObjects(FFileShapes, AList);
    if acSortName.Checked then
      ATag := acSortName.Tag
    else if acSortLinksTo.Checked then
      ATag := acSortLinksTo.Tag
    else if acSortLinksFrom.Checked then
      ATag := acSortLinksFrom.Tag
    else
      ATag := -1; // no need to sort: FFileShapes already sorted by name
    SortItems(ATag, AList, acInvertSort.Checked);
    for i := 0 to AList.Count - 1 do
    begin
      AShape := TJvBitmapShape(AList[i]);
      UsesUnits(AShape, UsesStrings, '');
      UsedByUnits(AShape, UsedByStrings, '');
      case AFormat of
        pfText:
          begin
            Strings.Add(AShape.Caption.Text);
            Strings.Add('  ' + SUsesColon);
            if UsesStrings.Count < 1 then
              Strings.Add('    ' + SNone)
            else
              for j := 0 to UsesStrings.Count - 1 do
                Strings.Add('    ' + UsesStrings[j]);
            Strings.Add('  ' + SUsedByColon);
            if UsedByStrings.Count < 1 then
              Strings.Add('    ' + SNone)
            else
              for j := 0 to UsedByStrings.Count - 1 do
                Strings.Add('    ' + UsedByStrings[j]);
          end;
        pfHTML:
          begin
            Strings.Add(Format('<h3>%s:</h3>', [AShape.Caption.Text]));
            if UsesStrings.Count > 0 then
              Strings.Add(Format('<b>%s</b>', [SUsesColon]));
            Strings.Add('<ul>');
            for j := 0 to UsesStrings.Count - 1 do
              Strings.Add('<li>' + UsesStrings[j]);
            Strings.Add('</ul>');
            if UsedByStrings.Count > 0 then
              Strings.Add(Format('<b>%s</b>', [SUsedByColon]));
            Strings.Add('<ul>');
            for j := 0 to UsedByStrings.Count - 1 do
              Strings.Add('<li>' + UsedByStrings[j]);
            Strings.Add('</ul>');
          end;
        pfXML:
          begin
            Strings.Add(Format('<UNIT Name="%s">', [AShape.Caption.Text]));
            for j := 0 to UsesStrings.Count - 1 do
              Strings.Add(Format('<USES Name="%s" />', [UsesStrings[j]]));
            for j := 0 to UsedByStrings.Count - 1 do
              Strings.Add(Format('<USEDBY Name="%s" />', [UsedByStrings[j]]));
            Strings.Add('</UNIT>');
          end;
      end; // case
    end;
    // insert headers and footers:
    case AFormat of
      pfXML:
        begin
          Strings.Insert(0, '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><DependencyWalker>');
          Strings.Add('</DependencyWalker>');
        end;
      pfHTML:
        begin
          Strings.Insert(0, Format('<html><head><title>%s</title><link rel="stylesheet" href="DependencyWalker.css" type="text/css"></head>', [SDependencyWalkerTitle]));
          Strings.Insert(1, Format('<body><h1>%s</h1><hr>', [SDependencyWalkerTitle]));
          Strings.Add('</body></html>');
        end;
    end; //
  finally
    UsedByStrings.Free;
    UsesStrings.Free;
    AList.Free;
  end;
end;


procedure TfrmMain.acArrangeAction(Sender: TObject);
var
  AList: TList;
begin
  WaitCursor;
  SuspendRedraw(sb, true);
  // (p3) reset checked here so it will be easier to check wich one is used as radio-item
  AList := TList.Create;
  try
    FLeft := cStartX;
    FTop := cStartY;
    acSortName.Checked := false;
    acSortLinksTo.Checked := false;
    acSortLinksFrom.Checked := false;
    sb.HorzScrollBar.Position := 0;
    sb.VertScrollBar.Position := 0;
    CopyObjects(FFileShapes, AList);
    SortItems((Sender as TAction).Tag, Alist, acInvertSort.Checked);
    Arrange(AList);
  finally
    SuspendRedraw(sb, false);
    AList.Free;
  end;
  TAction(Sender).Checked := true;
end;

procedure TfrmMain.acInvertSortExecute(Sender: TObject);
begin
  acInvertSort.Checked := not acInvertSort.Checked;
end;

procedure TfrmMain.acAddExecute(Sender: TObject);
var
  S: string;
begin
  S := '';
  if InputQuery(SAddSkipListTitle, SAddSkipListCaption, S) and (S <> '') and not InSkipList(S) then
    lbSkipList.Items.Add(ChangeFileExt(ExtractFilename(S), ''));
end;

procedure TfrmMain.acDeleteExecute(Sender: TObject);
var
  i: integer;
begin
  if not YesNo(SConfirmDelete, SDelSelItemsPrompt) then
    Exit;
  with lbSkipList do
    for i := Items.Count - 1 downto 0 do
      if Selected[i] then
        Items.Delete(i);
end;

procedure TfrmMain.acAboutExecute(Sender: TObject);
begin
  ShowMessage(SAboutText);
end;

procedure TfrmMain.acNewExecute(Sender: TObject);
begin
  if YesNo(SConfirmDelete, SClearDiagramPrompt) then
    Clear;
end;

procedure TfrmMain.alMainUpdate(Action: TBasicAction;
  var Handled: Boolean);
begin
  if csFreeNotification in ComponentState then
    Exit;
  acDelete.Enabled := lbSkipList.SelCount > 0;
  acNew.Enabled := sb.ControlCount > 0;
  acFind.Enabled := acNew.Enabled;
  acReport.Enabled := acNew.Enabled;

  // (p3) this might be too slow on large sets of shapes so comment it out
  // if it gets too sluggish
  acDelShape.Enabled := FSelected <> nil;
  acUnitStats.Enabled := acDelShape.Enabled;
  acAddToSkipList.Enabled := acDelShape.Enabled;
  acParseUnit.Enabled := acDelShape.Enabled;
end;

procedure TfrmMain.Load(Storage: TCustomIniFile);
begin
  Top := Storage.ReadInteger(ClassName, 'Top', Top);
  Left := Storage.ReadInteger(ClassName, 'Left', Left);
  Width := Storage.ReadInteger(ClassName, 'Width', Width);
  Height := Storage.ReadInteger(ClassName, 'Height', Height);
  acInvertSort.Checked := Storage.ReadBool(ClassName, 'InvertSort', false);
  FPrintFormat := TPrintFormat(Storage.ReadInteger(ClassName, 'Print Format', 0));
  FInitialDir := Storage.ReadString(ClassName, 'InitialDir', '');
  pnlSkipList.Width := Storage.ReadInteger(ClassName, 'vertSplitter', pnlSkipList.Width);
  if not acViewStatusBar.Checked = Storage.ReadBool(ClassName, acViewStatusBar.Name, acViewStatusBar.Checked) then
    acViewStatusBar.Execute; // toggle to other state
  if not acViewToolbar.Checked = Storage.ReadBool(ClassName, acViewToolbar.Name, acViewToolbar.Checked) then
    acViewToolbar.Execute;
  if not acViewSkipList.Checked = Storage.ReadBool(ClassName, acViewSkipList.Name, acViewSkipList.Checked) then
    acViewSkipList.Execute;
end;

procedure TfrmMain.Save(Storage: TCustomIniFile);
begin
  if not IsZoomed(Handle) and not IsIconic(Application.Handle) then
  begin
    Storage.WriteInteger(ClassName, 'Top', Top);
    Storage.WriteInteger(ClassName, 'Left', Left);
    Storage.WriteInteger(ClassName, 'Width', Width);
    Storage.WriteInteger(ClassName, 'Height', Height);
  end;
  Storage.WriteBool(ClassName, 'InvertSort', acInvertSort.Checked);
  Storage.WriteInteger(ClassName, 'Print Format', Ord(FPrintFormat));
  Storage.WriteString(ClassName, 'InitialDir', FInitialDir);
  Storage.WriteInteger(ClassName, 'vertSplitter', pnlSkipList.Width);
  Storage.WriteBool(ClassName, acViewStatusBar.Name, acViewStatusBar.Checked);
  Storage.WriteBool(ClassName, acViewToolbar.Name, acViewToolbar.Checked);
  Storage.WriteBool(ClassName, acViewSkipList.Name, acViewSkipList.Checked);
end;

procedure TfrmMain.LoadSettings;
var Ini: TIniFile;
begin
  LoadSkipList;
  Ini := TIniFile.Create(ChangeFileExt(Application.ExeName, cIniFileExt));
  try
    PersistSettings.LoadComponents(self, Ini);
  finally
    Ini.Free;
  end;
  Application.HintShortCuts := true;
end;

procedure TfrmMain.SaveSettings;
var Ini: TIniFile;
begin
  SaveSkipList;
  Ini := TIniFile.Create(ChangeFileExt(Application.ExeName, cIniFileExt));
  try
    PersistSettings.SaveComponents(self, Ini);
  finally
    Ini.Free;
  end;
end;

procedure TfrmMain.acUnitStatsExecute(Sender: TObject);
var
  AShape: TJvCustomDiagramShape;
  i:integer;
  S:string;
  UsedByStrings, UsesStrings: TStringlist;
begin
  AShape := FSelected;
  if AShape = nil then
    AShape := TJvCustomDiagramShape(popShape.PopupComponent);
  if AShape = nil then Exit;

  // (p3) collect the stats for the file
  // since we can't guarantee that the file can be found
  // on the system, only collect what we know explicitly (name, links):
  UsedByStrings := TStringlist.Create;
  UsesStrings := TStringlist.Create;
  try
    UsesUnits(AShape, UsesStrings);
    UsedByUnits(AShape, UsedByStrings);
    if UsedByStrings.Count < 1 then
      UsedByStrings.Add(SNone);
    if UsesStrings.Count < 1 then
      UsesStrings.Add(SNone);
    i := FFileShapes.IndexOfObject(AShape);
    if i > -1 then
      S := FFileShapes[i]
    else
      S := ChangeFileExt(AShape.Caption.Text, cPascalExt);
    TfrmUnitStats.Execute(S, UsedByStrings, UsesStrings);
  finally
    UsedByStrings.Free;
    UsesStrings.Free;
  end;
end;

procedure TfrmMain.acDelShapeExecute(Sender: TObject);
var AShape: TJvCustomDiagramShape;
  i: integer;
begin
  // (p3) Can't use TJvCustomDiagramShape.DeleteSelecetdShapes here since
  // we need to remove the item from the FFileShapes list as well:
  AShape := FSelected;
  if (AShape <> nil) and YesNo(SConfirmDelete, Format(SDelSelItemFmt, [AShape.Caption.Text])) then
  begin
    i := FFileShapes.IndexOfObject(AShape);
    if i > -1 then
      FFileShapes.Delete(i);
    FSelected := nil;
    AShape.Free;
  end;
end;

procedure TfrmMain.acReportExecute(Sender: TObject);
const
  cFormatExt: array[TPrintFormat] of PChar = ('.txt', '.htm', '.xml');
var
  S: TStringlist;
  AFileName: string;
begin
  S := TStringlist.Create;
  try
    if not TfrmPrint.Execute(FPrintFormat) then
      Exit;
    WaitCursor;
    CreatePrintOut(S, FPrintFormat);
    if S.Count > 0 then
    begin
      AFilename := ExtractFilePath(Application.Exename) + 'DependencyWalker' + cFormatExt[FPrintFormat];
      S.SaveToFile(AFilename);
      // show in default viewer: let user decide whether to print or not after viewing
      ShellExecute(Handle, 'open', PChar(AFilename), nil, nil, SW_SHOWNORMAL);
    end;
  finally
    S.Free;
  end;
end;


procedure TfrmMain.acFindExecute(Sender: TObject);
var S: string;
  i: integer;
begin
  S := '';
  if InputQuery(SFindTitle, SFindNameColon, S) and (S <> '') then
  begin
    i := FFileShapes.IndexOf(S);
    if i < 0 then
      ShowMessageFmt(SFindNotFoundFmt, [S])
    else
    begin
      TJvCustomDiagramShape(FFileShapes.Objects[i]).Selected := true;
      // (p3) the caption (mostly) extends further to the right than the image,
      // so scroll the caption to make as much of the shape as possible visible
      sb.ScrollInView(TJvCustomDiagramShape(FFileShapes.Objects[i]).Caption);
    end;
  end;
end;

procedure TfrmMain.acAddToSkipListExecute(Sender: TObject);
var ASHape: TJvCustomDiagramShape;
begin
  AShape := FSelected;
  if AShape <> nil then
  begin
    lbSkipList.Items.Add(ChangeFileExt(ExtractFilename(AShape.Caption.Text), ''));
    acDelShape.Execute;
  end;
end;

procedure TfrmMain.acViewStatusBarExecute(Sender: TObject);
begin
  acViewStatusBar.Checked := not acViewStatusBar.Checked;
  StatusBar1.Visible := acViewStatusBar.Checked;
end;

procedure TfrmMain.acViewSkipListExecute(Sender: TObject);
begin
  acViewSkipList.Checked := not acViewSkipList.Checked;
  pnlSkipList.Visible := acViewSkipList.Checked;
  vertSplitter.Visible := acViewSkipList.Checked;
  if pnlSkipList.Visible then
    vertSplitter.Left := pnlSkipList.Left;
end;

procedure TfrmMain.acViewToolBarExecute(Sender: TObject);
begin
  acViewToolBar.Checked := not acViewToolBar.Checked;
  cbToolbar.Visible := acViewToolBar.Checked;
end;

procedure TfrmMain.acRefreshExecute(Sender: TObject);
begin
  sb.Invalidate;
end;

function Max(Val1, Val2: integer): integer;
begin
  Result := Val1;
  if Val2 > Val1 then
    Result := Val2;
end;

// (p3) probably not the most effective code in the world but it does seem to work...

procedure PaintScrollBox(sb: TScrollBox; Canvas: TCanvas);
var sbPos: TPoint;
    tmpPos: integer;
begin
  sbPos.X := sb.HorzScrollBar.Position;
  sbPos.Y := sb.VertScrollBar.Position;
  try
    sb.HorzScrollBar.Position := 0;
    sb.VertScrollBar.Position := 0;
    while true do
    begin
      while true do
      begin
        sb.PaintTo(Canvas, sb.HorzScrollBar.Position, sb.VertScrollBar.Position);
        tmpPos := sb.VertScrollBar.Position;
        sb.VertScrollBar.Position := sb.VertScrollBar.Position + sb.ClientHeight;
        if sb.VertScrollBar.Position = tmpPos then
          Break;
      end;
      sb.VertScrollBar.Position := 0;
      tmpPos := sb.HorzScrollBar.Position;
      sb.HorzScrollBar.Position := sb.HorzScrollBar.Position + sb.ClientWidth;
      if sb.HorzScrollBar.Position = tmpPos then
        Break;
    end;
  finally
    sb.HorzScrollBar.Position := sbPos.X;
    sb.VertScrollBar.Position := sbPos.Y;
  end;
end;

procedure TfrmMain.CreateDiagramBitmap(Bmp: TBitmap);
begin
    // add some extra pixels around the edges...
  bmp.Width := Max(sb.ClientWidth, sb.HorzScrollBar.Range) + 10;
  bmp.Height := Max(sb.ClientHeight, sb.VertScrollBar.Range) + 10;
  bmp.Canvas.Brush.Color := sb.Color;
  bmp.Canvas.FillRect(Rect(0, 0, bmp.Width, bmp.Height));
  PaintScrollBox(sb, bmp.Canvas);
end;

procedure TfrmMain.acSaveBMPExecute(Sender: TObject);
var b: TBitmap;
begin
  if dlgSaveImage.Execute then
  begin
    b := TBitmap.Create;
    try
      CreateDiagramBitmap(b);
      b.SaveToFile(dlgSaveImage.Filename);
    finally
      b.Free;
    end;
    ShellExecute(Handle, 'open', PChar(dlgSaveImage.Filename), nil, nil, SW_SHOWNORMAL);
  end;
end;

procedure TfrmMain.acCopyExecute(Sender: TObject);
var
  AFormat : Word;
  b:TBitmap;
  AData:Cardinal;
  APalette : HPALETTE;
begin
  b := TBitmap.Create;
  try
    CreateDiagramBitmap(b);
    b.SaveToClipboardFormat(AFormat,AData,APalette);
    Clipboard.SetAsHandle(AFormat,AData);
  finally
    b.Free;
  end;
end;

procedure TfrmMain.acSaveDiagramExecute(Sender: TObject);
begin
  with TSaveDialog.Create(nil) do
  try
    if Execute then
      TJvCustomDiagramShape.SaveToFile(Filename,sb);
  finally
    Free;
  end;
end;

procedure TfrmMain.acOpenDiagramExecute(Sender: TObject);
begin
  with TOpenDialog.Create(nil) do
  try
    if Execute then
    begin
      FFileShapes.Clear;
      TJvCustomDiagramShape.LoadFromFile(Filename,sb);
      // TODO: update FFileShapes list with new items
      // NB! loading a saved diagram looses the info about interface/implementation uses!
    end;
  finally
    Free;
  end;
end;

procedure TfrmMain.sbMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if FSelected <> nil then
    FSelected.Selected := false;
  FSelected := nil;
end;

procedure TfrmMain.acParseUnitExecute(Sender: TObject);
var Errors:TStringList;i:integer;
begin
  WaitCursor;
  i := FFileShapes.IndexOfObject(FSelected);
  if i < 0 then
  begin
    if FSelected <> nil then
      ShowMessageFmt('Unit %s not found!',[FSelected.Caption.Text])
    else
      ShowMessage('Unit not found!');
    Exit;
  end;

  Errors := TStringlist.Create;
  try
    ParseUnit(FFileShapes[i],Errors);
      if Errors.Count > 0 then
      begin
        ShowMessageFmt(SParseErrorsFmt, [Errors.Text]);
        // copy to clipboard as well
        Clipboard.SetTextBuf(PChar(Errors.Text));
      end;
  finally
    Errors.Free;
  end;
end;


end.

