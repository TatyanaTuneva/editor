Unit FiguresUnit;

Interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Menus, ActnList, GraphMath, ScaleUnit, LCLType, LCLIntf, LCL, StdCtrls, Grids,
   Buttons, Math, Spin, FPCanvas, TypInfo,  Windows;

type

StringArray = array of string;
                                                                 // 2 - rectangle ellipce
TFigure = class                                                  // 3 - rrectangle
  Selected, SelectedChangeSize: boolean;                         // 1 - line polyline
  Index: integer;
  Region: HRGN;
  Points: array of TFloatPoint;
  procedure Draw(ACanvas:TCanvas); virtual; abstract;
  procedure SetRegion; Virtual; abstract;
  procedure DrawSelection(AFigure: TFigure; Canvas: TCanvas; Width: integer);   virtual;
  function Save(AFigure: TFigure): StringArray; virtual; abstract;
  class procedure Download(n: integer; a: StringArray); virtual; abstract;
end;

TLittleFigure = class(TFigure)
  PenColor: TColor;
  PenStyle: TPenStyle;
  Width: integer;
  procedure Draw(ACanvas:TCanvas); override;
  procedure SetRegion; override;
  function Save(AFigure: TFigure): StringArray; override;
  class  procedure Download(n: integer; a: StringArray); override;
end;

TBigFigure = class(TLittleFigure)
  BrushColor: TColor;
  BrushStyle: TBrushStyle;
  RoundingRadiusX: integer;
  RoundingRadiusY: Integer;
  procedure Draw(ACanvas:TCanvas); override;
  procedure SetRegion; override;
  function Save(AFigure: TFigure): StringArray; override;
  class  procedure Download(n: integer; a: StringArray);
end;

TPolyLine = class(TLittleFigure)
  max, min: TFloatPoint;
  procedure Draw(ACanvas:TCanvas); override;
  procedure SetRegion; override;
  function Save(AFigure: TFigure): StringArray; override;
  class  procedure Download(n: integer; a: StringArray);
end;

TLine = class(TLittleFigure)
  procedure Draw(ACanvas:TCanvas); override;
  procedure SetRegion; override;
  function Save(AFigure: TFigure): StringArray; override;
  class  procedure Download(n: integer; a: StringArray);
end;

TEllipce = class(TBigFigure)
  procedure Draw(ACanvas:TCanvas); override;
  procedure SetRegion; override;
  function Save(AFigure: TFigure): StringArray; override;
  class  procedure Download(n: integer; a: StringArray);
end;

TRectangle = class(TBigFigure)
  procedure Draw(ACanvas:TCanvas); override;
  procedure SetRegion; override;
  function Save(AFigure: TFigure): StringArray; override;
  class  procedure Download(n: integer; a: StringArray);
end;

TRectangleMagnifier = class(TLittleFigure)
  BrushStyle: TBrushStyle;
  BrushColor: TColor;
  procedure Draw(ACanvas:TCanvas); override;
end;

TRoundedRectangle = class (TBigFigure)
  procedure Draw(ACanvas:TCanvas); override;
  procedure SetRegion; override;
  function Save(AFigure: TFigure): StringArray; override;
  class  procedure Download(n: integer; a: StringArray);

end;

  TFigureClass    = class  of TFigure;
  Figures1 =  array of TFigure;


procedure CreateArrayOfActions();
procedure RefreshFigures(N: integer);
function RefreshArrays(B: Figures1): Figures1;
procedure LineRegion(p1,p2:TPoint;var tempPoints: array of TPoint;Width: integer);
procedure StopUndo();

var
  Figures: array of TFigure;
  Buffer: array of TFigure;
  Now: Integer;
  UndoFlag: Boolean;
  ArrayOfActions: array of Figures1;

const PStyles: array[0..5] of TPenStyle = (psSolid, psClear, psDot,
psDash, psDashDot, psDashDotDot);

const BStyles: array [0..7] of TBrushStyle = (bsSolid, bsClear,
bsHorizontal, bsVertical, bsFDiagonal, bsBDiagonal, bsCross, bsDiagCross);

Implementation

