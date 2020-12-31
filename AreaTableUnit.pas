unit AreaTableUnit;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  System.IniFiles,
  Data.DB,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.Objects,
  FMX.Menus,
  FMX.Grid,
  FMX.ExtCtrls,
  FMX.ListBox,
  FMX.TreeView,
  FMX.Memo,
  FMX.TabControl,
  FMX.Layouts,
  FMX.Edit,
  FMX.Platform,
  FMX.Bind.DBEngExt,
  FMX.Bind.Editors,
  FMX.Bind.DBLinks,
  FMX.Bind.Navigator,
  Data.Bind.EngExt,
  Data.Bind.Components,
  Data.Bind.DBScope,
  Data.Bind.DBLinks,
  Datasnap.DBClient,
  Fmx.Bind.Grid,
  System.Rtti,
  System.Bindings.Outputs,
  Data.Bind.Grid,
  Fmx.StdCtrls,
  FMX.Header,
  FMX.Graphics,

  Functions;

type
  TAreaTableForm = class(TForm)
    PageControl1: TTabControl;
    tsSearch: TTabItem;
    pnSearch: TPanel;
    edSearchMask: TEdit;
    edSearchMask_LBL: TLabel;
    Panel1: TPanel;
    btOK: TButton;
    btCancel: TButton;
    lvList: TListView;
    procedure lvListChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure edSearchMaskChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lvListDblClick(Sender: TObject);
    procedure lvListColumnClick(Sender: TObject; Column: TListColumn);
  private
    prmName, prmID: integer;  
    procedure Search();
  public
    procedure Prepare(Text: string);
    function GetValue(ID: integer): WideString;
  end;

var
  AreaTableForm: TAreaTableForm;

implementation

uses MyDataModule, MainUnit;

{$R *.FMX}

{ TAreaTableForm }

procedure TAreaTableForm.Prepare(Text: string);
var
  i: integer;
begin
  if lvList.Items.Count=0 then SetList(lvList, 'AreaTable');
  for i:=0 to lvList.Items.Count - 1 do
  begin
    if lvList.Items[i].Caption = Text then
    begin
      lvList.Selected:=lvList.Items[i];
      lvList.Selected.MakeVisible(false);
      Exit;
    end;
  end;
end;

procedure TAreaTableForm.Search;
var
  i: integer;
begin
  for i:=0 to lvList.Items.Count - 1 do
  begin
    if Pos(LowerCase(edSearchMask.Text), LowerCase(lvList.Items[i].SubItems[0])) > 0  then
    begin
      lvList.Selected:=lvList.Items[i];
      lvList.Selected.MakeVisible(false);
      Exit;
    end;
  end;
end;

procedure TAreaTableForm.lvListChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  btOK.Enabled:=Assigned(lvList.Selected);
end;

procedure TAreaTableForm.lvListColumnClick(Sender: TObject; Column: TListColumn);
begin
  if column.Index = 0 then
  begin
    lvList.CustomSort(@CustomIDSortProc, prmID);
    prmID := -prmID;
  end
  else
  begin
    lvList.CustomSort(@CustomNameSortProc, prmName);
    prmName := -prmName;    
  end;
end;

procedure TAreaTableForm.lvListDblClick(Sender: TObject);
begin
  if Assigned(TJvListView(Sender).Selected) then ModalResult:=mrOk;
end;

procedure TAreaTableForm.edSearchMaskChange(Sender: TObject);
begin
  Search;
end;

procedure TAreaTableForm.FormCreate(Sender: TObject);
begin
  if not MainForm.MyTrinityConnection.Connected then Exit;
  dmMain.Translate.CreateDefaultTranslation(TForm(Self));
  dmMain.Translate.TranslateForm(TForm(Self));
end;

function TAreaTableForm.GetValue(id: integer): WideString;
var
  i: integer;
begin
  Result:='';
  if id<1 then Exit;
  for i:=0 to lvList.Items.Count - 1 do
  begin
    if id = StrToIntDef(lvList.Items[i].Caption,0) then
    begin
      Result := lvList.Items[i].SubItems[0];
      Exit;
    end;
  end;
end;

end.
