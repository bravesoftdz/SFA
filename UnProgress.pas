unit UnProgress;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Buttons, ExtCtrls;

type
  TFmProgress = class(TForm)
    paMid: TPanel;
    Bevel1: TBevel;
    SB_No: TSpeedButton;
    Panel1: TPanel;
    paTop: TPanel;
    Label2: TLabel;
    StT_Lib: TStaticText;
    PB_Progress: TProgressBar;
    SB_Ok: TSpeedButton;
    L_Cap: TLabel;
    StT_File: TStaticText;
    Label1: TLabel;
    StT_FSave: TStaticText;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Showing:Boolean;
  end;

var
  FmProgress: TFmProgress;

implementation

{$R *.dfm}

procedure TFmProgress.FormCreate(Sender: TObject);
begin
 Showing:=False;
 Left:=(Screen.Width-Width) div 2;
 Top:=(Screen.Height-Height) div 2;
end;

end.
