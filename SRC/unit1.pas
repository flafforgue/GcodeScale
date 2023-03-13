unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  EditBtn, ComCtrls, Menus,StrUtils,UFview,UFSendGcode,Math;

type

  { TForm1 }

  TForm1 = class(TForm)
    ButtonOpenFile: TButton;
    ButtonParse: TButton;
    ButtonSaveFile: TButton;
    ButtonShow: TButton;
    ButtonSend: TButton;
    CBoxAlignComments: TCheckBox;
    CBoxComments: TCheckBox;
    CB_InvertY: TCheckBox;
    CB_InvertX: TCheckBox;
    CB_ScaleLink: TCheckBox;
    CB_Skew: TCheckBox;
    CB_Horizontal: TCheckBox;
    CB_AlignLeft: TCheckBox;
    CB_AlignBottom: TCheckBox;
    CB_CenterVertical: TCheckBox;
    CB_AlignRight: TCheckBox;
    CB_AlignTop: TCheckBox;
    CB_PolarGraph: TCheckBox;
    ComboB_Scale: TComboBox;
    Edit_LrSize: TEdit;
    Edit_Hauteur: TEdit;
    Edit_ScaleX: TEdit;
    Edit_Margin: TEdit;
    Edit_ScaleY: TEdit;
    Edit_OrigineV: TEdit;
    Edit_Skew_AD: TEdit;
    Edit_Skew_BD: TEdit;
    Edit_Skew_AC: TEdit;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    LabelLongCouroie: TLabel;
    LabelCenter: TLabel;
    LblXmaxD: TLabel;
    LblXminS: TLabel;
    LblXmaxS: TLabel;
    LblXminD: TLabel;
    LblYmaxD: TLabel;
    LblYminS: TLabel;
    LblYmaxS: TLabel;
    LblYminD: TLabel;
    LblZmaxD: TLabel;
    LblZminS: TLabel;
    LblZmaxS: TLabel;
    LblZminD: TLabel;
    MainMenu1: TMainMenu;
    Memo2: TMemo;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    OpenFileNameEdit: TFileNameEdit;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel12: TPanel;
    Panel13: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Label10: TLabel;
    LabelSkew: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label15: TLabel;
    LabelPosInit: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Memo1: TMemo;
    LogMemo: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
    MsgPanel: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel9: TPanel;
    SaveFileNameEdit: TFileNameEdit;
    procedure ButtonSaveFileClick(Sender: TObject);
    procedure ButtonSendClick(Sender: TObject);
    procedure ButtonOpenClick(Sender: TObject);
    procedure ButtonParseClick(Sender: TObject);
    procedure ButtonShowClick(Sender: TObject);
    procedure CBoxCommentsChange(Sender: TObject);
    procedure CB_HorizontalChange(Sender: TObject);
    procedure CB_AlignLeftChange(Sender: TObject);
    procedure CB_AlignBottomChange(Sender: TObject);
    procedure CB_CenterVerticalChange(Sender: TObject);
    procedure CB_AlignRightChange(Sender: TObject);
    procedure CB_AlignTopChange(Sender: TObject);
    procedure Edit_HauteurExit(Sender: TObject);
    procedure Edit_LrSizeExit(Sender: TObject);
    procedure Edit_MarginExit(Sender: TObject);
    procedure Edit_OrigineVExit(Sender: TObject);
    procedure Edit_ScaleXExit(Sender: TObject);
    procedure Edit_ScaleYExit(Sender: TObject);
    procedure Edit_Skew_ADExit(Sender: TObject);
    procedure Edit_Skew_ACExit(Sender: TObject);
    procedure Edit_Skew_BDExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    Largeur         : Extended;
    Hauteur         : Extended;
    Center          : Extended;
    Polar_Lcouroie  : Extended;
    Polar_OriginV   : Extended;
    Polar_PosInit   : Extended;
    Skew_AC         : Extended;
    Skew_BD         : Extended;
    Skew_AD         : Extended;
    Skew_factor     : Extended;
    ScaleX          : Extended;
    ScaleY          : Extended;
    Margin          : Extended; // marge lors de la mise en page
    XminG,XmaxG     : extended; // Min - Max Gcode
    YminG,YmaxG     : extended;
    ZminG,ZmaxG     : extended;
    ax,ay           : extended;
    bx,by           : extended;

    PrintLr         : extended;
    PrintHt         : extended;
    MargX           : extended;
    MargY           : extended;

    XminD,XmaxD     : extended; // Min - Max Converted Gcode
    YminD,YmaxD     : extended;
    ZminD,ZmaxD     : extended;

    AbsoluteMode    : Boolean;  // true absolu - false relativ
    A_X             : Extended; // Absolute curent position since startup
    A_Y             : Extended; // assuming initial pos was 0,0,0
    A_Z             : Extended;
    O_X             : Extended; // Origin of machine
    O_Y             : Extended; // 0,0,0 at startup
    O_Z             : Extended;
    C_X             : Extended; // Curent position in Source Gcode
    C_Y             : Extended;
    C_Z             : Extended;
    Current_F       : extended;
    Current_S       : Extended;
    PreviousCde     : Char;
    PreviousNcde    : integer;
    PenDown         : boolean;

    Procedure ResetGCodeDest();

    procedure GeometrieCalculate ();
    procedure CalculateSkew();

    Procedure PrepareCalculationPos();
    procedure RecalulatePos();

    procedure CalculateLimites(SIn:Tstrings);
    Function  ParseOneLine(S:String;recal:Boolean):string;
    procedure ParseMemo(SIn:Tstrings;SOut:Tstrings);

  public

  end;