procedure CreateArrayOfActions();
begin
  SetLength(ArrayOfActions, Length(ArrayOfActions) + 1);
  SetLength(ArrayOfActions[High(ArrayOfActions)], Length(Figures));
  ArrayOfActions[High(ArrayOfActions)] := RefreshArrays(Figures);
  Now := Now + 1;
end;

procedure RefreshFigures(N: integer);
begin
  SetLength(Figures, 0);
  SetLength(Figures, Length(ArrayOfActions[N]));
  Figures := RefreshArrays(ArrayOfActions[N]);
end;

function RefreshArrays(B: Figures1): Figures1;        // из B перенoсим в А
var
  a: Figures1;
  i, q: integer;
begin
  SetLength(A, Length(B));
  for i := 0 to high(B) do begin
  case B[i].ClassName of

    'TPolyLine':         A[i] := TPolyLine.Create;
    'TLine'    :         A[i] := TLine.Create;
    'TEllipce' :         begin
                           A[i] := TEllipce.Create;
                           (A[i]as TBigFigure).BrushColor := (B[i] as TBigFigure).BrushColor;
                           (A[i] as TBigFigure).BrushStyle := (B[i] as TBigFigure).BrushStyle;
                         end;
    'TRectangle':        begin
                           A[i] := TRectangle.Create;
                           (A[i] as TBigFigure).BrushColor := (B[i] as TBigFigure).BrushColor;
                           (A[i] as TBigFigure).BrushStyle := (B[i] as TBigFigure).BrushStyle;
                         end;
    'TRoundedRectangle': begin
                           A[i] := TRoundedRectangle.Create;
                           (A[i]as TBigFigure).BrushColor := (B[i] as TBigFigure).BrushColor;
                           (A[i] as TBigFigure).BrushStyle := (B[i] as TBigFigure).BrushStyle;
                           (A[i] as TRoundedRectangle).RoundingRadiusX := (B[i] as TRoundedRectangle).RoundingRadiusX;
                           (A[i] as TRoundedRectangle).RoundingRadiusY := (B[i] as TRoundedRectangle).RoundingRadiusY;
                         end;
  end;
  SetLength(A[i].Points, Length(B[i].Points));
  for q := 0 to Length(B[i].Points) do A[i].Points[q] := B[i].Points[q];

  (A[i] as TLittleFigure).PenColor := (B[i] as TLittleFigure).PenColor;
  (A[i] as TLittleFigure).PenStyle := (B[i] as TLittleFigure).PenStyle;
  (A[i] as TLittleFigure).Width := (B[i] as TLittleFigure).Width;
end;
  Result := A;
end;

procedure StopUndo();
begin
  SetLength(ArrayOfActions, Now + 1);
  UndoFlag := False;
end;

procedure TFigure.DrawSelection(AFigure: TFigure; Canvas: TCanvas; Width: integer);
var
  Point1, Point2, a:TFloatPoint;
  i: integer;
