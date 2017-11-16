unit ToolsUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FiguresUnit, Graphics, GraphMath, ScaleUnit, ExtCtrls, StdCtrls, Spin, ColorBox;

type

 TParam = class
 procedure CreateObjects(Panel: TPanel); virtual; abstract;
end;

 TPenColorParam = class(Tparam)
 procedure ChangePenColor(Sender: TObject);
 procedure CreateObjects(Panel: TPanel); override;
end;

 TBrushColorParam = class(TParam)
  procedure ChangeBrushColor(Sender: TObject);
  procedure CreateObjects(Panel: TPanel); override;
end;

 TWidthParam = class(TParam)
  procedure ChangeWidth(Sender: TObject);
  procedure CreateObjects(Panel: TPanel); override;
end;

TRoundingRadiusParamX = class(TParam)
  procedure ChangeRoundX(Sender: TObject);
  procedure CreateObjects(Panel: TPanel); override;
end;

TRoundingRadiusParamY = class(TParam)
  procedure ChangeRoundY(Sender: TObject);
  procedure CreateObjects(Panel: TPanel); override;
end;

TBrushStyleParam = class(TParam)
  procedure ChangeBrushStyle(Sender: TObject);
  procedure CreateObjects(Panel: TPanel); override;
end;

TPenStyleParam = class(TParam)
  procedure ChangePenStyle(Sender: TObject);
  procedure CreateObjects(Panel: TPanel); override;
end;

TFigureTool = class
  Icons: string;
  Param: array of TParam;
  procedure MouseDown(AX: integer;AY: integer); virtual; abstract;
  procedure MouseMove(X: integer;Y: integer); virtual; abstract;
  procedure Mouseup(X: integer;Y: integer); virtual;
  procedure ParamListCreate(); virtual;abstract;
  procedure ParamsCreate(Panel: TPanel);
end;

TLittleFigureTool = class(TFigureTool)
  procedure ParamListCreate(); override;
end;

TBigFigureTool = class(TLittleFigureTool)
  procedure ParamListCreate(); override;
end;

TPolyLineTool = class(TLittleFigureTool)
  procedure MouseDown(AX: integer;AY: integer); override;
  procedure MouseMove(X: integer;Y: integer); override;
end;

TLineTool = class(TLittleFigureTool)
  procedure MouseDown(AX: integer;AY: integer); override;
  procedure MouseMove(X: integer;Y: integer); override;
end;

TEllipceTool = class(TBigFigureTool)
  procedure MouseDown(AX: integer;AY: integer); override;
  procedure MouseMove(X: integer;Y: integer); override;
end;

TRectangleTool = class(TBigFigureTool)
  procedure MouseDown(AX: integer;AY: integer); override;
  procedure MouseMove(X: integer;Y: integer); override;
end;

TPaw = class(TFigureTool)
  FirstPoint: TPoint;
  procedure MouseDown(AX: integer;AY: integer); override;
  procedure MouseMove(X: integer;Y: integer); override;
  procedure ParamListCreate(); override;
end;

Tmagnifier = class(TFigureTool)
  procedure MouseDown(AX: integer;AY: integer); override;
  procedure MouseMove(X: integer;Y: integer); override;
  procedure MouseUp(X: integer;Y: integer); override;
  procedure ParamListCreate(); override;
end;

TRoundedRectangleTool = class(TBigFigureTool)
  procedure MouseDown(AX: integer;AY: integer); override;
  procedure MouseMove(X: integer;Y: integer); override;
  procedure ParamListCreate(); override;
end;


var
  Tool: array of TFigureTool;
  APenColor, ABrushColor: TColor;
  AWidth,ARadiusX,ARadiusY: integer;
  APenStyle: TPenStyle;
  ABrushStyle: TBrushStyle;

implementation

procedure TPenColorParam.CreateObjects(Panel: TPanel);
var
  ColorLabel: TLabel;
  PenColor: TColorBox;
begin
  ColorLabel := TLabel.Create(Panel);
  ColorLabel.Caption := 'Цвет карандаша';
  ColorLabel.Top := 0;
  ColorLabel.Parent:=Panel;

  PenColor := TColorBox.Create(panel);
  PenColor.Top := 20;
  PenColor.Parent := Panel;
  PenColor.Selected := APenColor;
  PenColor.OnChange := @ChangePenColor;
