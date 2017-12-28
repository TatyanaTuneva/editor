unit MainUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Menus, StdCtrls, ActnList, ColorBox, Spin, ToolsUnit, FiguresUnit, Buttons, ExtDlgs, ScaleUnit;

type

  { TEditor }

  TEditor = class(TForm)
    Correction: TMenuItem;
    CopySelected: TMenuItem;
    Undo: TMenuItem;
    Redoo: TMenuItem;
    PasteSelected: TMenuItem;
    OpenImage: TMenuItem;
    SaveImage: TMenuItem;
    ODialog: TOpenDialog;
    SDialog: TSaveDialog;
    ShowAll: TMenuItem;
    ClearAll: TMenuItem;
    SelectedDown: TMenuItem;
    SelectedUp: TMenuItem;
    SelectAll: TMenuItem;
    DeleteSelected: TMenuItem;
    ZoomLabel: TLabel;
    ScrollBarHorizontal: TScrollBar;
    ScrollBarVertical: TScrollBar;
    ToolPanel: TPanel;
    ButtonPanel: TPanel;
    MMenu: TMainMenu;
    File_: TMenuItem;
    About: TMenuItem;
    Exit_: TMenuItem;
    Author: TMenuItem;
    PB: TPaintBox;
    ZoomSpinEdit: TSpinEdit;
    procedure BackClick(Sender: TObject);
    procedure ButtonsDown(Sender: TObject);
    procedure ClearAllClick(Sender: TObject);
    procedure CopySelectedClick(Sender: TObject);
    procedure DeleteSelectedClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; ACanvas: TCanvas);
    procedure FormPaint(Sender: TObject);
    procedure Exit_Click(Sender: TObject);
    procedure AuthorClick(Sender: TObject);
    procedure MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure OpenImageClick(Sender: TObject);
    procedure PasteSelectedClick(Sender: TObject);
    procedure RedooClick(Sender: TObject);
    procedure SaveImageClick(Sender: TObject);
    procedure ScrollBarScroll(Sender: TObject;
      ScrollCode: TScrollCode; var ScrollPos: Integer);
    procedure SelectAllClick(Sender: TObject);
    procedure SelectedDownClick(Sender: TObject);
    procedure SelectedUpClick(Sender: TObject);
    procedure ShowAllClick(Sender: TObject);
    procedure UndoClick(Sender: TObject);
    procedure ZoomChange(Sender: TObject);




  private
    { private declarations }
  public
    { public declarations }
  end;
    procedure SaveImageAll(Path: string);
    procedure DownloadImage(Path: string);

const
  Key = '@TEditor' ;

var
  Editor: TEditor;
  isDrawing, BufferFlag: boolean;
  CurrentTool: TFigureTool;
  OpenPicture: string;

implementation

{$R *.lfm}

{ TEditor }


procedure TEditor.Exit_Click(Sender: TObject);
begin
  Close();
end;

procedure TEditor.MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; ACanvas: TCanvas);
var
  ParamPanel: TPanel;
begin
  IsDrawing := False;
  CurrentTool.MouseUp(X, Y, PB.Canvas);

  if SelectedCreateParamFlag then begin
  ParamPanel := TPanel.Create(Editor);
  ParamPanel.Top := 150;
  Parampanel.Left := 5;
  ParamPanel.Width := 155;
  ParamPanel.Height := 420;
  ParamPanel.Parent := ToolPanel;
  SelectedFigure.ParamsCreate(ParamPanel);
  end;
  SelectedCreateParamFlag := False;
  Invalidate;
end;

procedure TEditor.FormCreate(Sender: TObject);
var
  i: integer;
  ToolButton: TSpeedButton;
  ToolIcon: TBitMap;
begin
  SetLength(ArrayOfActions, Length(ArrayOfActions) + 1);
  CurrentTool := TPolyLineTool.Create();
  Zoom := 100;

  for i:=0 to high(Tool) do begin
  ToolButton := TSpeedButton.Create(Editor);
  ToolButton.Width := 40;
  ToolButton.Height := 40;
  ToolButton.Top := (i div 3) * 40;
  ToolButton.Left := (i mod 3) * 40 ;
  ToolButton.Parent := ButtonPanel;
  ToolButton.Tag := i;
  ToolButton.OnClick := @ButtonsDown;
  if i=0 then ToolButton.Click();
  ToolIcon := TBitmap.Create;
  with TPicture.create do
    begin
    LoadFromFile(Tool[i].Icons);
    ToolIcon.Assign(Graphic);
    end;
  ToolButton.Glyph := ToolIcon;
  end;
  Invalidate_:=@Invalidate;
  OpenPicture:='';
