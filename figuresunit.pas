Unit FiguresUnit;

Interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Menus, StdCtrls, ActnList, ColorBox, Spin, GraphMath, ScaleUnit;

type
TFigure = class
  procedure Draw(ACanvas:TCanvas); virtual;abstract;
end;

TLittleFigure = class(TFigure)
  Points: array of TFloatPoint;
  PenColor: TColor;
  Width: integer;
  procedure Draw(ACanvas:TCanvas); override;
end;

TBigFigure = class(TLittleFigure)
  BrushColor: TColor;
  BrushStyle: TBrushStyle;
  procedure Draw(ACanvas:TCanvas); override;
end;

TPolyLine = class(TLittleFigure)
  procedure Draw(ACanvas:TCanvas); override;
end;

TLine = class(TLittleFigure)
  procedure Draw(ACanvas:TCanvas); override;
end;

TEllipce = class(TBigFigure)
  procedure Draw(ACanvas:TCanvas); override;
end;

TRectangle = class(TBigFigure)
  procedure Draw(ACanvas:TCanvas); override;
end;

var
  Figures: array of TFigure;

Implementation

procedure TLittleFigure.Draw(ACanvas:TCanvas);
begin
  ACanvas.Pen.Color := PenColor;
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

procedure SetOffset (APoint: TFloatPoint);
begin
  Offset := APoint;
end;

begin

end.