begin
If length(AFigure.Points) = 2 then begin
   Point1.X := AFigure.Points[0].X;
   Point1.Y := AFigure.Points[0].Y;
   Point2.X := AFigure.Points[1].X;
   Point2.Y := AFigure.Points[1].Y;

  if (Point1.X>Point2.X) then
    begin
      a.X:=Point1.X;
      Point1.X:=Point2.X;
      Point2.X:=a.X;
    end;
  if (Point1.Y>Point2.Y) then
    begin
      a.Y:=Point1.Y;
      Point1.Y:=Point2.Y;
      Point2.Y:=a.Y;
    end;
  Canvas.Pen.Color := clBlack;
  Canvas.Pen.Width := 1;
  Canvas.Pen.Style := psDash;
  Canvas.Brush.Color := clBlack;
  Canvas.Frame(WorldToScreen(Point1).x - 5 - Width div 2,WorldToScreen(Point1).y - 5 - Width div 2,
               WorldToScreen(Point2).x + 5 + Width div 2,WorldToScreen(Point2).y + 5 + Width div 2);

  Canvas.Rectangle(WorldToScreen(Point1).x - 15 - Width div 2,
                   WorldToScreen(Point1).y - 15 - Width div 2,
                   WorldToScreen(Point1).x - 5 - Width div 2,
                   WorldToScreen(Point1).y - 5 - width div 2);

  Canvas.Rectangle(WorldToScreen(Point2).x + 15 - Width div 2,
                   WorldToScreen(Point2).y + 15 - Width div 2,
                   WorldToScreen(Point2).x + 5 - Width div 2,
                   WorldToScreen(Point2).y + 5 - width div 2);

  Canvas.Rectangle(WorldToScreen(Point2).x + 15 - Width div 2,
                   WorldToScreen(Point1).y - 15 - Width div 2,
                   WorldToScreen(Point2).x + 5 - Width div 2,
                   WorldToScreen(Point1).y - 5 - width div 2);

  Canvas.Rectangle(WorldToScreen(Point1).x - 15 - Width div 2,
                   WorldToScreen(Point2).y + 15 - Width div 2,
                   WorldToScreen(Point1).x - 5 - Width div 2,
                   WorldToScreen(Point2).y + 5 - width div 2);



 end else begin
   for i:=0 to high(AFigure.points) do begin
     Canvas.Pen.Color := clBlack;
     Canvas.Pen.Width := 1;
     Canvas.Pen.Style := psDash;
     Canvas.Brush.Color := clBlack;
     Canvas.Rectangle(WorldToScreen((AFigure as TPolyLine).points[i]).x - 5 - Width div 2,
                     WorldToScreen((AFigure as TPolyLine).points[i]).y - 5 - Width div 2,
                     WorldToScreen((AFigure as TPolyLine).points[i]).x + 5 - Width div 2,
                     WorldToScreen((AFigure as TPolyLine).points[i]).y + 5 - width div 2);
   end;
 end;
end;

procedure TLittleFigure.Draw(ACanvas:TCanvas);
begin
  ACanvas.Pen.Color := PenColor;
  ACanvas.Pen.Style := PenStyle;
  ACanvas.Pen.Width := Width;
end;

procedure TBigFigure.Draw(ACanvas:TCanvas);
begin
  Inherited;
  ACanvas.Brush.Style := BrushStyle;
  ACanvas.Brush.Color := BrushColor;
end;

procedure TLine.Draw(ACanvas:TCanvas);
begin
  Inherited;
  ACanvas.Line(WorldToScreen(Points[0]).x,WorldToScreen(Points[0]).Y,WorldToScreen(Points[1]).x,WorldToScreen(Points[1]).Y);
end;

procedure TPolyLine.Draw(ACanvas:TCanvas);
var
i: integer;
begin
  Inherited;
  for i:=1 to high(Points)-1 do
  ACanvas.Line(WorldToScreen(Points[i]), WorldToScreen(Points[i+1]));
end;

procedure TEllipce.Draw(ACanvas:TCanvas);
begin
  Inherited;
  ACanvas.Ellipse(WorldToScreen(Points[0]).x,WorldToScreen(Points[0]).Y,WorldToScreen(Points[1]).x,WorldToScreen(Points[1]).Y);
end;

procedure TRectangle.Draw(ACanvas:TCanvas);
begin
  Inherited;
  ACanvas.Rectangle(WorldToScreen(Points[0]).x,WorldToScreen(Points[0]).Y,WorldToScreen(Points[1]).x,WorldToScreen(Points[1]).Y);
end;

procedure TRectangleMagnifier.Draw(ACanvas:TCanvas);
begin
  Inherited;
  ACanvas.Frame(WorldToScreen(Points[0]).x,WorldToScreen(Points[0]).Y,WorldToScreen(Points[1]).x,WorldToScreen(Points[1]).Y);
end;

procedure TRoundedRectangle.Draw(ACanvas:TCanvas);
begin
  Inherited;
  ACanvas.RoundRect(WorldToScreen(Points[0]).x,WorldToScreen(Points[0]).Y,WorldToScreen(Points[1]).x,WorldToScreen(Points[1]).Y,
                   RoundingRadiusX, RoundingRadiusY);
end;

procedure SetOffset (APoint: TFloatPoint);
begin
  Offset := APoint;
end;

procedure TBigFigure.SetRegion;
begin
end;

procedure TLittleFigure.SetRegion;
begin
end;

procedure TRectangle.SetRegion;
var
  RegionRect: TRect;
begin
  RegionRect.TopLeft := WorldToScreen(Points[0]);
  RegionRect.BottomRight := WorldToScreen(Points[1]);
  Region := CreateRectRgn (RegionRect.Left,RegionRect.Top,
    RegionRect.Right,RegionRect.Bottom);
