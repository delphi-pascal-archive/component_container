unit ComponentContainer;

interface

uses
  SysUtils, Classes, Graphics, Controls, Dialogs,Types ;

type
  TComponentContainer = class(TCustomControl)
  private
    mcontrols: array of TControl;
    mhorizontal:boolean;
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner:TComponent); override;
    procedure addControl(ctrl:TControl; X:integer=-1;Y:integer=-1);
    function hasControl(ctrl:TControl):boolean;
    function getPosition(X, Y: Integer):integer;
    function getCtrlPos(ctrl:TControl):integer;
    procedure deleteControl(id:integer); overload;
    procedure moveControl(frompos,topos:integer); 
    procedure deleteControl(ctrl:TControl);overload;
    procedure refreshControls();
    procedure DragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ResizeEvt(Sender: TObject);
    procedure clearlasts(del: boolean=false);
    function controlsCount():integer;

  published
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
    property Horizontal : boolean read mhorizontal write mhorizontal;    
  end;

procedure Register;

var
    CurrentDraggingControl: TControl;
    LastParent: TControl;
implementation

constructor TComponentContainer.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  Width:=50;
  Height:=50;
  Color:=clWhite;
  setlength(mcontrols,0);
  horizontal:=false;

  onDragOver:=DragOver;
  onDragDrop:=DragDrop;
  onResize:=ResizeEvt;

end;
function TComponentContainer.controlsCount():integer;
begin
     result:=length(mcontrols);
end;

procedure TComponentContainer.clearlasts(del: boolean=false);
begin
     if(assigned(CurrentDraggingControl) and assigned(LastParent)) then
     begin
          if(LastParent is TComponentContainer) then
          begin
              if(del) then
              begin
                  (LastParent as TComponentContainer).deleteControl(CurrentDraggingControl);
              end;
          end
          else
                   showmessage('invalid class type');
     end
     else
     begin
          showmessage('Drag control not assigned');
     end;

     CurrentDraggingControl:=nil;
     LastParent:=nil
end;

procedure TComponentContainer.moveControl(frompos,topos:integer);
var
tctrl: TControl;
i:integer;
begin
     tctrl:=mcontrols[frompos];
     if((frompos>controlsCount) or (frompos<0) or (topos>controlsCount) or (topos<0)) then
     begin
       showmessage('bad position');
       exit;
     end;
     if(frompos>topos) then
     begin
         for i := frompos downto topos +1 do
             mcontrols[i]:=mcontrols[i-1];
     end
     else
     begin
         for i := frompos to topos -1 do
             mcontrols[i]:=mcontrols[i+1];
     end;
     mcontrols[topos]:=tctrl;
end;

function TComponentContainer.hasControl(ctrl:TControl):boolean;
var
i:integer;
begin
result:=false;
     for i := 0 to controlsCount-1 do
     begin
       if(mcontrols[i]=ctrl) then
       begin
           result:=true;
           break;
       end;
     end;
end;

function TComponentContainer.getPosition(X, Y: Integer):integer;
var
i,ttop:integer;
begin
result:=-1;
     for i := 0 to controlsCount -1 do
     begin
          ttop:=mcontrols[i].Top-5;
          if((Y>ttop) AND (Y<ttop+mcontrols[i].height)) then
          begin
            result:=i;
            break;
          end;
     end;
end;

procedure TComponentContainer.DragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := Source is TPersistent;
end;
procedure TComponentContainer.DragDrop(Sender, Source: TObject; X, Y: Integer);
begin
     addControl((Source as TControl),X,Y);
end;
procedure TComponentContainer.addControl(ctrl:TControl; X:integer=-1;Y:integer=-1);
var
i,i2:integer;
begin
     if(hascontrol(ctrl)) then
     begin
       if((X>=0) and (Y>=0)) then
       begin
            i:=getCtrlPos(ctrl);
            i2:=getPosition(X, Y);
            if((i2>=0) and (i>=0)) then
            begin
               moveControl(i,i2);
            end
            else
            begin
              if(i>=0) then
              begin
                 moveControl(i,controlsCount-1);   //if no position, add it at the end
              end
              else      //control not found, should not happen
              begin
                showmessage('Can''t get position');
              end;
            end;
       end;
     clearlasts();
     end
     else  //control does not exists
     begin
       i:=controlsCount;
       setlength(mcontrols,i+1);
       ctrl.parent:=self;
       mcontrols[i]:=ctrl;
       if((X>=0) and (Y>=0)) then
       begin
            i2:=getPosition(X, Y);
            if(i2>=0) then
            begin
               moveControl(i,i2);
            end
            else
            begin
              //showmessage('Can''t get position');
            end;
       end;
       clearlasts(true);
     end;

