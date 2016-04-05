unit UnImage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Jpeg, ExtCtrls;

type
  TFmImage = class(TForm)
    Image: TImage;
    procedure ImageClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FmImage: TFmImage;

implementation

{$R *.dfm}

procedure TFmImage.ImageClick(Sender: TObject);
begin
 Close;
end;

procedure TFmImage.FormKeyPress(Sender: TObject; var Key: Char);
begin
 if Key=#27 then Close;
end;

end.