end;

procedure TEditor.ButtonsDown(Sender: TObject);
var
  Parampanel: TPanel;
  i: Integer;
begin
  CurrentTool := Tool[(Sender as TSpeedbutton).tag];

  ParamPanel := TPanel.Create(Editor);
  ParamPanel.Top := 150;
  Parampanel.LeFt := 5;
  ParamPanel.Width := 155;
  ParamPanel.Height := 420;
  ParamPanel.Parent := ToolPanel;
  CurrentTool.ParamsCreate(ParamPanel);

  if not ((Sender as TSpeedbutton).tag = 8)  then for i := 0 to High(Figures) do Figures[i].Selected := False;
  Invalidate;
end;

procedure TEditor.ClearAllClick(Sender: TObject);
begin
  SetLength(Figures,0);
  Invalidate;
end;

procedure TEditor.CopySelectedClick(Sender: TObject);
var
  i, q: Integer;
  a: StringArray;
begin
  SetLength(Buffer, 0);
  for i := 0 to High(Figures) do begin
  BufferFlag := True;
  if Figures[i].Selected then begin

    SetLength(Buffer, Length(Buffer) + 1);
    case Figures[i].ClassName of

      'TPolyLine':         Buffer[High(Buffer)] := TPolyLine.Create;
      'TLine'    :         Buffer[High(Buffer)] := TLine.Create;
      'TEllipce' :         begin
                             Buffer[High(Buffer)] := TEllipce.Create;
                             (Buffer[High(Buffer)] as TBigFigure).BrushColor := (Figures[i] as TBigFigure).BrushColor;
                             (Buffer[High(Buffer)] as TBigFigure).BrushStyle := (Figures[i] as TBigFigure).BrushStyle;
                           end;
      'TRectangle':        begin
                             Buffer[High(Buffer)] := TRectangle.Create;
                             (Buffer[High(Buffer)] as TBigFigure).BrushColor := (Figures[i] as TBigFigure).BrushColor;
                             (Buffer[High(Buffer)] as TBigFigure).BrushStyle := (Figures[i] as TBigFigure).BrushStyle;
                           end;
      'TRoundedRectangle': begin
                             Buffer[High(Buffer)] := TRoundedRectangle.Create;
                             (Buffer[High(Buffer)] as TBigFigure).BrushColor := (Figures[i] as TBigFigure).BrushColor;
                             (Buffer[High(Buffer)] as TBigFigure).BrushStyle := (Figures[i] as TBigFigure).BrushStyle;
                             (Buffer[High(Buffer)] as TRoundedRectangle).RoundingRadiusX := (Figures[i] as TRoundedRectangle).RoundingRadiusX;
                             (Buffer[High(Buffer)] as TRoundedRectangle).RoundingRadiusY := (Figures[i] as TRoundedRectangle).RoundingRadiusY;
                           end;
    end;

    for q := 0 to Length(Figures[i].Points) do begin
      SetLength(Buffer[High(Buffer)].Points, Length(Buffer[High(Buffer)].Points) + 1);
      Buffer[High(Buffer)].Points[q] := Figures[i].Points[q];
    end;

    (Buffer[High(Buffer)] as TLittleFigure).PenColor := (Figures[i] as TLittleFigure).PenColor;
    (Buffer[High(Buffer)] as TLittleFigure).PenStyle := (Figures[i] as TLittleFigure).PenStyle;
    (Buffer[High(Buffer)] as TLittleFigure).Width := (Figures[i] as TLittleFigure).Width;
  end;
end;
end;

procedure TEditor.BackClick(Sender: TObject);
begin
  if Length(Figures)<>0 then SetLength(Figures, Length(figures) - 1);
  Invalidate;
  CreateArrayOfActions();
end;

procedure TEditor.DeleteSelectedClick(Sender: TObject);
var
  i, j: Integer;
begin
  j := 0;
  for i := 0 to high(Figures) do
    begin
      if (Figures[i].Selected) then
        FreeAndNil(Figures[i])
      else
      begin
        Figures[j] := Figures[i];
        j := j + 1;
      end;
    end;
  setLength(Figures, j);
  Invalidate;
end;