var
  Form1: TForm1;

implementation

{$R *.lfm}
const
  NbVal       = 11;
  MaxParam    = 15;

  _X = 0;
  _Y = 1;
  _Z = 2;
  _E = 3;
  _F = 4;
  _P = 5;
  _S = 6;
  _T = 7;
  _A = 8;
  _I = 9;
  _J = 10;

Var
  TabLetter   : Array [0..NbVal-1 ] of char = ('X','Y','Z','E','F','P','S','T','A','I','J');
  TabHasValue : Array [0..NbVal-1 ] of boolean;
  TabValue    : Array [0..NbVal-1 ] of extended;
  TabMinVal   : Array [0..NbVal-1 ] of extended;
  TabMaxVal   : Array [0..NbVal-1 ] of extended;
  CurrentLine : integer;

{ --------------------------------------------------------------------------- }
{                                                                             }
{ --------------------------------------------------------------------------- }

function strtofloat2(s:string):extended;
var
 i:integer;
 e:extended;
begin
  i:=pos('.',s);
  if i>0 then s:=LeftStr(s,i-1);
  try
    e:=strtofloat(s);
  except
    e:=0;
  end;
  strtofloat2:=e;
end;

Procedure ResetMinMax();
var i:integer;
begin
 for i:=0 to NbVal do
 begin
   TabMinVal[i]:= 9.9e999;
   TabMaxVal[i]:=-9.9e999;
 end
end;

Procedure TForm1.ResetGCodeDest();
begin
  XminD:= 9.9e999; // Min - Max Converted Gcode Reset
  YminD:= 9.9e999;
  ZminD:= 9.9e999;

  XmaxD:=-9.9e999;
  YmaxD:=-9.9e999;
  ZmaxD:=-9.9e999;
end;


Procedure ResetValues();
var i:integer;
begin
 for i:=0 to NbVal do
 begin
   TabValue[i]   := 0;
   TabHasValue[i]:=false;
 end
end;

