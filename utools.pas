unit utools;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Figures_, Graphics;

type
TFigureTool = class
  procedure MouseDown(AX: integer;AY: integer; AWidth: integer; APenColor: TColor; ABrushColor: TColor); virtual; abstract;
  procedure MouseMove(X: integer;Y: integer); virtual; abstract;
end;

TLittleFigureTool = class(TFigureTool)

end;

TBigFigureTool = class(TLittleFigureTool)

end;

TPolyLineTool = class(TLittleFigureTool)
  procedure MouseDown(AX: integer;AY: integer; AWidth: integer; APenColor: TColor; ABrushColor: TColor); override;
  procedure MouseMove(X: integer;Y: integer); override;
end;

TLineTool = class(TLittleFigureTool)
  procedure MouseDown(AX: integer;AY: integer; AWidth: integer; APenColor: TColor; ABrushColor: TColor); override;
  procedure MouseMove(X: integer;Y: integer); override;
end;

TEllipceTool = class(TBigFigureTool)
  procedure MouseDown(AX: integer;AY: integer; AWidth: integer; APenColor: TColor; ABrushColor: TColor); override;
  procedure MouseMove(X: integer;Y: integer); override;
end;

TRectangleTool = class(TBigFigureTool)
  procedure MouseDown(AX: integer;AY: integer; AWidth: integer; APenColor: TColor; ABrushColor: TColor); override;
  procedure MouseMove(X: integer;Y: integer); override;
end;

implementation

procedure TPolyLineTool.MouseDown(AX: integer;AY: integer; AWidth: integer; APenColor: TColor; ABrushColor: TColor);
  var
    AFigure: TLittleFigure;
  begin
  Setlength(Figures, Length(Figures) + 1);
  Figures[high(Figures)] := TPolyLine.Create();
  AFigure := (Figures[high(Figures)] as TLittleFigure);
  SetLength((Figures[high(Figures)] as TLittleFigure).Points, Length((Figures[high(Figures)] as TLittleFigure).points) + 1);
  (Figures[high(Figures)] as TLittleFigure).Points[high((Figures[high(Figures)] as TLittleFigure).Points)] := Point(AX,AY);
  AFigure.PenColor := APenColor;
  AFigure.Width := AWidth;
end;

procedure TLineTool.MouseDown(AX: integer;AY: integer; AWidth: integer; APenColor: TColor; ABrushColor: TColor);
var
  AFigure: TLittleFigure;
begin
 Setlength(Figures, length(Figures) + 1);
 Figures[high(Figures)] := TLine.Create();
 AFigure := (Figures[high(Figures)] as TLittleFigure);
 SetLength(AFigure.Points, 2);
 AFigure.Points[0] := Point(AX,AY);
 AFigure.Points[1] := Point(AX,AY);
 AFigure.PenColor := APenColor;
 AFigure.Width := AWidth;
end;

procedure TRectangleTool.MouseDown(AX: integer;AY: integer; AWidth: integer; APenColor: TColor; ABrushColor: TColor);
var
  AFigure: TBigFigure;
begin
 Setlength(Figures, Length(figures) + 1);
 Figures[high(Figures)] := TRectangle.Create();
 AFigure := (Figures[high(Figures)] as TBigFigure);
 SetLength(AFigure.Points, 2);
 AFigure.Points[0] := Point(AX,AY);
 AFigure.Points[1] := Point(AX,AY);
 AFigure.PenColor := APenColor;
 AFigure.Width := AWidth;
 AFigure.BrushColor := ABrushColor;
end;

procedure TEllipceTool.MouseDown(AX: integer;AY: integer; AWidth: integer; APenColor: TColor; ABrushColor: TColor);
var
  AFigure: TBigFigure;
begin
 SetLength(Figures, Length(figures) + 1);
 Figures[high(Figures)] := TEllipce.Create();
 AFigure := (Figures[high(Figures)] as TBigFigure);
 SetLength(AFigure.Points, 2);
 AFigure.Points[0] := Point(AX,AY);
 AFigure.Points[1] := Point(AX,AY);
 AFigure.PenColor := APenColor;
 AFigure.Width := AWidth;
 AFigure.BrushColor := ABrushColor;
end;

procedure TLineTool.MouseMove(X: integer;Y: integer);
begin
  (Figures[high(Figures)] as TLittleFigure).Points[1] := Point(X,Y);
end;

procedure TEllipceTool.MouseMove(X: integer;Y: integer);
begin
  (Figures[high(Figures)] as TLittleFigure).Points[1] := Point(X,Y);
end;

procedure TRectangleTool.MouseMove(X: integer;Y: integer);
begin
  (Figures[high(Figures)] as TLittleFigure).Points[1] := Point(X,Y);
end;

procedure TPolyLineTool.MouseMove(X: integer;Y: integer);
begin
  SetLength((Figures[high(Figures)] as TLittleFigure).points, length((Figures[high(Figures)] as TLittleFigure).points) + 1);
 (Figures[high(Figures)] as TLittleFigure).Points[high((Figures[high(Figures)] as TLittleFigure).Points)] := Point(X,Y);
end;

begin

end.