end;

procedure TPenColorParam.ChangePenColor(Sender: TObject);
begin
  APenColor := (Sender as TColorBox).Selected;
end;



procedure TPenStyleParam.CreateObjects(Panel: TPanel);
var
  StyleLabel: TLabel;
  PenStyle: TColorBox;
begin
  StyleLabel := TLabel.Create(Panel);
  StyleLabel.Caption := 'Стиль линии';
  StyleLabel.Top := 0;
  StyleLabel.Parent:=Panel;

  PenStyle  := TColorBox.Create(panel);
  PenStyle.Top := 20;
  PenStyle.Parent := Panel;
  PenStyle.Selected := APenColor;
  PenStyle.OnChange := @ChangePenStyle;
end;

procedure TPenStyleParam.ChangePenStyle(Sender: TObject);
begin
  APenStyle := (Sender as TColorBox).Selected;
end;


procedure TBrushColorParam.CreateObjects(Panel: TPanel);
var
  ColorLabel: TLabel;
  BrushColor: TColorBox;
begin
  ColorLabel := TLabel.Create(Panel);
  ColorLabel.Caption := 'Цвет заливки';
  ColorLabel.Top := 120;
  ColorLabel.Parent := Panel;

  BrushColor := TColorBox.Create(Panel);
  BrushColor.Top := 140;
  BrushColor.Parent := Panel;
  BrushColor.Selected := ABrushColor;
  BrushColor.OnChange := @ChangeBrushColor;
end;

procedure TBrushColorParam.ChangeBrushColor(Sender: TObject);
begin
  ABrushColor := (Sender as TColorBox).Selected;
end;

procedure TWidthParam.CreateObjects(Panel: TPanel);
var
  WidthLabel: TLabel;
  WidthParam: TSpinEdit;
begin
  WidthLabel := TLabel.Create(Panel);
  WidthLabel.Caption := 'Ширина карандаша';
  WidthLabel.Top := 60;
  WidthLabel.Parent := Panel;

  WidthParam := TSpinEdit.Create(Panel);
  WidthParam.Top := 80;
  WidthParam.MinValue := 1;
  WidthParam.Parent:= Panel;
  WidthParam.Value := AWidth;
  WidthParam.OnChange := @ChangeWidth;
end;

procedure TWidthParam.ChangeWidth(Sender: TObject);
begin
 AWidth := (Sender as TSpinEdit).Value;
end;

procedure TRoundingRadiusParamX.CreateObjects(Panel: TPanel);
var
  RoundingRadiusLabel: TLabel;
  RoundingRadiusX: TSpinEdit;
begin
  RoundingRadiusLabel := TLabel.Create(Panel);
  RoundingRadiusLabel.Caption := 'Радиус округления X';
  RoundingRadiusLabel.Top := 180;
  RoundingRadiusLabel.Parent := Panel;

  RoundingRadiusX := TSpinEdit.Create(Panel);
  RoundingRadiusX.Top := 200;
  RoundingRadiusX.MinValue := 0;
  RoundingRadiusX.Parent := Panel;
  RoundingRadiusX.Value := ARadiusX;
  RoundingRadiusX.OnChange := @ChangeRoundX;
end;

procedure TRoundingRadiusParamX.ChangeRoundX(Sender: TObject);
begin
  ARadiusX := (Sender as TSpinEdit).Value;
end;

procedure TRoundingRadiusParamY.CreateObjects(Panel: TPanel);
var
  RoundingRadiusLabel: TLabel;
  RoundingRadiusY: TSpinEdit;
begin
  RoundingRadiusLabel := TLabel.Create(Panel);
  RoundingRadiusLabel.Caption := 'Радиус округления Y';
  RoundingRadiusLabel.Top := 240;
  RoundingRadiusLabel.Parent :=Panel;

  RoundingRadiusY := TSpinEdit.Create(Panel);
  RoundingRadiusY.Top := 260;
  RoundingRadiusY.MinValue := 0;
  RoundingRadiusY.Parent := Panel;
  RoundingRadiusY.Value := ARadiusY;
  RoundingRadiusY.OnChange := @ChangeRoundY;
end;