Procedure AddValue(Letter:Char; Value:String; SetMax:boolean);
var i:integer;
begin
 Letter:=UpCase(Letter);
 i:=0;
 while (Letter<>TabLetter[i]) and (i<NbVal) do i:=i+1;
 if (i< NbVal ) then
 begin
   TabValue[i]  := 0;
   try
     TabValue[i]:=StrToFloat(Value);
   Except
     Form1.LogMemo.Lines.Add('Line :'+IntToStr(CurrentLine)+' : value '+Value+' not a number');;
   end;
   TabHasValue[i]:=true;
   if SetMax then
   begin
     if (TabValue[i] > TabMaxVal[i]) then TabMaxVal[i]:=TabValue[i];
     if (TabValue[i] < TabMinVal[i]) then TabMinVal[i]:=TabValue[i];
   end;
 end else begin
   Form1.LogMemo.Lines.Add('Line :'+IntToStr(CurrentLine)+' : '+Letter+' : not found');
 end;
end;

Procedure AddValue(Letter:Char; Value:String);
begin
  AddValue(Letter,Value,true);
end;

{ --------------------------------------------------------------------------- }
{                                                                             }
{ --------------------------------------------------------------------------- }

{ TForm1 }

procedure TForm1.CBoxCommentsChange(Sender: TObject);
begin
  CBoxAlignComments.Visible:=CBoxComments.Checked;
end;

procedure TForm1.CB_HorizontalChange(Sender: TObject);
begin
  if CB_Horizontal.Checked then
  begin
    CB_AlignLeft.Checked :=false;
    CB_AlignRight.Checked:=false;
  end;
end;

procedure TForm1.CB_AlignRightChange(Sender: TObject);
begin
  if CB_AlignRight.Checked then
  begin
    CB_AlignLeft.Checked :=false;
    CB_Horizontal.Checked:=false;
  end;
end;

procedure TForm1.CB_AlignLeftChange(Sender: TObject);
begin
  if CB_AlignLeft.Checked then
  begin
    CB_Horizontal.Checked:=false;
    CB_AlignRight.Checked:=false;
  end;
end;

procedure TForm1.CB_CenterVerticalChange(Sender: TObject);
begin
  if CB_CenterVertical.Checked then
  begin
    CB_AlignTop.Checked   :=false;
    CB_AlignBottom.Checked:=false;
  end;
end;

procedure TForm1.CB_AlignTopChange(Sender: TObject);
begin
  if CB_AlignTop.Checked then
  begin
    CB_CenterVertical.Checked:=false;
    CB_AlignBottom.Checked   :=false;
  end;
end;

procedure TForm1.CB_AlignBottomChange(Sender: TObject);
begin
  if CB_AlignBottom.Checked then
  begin
    CB_AlignTop.Checked      :=false;
    CB_CenterVertical.Checked:=false;
  end;
end;

{ --------------------------------------------------------------------------- }
{                           Values Change                                     }
{ --------------------------------------------------------------------------- }

procedure TForm1.GeometrieCalculate ();
var
  tmp:string;
begin
  Polar_PosInit:=sqrt(Center*Center + Polar_OriginV*Polar_OriginV);
  Polar_PosInit:=int(100*Polar_PosInit+0.005)/100;

  Center          :=Largeur / 2;
  Polar_Lcouroie  :=sqrt(Largeur*Largeur + (Hauteur+Polar_OriginV)*(Hauteur+Polar_OriginV));

  LabelPosInit.Caption     :=FloatToStrf(Polar_PosInit ,fffixed,6,2);
  LabelCenter.Caption      :=FloatToStrf(Center        ,fffixed,6,2);
  LabelLongCouroie.Caption :=FloatToStrf(Polar_Lcouroie,fffixed,6,2);
end;

procedure TForm1.Edit_LrSizeExit(Sender: TObject);
begin
  try
    Largeur:=strtofloat2(Edit_LrSize.Text);
  finally
  end;
  GeometrieCalculate ();
end;

procedure TForm1.Edit_MarginExit(Sender: TObject);
begin
   try
    Margin:=strtofloat2(Edit_Margin.Text);
  finally
  end;
end;

procedure TForm1.Edit_HauteurExit(Sender: TObject);
begin
  try
    Hauteur:=strtofloat2(Edit_Hauteur.Text);
  finally
  end;
  GeometrieCalculate ();