refreshControls();
refresh();
end;
procedure TComponentContainer.deleteControl(id:integer);
var
i:integer;
begin
     if((id<0) or (id>=controlsCount)) then
     begin
       showmessage('Bad control ID');
       exit;
     end;

     for i := id to controlsCount - 2 do
     begin
       mcontrols[i]:=mcontrols[i+1];
     end;

     setlength(mcontrols,controlsCount-1);
     refreshControls();
end;

procedure TComponentContainer.deleteControl(ctrl:TControl);
var
i:integer;
begin
     i:=getCtrlPos(ctrl);
     if(i>=0) then
          deleteControl(i);
end;

function TComponentContainer.getCtrlPos(ctrl:TControl):integer;
var
i:integer;
begin
result:=-1;
     for i := 0 to controlsCount -1 do
     begin
       if(mcontrols[i]=ctrl) then
       begin
           result:=i;
           break;
       end;
     end;
end;

procedure TComponentContainer.ResizeEvt(Sender: TObject);
begin
     refreshControls();
end;
procedure TComponentContainer.refreshControls();
var
ctop,cleft:integer;
i:integer;
begin
     ctop:=5;
     cleft:=5;
     for i := 0 to controlsCount - 1 do
     begin
       if(horizontal) then
       begin
         mcontrols[i].Top:= 5;
         mcontrols[i].Left:=cleft;
         mcontrols[i].width:=round((width-5)/controlsCount)-5;     //-10 pour laisser une marge pour les triangles
         if(mcontrols[i].width> (round(width/2)-5)) then 
              mcontrols[i].width:=round(width/2)-5;
              
         mcontrols[i].visible:=true;
         mcontrols[i].refresh();
         cleft := cleft + mcontrols[i].width + 5;
       end
       else
       begin
         mcontrols[i].Top:= ctop;
         mcontrols[i].Left:=5;
         mcontrols[i].width:=width-10;
         mcontrols[i].visible:=true;
         mcontrols[i].refresh();
         ctop := ctop + mcontrols[i].Height + 5;
       end;

     end;
refresh();
end;

procedure Register;
begin
  RegisterComponents('Samples', [TComponentContainer]);
end;

procedure TComponentContainer.Paint;
var
i,x,y:integer;
tcoords:array [0..2] of TPoint;
begin
  inherited Paint;
  with Canvas do
    begin
      Brush.Style:=bsSolid;
      Brush.Color:=Color;
      Pen.Color:=clBlack;
      Rectangle(0,0,Width,Height);
      x:=round((width-TextWidth(Caption))/2);
      y:=round((height-TextHeight(Caption))/2);
      textout(x,y,caption);
    end;

      canvas.brush.color:=clBlack;
      for i := 0 to controlsCount - 1 do
      begin
         mcontrols[i].refresh();
         if(i<(controlsCount - 1)) then
         begin
              if(horizontal) then
              begin
                 tcoords[0].X:=mcontrols[i].left + mcontrols[i].width;
                 tcoords[1].X:=mcontrols[i].left + mcontrols[i].width;//round(width/2)+2;
                 tcoords[0].Y:=round(height/2)+2;
                 tcoords[1].Y:=round(height/2)-2;
                 tcoords[2].X:=mcontrols[i].left + mcontrols[i].width +5;
                 tcoords[2].Y:=round(height/2);
                 canvas.Polygon(tcoords);
              end
              else
              begin
                 tcoords[0].X:=round(width/2)-2;
                 tcoords[1].X:=round(width/2)+2;
                 tcoords[0].Y:=mcontrols[i].top + mcontrols[i].Height;
                 tcoords[1].Y:=mcontrols[i].top + mcontrols[i].Height;
                 tcoords[2].X:=round(width/2);
                 tcoords[2].Y:=mcontrols[i].top + mcontrols[i].Height +5;
                 canvas.Polygon(tcoords);
              end;
         end;
      end;


end;


end.
