{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvUnicodeCanvas.PAS, released on 2003-09-21

The Initial Developers of the Original Code are: Andreas Hausladen <Andreas.Hausladen@gmx.de>
Copyright (c) 2003 Andreas Hausladen
All Rights Reserved.

Contributor(s):

Last Modified: 2003-10-31

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}

{$I JVCL.INC}

unit JvUnicodeCanvas;

interface

uses
  SysUtils,
  {$IFDEF VCL}
  Windows, Graphics,
  {$ENDIF VCL}
  {$IFDEF VisualCLX}
  Qt, Types, QGraphics,
  {$ENDIF VisualCLX}
  Classes, JvClxUtils, JvJCLUtils;

type
  TJvExtTextOutOptionsType = (etoClipped, etoOpaque);
  TJvExtTextOutOptions = Set of TJvExtTextOutOptionsType;

  { This Canvas has no new fields and can be type-casted form every TCanvas
    derived class. }
  TJvUnicodeCanvas = class(TCanvas)
  public
    function TextExtentW(const Text: WideString): TSize;
    function TextWidthW(const Text: WideString): Integer;
    function TextHeightW(const Text: WideString): Integer;
    procedure TextOutW(X, Y: Integer; const Text: WideString);
    procedure TextRectW(Rect: TRect; X, Y: Integer; const Text: WideString);
    function ExtTextOutW(X, Y: Integer; Options: TJvExtTextOutOptions; Rect: PRect;
      const Text: WideString; lpDx: Pointer): Boolean;

    function ExtTextOut(X, Y: Integer; Options: TJvExtTextOutOptions; Rect: PRect;
      const Text: String; lpDx: Pointer): Boolean; overload;
    {$IFDEF COMPILER6_UP}
    function ExtTextOut(X, Y: Integer; Options: TJvExtTextOutOptions;
      Rect: PRect; const Text: WideString; lpDx: Pointer): Boolean; overload;
    {$ENDIF}

    {$IFDEF VCL}
    {$IFDEF COMPILER6_UP}
    function TextExtent(const Text: WideString): TSize; overload;
    function TextWidth(const Text: WideString): Integer; overload;
    function TextHeight(const Text: WideString): Integer; overload;
    procedure TextOut(X, Y: Integer; const Text: WideString); overload;
    procedure TextRect(Rect: TRect; X, Y: Integer; const Text: WideString); overload;
    {$ENDIF}
    {$ENDIF VCL}

    {$IFDEF VisualCLX}
    procedure TextOutVCL(X, Y: Integer; const Text: WideString);
    procedure TextRectVCL(Rect: TRect; X, Y: Integer;
      const Text: WideString; TextFlags: Integer = 0);
    {$ENDIF VisualCLX}
  end;

implementation

{$IFDEF VCL}

function ExtTextOutOptionsToInt(Options: TJvExtTextOutOptions): Integer;
begin
  Result := 0;
  if etoClipped in Options then
    Result := Result or ETO_CLIPPED;
  if etoOpaque in Options then
    Result := Result or ETO_OPAQUE;
end;

function TJvUnicodeCanvas.TextExtentW(const Text: WideString): TSize;
begin
  Result.cX := 0;
  Result.cY := 0;
  Windows.GetTextExtentPoint32W(Handle, PWideChar(Text), Length(Text), Result);
end;

procedure TJvUnicodeCanvas.TextOutW(X, Y: Integer; const Text: WideString);
var W: Integer;
begin
  Changing;
  W := TextWidth(Text);
  if CanvasOrientation = coRightToLeft then
    Inc(X, W + 1);
  Windows.ExtTextOutW(Handle, X, Y, TextFlags, nil, PWideChar(Text), Length(Text), nil);
  MoveTo(X + W, Y);
  Changed;
end;

procedure TJvUnicodeCanvas.TextRectW(Rect: TRect; X, Y: Integer; const Text: WideString);
var
  Options: Longint;
