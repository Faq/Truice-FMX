unit TaxiMaskFormUnit;

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

  CharacterDataUnit;

type
  TTaxiMaskForm = class(TForm)
    Panel1: TPanel;
    btOK: TButton;
    btCancel: TButton;
    vleMain: TValueListEditor;
  private
    { Private declarations }
    function ReadData: string;
    procedure SetData(const Value: string);
    procedure SetKeys;
  public
    { Public declarations }
    property Data: string read ReadData write SetData;
  end;

implementation

{$R *.FMX}

{ TTaxiMaskForm }

function TTaxiMaskForm.ReadData: string;
var
  i : integer;
begin
  Result := '';
  for i := 1 to vleMain.RowCount - 1 do
    Result := Result + vleMain.Cells[1,i] + ' ';
end;

procedure TTaxiMaskForm.SetData(const Value: string);
begin
  ExtractStrings([' '], [], PWideChar(Value), vleMain.Strings);
  SetKeys;
end;

procedure TTaxiMaskForm.SetKeys;
begin
  SetCursor(LoadCursor(0,IDC_WAIT));
end;

end.
