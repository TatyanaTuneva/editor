unit ScaleUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, GraphMath;

function WorldToScreen (APoint: TFloatPoint): TPoint;
function ScreenToWorld (APoint: TPoint): TFloatPoint;
procedure MaxMin(APoint: TFloatPoint);
procedure RectZoom(AHeight,AWidth:Extended;MinX,MaxX,MinY,MaxY:Extended);

var
zoom: double;
Offset: TPoint;
MinX,MaxX,MinY,MaxY: Extended;
AHeight, AWidth: Extended;

implementation

procedure RectZoom(AHeight,AWidth:Extended;MinX,MaxX,MinY,MaxY:Extended);
begin
  if (Awidth/(MaxX-MinX))>(AHeight/(MaxY-MinY)) then
    Zoom := AHeight/(MaxY-MinY)*100
  else
    Zoom := AWidth/(MaxX-MinX)*100;
  Offset.x:=round(MinX*Zoom/100);
  Offset.y:=round(MinY*Zoom/100);
end;

function WorldToScreen (APoint: TFloatPoint): TPoint;
begin
  WorldToScreen.X:=round(APoint.X*Zoom/100)-Offset.x;
  WorldToScreen.y:=round(APoint.Y*Zoom/100)-Offset.y;
end;

function ScreenToWorld (APoint: TPoint): TFloatPoint;
begin
  ScreenToWorld.X:=(APoint.x+Offset.x)/(Zoom/100);
  ScreenToWorld.Y:=(APoint.y+Offset.y)/(Zoom/100);
end;

procedure MaxMin(APoint: TFloatPoint);
begin
 if APoint.X > MaxX then MaxX :=APoint.X;
 if APoint.Y > MaxY then MaxY :=APoint.Y;
 if APoint.X < MinX then MinX :=APoint.X;
 if APoint.Y < MinY then MinY :=APoint.Y;
end;

begin

end.