end;

procedure TEllipce.SetRegion;
var
  RegionRect: TRect;
begin
  RegionRect.TopLeft := WorldToScreen(Points[0]);
  RegionRect.BottomRight := WorldToScreen(Points[1]);
  Region := CreateEllipticRgn (RegionRect.Left,RegionRect.Top,RegionRect.Right,RegionRect.Bottom);
end;

procedure TRoundedRectangle.SetRegion;
var
  RegionRect: TRect;
begin
  RegionRect.TopLeft := WorldToScreen(Points[0]);
  RegionRect.BottomRight := WorldToScreen(Points[1]);
  Region := CreateRoundRectRgn (RegionRect.Left,RegionRect.Top,RegionRect.Right,
    RegionRect.Bottom,RoundingRadiusX,RoundingRadiusY);
end;

procedure TLine.SetRegion;
var
  RegionPoints: array[0..3] of TPoint;
  p1,p2: TPoint;
begin
  p1 := WorldToScreen(Points[0]);
  p2 := WorldToScreen(Points[1]);
  LineRegion(p1,p2,RegionPoints,Width);
  Region := CreatePolygonRgn(RegionPoints,3,2);
end;

procedure TPolyline.SetRegion;
var
  RegionPoints: array[0..3] of TPoint;
  p1,p2: TPoint;
  curRgn: HRGN;
  i: integer;
begin
  for i := 0 to high(Points)-1 do
  begin
    p1 := WorldToScreen(Points[i]);
    p2 := WorldToScreen(Points[i+1]);
    LineRegion(p1,p2,RegionPoints,Width);
    if (i=low(Points)) then Region := CreatePolygonRgn (RegionPoints,3,2);
    curRgn := CreatePolygonRgn (RegionPoints,3,2);
    CombineRgn (Region,Region,curRgn,RGN_OR);
    DeleteObject(curRgn);
  end;
end;

procedure LineRegion(p1,p2:TPoint;var tempPoints: array of TPoint;Width:integer);
begin
      if (abs(p2.x-p1.x)>45) then
    begin
      tempPoints[0].x := p1.x-Width div 2;
      tempPoints[0].y := p1.y-5-Width;
      tempPoints[1].x := p2.x+Width div 2;
      tempPoints[1].y := p2.y-5-Width;
      tempPoints[2].x := p2.x+Width div 2;
      tempPoints[2].y := p2.y+5+Width;
      tempPoints[3].x := p1.x-Width div 2;
      tempPoints[3].y := p1.y+5+Width;
    end else
    begin
      tempPoints[0].x := p1.x-5-Width;
      tempPoints[0].y := p1.y-Width div 2;
      tempPoints[1].x := p2.x-5-Width;
      tempPoints[1].y := p2.y+Width div 2;
      tempPoints[2].x := p2.x+5+Width;
      tempPoints[2].y := p2.y+Width div 2;
      tempPoints[3].x := p1.x+5+Width;
      tempPoints[3].y := p1.y-Width div 2;
    end;
end;


/////////////////////////SAVE///////////////////////////////////

function TLittleFigure.Save(AFigure: TFigure): StringArray;
begin
  SetLength(Save, 7);
  Save[0] := FloatToStr((AFigure as TLittleFigure).Points[0].X);
  Save[1] := FloatToStr((AFigure as TLittleFigure).Points[0].Y);
  Save[2] := FloatToStr((AFigure as TLittleFigure).Points[1].X);
  Save[3] := FloatToStr((AFigure as TLittleFigure).Points[1].Y);
  Save[4] := IntToStr((AFigure as TLittleFigure).Width);
  Save[5] := IntToStr(ord((AFigure as TLittleFigure).PenStyle));
  Save[6] := ColorToString((AFigure as TLittleFigure).PenColor);
end;

function TBigFigure.Save(AFigure: TFigure): StringArray;
begin
  Save:=Inherited Save(AFigure);
  SetLength(Save, Length(Save) + 2);
  Save[High(Save) - 1] := IntToStr(ord((AFigure as TBigFigure).BrushStyle));
  Save[High(Save)] :=  ColorToString((AFigure as TBigFigure).BrushColor);
end;

