unit ItemPageUnit;

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
  TItemPageForm = class(TForm)
    Panel1: TPanel;
    btOK: TButton;
    btCancel: TButton;
    PageControl1: TTabControl;
    tsSearch: TTabItem;
    pnSearch: TPanel;
    edPageID: TEdit;
    edPageID_LBL: TLabel;
    btSearch: TButton;
    lvPageItem: TJvListView;
    MyQuery: TFDQuery;
    edText: TEdit;
    edText_LBL: TLabel;
    procedure btSearchClick(Sender: TObject);
    procedure lvPageItemChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lvPageItemDblClick(Sender: TObject);
  private
    procedure Search;
  public
    procedure Prepare(Text: string);
  end;

implementation

uses MainUnit;

{$R *.FMX}

procedure TItemPageForm.btSearchClick(Sender: TObject);
begin
  Search;
  with lvPageItem do if Items.Count>0 then begin SetFocus; Selected:=Items[0]; end;
end;

procedure TItemPageForm.Prepare(Text: string);
begin
  edPageID.Text:=Text;
  Search;
end;

procedure TItemPageForm.Search;
var
  ID, Name, QueryStr, WhereStr: string;
begin
  ID:= edPageID.Text;

  Name:=edText.Text;
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
      WhereStr:=Format('%s AND (`text` LIKE ''%s'')',[WhereStr, Name])
    else
      WhereStr:=Format('WHERE (`text` LIKE ''%s'')',[Name]);
  end;

  QueryStr:=Format('SELECT * FROM `page_text` %s',[WhereStr]);

  MyQuery.SQL.Text:=QueryStr;
  lvPageItem.Items.BeginUpdate;
  try
    MyQuery.Open;
    lvPageItem.Clear;
    while not MyQuery.Eof do
    begin
      with lvPageItem.Items.Add do
      begin
        Caption:=MyQuery.FieldByName('entry').AsString;
        SubItems.Add(MyQuery.FieldByName('text').AsString);
        MyQuery.Next;
      end;
    end;
  finally
    lvPageItem.Items.EndUpdate;
    MyQuery.Close;
  end;
end;

procedure TItemPageForm.lvPageItemChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  btOK.Enabled:=Assigned(lvPageItem.Selected);
end;

procedure TItemPageForm.lvPageItemDblClick(Sender: TObject);
begin
  if Assigned(TJvListView(Sender).Selected) then ModalResult:=mrOk;
end;

procedure TItemPageForm.FormShow(Sender: TObject);
begin
  with lvPageItem do if Items.Count>0 then begin SetFocus; Selected:=Items[0]; end;
end;

procedure TItemPageForm.FormCreate(Sender: TObject);
begin
  dmMain.Translate.CreateDefaultTranslation(TForm(Self));
  dmMain.Translate.TranslateForm(TForm(Self));
end;

end.