procedure TEditor.FormPaint(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to high(Figures) do begin
    Figures[i].Draw(PB.Canvas);
    if Figures[i].Selected then Figures[i].DrawSelection(Figures[i], PB.Canvas, (Figures[I] AS TLittleFigure).WIDTH);
  end;
  ScrollBarVertical.Max := trunc(MaxPoint.Y);
  ScrollBarVertical.Min := trunc(MinPoint.Y);
  ScrollBarHorizontal.Max := trunc(MaxPoint.X);
  ScrollBarHorizontal.Min := trunc(MinPoint.X);
  ZoomSpinEdit.Value := zoom;
  AHeightPB := PB.Height;
  AWidthPB := PB.Width;
end;

procedure TEditor.AuthorClick(Sender: TObject);
begin
  ShowMessage('Татьяна Тунева, Б8103a');
end;

procedure TEditor.MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  IsDrawing := true;
  CurrentTool.MouseDown(X, Y);
  MaxMin(ScreenToWorld(Point(X,Y)));
  Invalidate;
end;

procedure TEditor.MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
  );
begin
  if IsDrawing then  begin
    CurrentTool.MouseMove(X, Y);
    MaxMin(ScreenToWorld(Point(X,Y)));
    Invalidate;
  end;
end;


procedure TEditor.ScrollBarScroll(Sender: TObject;
  ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
  Offset := Point(ScrollBarHorizontal.Position, ScrollBarVertical.Position);
  Invalidate;
end;

procedure TEditor.SelectAllClick(Sender: TObject);
var
  i: Integer;
begin
  for i:=0 to High(Figures) do Figures[i].Selected := True;
  Invalidate;
end;

procedure TEditor.SelectedDownClick(Sender: TObject);
var
  i, j, k: Integer;
  Figure: TFigure;
begin
  k := 0;
  for i := high(Figures) downto 0 do
    begin
      if (Figures[i].Selected) then
        begin
          for j := i downto k + 1  do
          begin
            Figure := Figures[j];
            Figures[j] := Figures[j-1];
            Figures[j-1] := Figure;
            k := j
          end;
        end;
    end;
  Invalidate;
end;

procedure TEditor.SelectedUpClick(Sender: TObject);
var
  i, j, k: Integer;
  Figure: TFigure;
begin
  k := high(Figures);
  for i := 0 to high(Figures) do
    begin
      if (Figures[i].Selected) then
        begin
          for j := i to k - 1 do
          begin
            Figure := Figures[j];
            Figures[j] := Figures[j+1];
            Figures[j+1] := Figure;
            k := j
          end;
        end;
    end;
  Invalidate;
end;

procedure TEditor.ShowAllClick(Sender: TObject);
begin
  RectZoom(pB.Height,PB.Width,MinPoint,MaxPoint);
  Invalidate;
  ScrollBarVertical.Max:=trunc(MaxPoint.Y);
  ScrollBarVertical.Min:=trunc(MinPoint.Y);
  ScrollBarHorizontal.Max:=trunc(MaxPoint.X);
  ScrollBarHorizontal.Min:=trunc(MinPoint.X);
  Offset.X:=0;
  Offset.Y:=0;
end;

procedure TEditor.ZoomChange(Sender: TObject);
begin
  Zoom := ZoomSpinEdit.Value;
  Invalidate;
end;

procedure TEditor.SaveImageClick(Sender: TObject);
begin
  if SDialog.Execute then begin
    OpenPicture := SDialog.FileName;
  end;
  SaveImageAll(OpenPicture);
end;

procedure SaveImageAll(Path: string);
var
  image: text;
  a: array of string;
  i, j: integer;
begin
  assign(image, Path);
  rewrite(image);
  writeln(image, Key);
  writeln(image, high(Figures));
  for i:=0 to High(Figures) do begin
    writeln(image, Figures[i].ClassName);
    writeln(image, '{');
    a := Figures[i].Save(Figures[i]);
    for j:=0 to high(a) do writeln(image, a[j]);
    writeln(image, '}');
  end;
  close(image);
end;

procedure TEditor.OpenImageClick(Sender: TObject);
begin
  if ODialog.Execute then begin
    DownloadImage(ODialog.Filename);
  end;
  Invalidate;
end;

procedure TEditor.PasteSelectedClick(Sender: TObject);
var
  i, q: Integer;
  a: StringArray;
begin
if (Length(Buffer) <> 0) and BufferFlag then begin
    SetLength(Figures, Length(Figures) + Length(Buffer));
    for i := 0 to high(Buffer) do begin
    case Buffer[i].ClassName of

      'TPolyLine':         Figures[Length(Figures) + i] := TPolyLine.Create;
      'TLine'    :         Figures[Length(Figures) + i] := TLine.Create;
      'TEllipce' :         begin
                             Figures[Length(Figures) + i] := TEllipce.Create;
                             (Figures[Length(Figures) + i] as TBigFigure).BrushColor := (Buffer[i] as TBigFigure).BrushColor;
                             (Figures[Length(Figures) + i] as TBigFigure).BrushStyle := (Buffer[i] as TBigFigure).BrushStyle;
                           end;
      'TRectangle':        begin
                             Figures[Length(Figures) + i] := TRectangle.Create;
                             (Figures[Length(Figures) + i] as TBigFigure).BrushColor := (Buffer[i] as TBigFigure).BrushColor;
                             (Figures[Length(Figures) + i] as TBigFigure).BrushStyle := (Buffer[i] as TBigFigure).BrushStyle;
                           end;
      'TRoundedRectangle': begin
                             Figures[Length(Figures) + i] := TRoundedRectangle.Create;
                             (Figures[Length(Figures) + i] as TBigFigure).BrushColor := (Buffer[i] as TBigFigure).BrushColor;
                             (Figures[Length(Figures) + i] as TBigFigure).BrushStyle := (Buffer[i] as TBigFigure).BrushStyle;
                             (Figures[Length(Figures) + i] as TRoundedRectangle).RoundingRadiusX := (Buffer[i] as TRoundedRectangle).RoundingRadiusX;
                             (Figures[Length(Figures) + i] as TRoundedRectangle).RoundingRadiusY := (Buffer[i] as TRoundedRectangle).RoundingRadiusY;
                           end;
    end;

    for q := 0 to Length(Buffer[i].Points) do begin
      SetLength(Figures[Length(Figures) + i].Points, Length(Figures[Length(Figures) + i].Points) + 1);
      Figures[Length(Figures) + i].Points[q] := Buffer[i].Points[q];
    end;

    (Figures[Length(Figures) + i] as TLittleFigure).PenColor := (Buffer[i] as TLittleFigure).PenColor;
    (Figures[Length(Figures) + i] as TLittleFigure).PenStyle := (Buffer[i] as TLittleFigure).PenStyle;
    (Figures[Length(Figures) + i] as TLittleFigure).Width := (Buffer[i] as TLittleFigure).Width;
  end;
  end;
  Invalidate;
end;

procedure TEditor.RedooClick(Sender: TObject);
begin
 if UndoFlag then
 begin
   if Length(ArrayOfActions) <> 0 then begin
     Now := Now + 1;
     Figures := RefreshArrays(ArrayOfActions[Now]);
   end;
 end;
 Invalidate;
end;

procedure TEditor.UndoClick(Sender: TObject);
begin
  if Length(ArrayOfActions) <> 0 then begin
  Now := Now - 1;
  RefreshFigures(Now);
  UndoFlag := True;
end;
  Invalidate;
end;

procedure DownloadImage(Path: string);
var
  image: text;
  i, j: integer;
  s, l: String;
  a: StringArray;
begin
  assign(image, Path);
  reset(image);
  readln(image, s);
  if s = Key then begin
    Editor.FormCreate(nil);
    OpenPicture := Path;
    readln(image, l);
    SetLength(Figures, StrToInt(l) + 1);
    for i := 0 to StrToInt(l) do  begin
      readln(image, s);
      readln(image);
      if not (s = 'TPolyLine') then  begin
        setlength(a, 4);
        for j:=0 to 3 do readln(image, a[j]);

        if (s = 'TLine') then begin
          SetLength(a, 7);
          for j:=4 to 6 do readln(image, a[j]);
          TLine.Download(i, a) ;
          end;

        if (s = 'TRectangle') then begin
          SetLength(a, 9);
          for j:=4 to 8 do readln(image, a[j]);
          TRectangle.Download(i,a);
          end;

        if (s = 'TEllipce') then begin
          SetLength(a, 9);
          for j:=4 to 8 do readln(image, a[j]);
          TEllipce.Download(i, a);
          end;

        if (s = 'TRoundedRectangle') then begin
          SetLength(a, 11);
          for j:=4 to 10 do readln(image, a[j]);
          TRoundedRectangle.Download(i, a);
        end;

    end
    else begin
      read(image, s);
      SetLength(a, StrToInt(s) * 2 + 4);
      a[0] := S;
      for j := 1 to high(a) do readln(image, a[j]);
      TPolyline.Download(i, a);
    end;
    ReadLn(image);
    end;
  end;
end;

begin
end.