function TRectangle.Save(AFigure: TFigure): StringArray;
begin
  Save:=Inherited Save(AFigure);
end;

function TEllipce.Save(AFigure: TFigure): StringArray;
begin
  Save:=Inherited Save(AFigure);
end;

function TLine.Save(AFigure: TFigure): StringArray;
begin
  Save:=Inherited Save(AFigure);
end;

function TPolyline.Save(AFigure: TFigure): StringArray;
var
  i, j: integer;
begin
  SetLength(Save, 2 * Length(AFigure.Points) + 4);
  Save[0]:=IntToStr(Length(AFigure.Points));
  Save[1]:=IntToStr((AFigure as TLittleFigure).Width);
  Save[2] := IntToStr(ord((AFigure as TLittleFigure).PenStyle));
  Save[3]:= ColorToString((AFigure as TLittleFigure).PenColor);
  i := 4;
  for j:=0 to high(AFigure.Points)do begin
    Save[i]:=FloatToStr(AFigure.Points[j].x);
    Save[i + 1]:=FloatToStr(AFigure.Points[j].y);
    i := i + 2;
  end;
end;

function TRoundedRectangle.Save(AFigure: TFigure): StringArray;
begin
  Save:=Inherited Save(AFigure);
  SetLength(Save, Length(Save) + 2);
  Save[high(Save) - 1]:=IntToStr((AFigure as TRoundedRectangle).RoundingRadiusX);
  Save[high(Save)]:=IntToStr(((AFigure as TRoundedRectangle).RoundingRadiusY));
end;

////////////DOWNLOAD////////////////////////////////////////////

class procedure TLittleFigure.Download(n: integer; a: StringArray);
begin
  SetLength(Figures[n].Points, 2);
  Figures[n].Points[0].X := StrToFloat(a[0]);
  Figures[n].Points[0].Y := StrToFloat(a[1]);
  Figures[n].Points[1].X := StrToFloat(a[2]);
  Figures[n].Points[1].Y := StrToFloat(a[3]);
 (Figures[n] as TLittleFigure).Width := StrToInt(a[4]);
 (Figures[n] as TLittleFigure).PenStyle := PStyles[StrToInt(a[5])];
 (Figures[n] as TLittleFigure).PenColor := StringToColor(a[6]);
end;

class procedure TBigFigure.Download(n: integer; a: StringArray);
begin
  Inherited Download(n,a);
  (Figures[n] as TBigFigure).BrushStyle := BStyles[StrToInt(a[7])];
  (Figures[n] as TBigFigure).BrushColor := StringToColor(a[8]);
end;

class procedure TRectangle.Download(n: integer; a: StringArray);
begin
  Figures[n] := TRectangle.Create();
  Inherited Download(n,a);
end;

class procedure TEllipce.Download(n: integer; a: StringArray);
begin
  Figures[n] := TEllipce.Create();
  Inherited Download(n,a);
end;

class procedure TRoundedRectangle.Download(n: integer; a: StringArray);
begin
  Figures[n] := TRoundedRectangle.Create;
  Inherited Download(n,a);
  (Figures[n] as TRoundedRectangle).RoundingRadiusX := StrToInt(a[9]);
  (Figures[n] as TRoundedRectangle).RoundingRadiusY := StrToInt(a[10]);
end;

class procedure TLine.Download(n: integer; a: StringArray);
begin
  Figures[n] := TLine.Create;
  Inherited Download(n,a);
end;

class procedure TPolyLine.Download(n: integer; a: StringArray);
var
   i, j: integer;
begin
  Figures[n] := TPolyLine.Create();
  SetLength(Figures[n].Points, StrToInt(a[0]));
  (Figures[n] as TLittleFigure).Width := StrToInt(a[1]);
  (Figures[n] as TLittleFigure).PenStyle := PStyles[StrToInt(a[2])];
  (Figures[n] as TLittleFigure).PenColor := StringToColor(a[3]);
  i := 4;
  for j:=0 to (strtoint(a[0])) * 2 - 1 do begin
    Figures[n].Points.[j].x:=StrToFloat(a[i]);
    Figures[n].Points.[j].y:=StrToFloat(a[i + 1]);
    i:= i + 2;
  end;
end;


begin
  Now := 0;
end.
