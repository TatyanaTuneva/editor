Unit FiguresUnit;

Interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Menus, ActnList, GraphMath, ScaleUnit, LCLType, LCLIntf, LCL;

type

TFigureClass    = class  of TFigure;
tempPointsArray = array[0..3] of TPoint;
PolygonPointsArray = array of TPoint;
StringArray = array of string;

TFigure = class
  Selected: boolean;
  FigureRegion: HRGN;
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

function CreateRectAroundLine(p1,p2: TPoint; FigurePenWidth: integer): tempPointsArray;

var
  Figures: array of TFigure;
  layer: array of Tfigure;

Implementation

function CreateRectAroundLine(p1,p2: TPoint; FigurePenWidth: integer):
  tempPointsArray;
begin
  if (abs(p2.x-p1.x)>45) then
  begin
    Result[0].x := p1.x-FigurePenWidth div 2;
    Result[0].y := p1.y-5-FigurePenWidth;
    Result[1].x := p2.x+FigurePenWidth div 2;
    Result[1].y := p2.y-5-FigurePenWidth;
    Result[2].x := p2.x+FigurePenWidth div 2;
    Result[2].y := p2.y+5+FigurePenWidth;
    Result[3].x := p1.x-FigurePenWidth div 2;
    Result[3].y := p1.y+5+FigurePenWidth;
  end else
  begin
    Result[0].x := p1.x-5-FigurePenWidth;
    Result[0].y := p1.y-FigurePenWidth div 2;
    Result[1].x := p2.x-5-FigurePenWidth;
    Result[1].y := p2.y+FigurePenWidth div 2;
    Result[2].x := p2.x+5+FigurePenWidth;
    Result[2].y := p2.y+FigurePenWidth div 2;
    Result[3].x := p1.x+5+FigurePenWidth;
    Result[3].y := p1.y-FigurePenWidth div 2;
  end;
end;

procedure TFigure.DrawSelection(AFigure: TFigure; Canvas: TCanvas);
var
  lP,hP, pt1, pt2: TPoint;
begin
  Canvas.Pen.Color := clBlack;
  Canvas.Brush.Color := clWhite;
  Canvas.Pen.Style := psSolid;
  Canvas.Brush.Style := bsSolid;
  Canvas.Pen.Width := 1;

  AFigure.Points[0] := pt1;
  AFigure.Points[1] := pt2;


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

procedure TRectangle.SetRegion;
var
  tempRect: TRect;
begin
  tempRect.TopLeft := WorldToScreen(Points[0]);
  tempRect.BottomRight := WorldToScreen(Points[1]);
  FigureRegion := CreateRectRgn(tempRect.Left,tempRect.Top,tempRect.Right,
    tempRect.Bottom);
end;

procedure TEllipce.SetRegion;
var
  tempRect: TRect;
begin
  tempRect.TopLeft := WorldToScreen(Points[0]);
  tempRect.BottomRight := WorldToScreen(Points[1]);
  FigureRegion := CreateEllipticRgn(tempRect.Left,tempRect.Top,tempRect.Right,
    tempRect.Bottom);
end;

procedure TRoundedRectangle.SetRegion;
var
  tempRect: TRect;
begin
  tempRect.TopLeft := WorldToScreen(Points[0]);
  tempRect.BottomRight := WorldToScreen(Points[1]);
  FigureRegion := CreateRoundRectRgn(tempRect.Left,tempRect.Top,tempRect.Right,
    tempRect.Bottom,RoundingRadiusX,RoundingRadiusY);
end;

procedure TLine.SetRegion;
var
  tempPoints: tempPointsArray;
  p1,p2: TPoint;
begin
  p1 := WorldToScreen(Points[0]);
  p2 := WorldToScreen(Points[1]);
  tempPoints := CreateRectAroundLine(p1,p2,Width);
  FigureRegion := CreatePolygonRgn(tempPoints,length(tempPoints),winding);
end;

procedure TPolyline.SetRegion;
var
  tempPoints: array[0..3] of TPoint;
  p1,p2: TPoint;
  curRgn: HRGN;
  i: integer;
begin
  for i := low(Points) to high(Points)-1 do
  begin
    p1 := WorldToScreen(Points[i]);
    p2 := WorldToScreen(Points[i+1]);
    tempPoints := CreateRectAroundLine(p1,p2,Width);
    if (i=low(Points)) then
      FigureRegion := CreatePolygonRgn (tempPoints,length(tempPoints),winding);
    curRgn := CreatePolygonRgn (tempPoints,length(tempPoints),winding);
    CombineRgn (FigureRegion,FigureRegion,curRgn,RGN_OR);
    DeleteObject(curRgn);
  end;
end;

begin

end.
