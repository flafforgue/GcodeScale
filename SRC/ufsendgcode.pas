unit uFSendGcode;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  LazSerial;

type

  { TFSend }

  TFSend = class(TForm)
    BtnConnect: TButton;
    BtnConnect1: TButton;
    BtnConnect2: TButton;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Edit1: TEdit;
    LazSerial1: TLazSerial;
    Memo1: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
  private

  public

  end;

var
  FSend: TFSend;

implementation

{$R *.lfm}

end.