procedure TRoundingRadiusParamY.ChangeRoundY(Sender: TObject);
begin
  ARadiusY := (Sender as TSpinEdit).Value;
end;

procedure TLittleFigureTool.ParamListCreate();
begin
  SetLength(Param, Length(Param) + 2);
  Param[High(Param)-1] := TPenColorParam.Create();
  Param[High(Param)] := TWidthParam.Create();
end;

procedure TBigFigureTool.ParamListCreate();
begin
  Inherited;
  SetLength(Param,Length(Param) + 1);
  Param[High(Param)]:= TBrushColorParam.Create();
end;

procedure TRoundedRectangleTool.ParamListCreate();
begin
  Inherited;
  SetLength(Param,Length(Param) + 2);
  Param[High(Param)-1] := TRoundingRadiusParamX.Create();
  Param[High(Param)] := TRoundingRadiusParamY.Create();
end;

procedure TPaw.ParamListCreate();
begin
end;

procedure Tmagnifier.ParamListCreate();
begin
end;

procedure TFigureTool.paramscreate(Panel: TPanel);
var
  i: Integer;
begin
  For i:=0 to high(Param) do begin
    Param[i].CreateObjects(Panel);
  end;
end;

procedure RegisterTool(ATool: TFigureTool; S: string);
begin
  Setlength(Tool, Length(Tool)+1);
  Tool[high(Tool)] := ATool;
  Tool[high(Tool)].Icons := s;
  Atool.ParamListCreate();
end;

procedure TFigureTool.MouseUp(X: Integer;Y: Integer);
begin

end;

procedure TMagnifier.MouseUp(X: integer;Y: integer);
begin
  RectZoom(AHeightPB,AWidthPB,(Figures[high(Figures)] as TLittleFigure).Points[0],(Figures[high(Figures)] as TLittleFigure).Points[1]);
  SetLength(Figures, Length(Figures) - 1);
end;

procedure TMagnifier.MouseDown(AX: integer;AY: integer);
var
  AFigure: TRectangleMagnifier;
begin
  SetLength(Figures, Length(figures) + 1);
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

procedure TPaw.MouseDown(AX: integer;AY: integer);
begin
  FirstPoint := Point(AX,AY);
end;

procedure TPaw.MouseMove(X: integer;Y: integer);
begin
  offset.x += FirstPoint.X - X;
  offset.y += FirstPoint.Y - Y;
  FirstPoint:=Point(X,Y);
end;

procedure TPolyLineTool.MouseDown(AX: integer;AY: integer);
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

procedure TLineTool.MouseDown(AX: integer;AY: integer);
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

procedure TRectangleTool.MouseDown(AX: integer;AY: integer);
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

procedure TRoundedRectangleTool.MouseDown(AX: integer;AY: integer);
var
  AFigure: TBigFigure;
begin
  Setlength(Figures, Length(figures) + 1);
  Figures[high(Figures)] := TRoundedRectangle.Create();
  AFigure := (Figures[high(Figures)] as TBigFigure);
  SetLength(AFigure.Points, 2);
  AFigure.Points[0] := ScreenToWorld(Point(AX,AY));
  AFigure.Points[1] := ScreenToWorld(Point(AX,AY));
  AFigure.PenColor := APenColor;
  AFigure.Width := AWidth;
  AFigure.BrushColor := ABrushColor;
  AFigure.RoundingRadiusX := ARadiusX;
  AFigure.RoundingRadiusY:= ARadiusY;
  MaxMin(Point(AX,AY));
end;

procedure TEllipceTool.MouseDown(AX: integer;AY: integer);
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

procedure TRoundedRectangleTool.MouseMove(X: integer;Y: integer);
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
  REgisterTool(TPolyLineTool.Create(),'0.png');
  REgisterTool(TLineTool.Create(),'1.png');
  REgisterTool(TRectangleTool.Create(),'2.png');
  REgisterTool(TEllipceTool.Create(),'3.png');
  REgisterTool(TPaw.Create(),'4.png');
  REgisterTool(Tmagnifier.Create(),'5.png');
  REgisterTool(TRoundedRectangleTool.Create(),'6.png');
  APenColor := clBlack;
  ABrushColor := clBlack;
  AWidth := 1;
  ARadiusX := 30;
  ARadiusY := 30;
end.

