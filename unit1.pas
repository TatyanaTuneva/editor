unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Menus, StdCtrls, ActnList, ColorBox, Spin, utools, figures_, Buttons;

type

  { TEditor }

  TEditor = class(TForm)
    Back: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Color_: TColorBox;
    ColorLabel: TLabel;
    BrushColor_: TColorBox;
    Ellipce: TButton;
    Line: TButton;
    FuckingPanel: TPanel;
    ButtonPanel: TPanel;
    Polyline: TButton;
    Rectangle: TButton;
    WidthLabel: TLabel;
    MMenu: TMainMenu;
    File_: TMenuItem;
    About: TMenuItem;
    Exit_: TMenuItem;
    Author: TMenuItem;
    PB: TPaintBox;
    BrushLabel: TLabel;
    Width_: TSpinEdit;
    procedure ButtonsDown(Sender: TObject);
    procedure BackClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormPaint(Sender: TObject);
    procedure Exit_Click(Sender: TObject);
    procedure AuthorClick(Sender: TObject);
    procedure MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);


  private
    { private declarations }
  public
    { public declarations }
  end;

type
  line = record
  color: TColor;
  width: integer;
  points: array of TPoint;
end;

var
  Editor: TEditor;
  lines: array of line;
  isDrawing: boolean;
  CurrentTool: TFigureTool;
  Tool: array of TFigureTool;

implementation

{$R *.lfm}

{ TEditor }


procedure TEditor.Exit_Click(Sender: TObject);
begin
   Close();
end;

procedure TEditor.MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  IsDrawing := False;
  Invalidate;
end;

procedure TEditor.Button5Click(Sender: TObject);
begin
  setlength(Figures, 0);
  Invalidate;
end;

procedure TEditor.FormCreate(Sender: TObject);
var
  i: integer;
  TButton_: TSpeedButton;
  ToolIcon: TBitMap;
begin
  for i:=0 to 3 do begin
  TButton_ := TSpeedButton.Create(Editor);
  TButton_.Width := 40;
  TButton_.Height := 40;
  TButton_.Top := 0;
  TButton_.Left := 5+5*i+40*i;
  TButton_.Parent := ButtonPanel;
  TButton_.Tag := i ;
  ToolIcon := TBitmap.Create;
  with TPicture.create do
    begin
    LoadFromFile(Tool[i].Icons);
    ToolIcon.Assign(Graphic);
    end;
  TButton_.Glyph := ToolIcon;
  end;

end;

procedure TEditor.ButtonsDown(Sender: TObject);
begin
  CurrentTool := Tool[(Sender as TSpeedbutton).tag];
end;

procedure TEditor.Button1Click(Sender: TObject);
begin
  CurrentTool := TLineTool.Create();
end;

procedure TEditor.BackClick(Sender: TObject);
begin
  if length(figures)>0 then setlength(Figures, length(figures) -1);
  Invalidate;
end;

procedure TEditor.Button2Click(Sender: TObject);
begin
  CurrentTool := TRectangleTool.Create();
end;

procedure TEditor.Button3Click(Sender: TObject);
begin
  CurrentTool := TEllipceTool.Create();
end;

procedure TEditor.Button4Click(Sender: TObject);
begin
  CurrentTool := TPolyLineTool.Create();
end;

procedure TEditor.FormPaint(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to high(Figures) do begin
    Figures[i].Draw(PB.Canvas);
  end;
end;

procedure TEditor.AuthorClick(Sender: TObject);
begin
  ShowMessage('Татьяна Тунева, Б8103a');
end;

procedure TEditor.MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  IsDrawing := true;
  CurrentTool.MouseDown(X, Y, Width_.Value, Color_.Selected, BrushColor_.Selected);
  Invalidate;
end;

procedure TEditor.MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
  );
begin
  if IsDrawing then  begin
  CurrentTool.MouseMove(X, Y);
  Invalidate;
  end;
end;

begin
  CurrentTool := TPolyLineTool.Create();
  Setlength(Tool, 4);
  Tool[0]:= TPolyLineTool.Create();
  Tool[0].Icons:='C:\Users\Таня\Desktop\pascal\редактор\никчемная\0.png';
  Tool[1]:= TLineTool.Create();
  Tool[1].Icons:='C:\Users\Таня\Desktop\pascal\редактор\никчемная\1.png';
  Tool[2]:= TRectangleTool.Create();
  Tool[2].Icons:='C:\Users\Таня\Desktop\pascal\редактор\никчемная\2.png';
  Tool[3]:= TEllipceTool.Create();
  Tool[3].Icons:='C:\Users\Таня\Desktop\pascal\редактор\никчемная\3.png';

end.