end;

procedure TForm1.Edit_OrigineVExit(Sender: TObject);
begin
  try
    Polar_OriginV:=strtofloat2(Edit_OrigineV.Text);
  finally
  end;
  GeometrieCalculate ();
end;

procedure TForm1.Edit_ScaleXExit(Sender: TObject);
begin
  try
    ScaleX:=strtofloat2(Edit_ScaleX.Text);
  finally
  end;
  if CB_ScaleLink.checked then
  begin
    if ScaleY<>ScaleX then Edit_ScaleY.Text:=FloatToStrf(ScaleX,fffixed,6,3 );
  end;
end;

procedure TForm1.Edit_ScaleYExit(Sender: TObject);
begin
  try
    ScaleY:=strtofloat2(Edit_ScaleY.Text);
  finally
  end;
  if CB_ScaleLink.checked then
  begin
    if ScaleY<>ScaleX then Edit_ScaleX.Text:=FloatToStrf(ScaleY,fffixed,6,3 );
  end;
end;

//const
//  pi_ = 3.1418526;

Procedure Tform1.CalculateSkew();
var
  ab    : extended;
  alpha : extended;
begin
  try
    ab   := sqrt(2*Skew_AC*Skew_AC+2*Skew_BD*Skew_BD-4*Skew_AD*Skew_AD)/2;
    alpha:= arccos((Skew_AC*Skew_AC-AB*AB-Skew_AD*Skew_AD) / (2*AB*Skew_AD));
    Skew_factor := tan(pi/2 - alpha);
  except
    Skew_factor := 0;
  end;
  LabelSkew.Caption:=FloatToStrf(Skew_factor,fffixed,6,4 );
end;


procedure TForm1.Edit_Skew_ADExit(Sender: TObject);
begin
  try
    Skew_AC:=strtofloat2(Edit_Skew_AC.Text);
  finally
  end;
  CalculateSkew();
end;

procedure TForm1.Edit_Skew_ACExit(Sender: TObject);
begin
  try
    Skew_BD:=strtofloat2(Edit_Skew_BD.Text);
  finally
  end;
  CalculateSkew();
end;

procedure TForm1.Edit_Skew_BDExit(Sender: TObject);
begin
  try
    Skew_BD:=strtofloat2(Edit_Skew_BD.Text);
  finally
  end;
  CalculateSkew();
end;

{ --------------------------------------------------------------------------- }
{                                                                             }
{ --------------------------------------------------------------------------- }

procedure TForm1.ButtonOpenClick(Sender: TObject);
begin
  Memo1.Clear;
  try
    MsgPanel.Caption:='Open : ' + OpenFileNameEdit.FileName;
    Memo1.Lines.LoadFromFile(OpenFileNameEdit.FileName);
    MsgPanel.Caption:='Limites';
    CalculateLimites (Memo1.Lines);
  except
    MsgPanel.Caption:='Error : '+IntToStr(CurrentLine)+' ' + OpenFileNameEdit.FileName;
  end;

  LblXminS.Caption:='.';  LblXmaxS.Caption:='.';
  LblYminS.Caption:='.';  LblYmaxS.Caption:='.';
  LblZminS.Caption:='.';  LblZmaxS.Caption:='.';

  if TabMinVal[_X]< 10000 then LblXminS.Caption:=FloatToStrf(TabMinVal[_X],fffixed,5,1 );
  if TabMinVal[_Y]< 10000 then LblYminS.Caption:=FloatToStrf(TabMinVal[_Y],fffixed,5,1 );
  if TabMinVal[_Z]< 10000 then LblZminS.Caption:=FloatToStrf(TabMinVal[_Z],fffixed,5,1 );
  if TabMaxVal[_X]>-10000 then LblXmaxS.Caption:=FloatToStrf(TabMaxVal[_X],fffixed,5,1 );
  if TabMaxVal[_Y]>-10000 then LblYmaxS.Caption:=FloatToStrf(TabMaxVal[_Y],fffixed,5,1 );
  if TabMaxVal[_Z]>-10000 then LblZmaxS.Caption:=FloatToStrf(TabMaxVal[_Z],fffixed,5,1 );
