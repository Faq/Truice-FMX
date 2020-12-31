unit SettingsUnit;

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
  TSettingsForm = class(TForm)
    pcSettings: TTabControl;
    tsColumns: TTabItem;
    Panel1: TPanel;
    lvColumns: TJvListView;
    Panel2: TPanel;
    btAdd: TSpeedButton;
    btDel: TSpeedButton;
    btUp: TSpeedButton;
    btDown: TSpeedButton;
    edFieldName: TEdit;
    edFieldName_LBL: TLabel;
    edWidth: TEdit;
    edWidth_LBL: TLabel;
    btUpdate: TSpeedButton;
    Label1: TLabel;
    tsSite: TTabItem;
    Panel3: TPanel;
    btOK: TButton;
    btCancel: TButton;
    Panel4: TPanel;
    Label2: TLabel;
    Panel5: TPanel;
    rgSite: TPanel;
    tsLanguage: TTabItem;
    Panel6: TPanel;
    Panel7: TPanel;
    Label3: TLabel;
    lbLanguage: TLabel;
    tsInternet: TTabItem;
    cbAutomaticCheckForUpdates: TCheckBox;
    Button1: TButton;
    edProxyServer: TEdit;
    edProxyServer_LBL: TLabel;
    edUsername: TEdit;
    edUsername_LBL: TLabel;
    edPassword: TEdit;
    edPassword_LBL: TLabel;
    edProxyPort: TEdit;
    edProxyPort_LBL: TLabel;
    tsPreferences: TTabItem;
    rgSQLStyle: TPanel;
    cbxLanguage: TComboBox;
    tsDBC: TTabItem;
    edDBCDir: TJvDirectoryEdit;
    lbDBCDir: TLabel;
    cbxDBCLocale: TComboBox;
    lbDBCLocale: TLabel;
    cbxLocales: TComboBox;
    lbLocales: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btDelClick(Sender: TObject);
    procedure btUpClick(Sender: TObject);
    procedure btDownClick(Sender: TObject);
    procedure btAddClick(Sender: TObject);
    procedure lvColumnsChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure btUpdateClick(Sender: TObject);
    procedure btOKClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    procedure LoadLanguages;
  public
    { Public declarations }
  end;

var
  SettingsForm: TSettingsForm;


implementation

uses MainUnit, Math;

{$R *.FMX}

procedure TSettingsForm.FormCreate(Sender: TObject);
var
  i: integer;
begin
  dmMain.Translate.CreateDefaultTranslation(TForm(Self));
  for i:=0 to MainForm.lvQuest.Columns.Count - 1 do
  begin
     with lvColumns.Items.Add do
     begin
       Caption:=MainForm.lvQuest.Columns[i].Caption;
       SubItems.Add(IntToStr(MainForm.lvQuest.Columns[i].Width));
     end;
  end;
  case dmMain.Site of
    sW: rgSite.ItemIndex:=0;
    sRW: rgSite.ItemIndex:=1;
    sT: rgSite.ItemIndex:=2;
    sA: rgSite.ItemIndex:=3;
    sD: rgSite.ItemIndex:=4;
  end;
  LoadLanguages;

  cbxLanguage.ItemIndex := cbxLanguage.Items.IndexOf(dmMain.Language);
  dmMain.Translate.TranslateForm(TForm(Self));

  cbAutomaticCheckForUpdates.Checked := dmMain.IsAutoUpdates;
  edProxyServer.Text := dmMain.ProxyServer;
  edProxyPort.Text := dmMain.ProxyPort;
  edUsername.Text := dmMain.ProxyUser;
  edPassword.Text := dmMain.ProxyPass;
  edDBCDir.Text := dmMain.DBCDir;
  cbxDBCLocale.ItemIndex := dmMain.DBCLocale;
  cbxLocales.ItemIndex:= dmMain.Locales;

  case MainForm.SyntaxStyle of
    ssInsertDelete: rgSQLStyle.ItemIndex := 1;
    ssReplace: rgSQLStyle.ItemIndex := 0;
    ssUpdate: rgSQLStyle.ItemIndex := 2;
  end;
