object RunningDocumentsForm: TRunningDocumentsForm
  Left = 305
  Top = 229
  Width = 247
  Height = 260
  BorderStyle = bsSizeToolWin
  Caption = 'Running Documents'
  Color = clBtnFace
  DockSite = True
  DragKind = dkDock
  DragMode = dmAutomatic
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = '����'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 12
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 239
    Height = 232
    Align = alClient
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Caption = 'Panel1'
    TabOrder = 0
    object RichEdit1: TRichEdit
      Left = 2
      Top = 2
      Width = 235
      Height = 228
      Align = alClient
      BorderStyle = bsNone
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = '����'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
  end
  object lbDockClient1: TJvDockClient
    LRDockWidth = 100
    TBDockHeight = 100
    DirectDrag = False
    ShowHint = True
    DockStyle = MainForm.JvDockVIDStyle1
    Left = 64
    Top = 88
  end
end
