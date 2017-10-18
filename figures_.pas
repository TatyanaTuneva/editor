Unit Figures_;

Interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Menus, StdCtrls, ActnList, ColorBox, Spin;

type
TFigure = class
  procedure Draw(ACanvas:TCanvas); virtual;abstract;
end;

TLittleFigure = class(TFigure)
  Points: array of TPoint;
  PenColor: TColor;
  Width: integer;
  procedure Draw(ACanvas:TCanvas); override;
end;

TBigFigure = class(TLittleFigure)
  BrushColor: TColor;
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
  ACanvas.Brush.Color := BrushColor;
end;

procedure TLine.Draw(ACanvas:TCanvas);
begin
  Inherited;
  ACanvas.Line(Points[0],Points[1]);
end;

procedure TPolyLine.Draw(ACanvas:TCanvas);
begin
     Inherited;
     ACanvas.PolyLine(Points);
end;

procedure TEllipce.Draw(ACanvas:TCanvas);
begin
     Inherited;
     ACanvas.Ellipse(Points[0].X,Points[0].Y,Points[1].X,Points[1].Y);
end;

procedure TRectangle.Draw(ACanvas:TCanvas);
begin
     Inherited;
     ACanvas.Rectangle(Points[0].X,Points[0].Y,Points[1].X,Points[1].Y);
end;

begin

end.