end;

procedure TSettingsForm.LoadLanguages;
var
  SR: TSearchRec;
  F: integer;
begin
  cbxLanguage.Items.Clear;
  F := FindFirst(dmMain.ProgramDir+'LANG\*.lng', faAnyFile, SR);
  try
    while F = 0 do
    begin
      cbxLanguage.Items.Add(StringReplace(ExtractFileName(SR.Name),'.lng','',[]));
      F := FindNext(SR);
    end;
  finally
    FindClose(SR);
  end;
end;

procedure TSettingsForm.btDelClick(Sender: TObject);
begin
  if not Assigned(lvColumns.Selected) then exit;
  lvColumns.DeleteSelected;
end;

procedure TSettingsForm.btUpClick(Sender: TObject);
begin
  if Assigned(lvColumns.Selected) then
    lvColumns.MoveUp(lvColumns.Selected.Index);
end;

procedure TSettingsForm.btDownClick(Sender: TObject);
begin
  if Assigned(lvColumns.Selected) then
    lvColumns.MoveDown(lvColumns.Selected.Index);
end;

procedure TSettingsForm.btAddClick(Sender: TObject);
begin
  if edFieldName.Text='' then Exit;
  with lvColumns.Items.Add do
  begin
    Caption:=edFieldName.Text;
    if mainform.IsNumber(edWidth.Text) then
      SubItems.Add(edWidth.Text)
    else
      SubItems.Add('80');    
  end;
end;

procedure TSettingsForm.lvColumnsChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  if not Assigned(lvColumns.Selected) then exit;
  edFieldName.Text:=lvColumns.Selected.Caption;
  edWidth.Text:=lvColumns.Selected.SubItems[0];
end;

procedure TSettingsForm.btUpdateClick(Sender: TObject);
begin
  if not Assigned(lvColumns.Selected) then
  begin
    btAdd.Click;
  end
  else
  begin
    lvColumns.Selected.Caption:=edFieldName.Text;
    if mainform.IsNumber(edWidth.Text) then
      lvColumns.Selected.SubItems[0]:=edWidth.Text
    else
      lvColumns.Selected.SubItems[0]:='80';
  end;
end;

procedure TSettingsForm.Button1Click(Sender: TObject);
begin
  dmMain.IsAutoUpdates := cbAutomaticCheckForUpdates.Checked;
  dmMain.ProxyServer := edProxyServer.Text;
  dmMain.ProxyPort := edProxyPort.Text;
  dmMain.ProxyUser := edUsername.Text;
  dmMain.ProxyPass := edPassword.Text;
end;

procedure TSettingsForm.btOKClick(Sender: TObject);
begin
  case rgSite.ItemIndex of
    0: dmMain.Site:=sW;
    1: dmMain.Site:=sRW;
    2: dmMain.Site:=sT;
    3: dmMain.Site:=sA;
    4: dmMain.Site:=sD;
  end;
  dmMain.Language:=cbxLanguage.Text;
  dmMain.IsAutoUpdates := cbAutomaticCheckForUpdates.Checked;
  dmMain.ProxyServer := edProxyServer.Text;
  dmMain.ProxyPort := edProxyPort.Text;
  dmMain.ProxyUser := edUsername.Text;
  dmMain.ProxyPass := edPassword.Text;
  dmMain.DBCDir := edDBCDir.Text;
  dmMain.DBCLocale := cbxDBCLocale.ItemIndex;
  dmMain.Locales:= cbxLocales.ItemIndex;

  case rgSQLStyle.ItemIndex of
    0: MainForm.SyntaxStyle := ssReplace;
    1: MainForm.SyntaxStyle := ssInsertDelete;
    2: MainForm.SyntaxStyle := ssUpdate;
  end;
end;

end.
