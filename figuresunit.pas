Unit FiguresUnit;

Interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Menus, ActnList, GraphMath, ScaleUnit, LCLType, LCLIntf, LCL, StdCtrls, Grids,
   Buttons, Math, Spin, FPCanvas, TypInfo,  Windows;

type

TFigureClass    = class  of TFigure;
tempPointsArray = array[0..3] of TPoint;
PolygonPointsArray = array of TPoint;
StringArray = array of string;

TFigure = class
  Selected: boolean;
  Region: HRGN;
  Points: array of TFloatPoint;
  procedure Draw(ACanvas:TCanvas); virtual;abstract;
  procedure SetRegion; Virtual; abstract;
  procedure DrawSelection(AFigure: TFigure; Canvas: TCanvas);  virtual;
end;

TLittleFigure = class(TFigure)
  PenColor: TColor;
  PenStyle: TPenStyle;
  Width: integer;
  procedure Draw(ACanvas:TCanvas); override;
  procedure SetRegion; override;
end;

TBigFigure = class(TLittleFigure)
  BrushColor: TColor;
  BrushStyle: TBrushStyle;
  RoundingRadiusX: integer;
  RoundingRadiusY: Integer;
  procedure Draw(ACanvas:TCanvas); override;
  procedure SetRegion; override;
end;

TPolyLine = class(TLittleFigure)
  procedure Draw(ACanvas:TCanvas); override;
  procedure SetRegion; override;
end;

TLine = class(TLittleFigure)
  procedure Draw(ACanvas:TCanvas); override;
  procedure SetRegion; override;
end;

TEllipce = class(TBigFigure)
  procedure Draw(ACanvas:TCanvas); override;
  procedure SetRegion; override;
end;

TRectangle = class(TBigFigure)
  procedure Draw(ACanvas:TCanvas); override;
  procedure SetRegion; override;
end;

TRectangleMagnifier = class(TLittleFigure)
  BrushStyle: TBrushStyle;
  BrushColor: TColor;
  procedure Draw(ACanvas:TCanvas); override;
end;

TRoundedRectangle = class (TBigFigure)
  procedure Draw(ACanvas:TCanvas); override;
  procedure SetRegion; override;
end;

procedure LineRegion(p1,p2:TPoint;var tempPoints: array of TPoint;Width:integer);

var
  Figures: array of TFigure;
  layer: array of Tfigure;

Implementation


procedure TFigure.DrawSelection(AFigure: TFigure; Canvas: TCanvas);
var
  lP,hP, pt1, pt2: TPoint;
begin
  Canvas.Pen.Color := clBlack;
  Canvas.Brush.Color := clWhite;
  Canvas.Pen.Style := psSolid;
  Canvas.Brush.Style := bsSolid;
  Canvas.Pen.Width := 1;

  pt1 := AFigure.Points[0];
  pt2 := AFigure.Points[1];

  if Pt1.x < Pt2.x then lP.x := Pt1.X else lP.x := Pt2.X;
  if Pt1.y < Pt2.y then lP.y := Pt1.y else lP.y := Pt2.y;

  if Pt1.x > Pt2.x then hP.x := Pt1.X else hP.x := Pt2.X;
  if Pt1.y > Pt2.y then hP.x := Pt1.X else hP.x := Pt2.X;

  Canvas.Rectangle(lp.X-5, lP.y-5, lP.x+5, lP.y+5);
  Canvas.Rectangle(hP.x-5, hP.y-5, hP.x+5, hP.y+5);
  Canvas.Rectangle(hP.x-5, lP.y-5, hP.x+5, lP.y+5);
  Canvas.Rectangle(lP.x-5, hP.y-5, lP.x+5, hP.y+5);
  Canvas.Pen.Style := psDash;
  Canvas.Frame(lP.x-5, lP.y-5,hP.x+5, hP.y+5);
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
  ACanvas.RoundRect(WorldToScreen(Points[0]).x,WorldToScreen(Points[0]).Y,WorldToScreen(Points[1]).x,WorldToScreen(Points[1]).Y, RoundingRadiusX,RoundingRadiusY);
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


////ПОШЛА ЖАРААА

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



// ЖАРА ЗАКОНЧИЛАСЬ


begin

end.
