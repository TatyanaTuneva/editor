unit ScaleUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, GraphMath;

function WorldToScreen (APoint: TFloatPoint): TPoint;
function ScreenToWorld (APoint: TPoint): TFloatPoint;
procedure MaxMin(APoint: TFloatPoint);
procedure RectZoom(AHeight,AWidth:Extended;MinPoint,MaxPoint: TFloatPoint);
procedure ShowAll(MinPoint, MaxPoint: TFloatPoint; zoom: double);

var
zoom: double;
Offset : TPoint;
MinPoint, MaxPoint: TFloatPoint;
AHeight, AWidth: Extended;
AHeightPB, AWidthPB: Extended;

implementation

procedure RectZoom(AHeight,AWidth:Extended;MinPoint,MaxPoint: TFloatPoint);
begin
  if (Awidth/(MaxPoint.X-MinPoint.X))>(AHeight/(MaxPoint.Y-MinPoint.Y)) then
    Zoom := 100*AHeight/(MaxPoint.Y-MinPoint.Y)
  else
    Zoom := 100*AWidth/(MaxPoint.X-MinPoint.X);
  Offset.x:=round(MinPoint.X*Zoom/100);
  Offset.y:=round(MinPoint.Y*Zoom/100);
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
  if (APoint.x > MaxPoint.x) then
     MaxPoint.x := APoint.x;
  if (APoint.y > MaxPoint.y) then
     MaxPoint.y := APoint.y;
  if (APoint.x < MinPoint.x) then
     MinPoint.x := APoint.x;
  if (APoint.y < MinPoint.y) then
     MinPoint.y := APoint.y;
end;

procedure ShowAll(MinPoint, MaxPoint: TFloatPoint; zoom: double);
begin
{ if abs(MaxPoint.X-MinPoint.x) then
    zoom := zoom
    else   }
end;

begin

end.
