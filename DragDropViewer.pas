unit DragDropViewer;

interface

uses
  Windows, Forms, Messages, SysUtils, Classes, Controls, Graphics;

type
  TDragDropViewer = class(TComponent)
  private
    { Contient le controle en cours de d�placement, 'Nil' sinon. }
    FControl: TWinControl;

    { Handle du canvas du controle. }
    FControlDC: HDC;

    { Dessin et position � laquelle le controle � �t� dessin�. }
    FControlBmp: TBitmap;
    FControlBmpPos: TPoint;

    { Contient le Canvas de l'�cran. }
    FScreenDC: HDC;

    { Ancien gestionnaire de messages de l'application. }
    FOldAppMsg: TMessageEvent;

    { Setter. }
    procedure SetControl(New: TWinControl);

  protected
    { Nouvelle m�thode de traitement des messages de l'application. }
    procedure NewMessageEvent(var Msg: TMsg; var Handled: Boolean);

    { Dessine le control s'il existe. }
    procedure DrawControl;

    { Efface le controle de son ancienne position. }
    procedure EraseControl;

  public
    { G�re les choses � faire. }
    procedure Refresh;

  published
    { Constructeur / Destructeur. }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    { Propr�t�s. }
    property DragControl: TWinControl read FControl write SetControl;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Exemples', [TDragDropViewer]);
end;

constructor TDragDropViewer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FControl := nil;
  FControlDC := 0;
  FScreenDC := GetDC(0);
  FControlBmp := nil;
  FControlBmpPos := Point(-1, -1);
  FOldAppMsg := nil;
end;

destructor TDragDropViewer.Destroy;
begin
  DragControl := nil;
  ReleaseDC(0, FScreenDC);
  inherited Destroy;
end;

procedure TDragDropViewer.NewMessageEvent(var Msg: TMsg; var Handled: Boolean);
begin
  { Traitement du message de souris. }
  if Msg.message = WM_MOUSEMOVE then
    Refresh;

  { On ne rompt pas la chaine de messages. }
  if Assigned(FOldAppMsg) then
    FOldAppMsg(Msg, Handled);
end;

procedure TDragDropViewer.DrawControl;
begin
  { Test pr�liminaire. }
  if not Assigned(FControl) then
    Exit;

  { Dessin du bitmap sur l'�cran en mode XOR. }
  BitBlt(FScreenDc, FControlBmpPos.X, FControlBmpPos.Y, FControlBmp.Width,
   FControlBmp.Height, FControlBmp.Canvas.Handle, 0, 0, SRCINVERT);
end;

procedure TDragDropViewer.EraseControl;
begin
  { Test pr�lminaire. }
  if FControlBmpPos.X = -1 then
    Exit;

  { Dessin du bitmap sur l'�cran en mode XOR. }
  BitBlt(FScreenDc, FControlBmpPos.X, FControlBmpPos.Y, FControlBmp.Width,
   FControlBmp.Height, FControlBmp.Canvas.Handle, 0, 0, SRCINVERT);
end;

procedure TDragDropViewer.Refresh;
begin
  { Efface le dessin s'il existait. }
  EraseControl;

  { Capture de la position du curseur. }
  GetCursorPos(FControlBmpPos);

  { Dessin du controle s'il existe toujours. }
  DrawControl;
end;

procedure TDragDropViewer.SetControl(New: TWinControl);
begin
  if New <> FControl then
  begin
    { Test super important: si New et Fcontrol sont tous deux assign�s,
    il faut appeler Setcontrol(nil) pour enlever le m�canisme de controle
    pour l'ancien TControl. }
    if Assigned(New) and Assigned(FControl) then
      SetControl(nil);

    { Affectation. }
    FControl := New;

    { Si le controle existe, onmet en place le m�canisme, sinon, on l'enl�ve. }
    if Assigned(New) then
    begin
      { D�tournement des messages de l'application. }
      FOldAppMsg := Application.OnMessage;
      Application.OnMessage := NewMessageEvent;

      { Cr�ation du bitmap et remplissage. }
      FControlBmp := TBitmap.Create;
      FControlBmp.Width := New.Width;
      FControlBmp.Height := New.Height;
      New.PaintTo(FControlBmp.Canvas, 0, 0);

      { Initialisation. }
      FControlBmpPos := Point(-1 , -1);

      { Dessin. }
      Refresh;
    end
    else
    begin
      { Ici, on enl�ve le m�canisme. }
      { D�j� le d�tournement des messages. }
      Application.OnMessage := FOldAppMsg;

      { On efface. }
      EraseControl;

      { On lib�re le bitmap. }
      FreeAndNil(FControlBmp);
    end;
  end; // if New <> FControl.
end;

end.
 