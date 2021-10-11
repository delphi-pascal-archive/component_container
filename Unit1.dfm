object Form1: TForm1
  Left = 218
  Top = 125
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Component container'
  ClientHeight = 270
  ClientWidth = 611
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object Button1: TButton
    Left = 424
    Top = 56
    Width = 113
    Height = 25
    Caption = 'Button1'
    DragMode = dmAutomatic
    TabOrder = 0
  end
  object Button2: TButton
    Left = 424
    Top = 88
    Width = 113
    Height = 25
    Caption = 'Button2'
    DragMode = dmAutomatic
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 424
    Top = 120
    Width = 113
    Height = 25
    Caption = 'Button3'
    DragMode = dmAutomatic
    TabOrder = 2
  end
  object Panel1: TPanel
    Left = 424
    Top = 8
    Width = 177
    Height = 41
    Caption = 'Panel1'
    DragMode = dmAutomatic
    TabOrder = 3
  end
  object Memo1: TMemo
    Left = 424
    Top = 184
    Width = 177
    Height = 73
    DragMode = dmAutomatic
    Lines.Strings = (
      'Memo1')
    TabOrder = 4
  end
  object Edit1: TEdit
    Left = 424
    Top = 152
    Width = 113
    Height = 24
    DragMode = dmAutomatic
    TabOrder = 5
    Text = 'Edit1'
  end
end
