object FmProgress: TFmProgress
  Left = 193
  Top = 111
  BorderStyle = bsToolWindow
  ClientHeight = 133
  ClientWidth = 395
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object paMid: TPanel
    Left = 0
    Top = 28
    Width = 395
    Height = 105
    Align = alClient
    BevelOuter = bvLowered
    TabOrder = 0
    object Bevel1: TBevel
      Left = 48
      Top = 72
      Width = 294
      Height = 26
    end
    object SB_No: TSpeedButton
      Left = 208
      Top = 74
      Width = 127
      Height = 22
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100' '#1086#1087#1077#1088#1072#1094#1080#1102
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object SB_Ok: TSpeedButton
      Left = 56
      Top = 74
      Width = 137
      Height = 22
      Enabled = False
    end
    object L_Cap: TLabel
      Left = 8
      Top = 8
      Width = 63
      Height = 13
      Caption = #1044#1086#1073#1072#1074#1083#1077#1085#1080#1077
    end
    object Label1: TLabel
      Left = 8
      Top = 28
      Width = 72
      Height = 13
      Caption = #1057#1086#1093#1088#1072#1085#1077#1085#1080#1077' '#1074':'
    end
    object Panel1: TPanel
      Left = 199
      Top = 74
      Width = 3
      Height = 22
      TabOrder = 0
    end
    object PB_Progress: TProgressBar
      Left = 8
      Top = 50
      Width = 381
      Height = 17
      TabOrder = 1
    end
    object StT_File: TStaticText
      Left = 84
      Top = 5
      Width = 301
      Height = 19
      AutoSize = False
      BorderStyle = sbsSingle
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
    object StT_FSave: TStaticText
      Left = 84
      Top = 25
      Width = 301
      Height = 19
      AutoSize = False
      BorderStyle = sbsSingle
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
    end
  end
  object paTop: TPanel
    Left = 0
    Top = 0
    Width = 395
    Height = 28
    Align = alTop
    BevelOuter = bvLowered
    TabOrder = 1
    object Label2: TLabel
      Left = 6
      Top = 7
      Width = 63
      Height = 13
      Caption = #1041#1080#1073#1083#1080#1086#1090#1077#1082#1072':'
    end
    object StT_Lib: TStaticText
      Left = 76
      Top = 5
      Width = 309
      Height = 19
      Alignment = taCenter
      AutoSize = False
      BorderStyle = sbsSingle
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
  end
end