end;

procedure TForm1.ButtonSaveFileClick(Sender: TObject);
begin
  Memo2.Lines.SaveToFile(SaveFileNameEdit.FileName);
end;

procedure TForm1.ButtonParseClick(Sender: TObject);
begin
  ParseMemo(Memo1.Lines,Memo2.Lines);

  LblXminD.Caption:='-';  LblXmaxD.Caption:='-';
  LblYminD.Caption:='-';  LblYmaxD.Caption:='-';
  LblYminD.Caption:='-';  LblZmaxD.Caption:='-';

  if XminD< 10000 then LblXminD.Caption:=FloatToStrf(XminD,fffixed,5,1 );
  if YminD< 10000 then LblYminD.Caption:=FloatToStrf(YminD,fffixed,5,1 );
  if ZminD< 10000 then LblZminD.Caption:=FloatToStrf(ZminD,fffixed,5,1 );
  if XmaxD>-10000 then LblXmaxD.Caption:=FloatToStrf(XmaxD,fffixed,5,1 );
  if YmaxD>-10000 then LblYmaxD.Caption:=FloatToStrf(YmaxD,fffixed,5,1 );
  if ZmaxD>-10000 then LblZmaxD.Caption:=FloatToStrf(ZmaxD,fffixed,5,1 );
end;

procedure TForm1.ButtonShowClick(Sender: TObject);
begin
  FView.Display(Memo2.Lines ,XminD,YminD,XmaxD,YmaxD);
//  FView.Display(Memo2.Lines ,0,0,300,300);
end;

procedure TForm1.ButtonSendClick(Sender: TObject);
begin
  FSend.Show;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Largeur         :=550;
  Hauteur         :=700;
  Polar_OriginV   :=120;
  Skew_AC         :=140;
  Skew_BD         :=140;
  Skew_AD         :=100;
  ScaleX          :=1;
  ScaleY          :=1;
  Margin          :=20;

  Edit_HauteurExit(Nil);
  Edit_LrSizeExit(Nil);
  Edit_MarginExit(Nil);
  Edit_OrigineVExit(Nil);
  Edit_ScaleXExit(Nil);
  Edit_ScaleYExit(Nil);
  Edit_Skew_ADExit(Nil);
  Edit_Skew_ACExit(Nil);
  Edit_Skew_BDExit(Nil);
  GeometrieCalculate();
  CalculateSkew();
end;

{ --------------------------------------------------------------------------- }
{                                                                             }
{ --------------------------------------------------------------------------- }

var
  Comment    : string;
  HasComment : boolean;

