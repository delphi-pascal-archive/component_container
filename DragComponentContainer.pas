unit DragComponentContainer;

interface

uses
  SysUtils, Classes, Graphics, Controls, Dialogs,ComponentContainer,DragDropViewer;

type
  TDragComponentContainer = class(TCustomControl)
  private
    FDragDrop: TDragDropViewer;
    //procedure CanResize(Sender: TObject; var NewWidth, NewHeight: Integer; var Resize: Boolean);
  protected
    procedure Paint; override;
  public
    RowsCont: TComponentContainer;
    ColsCont: TComponentContainer;
    DataCont: TComponentContainer;
    BtnsCont: TComponentContainer;
    constructor Create(AOwner:TComponent); override;
    procedure ControlEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure ControlStartDrag(Sender: TObject; var DragObject: TDragObject);
  published
    //property minwidth:integer read m_minWidth write m_minWidth;
    //property minheight:integer read m_minHeight write m_minHeight;
    property Align;
    property Caption;
    property Color;
    property Cursor;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property Hint;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property Visible;
    property Anchors;
    property OnCanResize;

end;

procedure Register;


const
     rowsContWidth=75;
     btnsContWidth=75;

implementation

constructor TDragComponentContainer.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  FDragDrop := TDragDropViewer.Create(Self);
  
  RowsCont:=TComponentContainer.create(self);
  ColsCont:=TComponentContainer.create(self);
  DataCont:=TComponentContainer.create(self);
  BtnsCont:=TComponentContainer.create(self);

  //onCanResize:=CanResize;

  RowsCont.Parent:=self;
  ColsCont.Parent:=self;
  DataCont.Parent:=self;
  BtnsCont.Parent:=self;

  Width:=400;
  Height:=250;
  constraints.MinWidth:=width;
  constraints.MinHeight:=Height;

  ColsCont.Width:=Width-rowsContWidth - btnsContWidth;
  ColsCont.Height:=30;
  ColsCont.Left:=rowsContWidth-1;
  ColsCont.top:=0;
  ColsCont.visible:=true;
  ColsCont.color:=clBlue;
  ColsCont.anchors:=[akLeft, akTop, akRight];
  ColsCont.caption:='Columns';
  ColsCont.Horizontal:=true;

  RowsCont.Width:=rowsContWidth;
  RowsCont.Left:=0;
  RowsCont.height:=height-ColsCont.height +1;
  RowsCont.top:=ColsCont.height-1;
  RowsCont.visible:=true;
  RowsCont.color:=clGreen;
  RowsCont.anchors:=[akLeft, akTop, akBottom];
  RowsCont.caption:='Lines';

  DataCont.Width:= ColsCont.Width;
  DataCont.Left:=ColsCont.Left;
  DataCont.height:=height-ColsCont.height +1;
  DataCont.top:=RowsCont.top;
  DataCont.visible:=true;
  DataCont.color:=clFuchsia;
  DataCont.anchors:=[akLeft, akTop, akRight, akBottom];
  DataCont.caption:='Data';

  BtnsCont.Color:=clSilver;
  BtnsCont.top:=0;
  BtnsCont.Height:=height;
  BtnsCont.left:=ColsCont.left+ ColsCont.Width+5;
  BtnsCont.Width:=width-BtnsCont.left;
  BtnsCont.visible:=true;
  BtnsCont.anchors:=[akTop, akRight, akBottom];   
end;

procedure Register;
begin
  RegisterComponents('Samples', [TDragComponentContainer]);
end;

{procedure TDragComponentContainer.CanResize(Sender: TObject; var NewWidth, NewHeight: Integer; var Resize: Boolean);
begin
       if((NewWidth<minWidth)) then NewWidth:=minWidth;
       if((NewHeight<minHeight)) then NewHeight:=minHeight;
       resize:=true;
end;      }

procedure TDragComponentContainer.Paint;
begin
  inherited Paint;
  with Canvas do
    begin
      Brush.Style:=bsSolid;
      Brush.Color:=clBtnFace;
      Pen.Color:=clRed;
      Rectangle(0,0,Width,Height);
      //Rectangle(rowsBlockWidth+colsBlockWidth+5,0,btnsBlockWidth,height);
    end;
  RowsCont.Repaint;
  ColsCont.Repaint;
  DataCont.Repaint;
  BtnsCont.Repaint;
end;


procedure TDragComponentContainer.ControlEndDrag(Sender, Target: TObject; X, Y: Integer);
begin
     FDragDrop.DragControl := nil;
     (parent as TControl).Refresh;
     refresh();
end;

procedure TDragComponentContainer.ControlStartDrag(Sender: TObject; var DragObject: TDragObject);
begin
     CurrentDraggingControl:=(Sender as TControl);
     FDragDrop.DragControl := Sender as TWinControl;
     LastParent:=(Sender as TControl).parent;
end;


end.
