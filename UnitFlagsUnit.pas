unit UnitFlagsUnit;

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
  TUnitFlagsForm = class(TForm)
    Bevel: TPanel;
    btCancel: TButton;
    btOK: TButton;
    btCheckAll: TButton;
    clbMain: TCheckListBox;
    procedure FormCreate(Sender: TObject);
    procedure btOKClick(Sender: TObject);
    procedure btCheckAllClick(Sender: TObject);
  private
    FFlags: int64;
    { Private declarations }
  public
    { Public declarations }
    property Flags: int64 read FFlags;
    procedure Prepare(Text: string);
    procedure Load(What: string);
  end;

implementation

uses MyDataModule, Functions;

{$R *.FMX}

{ TUnitFlagsForm }

procedure TUnitFlagsForm.btCheckAllClick(Sender: TObject);
var
    i: integer;
begin
    FFlags := StrToInt64Def(Text,0);
    for i := 0 to clbMain.Items.Count - 1 do
    begin
        clbMain.Checked[i] := true;
    end;
end;

procedure TUnitFlagsForm.btOKClick(Sender: TObject);
var
  i: integer;
begin
  FFlags := 0;
  for i := 0 to clbMain.Items.Count - 1 do
    if clbMain.Checked[i] then FFlags := FFlags or (1 shl i); 
end;

procedure TUnitFlagsForm.FormCreate(Sender: TObject);
begin
  dmMain.Translate.CreateDefaultTranslation(TForm(Self));
  dmMain.Translate.TranslateForm(TForm(Self));
end;

procedure TUnitFlagsForm.Load(What: string);
begin
  Caption := What;
  LoadStringListFromFile(clbMain.Items, What);
  if clbMain.Items.Count <= 16  then clbMain.Columns := 1;
end;

procedure TUnitFlagsForm.Prepare(Text: string);
var
  i: integer;
begin
  FFlags := StrToInt64Def(Text,0);
  for i := 0 to clbMain.Items.Count - 1 do
  begin
    if FFlags and (1 shl i) <> 0 then
      clbMain.Checked[i] := true;
  end;
end;

end.