Procedure Tform1.PrepareCalculationPos();
begin
  XminG:=TabMinVal[_X];
  XmaxG:=TabMaxVal[_X];
  YminG:=TabMinVal[_Y];
  YmaxG:=TabMaxVal[_Y];

  if ComboB_Scale.ItemIndex>0 then
  begin
    case ComboB_Scale.ItemIndex of
     1 : begin                     // A4 - Portrait
           PrintLr :=210;
           PrintHt :=297;
         end;
     2 : begin                     // A4 - Paysage
           PrintLr :=297;
           PrintHt :=210;
         end;
     3 : begin                     // A3 - Portrait
           PrintLr :=297;
           PrintHt :=420;
         end;
     4 : begin                     // A3 - Paysage
           PrintLr :=420;
           PrintHt :=297;
         end;
     5 : begin                     // A2 - Portrait
           PrintLr :=420;
           PrintHt :=594;
         end;
     6 : begin                     // 50 x 100
           PrintLr :=50;
           PrintHt :=100;
         end;
     7 : begin                     // 100 x 160
           PrintLr :=100;
           PrintHt :=160;
         end;
     8 : begin                     // 300 x 400
           PrintLr :=300;
           PrintHt :=400;
         end;
     9 : begin                     // 500 x 800
           PrintLr :=500;
           PrintHt :=800;
         end;
     else begin
          PrintLr :=Largeur;
          PrintHt :=Hauteur;
         end;
    end;
    MargX   :=Margin;
    MargY   :=Margin;

    ax:=( PrintLr - 2*MargX ) / ( XmaxG - XminG );
    ay:=( PrintHt - 2*MargY ) / ( YmaxG - YminG );
    if ay<ax then ax:=ay;
    if ax<ay then ay:=ax;
  end else
  begin
    PrintLr :=Largeur;
    PrintHt :=Hauteur;
    MargX   :=0;
    MargY   :=0;

    ax:=scaleX;
    ay:=scaleY;
  end;

  //     X
  if CB_Horizontal.Checked then
  begin
    bx:=PrintLr/2 - ax*(XmaxG + XminG)/2;
  end else if CB_AlignRight.Checked then
  begin
    bx:=(PrintLr-MargX - ax * XmaxG);
  end else //    if CB_AlignLeft.Checked then  // if Not defined align Left
  begin
    bx:=MargX - ax * XminG;
  end;

  //     Y
  if CB_CenterVertical.Checked then
  begin
    by:=PrintHt/2 - ay*(YmaxG + YminG)/2;
  end else if CB_AlignBottom.Checked then
  begin
    by:=(PrintHt-MargY - ay * YmaxG);
  end else // if CB_AlignTop.Checked then      // if Not defined align Top
  begin
    by:=MargY - ay*YminG;
  end;

end;

procedure TForm1.RecalulatePos();
var
  x,y,z  : extended;
  x0,y0  : extended;
begin
  x:=TabValue[_X];
  y:=TabValue[_Y];
  z:=TabValue[_Z];

  // Calculate new position
  x:=ax*x + bx;
  y:=ay*y + by;

  // CB_InvertX & CB_InvertY
  if CB_InvertX.Checked then  x:=PrintLr - x;
  if CB_InvertY.Checked then  y:=PrintHt - y;

  // calculate Min / Max
  if TabHasValue[_X] then
  begin
    if x < XminD then XminD:=x;
    if x > XmaxD then XmaxD:=x;
  end;

  if TabHasValue[_Y] then
  begin
    if y < YminD then YminD:=y;
    if y > YmaxD then YmaxD:=y;
  end;

  if TabHasValue[_Z] then
  begin
    if z < ZminD then ZminD:=z;
    if z > ZmaxD then ZmaxD:=z;
  end;

  // Skew correction
  if CB_Skew.Checked then
  begin
    x:=x + Skew_factor*y;
  end;

  // polar correction
  if CB_PolarGraph.Checked then
  begin
    x0:=sqrt(x*x                     + (y+Polar_OriginV)*(y+Polar_OriginV));
    y0:=sqrt((Largeur-x)*(Largeur-x) + (y+Polar_OriginV)*(y+Polar_OriginV));
    x:=x0;
    y:=y0;
    if (TabHasValue[_X] or TabHasValue[_Y]) then
    begin
      TabHasValue[_X]:=true;
      TabHasValue[_Y]:=true;
    end;
  end;

  // reafect values
  TabValue[_X]:=x;
  TabValue[_Y]:=y;
  TabValue[_Z]:=z;
end;

procedure TForm1.CalculateLimites(SIn:Tstrings);
var
 s    : string;
 nb   : integer;
 i    : integer;
begin
  ResetMinMax();
  nb:=SIn.Count;
  for i:=0 to nb-1 do
  begin
    CurrentLine:=i;
    s:=ParseOneLine(SIn[i],false);
  end;
end;

Function TForm1.ParseOneLine(S:String;recal:Boolean):string;
Var
  i     : integer;
  Group : char;
  Code  : integer;
  Tab   : Array [0..MaxParam-1 ] of string;
  NbTab : integer;
  Tmp   : string;

