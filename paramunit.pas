unit ParamUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ToolsUnit, FiguresUnit, ScaleUnit, MainUnit, Graphics;

type
TParam = class
 procedure SelectedParam(AWidth: integer; APenColor: TColor; ABrushColor: TColor ); virtual;abstract;
end;

TPenColor = class (TParam)
 procedure SelectedParam(AWidth: integer; APenColor: TColor; ABrushColor: TColor); override;
end;

TBrushColor = class (TParam)
 procedure SelectedParam(AWidth: integer; APenColor: TColor; ABrushColor: TColor); override;
end;

TWidth = class(TParam)
 procedure SelectedParam(AWidth: integer; APenColor: TColor; ABrushColor: TColor); override;
end;

TRoundingRadius = class (TParam)
  procedure SelectedParam(AWidth: integer; APenColor: TColor; ABrushColor: TColor); override;
end;

implementation

procedure TPenColor.SelectedParam(AWidth: integer; APenColor: TColor; ABrushColor: TColor);
begin

end;

procedure TBrushColor.SelectedParam(AWidth: integer; APenColor: TColor; ABrushColor: TColor);
begin

end;

procedure TWidth.SelectedParam(AWidth: integer; APenColor: TColor; ABrushColor: TColor);
begin

end;

procedure TRoundingRadius.SelectedParam(AWidth: integer; APenColor: TColor; ABrushColor: TColor);
begin

end;

end.


