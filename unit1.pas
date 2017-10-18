unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Menus, StdCtrls, ActnList, ColorBox, Spin, utools, figures_;

type

  { TEditor }

  TEditor = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Color_: TColorBox;
    ColorLabel: TLabel;
    Ellipce: TButton;
    Line: TButton;
    FuckingPanel: TPanel;
    Polyline: TButton;
    Rectangle: TButton;
    WidthLabel: TLabel;
    MMenu: TMainMenu;
    File_: TMenuItem;
    About: TMenuItem;
    Exit_: TMenuItem;
    Author: TMenuItem;
    PB: TPaintBox;
    Width_: TSpinEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
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
  CurrentTool : TFigureTool;
  TButton1: TButton;

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

procedure TEditor.Button1Click(Sender: TObject);
begin
  CurrentTool := TLineTool.Create();
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
  CurrentTool.MouseDown(X, Y, Width_.Value, Color_.Selected, Color_.Selected);
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
 { TButton1:= TButton.Create();
  TButton1.Caption:='добавить';
  TButton1.Width:=75;
  TButton1.Height:=17;
  TButton1.Top:=36;
  TButton1.Left:=535;
 // TButton1.Parent:=;//место ее размещения
  //TButton1.OnClick:=create_batton(t.Tag+1);//по идеи для создания следующей кнопки }



end.
