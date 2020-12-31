unit CheckUnit;

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
  TCheckForm = class(TForm)
    Memo: TMemo;
    Panel1: TPanel;
    btClose: TButton;
    btStop: TButton;
    btSave: TButton;
    SaveDialog: TSaveDialog;
    pbCheckQuest: TProgressBar;
    Label1: TLabel;
    procedure btStopClick(Sender: TObject);
    procedure btCloseClick(Sender: TObject);
    procedure btSaveClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    isStopped: boolean;
  end;

var
  CheckForm: TCheckForm;

implementation

uses MainUnit, MyDataModule;

{$R *.FMX}

procedure TCheckForm.btStopClick(Sender: TObject);
begin
  Label1.Caption:=dmMain.Text[22]; //  'Terminating check. Please wait.'
  Application.ProcessMessages;
  MainForm.StopThread;
  Label1.Caption:=dmMain.Text[23];  //'Terminated'
end;

procedure TCheckForm.btCloseClick(Sender: TObject);
begin
  close;
end;

procedure TCheckForm.btSaveClick(Sender: TObject);
begin
  if SaveDialog.Execute then
    Memo.Lines.SaveToFile(SaveDialog.FileName);
end;

procedure TCheckForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Label1.Caption:=dmMain.Text[22]; //  'Terminating check. Please wait.'
  Application.ProcessMessages;
  MainForm.StopThread;
  Label1.Caption:=dmMain.Text[23];  //'Terminated'
end;

procedure TCheckForm.FormCreate(Sender: TObject);
begin
  if not MainForm.MyTrinityConnection.Connected then Exit;
  dmMain.Translate.CreateDefaultTranslation(TForm(Self));
  dmMain.Translate.TranslateForm(TForm(Self));
  MainForm.Show;
  MainForm.SplashForm.Free;
end;

end.