begin
  ResetValues();
  Comment   :='';
  HasComment:= false;
  for i:=1 to Length(s) do   // Remove Tabs
  begin
     if s[i]=#9 then s[i]:=' ';
  end;

  for i:=1 to length(s) do if s[i]='.' then s[i]:=',';  // convert decimal

  s:=TrimLeft(TrimRight(s)); // remove comments
  i:=pos(';',s);
  if (i>0) then
  begin
    Comment   :=TrimLeft(RightStr(s,Length(s)-i));
    HasComment:=true;
    s         :=TrimRight(LeftStr(s,i-1));
  end;

  i:=1;                      // Remove double space
  while (i<Length(s)) do
  begin
   if (s[i]=' ') then
    begin
      i:=i+1;
      while (i<Length(s)) and (s[i]=' ')  do delete(s,i,1);
    end;
    i:=i+1;
  end;

  i:=1;                      // remove space after letter
  while (i<Length(s)) do
  begin
  if ( (s[i]>='A') and (s[i]<='Z') ) then
    begin
      i:=i+1;
      while (i<Length(s)) and (s[i]=' ')  do delete(s,i,1);
    end;
    i:=i+1;
  end;

  if ( length(s) > 0 ) then
  begin
    nbTab:=0;
    i:= pos(' ',s);
    while (i>0 ) and (Nbtab < MaxParam-1) do
    begin
      tab[nbTab]:=LeftStr(s,i-1);
      delete(s,1,i);
      i:= pos(' ',s);
      nbTab:=nbTab+1;
    end;
    Tab[nbTab]:=s;

    Group:=Tab[0][1];
    Code :=StrToInt(RightStr(Tab[0],Length(Tab[0])-1));

    for i:=1 to nbTab do
    if length(Tab[i])>0 then
    begin
      AddValue(Tab[i][1], RightStr(Tab[i],Length(Tab[i])-1), true);
    end;

    if (( Group='G') and Recal ) then RecalulatePos();
//    if Recal then RecalulatePos();

    Tmp:=Group+inttoStr(Code)+' ';
    for i:=0 to NbVal do
      if TabHasValue[i] then
      begin
        Tmp:=Tmp + TabLetter[i];
        if pos(TabLetter[i],'PST')>0 then
          Tmp:=Tmp + FloatToStrf(TabValue[i],fffixed,1,0)+' '
        else
          Tmp:=Tmp + FloatToStrf(TabValue[i],fffixed,5,1 )+' ';
      end;
  end else
  begin             // empty line
    tmp:='';
  end;

  for i:=1 to length(tmp) do if tmp[i]=',' then tmp[i]:='.';  // change decimal
  tmp:=TrimRight(tmp);
  ParseOneLine:= Tmp;
end;

procedure TForm1.ParseMemo(SIn: Tstrings; SOut: Tstrings);
var
 s:string;
 nb:integer;
 i:integer;
begin
//  ResetMinMax();
  ResetGCodeDest();
  O_X             :=0;
  O_Y             :=0;
  O_Z             :=0;
  A_X             :=O_X;
  A_Y             :=O_Y;
  A_Z             :=O_Z;
  AbsoluteMode    :=true;
  C_X             :=A_X;
  C_Y             :=A_X;
  C_Z             :=A_X;
  PreviousCde     :=' ';
  PreviousNcde    :=-1;
  PenDown         :=false;
  Current_F       :=0;
  Current_S       :=0;

  PrepareCalculationPos();
  SOut.Clear;
  nb:=SIn.Count;
  for i:=0 to nb-1 do
   begin
     CurrentLine:=i;
     s:=ParseOneLine(SIn[i],true);
     if ( form1.CBoxComments.Checked and HasComment)  then
     begin
       if form1.CBoxAlignComments.Checked then
          s:=PadRight(s,25)+'; '+Comment
       else
          s:=s+'; '+Comment;
     end;
     if SOut<>Nil then SOut.add(s);
   end;
end;

{ --------------------------------------------------------------------------- }
{                                                                             }
{ --------------------------------------------------------------------------- }

end.

