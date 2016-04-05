program SFA;

uses
  Forms,
  UnMain in 'UnMain.pas' {FmMain},
  UnSaves in 'UnSaves.pas' {FmSaves},
  UnProgress in 'UnProgress.pas' {FmProgress},
  UnImage in 'UnImage.pas' {FmImage};

{$R *.res}
{$R Manifest.RES}

begin
  Application.Initialize;
  Application.HintColor:=$FFFFFF;
  Application.HintPause:=0;
  Application.CreateForm(TFmMain, FmMain);
  Application.CreateForm(TFmSaves, FmSaves);
  Application.CreateForm(TFmProgress, FmProgress);
  Application.CreateForm(TFmImage, FmImage);
  if ParamCount>0 then FmMain.NameBibl:=ParamStr(1) else FmMain.NameBibl:='';
  Application.Run;
end.
