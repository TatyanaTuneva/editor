unit ToolsUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FiguresUnit, Graphics, GraphMath, ScaleUnit, ExtCtrls, StdCtrls, Spin, ColorBox, LCLType;

type

 TParam = class
 procedure CreateObjects(Panel: TPanel; pos: Integer); virtual; abstract;
end;

 TPenColorParam = class(Tparam)
 procedure ChangePenColor(Sender: TObject);
 procedure CreateObjects(Panel: TPanel; pos: Integer); override;
end;

 TBrushColorParam = class(TParam)
  procedure ChangeBrushColor(Sender: TObject);
  procedure CreateObjects(Panel: TPanel; pos: Integer); override;
end;

 TWidthParam = class(TParam)
  procedure ChangeWidth(Sender: TObject);
  procedure CreateObjects(Panel: TPanel; pos: Integer); override;
end;

TRoundingRadiusParamX = class(TParam)
  procedure ChangeRoundX(Sender: TObject);
  procedure CreateObjects(Panel: TPanel; pos: Integer); override;
end;

TRoundingRadiusParamY = class(TParam)
  procedure ChangeRoundY(Sender: TObject);
  procedure CreateObjects(Panel: TPanel; pos: Integer); override;
end;

TBrushStyleParam = class(TParam)
  const BStyles: array [0..7] of TBrushStyle = (bsSolid, bsClear,
bsHorizontal, bsVertical, bsFDiagonal, bsBDiagonal, bsCross, bsDiagCross);
  procedure ChangeBrushStyle(Sender: TObject);
  procedure CreateObjects(Panel: TPanel; pos: Integer); override;
end;

TPenStyleParam = class(TParam)
  procedure ChangePenStyle(Sender: TObject);
  procedure CreateObjects(Panel: TPanel; pos: Integer); override;
  const PStyles: array[0..5] of TPenStyle = (psSolid, psClear, psDot,
psDash, psDashDot, psDashDotDot);
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

TSelectTool = class(TFigureTool)
  procedure MouseDown(AX: integer;AY: integer); override;
  procedure MouseMove(X: integer;Y: integer); override;
  procedure MouseUp(X: integer;Y: integer); override;
  procedure ParamListCreate(); override;
end;


var
  Tool: array of TFigureTool;
  APenColor, ABrushColor: TColor;
  AWidth,ARadiusX,ARadiusY: integer;
  APenStyle: TPenStyle;
  ABrushStyle: TBrushStyle;
  SelectedBStyleIndex, SelectedPStyleIndex: integer;
  SelectToolSelected: Boolean;

implementation

procedure TPenColorParam.CreateObjects(Panel: TPanel; pos: integer);
var
  ColorLabel: TLabel;
  PenColor: TColorBox;
begin
  ColorLabel := TLabel.Create(Panel);
  ColorLabel.Caption := 'Цвет карандаша';
  ColorLabel.Top := pos;
  ColorLabel.Parent:=Panel;

  PenColor := TColorBox.Create(panel);
  PenColor.Top := pos + 20;
  PenColor.Parent := Panel;
  PenColor.Selected := APenColor;
  PenColor.OnChange := @ChangePenColor;
end;

procedure TPenColorParam.ChangePenColor(Sender: TObject);
begin
  APenColor := (Sender as TColorBox).Selected;
end;

procedure TPenStyleParam.CreateObjects(Panel: TPanel; pos: Integer);
var
  StyleLabel: TLabel;
  PenStyle: TComboBox;
  i: integer;
  s: string;
begin
  StyleLabel := TLabel.Create(Panel);
  StyleLabel.Caption := 'Стиль линии';
  StyleLabel.Top := pos;
  StyleLabel.Parent:=Panel;

  PenStyle  := TComboBox.Create(panel);
  for i:=0 to 5 do
  begin
    WriteStr(s, PStyles[i]);
    PenStyle.Items.Add(s);
  end;
  PenStyle.Top := pos + 20;
  PenStyle.Parent := Panel;
  PenStyle.ReadOnly := True;
  PenStyle.ItemIndex := SelectedPStyleIndex;
  PenStyle.OnChange := @ChangePenStyle;
end;

procedure TPenStyleParam.ChangePenStyle(Sender: TObject);
begin
  APenStyle := PStyles[(Sender as TComboBox).ItemIndex];
  SelectedPStyleIndex := (Sender as TComboBox).ItemIndex;
end;

procedure TWidthParam.CreateObjects(Panel: TPanel; pos: Integer);
var
  WidthLabel: TLabel;
  WidthParam: TSpinEdit;
begin
  WidthLabel := TLabel.Create(Panel);
  WidthLabel.Caption := 'Ширина карандаша';
  WidthLabel.Top := pos;
  WidthLabel.Parent := Panel;

  WidthParam := TSpinEdit.Create(Panel);
  WidthParam.Top := pos + 20;
  WidthParam.MinValue := 1;
  WidthParam.Parent:= Panel;
  WidthParam.Value := AWidth;
  WidthParam.OnChange := @ChangeWidth;
end;

procedure TWidthParam.ChangeWidth(Sender: TObject);
begin
 AWidth := (Sender as TSpinEdit).Value;
end;

procedure TBrushColorParam.CreateObjects(Panel: TPanel; pos: Integer);
var
  ColorLabel: TLabel;
  BrushColor: TColorBox;
begin
  ColorLabel := TLabel.Create(Panel);
  ColorLabel.Caption := 'Цвет заливки';
  ColorLabel.Top := pos;
  ColorLabel.Parent := Panel;

  BrushColor := TColorBox.Create(Panel);
  BrushColor.Top := pos + 20;
  BrushColor.Parent := Panel;
  BrushColor.Selected := ABrushColor;
  BrushColor.OnChange := @ChangeBrushColor;