begin
  Changing;
  Options := ETO_CLIPPED or TextFlags;
  if Brush.Style <> bsClear then
    Options := Options or ETO_OPAQUE;
  if ((TextFlags and ETO_RTLREADING) <> 0) and (CanvasOrientation = coRightToLeft) then
    Inc(X, TextWidth(Text) + 1);
  Windows.ExtTextOutW(Handle, X, Y, Options, @Rect, PWideChar(Text), Length(Text), nil);
  Changed;
end;

function TJvUnicodeCanvas.TextWidthW(const Text: WideString): Integer;
begin
  Result := TextExtent(Text).cx;
end;

function TJvUnicodeCanvas.TextHeightW(const Text: WideString): Integer;
begin
  Result := TextExtent(Text).cy;
end;

{$IFDEF COMPILER6_UP}

function TJvUnicodeCanvas.TextExtent(const Text: WideString): TSize;
begin
  Result := TextExtentW(Text);
end;

function TJvUnicodeCanvas.TextHeight(const Text: WideString): Integer;
begin
  Result := TextHeightW(Text);
end;

procedure TJvUnicodeCanvas.TextOut(X, Y: Integer; const Text: WideString);
begin
  TextOutW(X, Y, Text);
end;

procedure TJvUnicodeCanvas.TextRect(Rect: TRect; X, Y: Integer;
  const Text: WideString);
begin
  TextRectW(Rect, X, Y, Text);
end;

function TJvUnicodeCanvas.TextWidth(const Text: WideString): Integer;
begin
  Result := TextWidthW(Text);
end;

function TJvUnicodeCanvas.ExtTextOut(X, Y: Integer; Options: TJvExtTextOutOptions; Rect: PRect;
  const Text: WideString; lpDx: Pointer): Boolean;
begin
  Result := ExtTextOutW(X, Y, Options, Rect, Text, lpDx);
end;

{$ENDIF COMPILER6_UP}

{$ENDIF VCL}


{$IFDEF VisualCLX}

function TJvUnicodeCanvas.TextExtentW(const Text: WideString): TSize;
begin
  Result := TextExtent(Text);
end;

function TJvUnicodeCanvas.TextHeightW(const Text: WideString): Integer;
begin
  Result := TextHeight(Text);
end;

procedure TJvUnicodeCanvas.TextOutW(X, Y: Integer; const Text: WideString);
begin
  TextOutVCL( X, Y, Text);
end;

procedure TJvUnicodeCanvas.TextRectW(Rect: TRect; X, Y: Integer;
  const Text: WideString);
begin
  TextRectVCL(Rect, X, Y, Text);
end;

function TJvUnicodeCanvas.TextWidthW(const Text: WideString): Integer;
begin
  Result := TextWidth(Text);
end;

procedure TJvUnicodeCanvas.TextOutVCL(X, Y: Integer; const Text: WideString);
var
  R: TRect;
begin
  if Brush.Style = bsSolid then
  begin
    R := Rect(0, 0, MaxLongint, MaxLongint);
    TextExtent(Text, R);
    OffsetRect(R, X, Y);
    FillRect(R);
  end;
  TextOut(X, Y, Text);
end;

procedure TJvUnicodeCanvas.TextRectVCL(Rect: TRect; X, Y: Integer;
  const Text: WideString; TextFlags: Integer = 0);
begin
  if Brush.Style = bsSolid then
    FillRect(Rect);
  TextRect(Rect, X, Y, Text, TextFlags);
end;

{$ENDIF VisualCLX}

function TJvUnicodeCanvas.ExtTextOut(X, Y: Integer; Options: TJvExtTextOutOptions; Rect: PRect;
  const Text: String; lpDx: Pointer): Boolean;
begin
  Result := ClxExtTextOut(Self, X, Y, ExtTextOutOptionsToInt(Options), Rect, Text, lpDx);
end;

function TJvUnicodeCanvas.ExtTextOutW(X, Y: Integer; Options: TJvExtTextOutOptions;
  Rect: PRect; const Text: WideString; lpDx: Pointer): Boolean;
begin
  Result := ClxExtTextOutW(Self, X, Y, ExtTextOutOptionsToInt(Options), Rect, Text, lpDx);
end;

end.
