unit UFView;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

type

  { TFView }

  TFView = class(TForm)
    BtnConnect : TButton;
    Image1     : TImage;
    Label_Coord: TLabel;
    Panel1     : TPanel;
    Panel2     : TPanel;
    procedure BtnTestClick(Sender: TObject);
  private
    procedure SetLimites(x0,y0,x1,y1:extended);
    Procedure DefineLimites;
  public
    rx0,ry0,rx1,ry1: extended;
    Xmin           : extended;
    Ymin           : extended;
    Xmax           : extended;
    Ymax           : extended;
    a,bx,by        : extended;
    Gcode          : Tstrings;

    Procedure Display(SGcode:Tstrings; xmi,ymi,xma,yma:extended);

  end;

var
  FView: TFView;

implementation

{$R *.lfm}

{ TFView }

Procedure TFView.Display(SGcode:Tstrings; xmi,ymi,xma,yma:extended);
var
  i : integer;
begin
  Show;
//  Gcode.Clear;
//  for i:=0 to Sgcode.Count do Gcode.add(Sgcode[i]);
  SetLimites(xmi,ymi,xma,yma);
end;

procedure TFView.BtnTestClick(Sender: TObject);
var
  x0,y0,x1,y1:longint;
begin
  Image1.Canvas.Brush.Color := clWhite;
  Image1.Canvas.Brush.Style := bsSolid;

  Image1.Canvas.Pen.Color   := clBlue;
  Image1.Canvas.Pen.Width   := 1;
  Image1.Canvas.Pen.Style   := psSolid;

  Image1.Canvas.FillRect(0,0,Image1.Canvas.Width ,Image1.Canvas.Height );
  x0:=trunc( a*Xmin+Bx + 0.5);
  y0:=trunc( a*Ymin+By + 0.5);
  x1:=trunc( a*Xmax+Bx + 0.5);
  y1:=trunc( a*Ymax+By + 0.5);
  Image1.Canvas.Rectangle(x0, y0, x1, y1);
  Image1.Canvas.Line(x0, y0, x1, y1);
  Image1.Canvas.Line(x0, y1, x1, y0);

end;

procedure TFView.SetLimites(x0,y0,x1,y1:extended);
begin
 if x0=x1 then x1:=x0+10;
 if x0<x1 then
  begin
    rx0 :=x0;
    rx1 :=x1;
  end else begin
    rx0 :=x1;
    rx1 :=x0;
  end;

 if y0=y1 then x1:=y0+10;
 if y0<y1 then
  begin
    ry0 :=y0;
    ry1 :=y1;
  end else begin
    ry0 :=y1;
    ry1 :=y0;
  end;

 DefineLimites;
end;

Procedure TFView.DefineLimites;
Var
  ax,ay : extended;
  tmp:string;
begin
  ax:=Image1.width /(rx1-rx0);
  ay:=Image1.height/(ry1-ry0);
  if ay<ax then ax:=ay;
  a:=ax;
  bx:=Image1.width /2-a*(rx0+rx1)/2;
  by:=Image1.Height/2-a*(ry0+ry1)/2;

  Xmin :=-bx/a;
  Ymin :=-by/a;
  Xmax :=(Image1.width -bx)/a;
  Ymax :=(Image1.Height-by)/a;
  tmp:='('+FloatToStrf( Xmin,fffixed,6,1)+' ,'+FloatToStrf( Ymin,fffixed,6,1)+') - ('+FloatToStrf( Xmax,fffixed,6,1)+' ,'+FloatToStrf( Ymax,fffixed,6,1)+')';
  Label_Coord.Caption:=tmp;

end;

end.