end;

procedure TBrushColorParam.ChangeBrushColor(Sender: TObject);
begin
  ABrushColor := (Sender as TColorBox).Selected;
end;

procedure TBrushStyleParam.CreateObjects(Panel: TPanel; pos: Integer);
var
  StyleLabel: TLabel;
  BrushStyle: TComboBox;
  i: Integer;
  s: String;
begin
  StyleLabel := TLabel.Create(Panel);
  StyleLabel.Caption := 'Стиль заливки ';
  StyleLabel.Top := pos;
  StyleLabel.Parent:=Panel;

  BrushStyle := TComboBox.Create(panel);
  for i:=0 to 5 do
  begin
    WriteStr(s, BStyles[i]);
    BrushStyle.Items.Add(s);
  end;
  BrushStyle.Top := pos + 20;
  BrushStyle.Parent := Panel;
  BrushStyle.ItemIndex := SelectedBStyleIndex;
  BrushStyle.ReadOnly := True;
  BrushStyle.OnChange := @ChangeBrushStyle;
end;

procedure TBrushStyleParam.ChangeBrushStyle(Sender: TObject);
begin
  ABrushStyle := BStyles[(Sender as TComboBox).ItemIndex];
  SelectedBStyleIndex := (Sender as TComboBox).ItemIndex;
end;

procedure TRoundingRadiusParamX.CreateObjects(Panel: TPanel; pos: Integer);
var
  RoundingRadiusLabel: TLabel;
  RoundingRadiusX: TSpinEdit;
begin
  RoundingRadiusLabel := TLabel.Create(Panel);
  RoundingRadiusLabel.Caption := 'Радиус округления X';
  RoundingRadiusLabel.Top := pos;
  RoundingRadiusLabel.Parent := Panel;

  RoundingRadiusX := TSpinEdit.Create(Panel);
  RoundingRadiusX.Top := pos + 20;
  RoundingRadiusX.MinValue := 0;
  RoundingRadiusX.OnChange := @ChangeRoundX;
  RoundingRadiusX.Parent := Panel;
  RoundingRadiusX.Value := ARadiusX;
end;

procedure TRoundingRadiusParamX.ChangeRoundX(Sender: TObject);
begin
  ARadiusX := (Sender as TSpinEdit).Value;
end;

procedure TRoundingRadiusParamY.CreateObjects(Panel: TPanel; pos: Integer);
var
  RoundingRadiusLabel: TLabel;
  RoundingRadiusY: TSpinEdit;
begin
  RoundingRadiusLabel := TLabel.Create(Panel);
  RoundingRadiusLabel.Caption := 'Радиус округления Y';
  RoundingRadiusLabel.Top := pos;
  RoundingRadiusLabel.Parent :=Panel;

  RoundingRadiusY := TSpinEdit.Create(Panel);
  RoundingRadiusY.Top := pos + 20;
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
  SetLength(Param, Length(Param) + 3);
  Param[High(Param) - 2] := TPenColorParam.Create();
  Param[High(Param) - 1] := TPenStyleParam.Create();
  Param[High(Param)] := TWidthParam.Create();
end;

procedure TBigFigureTool.ParamListCreate();
begin
  Inherited;
  SetLength(Param,Length(Param) + 2);
  Param[High(Param) - 1]:= TBrushColorParam.Create();
  Param[High(Param)]:= TBrushStyleParam.Create();
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

procedure TSelectTool.ParamListCreate();
begin
end;

procedure TFigureTool.paramscreate(Panel: TPanel);
var
  i, pos: Integer;
begin
  For i:=0 to high(Param) do begin
    Param[i].CreateObjects(Panel, i * 60);
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
  Figures[high(Figures)] := TRectangleMagnifier.Create();           ////
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
  AFigure.PenStyle := APenStyle;
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
  AFigure.PenStyle := APenStyle;
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
  AFigure.PenStyle := APenStyle;
  AFigure.BrushStyle := ABrushStyle;
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
  AFigure.PenStyle := APenStyle;
  AFigure.BrushStyle := ABrushStyle;
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
  AFigure.PenStyle := APenStyle;
  AFigure.BrushStyle := ABrushStyle;
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

procedure TSelectTool.MouseDown(AX: Integer; AY: Integer);
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

procedure TSelectTool.MouseMove(X: Integer; Y: Integer);
begin
  (Figures[high(Figures)] as TLittleFigure).Points[1] := ScreenToWorld(Point(X,Y));                                                                    /////////
end;

procedure TSelectTool.MouseUp(X: Integer; Y: Integer);
begin
  SelectToolSelected := True;




  SetLength(Figures, Length(figures) - 1);
end;

begin
  RegisterTool(TPolyLineTool.Create(),'0.png');
  RegisterTool(TLineTool.Create(),'1.png');
  RegisterTool(TRectangleTool.Create(),'2.png');
  RegisterTool(TEllipceTool.Create(),'3.png');
  RegisterTool(TPaw.Create(),'4.png');
  RegisterTool(Tmagnifier.Create(),'5.png');
  RegisterTool(TRoundedRectangleTool.Create(),'6.png');
  RegisterTool(TSelectTool.Create(), '7.png');
  APenColor := clBlack;
  ABrushColor := clBlack;
  AWidth := 1;
  ARadiusX := 30;
  ARadiusY := 30;
  ABrushStyle := bsSolid;
  APenStyle := psSolid;
  SelectedPStyleIndex := 0;
  SelectedBStyleIndex := 0;
end.

