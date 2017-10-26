unit ToolsUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FiguresUnit, Graphics, GraphMath, ScaleUnit;

type
TFigureTool = class
  Icons: string;
  procedure MouseDown(AX: integer;AY: integer; AWidth: integer; APenColor: TColor; ABrushColor: TColor); virtual; abstract;
  procedure MouseMove(X: integer;Y: integer); virtual; abstract;
  procedure Mouseup(X: integer;Y: integer); virtual;abstract;
end;

TLittleFigureTool = class(TFigureTool)
  procedure Mouseup(X: integer; Y: integer); override;
end;

TBigFigureTool = class(TLittleFigureTool)
  procedure Mouseup(X: integer;Y: integer); override;
end;

TPolyLineTool = class(TLittleFigureTool)
  procedure MouseDown(AX: integer;AY: integer; AWidth: integer; APenColor: TColor; ABrushColor: TColor); override;
  procedure MouseMove(X: integer;Y: integer); override;
  procedure Mouseup(X: integer;Y: integer); override;
end;

TLineTool = class(TLittleFigureTool)
  procedure MouseDown(AX: integer;AY: integer; AWidth: integer; APenColor: TColor; ABrushColor: TColor); override;
  procedure MouseMove(X: integer;Y: integer); override;
  procedure Mouseup(X: integer;Y: integer); override;
end;

TEllipceTool = class(TBigFigureTool)
  procedure MouseDown(AX: integer;AY: integer; AWidth: integer; APenColor: TColor; ABrushColor: TColor); override;
  procedure MouseMove(X: integer;Y: integer); override;
  procedure Mouseup(X: integer;Y: integer); override;
end;

TRectangleTool = class(TBigFigureTool)
  procedure MouseDown(AX: integer;AY: integer; AWidth: integer; APenColor: TColor; ABrushColor: TColor); override;
  procedure MouseMove(X: integer;Y: integer); override;
  procedure MouseUp(X: integer;Y: integer); override;
end;

TPaw = class(TFigureTool)
  FirstPoint: TPoint;
  procedure MouseDown(AX: integer;AY: integer; AWidth: integer; APenColor: TColor; ABrushColor: TColor); override;
  procedure MouseMove(X: integer;Y: integer); override;
  procedure MouseUp(X: integer;Y: integer); override;
end;

Tmagnifier = class(TFigureTool)
  procedure MouseDown(AX: integer;AY: integer; AWidth: integer; APenColor: TColor; ABrushColor: TColor); override;
  procedure MouseMove(X: integer;Y: integer); override;
  procedure MouseUp(X: integer;Y: integer); override;
end;


var
  Tool: array of TFigureTool;

implementation

procedure TLittleFigureTool.MouseUp(X: integer;Y: integer);
begin
end;

procedure TBigFigureTool.MouseUp(X: integer;Y: integer);
begin
end;

procedure TEllipceTool.MouseUp(X: integer;Y: integer);
begin
end;

procedure TPolyLineTool.MouseUp(X: integer;Y: integer);
begin
end;

procedure TRectangleTool.MouseUp(X: integer;Y: integer);
begin
end;

procedure Tlinetool.MouseUp(X: integer;Y: integer);
begin
end;

procedure TPaw.MouseUp(X: integer;Y: integer);
begin
end;

procedure TMagnifier.MouseUp(X: integer;Y: integer);
begin
 RectZoom(AHeightPB,AWidthPB,(Figures[high(Figures)] as TLittleFigure).Points[0],(Figures[high(Figures)] as TLittleFigure).Points[1]);
 SetLength(Figures, Length(Figures) - 1);
end;

procedure TMagnifier.MouseDown(AX: integer;AY: integer; AWidth: integer; APenColor: TColor; ABrushColor: TColor);
var
  AFigure: TRectangleMagnifier;
begin
  Setlength(Figures, Length(figures) + 1);
  Figures[high(Figures)] := TRectangleMagnifier.Create();
  AFigure := (Figures[high(Figures)] as TRectangleMagnifier);
  SetLength(AFigure.Points, 2);
  AFigure.Points[0] := ScreenToWorld(Point(AX,AY));
  AFigure.Points[1] := ScreenToWorld(Point(AX,AY));
end;

procedure TMagnifier.MouseMove(X: integer;Y: integer);
begin
  (Figures[high(Figures)] as TLittleFigure).Points[1] := ScreenToWorld(Point(X,Y));
end;

procedure TPaw.MouseDown(AX: integer;AY: integer; AWidth: integer; APenColor: TColor; ABrushColor: TColor);
begin
  FirstPoint := Point(AX,AY);
end;

procedure TPaw.MouseMove(X: integer;Y: integer);
begin
  offset.x += FirstPoint.X - X;
  offset.y += FirstPoint.Y - Y;
  FirstPoint:=Point(X,Y);
end;

