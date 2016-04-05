object FmImage: TFmImage
  Left = 193
  Top = 110
  BorderStyle = bsNone
  Caption = 'FmImage'
  ClientHeight = 446
  ClientWidth = 688
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  WindowState = wsMaximized
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object Image: TImage
    Left = 0
    Top = 0
    Width = 688
    Height = 446
    Align = alClient
    Center = True
    Proportional = True
    OnClick = ImageClick
  end
end
