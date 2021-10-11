unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,ComponentContainer, StdCtrls, DragComponentContainer, ExtCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Panel1: TPanel;
    Memo1: TMemo;
    Edit1: TEdit;
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    dragcomp: TDragComponentContainer;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button2Click(Sender: TObject);
begin
 dragcomp.BtnsCont.addControl(Button1);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  dragcomp:=TDragComponentContainer.create(self);
  dragcomp.Parent:=Self;
  dragcomp.Left:=10;
  dragcomp.top:=10;
  dragcomp.visible:=true;
  dragcomp.anchors:=[akLeft, akTop, akRight, akBottom];

  button1.OnStartDrag:=dragcomp.ControlStartDrag;
  button1.OnEndDrag:=dragcomp.ControlEndDrag;
  button2.OnStartDrag:=dragcomp.ControlStartDrag;
  button2.OnEndDrag:=dragcomp.ControlEndDrag;
  button3.OnStartDrag:=dragcomp.ControlStartDrag;
  button3.OnEndDrag:=dragcomp.ControlEndDrag;
  panel1.OnStartDrag:=dragcomp.ControlStartDrag;
  panel1.OnEndDrag:=dragcomp.ControlEndDrag;
  memo1.OnStartDrag:=dragcomp.ControlStartDrag;
  memo1.OnEndDrag:=dragcomp.ControlEndDrag;
  edit1.OnStartDrag:=dragcomp.ControlStartDrag;
  edit1.OnEndDrag:=dragcomp.ControlEndDrag;
end;


end.
