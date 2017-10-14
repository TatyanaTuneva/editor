unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Menus, StdCtrls, ActnList, ColorBox, Spin;

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
    WidthLabel: TLabel;
    MMenu: TMainMenu;
    File_: TMenuItem;
    About: TMenuItem;
    Exit_: TMenuItem;
    Author: TMenuItem;
    PB: TPaintBox;
    Width_: TSpinEdit;
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
  SetLength(lines, 0);
  Invalidate;
end;

procedure TEditor.FormPaint(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to high(lines) do begin
    PB.Canvas.Pen.Color:= lines[i].Color;
    PB.Canvas.Pen.Width:= lines[i].Width;
      if Length(lines[i].points) = 1 then
      PB.Canvas.Line(lines[i].points[0],lines[i].points[0]);
    PB.Canvas.Polyline(lines[i].points);
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
  Invalidate;
end;

procedure TEditor.MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
  );
begin
  if IsDrawing then  begin
  Invalidate;
  end;
end;

begin
end.