procedure TPolyLineTool.MouseDown(AX: integer;AY: integer; AWidth: integer; APenColor: TColor; ABrushColor: TColor);
var
  AFigure: TLittleFigure;
begin
  Setlength(Figures, Length(Figures) + 1);
  Figures[high(Figures)] := TPolyLine.Create();
  AFigure := (Figures[high(Figures)] as TLittleFigure);
  SetLength((Figures[high(Figures)] as TLittleFigure).Points, Length((Figures[high(Figures)] as TLittleFigure).points) + 1);
  (Figures[high(Figures)] as TLittleFigure).Points[high((Figures[high(Figures)] as TLittleFigure).Points)] := ScreenToWorld(Point(AX,AY));
  AFigure.PenColor := APenColor;
  AFigure.Width := AWidth;
  MaxMin(Point(AX,AY));
end;

procedure TLineTool.MouseDown(AX: integer;AY: integer; AWidth: integer; APenColor: TColor; ABrushColor: TColor);
var
  AFigure: TLittleFigure;
begin
 Setlength(Figures, length(Figures) + 1);
 Figures[high(Figures)] := TLine.Create();
 AFigure := (Figures[high(Figures)] as TLittleFigure);
 SetLength(AFigure.Points, 2);
 AFigure.Points[0] := ScreenToWorld(Point(AX,AY));
 AFigure.Points[1] := ScreenToWorld(Point(AX,AY));
 AFigure.PenColor := APenColor;
 AFigure.Width := AWidth;
 MaxMin(Point(AX,AY));
end;

procedure TRectangleTool.MouseDown(AX: integer;AY: integer; AWidth: integer; APenColor: TColor; ABrushColor: TColor);
var
  AFigure: TBigFigure;
begin
 Setlength(Figures, Length(figures) + 1);
 Figures[high(Figures)] := TRectangle.Create();
 AFigure := (Figures[high(Figures)] as TBigFigure);
 SetLength(AFigure.Points, 2);
 AFigure.Points[0] := ScreenToWorld(Point(AX,AY));
 AFigure.Points[1] := ScreenToWorld(Point(AX,AY));
 AFigure.PenColor := APenColor;
 AFigure.Width := AWidth;
 AFigure.BrushColor := ABrushColor;
 MaxMin(Point(AX,AY));
end;

procedure TEllipceTool.MouseDown(AX: integer;AY: integer; AWidth: integer; APenColor: TColor; ABrushColor: TColor);
var
  AFigure: TBigFigure;
begin
 SetLength(Figures, Length(figures) + 1);
 Figures[high(Figures)] := TEllipce.Create();
 AFigure := (Figures[high(Figures)] as TBigFigure);
 SetLength(AFigure.Points, 2);
 AFigure.Points[0] := ScreenToWorld(Point(AX,AY));
 AFigure.Points[1] := ScreenToWorld(Point(AX,AY));
 AFigure.PenColor := APenColor;
 AFigure.Width := AWidth;
 AFigure.BrushColor := ABrushColor;
 MaxMin(Point(AX,AY));
end;

procedure TLineTool.MouseMove(X: integer;Y: integer);
begin
  (Figures[high(Figures)] as TLittleFigure).Points[1] := ScreenToWorld(Point(X,Y));
  MaxMin(Point(X,Y));
end;

procedure TEllipceTool.MouseMove(X: integer;Y: integer);
begin
  (Figures[high(Figures)] as TLittleFigure).Points[1] := ScreenToWorld(Point(X,Y));
    MaxMin(Point(X,Y));
end;

procedure TRectangleTool.MouseMove(X: integer;Y: integer);
begin
  (Figures[high(Figures)] as TLittleFigure).Points[1] := ScreenToWorld(Point(X,Y));
    MaxMin(Point(X,Y));
end;

procedure TPolyLineTool.MouseMove(X: integer;Y: integer);
begin
  SetLength((Figures[high(Figures)] as TLittleFigure).points, length((Figures[high(Figures)] as TLittleFigure).points) + 1);
 (Figures[high(Figures)] as TLittleFigure).Points[high((Figures[high(Figures)] as TLittleFigure).Points)] := ScreenToWorld(Point(X,Y));
   MaxMin(Point(X,Y));
end;

begin
  Setlength(Tool, 6);
  Tool[0]:= TPolyLineTool.Create();
  Tool[0].Icons:='0.png';
  Tool[1]:= TLineTool.Create();
  Tool[1].Icons:='1.png';
  Tool[2]:= TRectangleTool.Create();
  Tool[2].Icons:='2.png';
  Tool[3]:= TEllipceTool.Create();
  Tool[3].Icons:='3.png';
  Tool[4]:= TPaw.Create();
  Tool[4].Icons:='4.png';
  Tool[5]:=Tmagnifier.Create();
  Tool[5].Icons:='5.png';
end.
