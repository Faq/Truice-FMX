unit ItemUnit;

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

  MyDataModule;

type
  TItemForm = class(TForm)
    Panel1: TPanel;
    btOK: TButton;
    btCancel: TButton;
    PageControl1: TTabControl;
    tsSearch: TTabItem;
    pnSearch: TPanel;
    edItemID: TEdit;
    edItemID_LBL: TLabel;
    edItemName: TEdit;
    edItemName_LBL: TLabel;
    btSearch: TButton;
    lvItem: TJvListView;
    MyQuery: TFDQuery;
    btBrowseSite: TButton;
    btLoot: TButton;
    pmBrowseSite: TPopupMenu;
    pmwowhead: TMenuItem;
    pmthottbot: TMenuItem;
    pmallakhazam: TMenuItem;
    btBrowseItemPopup: TButton;
    pmwowdb: TMenuItem;
    pmruwowhead: TMenuItem;
    procedure btSearchClick(Sender: TObject);
    procedure lvItemChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure FormShow(Sender: TObject);
    procedure btBrowseSiteClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btLootClick(Sender: TObject);
    procedure pmSiteClick(Sender: TObject);
    procedure lvItemDblClick(Sender: TObject);
    procedure btBrowseItemPopupClick(Sender: TObject);
    procedure btOKClick(Sender: TObject);
  private
    procedure Search;
  public
    Result: string;
    procedure Prepare(Text: string);
  end;

implementation

uses MainUnit, ItemLootUnit;

{$R *.FMX}

procedure TItemForm.btSearchClick(Sender: TObject);
begin
  Search;
  with lvItem do if Items.Count>0 then begin SetFocus; Selected:=Items[0]; end;
end;

procedure TItemForm.Prepare(Text: string);
begin
  edItemID.Text:=Text;
  Search;
end;

procedure TItemForm.Search;
var
  ID, Name, QueryStr, WhereStr: string;
begin
  ID:= edItemID.Text;

  Name:=edItemName.Text;
  Name:=StringReplace(Name, '''', '\''', [rfReplaceAll]);  
  Name:=StringReplace(Name, ' ', '%', [rfReplaceAll]);
  Name:='%'+Name+'%';

  QueryStr:='';
  WhereStr:='';
  if ID<>'' then
    WhereStr:=Format('WHERE (`entry` = %s)',[ID]);

  if Name<>'' then
  begin
    if WhereStr<> '' then
      WhereStr:=Format('%s AND (`name` LIKE ''%s'')',[WhereStr, Name])
    else
      WhereStr:=Format('WHERE (`name` LIKE ''%s'')',[Name]);
  end;

  QueryStr:=Format('SELECT * FROM `item_template` %s',[WhereStr]);

  MyQuery.SQL.Text:=QueryStr;
  lvItem.Items.BeginUpdate;
  try
    MyQuery.Open;
    lvItem.Clear;
    while not MyQuery.Eof do
    begin
      with lvItem.Items.Add do
      begin
        Caption:=MyQuery.FieldByName('entry').AsString;
        SubItems.Add(MyQuery.FieldByName('name').AsString);
        MyQuery.Next;
      end;
    end;
  finally
    lvItem.Items.EndUpdate;
    MyQuery.Close;
  end;
end;

procedure TItemForm.lvItemChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  btOK.Enabled:=Assigned(lvItem.Selected);
  btBrowseSite.Enabled:=Assigned(lvItem.Selected);
  btBrowseItemPopup.Enabled:=Assigned(lvItem.Selected);
  btLoot.Enabled:=Assigned(lvItem.Selected);
end;

procedure TItemForm.lvItemDblClick(Sender: TObject);
begin
  if Assigned(TJvListView(Sender).Selected) then ModalResult:=mrOk;
end;

procedure TItemForm.FormShow(Sender: TObject);
begin
  with lvItem do if Items.Count>0 then begin SetFocus; Selected:=Items[0]; end;
end;

procedure TItemForm.btBrowseItemPopupClick(Sender: TObject);
var
  pt: TPoint;
begin
  pt.X := TButton(Sender).Width;
  pt.Y := 0;
  pt := TButton(Sender).ClientToScreen(pt);
  TButton(Sender).PopupMenu.PopupComponent := TButton(Sender);
  TButton(Sender).PopupMenu.Popup(pt.X, pt.Y);
end;

procedure TItemForm.btBrowseSiteClick(Sender: TObject);
begin
  if assigned(lvItem.Selected) then
    dmMain.BrowseSite(ttItem, StrToInt(lvItem.Selected.Caption));
end;

procedure TItemForm.FormCreate(Sender: TObject);
begin
  dmMain.Translate.CreateDefaultTranslation(TForm(Self));
  dmMain.Translate.TranslateForm(TForm(Self));  
end;

procedure TItemForm.btLootClick(Sender: TObject);
var
  F: TItemLootForm;
begin
  F:=TItemLootForm.Create(Self);
  try
    F.Prepare(lvItem.Selected.Caption);
    F.ShowModal;
  finally
    F.Free;
  end;
end;

procedure TItemForm.btOKClick(Sender: TObject);
begin
  if assigned(lvItem.Selected) then
    Result := lvItem.Selected.Caption
  else
    Result := '';
end;

procedure TItemForm.pmSiteClick(Sender: TObject);
begin
  if Assigned(lvItem.Selected) then
  begin
    if TMenuItem(Sender).Name='pmwowhead' then
        dmMain.wowhead(ttItem, StrToInt(lvItem.Selected.Caption));
    if TMenuItem(Sender).Name='pmruwowhead' then
        dmMain.ruwowhead(ttItem, StrToInt(lvItem.Selected.Caption));
    if TMenuItem(Sender).Name='pmallakhazam' then
        dmMain.allakhazam(ttItem, StrToInt(lvItem.Selected.Caption));
    if TMenuItem(Sender).Name='pmthottbot' then
        dmMain.thottbot(ttItem, StrToInt(lvItem.Selected.Caption));
    if TMenuItem(Sender).Name='pmwowdb' then
        dmMain.wowdb(ttItem, StrToInt(lvItem.Selected.Caption));
  end;
end;

end.
