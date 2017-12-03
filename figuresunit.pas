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
StringArray = array of string;                                   // 1 - line polyline
                                                                 // 2 - rectangle ellipce
TFigure = class                                                  // 3 - rrectangle
  Selected: boolean;
  Index: integer;
  Region: HRGN;
  Points: array of TFloatPoint;
  procedure Draw(ACanvas:TCanvas); virtual;abstract;
  procedure SetRegion; Virtual; abstract;
  procedure DrawSelection(AFigure: TFigure; Canvas: TCanvas; Width: integer);   virtual;
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

procedure TFigure.DrawSelection(AFigure: TFigure; Canvas: TCanvas; Width: integer);
var
  Point1, Point2, a:TFloatPoint;
  i: integer;
  max,min: TFloatPoint;
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
  Canvas.Frame(WorldToScreen(Point1).x - 5 - Width div 2,WorldToScreen(Point1).y - 5 - Width div 2,
               WorldToScreen(Point2).x + 5 + Width div 2,WorldToScreen(Point2).y + 5 + Width div 2);

 end else begin
    max := AFigure.Points[0];
    min := AFigure.Points[0];
   for i:=0 to length(AFigure.Points) - 1 do begin
    if AFigure.Points[i].X > max.x then max.x := AFigure.Points[i].X;
    if AFigure.Points[i].Y > max.y then max.y := AFigure.Points[i].y;

    if AFigure.Points[i].X < min.x then min.x := AFigure.Points[i].X;
    if AFigure.Points[i].Y < min.y then min.y := AFigure.Points[i].Y;
   end;


    Canvas.Pen.Color := clBlack;
    Canvas.Pen.Width := 1;
    Canvas.Pen.Style := psDash;
    Canvas.Frame(WorldToScreen(min).x - 5 - Width div 2,WorldToScreen(min).y - 5 - Width div 2,
                 WorldToScreen(max).x + 5 + Width div 2,WorldToScreen(max).y + 5 + Width div 2);
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


begin

end.
