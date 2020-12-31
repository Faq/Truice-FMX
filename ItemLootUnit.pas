unit ItemLootUnit;

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
  FMX.Graphics;

type
  TItemLootForm = class(TForm)
    Panel1: TPanel;
    btClose: TButton;
    PageControl1: TTabControl;
    tsLoot: TTabItem;
    lvItemLoot: TJvListView;
    MyQuery: TFDQuery;
    procedure FormCreate(Sender: TObject);
  public
    procedure Prepare(key: string);
  end;

implementation

uses MainUnit, MyDataModule;

{$R *.FMX}

procedure TItemLootForm.Prepare(key: string);
begin
  // load creature loot
  MainForm.LoadLoot(lvItemLoot, key);
end;

procedure TItemLootForm.FormCreate(Sender: TObject);
begin
  dmMain.Translate.CreateDefaultTranslation(TForm(Self));
  dmMain.Translate.TranslateForm(TForm(Self));
end;

end.
