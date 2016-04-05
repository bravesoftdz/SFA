unit UnMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, jpeg,
  StdCtrls, Grids, ExtCtrls, Buttons, ComCtrls, ShellAPI, Menus, FileCTRL,
  Dialogs, ImgList, IniFiles, OleCtrls, SHDocVw, MSHTML, ActiveX, Registry, ShlObj;

type
  TFileStatus = (fsNone, fsModify, fsOpen);
  {T_FileType = (ftTXT, ftIMAGE, ftVIDEO, ftMUSIK, ftPROGRAM, ftWEB, ftNONE);
  TFileType = Record
   FileType:T_FileType;
   FileTypeInf:String;
  end;}
  TFileType = (ftTXT, ftIMAGE, ftVIDEO, ftMUSIK, ftPROGRAM, ftWEB, ftNONE);
  //Пример записи информации на файл (в одну строку):
  // :: name|UnMain.dfm|;size|36812|;type|1|;
  // :: name|1.txt|;size|812|;type|1|;
  // :: name|Vid.avi|;size|48412356|;type|3|;
  TFileInfo = ^T_FileInfo;
  T_FileInfo = Record
   fiName,           //Оригинальное имя файла
   fiProg,           //используемое Приложение (для запуска)
   fiPath:String;    //Полный путь с именем файла
   fiSize:Integer;   //Размер файла
   fiType:TFileType; //Тип файла
   //fiDate:TDate;     //Дата создания файла
  end;

  TFmMain = class(TForm)
    StB: TStatusBar;
    PM: TPopupMenu;
    N_Del: TMenuItem;
    OD: TOpenDialog;
    SD: TSaveDialog;
    N_IzvlSel: TMenuItem;
    P_Client: TPanel;
    Splitter1: TSplitter;
    N2: TMenuItem;
    N_IzvlAll: TMenuItem;
    IL_Small: TImageList;
    ScB_Main: TScrollBox;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N_OpenBibl: TMenuItem;
    N_SaveBibl: TMenuItem;
    N5: TMenuItem;
    N_Close: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N_OpenDir: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    LVFiles: TListView;
    PClSearch: TPanel;
    Panel4: TPanel;
    PClS: TPanel;
    TreeView1: TTreeView;
    N3: TMenuItem;
    N4: TMenuItem;
    N_Renamer: TMenuItem;
    N19: TMenuItem;
    N20: TMenuItem;
    Splitter2: TSplitter;
    PC_Inf: TPageControl;
    TS_TXT: TTabSheet;
    RE_Info: TRichEdit;
    TS_IMAGE: TTabSheet;
    Im_Info: TImage;
    TS_VIDEO: TTabSheet;
    TS_MUSIK: TTabSheet;
    TS_PROGRAM: TTabSheet;
    TS_WEB: TTabSheet;
    WBR_Info: TWebBrowser;
    ScrollBox1: TScrollBox;
    N9: TMenuItem;
    N21: TMenuItem;
    N22: TMenuItem;
    N23: TMenuItem;
    N24: TMenuItem;
    N25: TMenuItem;
    N26: TMenuItem;
    N27: TMenuItem;
    N28: TMenuItem;
    IL_Temp: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure LVFilesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure N_IzvlSelClick(Sender: TObject);
    procedure N_IzvlAllClick(Sender: TObject);
    procedure PMPopup(Sender: TObject);
    procedure N_DelClick(Sender: TObject);
    procedure N_SaveBiblClick(Sender: TObject);
    procedure N_OpenBiblClick(Sender: TObject);
    procedure N_OpenDirClick(Sender: TObject);
    procedure LVFilesDeletion(Sender: TObject; Item: TListItem);
    procedure N_RenamerClick(Sender: TObject);
    procedure TS_TXTHide(Sender: TObject);
    procedure TS_IMAGEHide(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure TS_WEBHide(Sender: TObject);
    procedure LVFilesDblClick(Sender: TObject);
    procedure LVFilesChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure N22Click(Sender: TObject);
    procedure N_CloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure LoadInfIMAGE(FF:TMemoryStream; Mode:Boolean);
    procedure TextToWebBrowser(FF:TMemoryStream; var WB:TWebBrowser);
    //
    procedure LoadInfoFile(Mode:Boolean);
  public
    { Public declarations }
    NameBibl:String;
//    procedure LoadTV(Kategory:String);
    function FileSizeFrom_(Source:String; Mode:Boolean):String;
    procedure WMDropFiles(var Msg:TMessage); message wm_DropFiles;
    procedure CreateArhive(FileName:String; Files:TListView);
    procedure OpenAndCreateFromArhiv(FileName,Files:String; Index:Integer);
    procedure AddToStream(Source,Dest:TStream );
    procedure GetFromStream(Source,Dest:TStream; Index:Integer);
//    procedure FillTreeViewWithFiles(TV:TTreeView; Strs:TStringList);
    procedure Find(S:String; LVFile:TListView);
    function CreatePath(Path:String):String;
    procedure DeleteItems;
    function _FileType(FName:String):TFileType;
    procedure AddNewFileToLV(Name:String; Size:Integer);
    procedure Progress(I_Max, I_Pos:Integer);
    procedure RegisterFileType(Ext,FilePath:String);
    procedure OpenBibl(FilePath:String);
  end;

var
  FmMain: TFmMain;
  //glKategory:String;
  PathToCreateBibl:String;
  MemoryMatrix:array[0..99] of TFileInfo;

implementation

uses UnProgress, UnImage;

{$R *.dfm}

procedure TFmMain.RegisterFileType(Ext,FilePath:String);
var
 Reg:TRegistry;
 EF:String;
begin
 Reg:=TRegistry.Create;
 EF:=Ext+'File';
 with Reg do begin
  RootKey:=HKEY_CLASSES_ROOT;
  OpenKey('.'+Ext,True); WriteString('',EF); CloseKey;
  CreateKey(EF);
  OpenKey(EF,True); WriteString('','Библиотека SFA'); CloseKey;
  OpenKey(EF+'\DefaultIcon',True); WriteString('',FilePath+',0'); CloseKey;
  OpenKey(EF+'\Shell\Open\Command',True); WriteString('',FilePath+' "%1"'); CloseKey;
  Free;
 end;
 SHChangeNotify(SHCNE_ASSOCCHANGED, SHCNF_IDLIST, nil, nil);
end;

procedure ShowRealPath(const Path:String; Z:Byte; Res:TStaticText);
 function StartProgress:String;
 label
  DelL;
 var
  SText,DSo,PSo:String;
  P:Integer;
  Kx:Boolean;
 begin
  P:=Length(Path); SText:=Path;
  if P>Z then begin
   DSo:=Copy(SText,1,3);
   Delete(SText,1,3);
   DelL: begin
          Kx:=False;
          P:=Pos('\',SText);
          if P<>0 then begin
           Delete(SText,1,P);
          end else Kx:=True;
          SText:=Trim(SText);
         end;
   if (Length(SText)>Z) and (Kx=False) then goto DelL else
    PSo:=DSo+'...\'+Copy(SText,1,Length(SText));
   SText:=PSo;
  end;
  if SText[Length(SText)]='\' then Result:=Copy(SText,1,Length(SText)-1)
   else Result:=SText;
 end;
begin
 with Res do begin
  Caption:=StartProgress;
  Hint:=Path;
  ShowHint:=True;
 end;
end;

function LongToSize(SizeF:Longint):String;
 var
  S:String;
  DF:Real;
 begin
  S:=IntToStr(SizeF);
  case Length(S) of
   1..3: begin
          DF:=SizeF;
          S:=FloatToStr(DF)+' байт';
         end;
   4..6: begin
          DF:=SizeF/1024;
          S:=FloatToStr(Integer(Round(DF)))+' Кб';
         end;
   7..9: begin
          DF:=SizeF/1024/1024;
          S:=FloatToStr(Integer(Round(DF)))+' Мб';
         end;
   10..12: begin
            DF:=SizeF/1024/1024;
            S:=FloatToStr(Integer(Round(DF)))+' Mб';
           end;
  end;
  S:=Trim(S);
  Result:=S;
 end;

function DelInInt(S:String):Integer;
var
 I:Integer;
begin
 Result:=-1;
 if S='' then Exit;
 I:=1;
 while I<=Length(S) do begin
  if (StrToInt(S[I])<Ord('0')) and (S[I]>'9') then System.Delete(S,I,1) else Inc(I);
 end;
 Result:=StrToInt(S);
end;

{procedure TFmMain.LoadTV(Kategory:String);
var
 Str:TStringList;
 I:Integer;
 S:String;
begin
 I:=LVFiles.ItemIndex;
 if I<>-1 then LVFiles.Items[I].SubItems.Strings[3]:=Kategory;
 //K:=0;
 with TVTree do begin
  Items.Clear;
  Items.BeginUpdate;
  Str:=TStringList.Create;
  try
   for I:=0 to LVFiles.Items.Count-1 do begin
    //Z:=DelInInt(LVFiles.Items[I].SubItems.Strings[1]);
    //K:=K+Z;
    S:=LVFiles.Items[I].SubItems.Strings[3];
    if S<>'' then Str.Add(S+'\'+LVFiles.Items[I].Caption+'; '+IntToStr(I+1))
     else Str.Add(LVFiles.Items[I].Caption+'; '+IntToStr(I+1));
   end;
   FillTreeViewWithFiles(TVTree, Str);
   Items.EndUpdate;
  finally
   Str.Free;
  end;
  //MessageBox(Handle,PChar(String(TVTree.Items[0]...)),'',MB_OK);
 end;
 //StB.Panels[1].Text:='Размер: '+IntToStr(K);
end;}

function TFmMain.FileSizeFrom_(Source:String; Mode:Boolean):String;
var
 FileName:File of Byte;
 FileLength: Longint;
begin
 FileMode:=fmOpenRead; AssignFile(FileName,Source); Reset(FileName);
 FileLength:=FileSize(FileName);
 CloseFile(FileName);
 if Mode then Result:=LongToSize(FileLength) else Result:=IntToStr(FileLength);
end;

function TFmMain._FileType(FName:String):TFileType;
const
 Str:array[1..6] of String=('ftTXT','ftIMAGE','ftVIDEO','ftMUSIK','ftPROGRAM','ftWEB');
var
 Res,S:String;
 I:Integer;
 IniF:TIniFile;
begin
 Result:=ftNONE; Res:=''; S:='';
 for I:=Length(FName) downto 1 do if FName[I]<>'.' then Res:=Res+FName[I] else Break;
 for I:=Length(Res) downto 1 do S:=S+Res[I];
 Res:=AnsiLowerCase(S);
 IniF:=TIniFile.Create(ExtractFilePath(ParamStr(0))+'FileType.ini');
 try
  for I:=1 to 6 do begin
   S:=IniF.ReadString(Str[I],'Type','');
   if Pos(Res,S)<>0 then begin
    case I of
     1: Result:=ftTXT;
     2: Result:=ftIMAGE;
     3: Result:=ftVIDEO;
     4: Result:=ftMUSIK;
     5: Result:=ftPROGRAM;
     6: Result:=ftWEB;
    else Result:=ftNONE;
    end;
    Break;
   end;
  end;
 finally
  IniF.Free;
 end;
end;

function _fiTypeNum(FileType:TFileType):Integer;
begin
 case FileType of
  ftTXT:     Result:=1;
  ftIMAGE:   Result:=2;
  ftVIDEO:   Result:=3;
  ftMUSIK:   Result:=4;
  ftPROGRAM: Result:=5;
  ftWEB:     Result:=6;
  ftNONE:    Result:=0;
 end;
end;

procedure TFmMain.WMDropFiles(var Msg:TMessage);
var
 FileName:array[0..256] of Char;
 LI:TListItem;
 I:Integer;
 S:String;
 FileInfo:TFileInfo;
begin
 LVFiles.ItemIndex:=-1;
 DragQueryFile(THandle(Msg.WParam),0,FileName,SizeOf(FileName));
 S:=ExtractFileName(FileName);
 for I:=0 to LVFiles.Items.Count-1 do begin
  if S=LVFiles.Items[I].Caption then begin
   MessageBox(Handle,PChar('В списке уже есть файл с подобным именем!'),'Ошибка',
    MB_OK+MB_ICONERROR);
   Exit;
  end;
 end;
 LI:=LVFiles.Items.Add;
 LI.Caption:=S;
 LI.SubItems.Add(FileName);
 LI.SubItems.Add(FileSizeFrom_(FileName,True));
 LI.SubItems.Add(FileSizeFrom_(FileName,False));
  New(FileInfo);
  FileInfo.fiName := S;
  FileInfo.fiPath := FileName;
  //FileInfo.fiProg := '';
  FileInfo.fiSize := StrToInt(LI.SubItems[2]);
  FileInfo.fiType := _FileType(FileName);
 LI.ImageIndex    := _fiTypeNum(FileInfo.fiType);
 LI.Data:=FileInfo;
 DragFinish(THandle(Msg.WParam));
 StB.Panels[0].Text:='Объектов '+IntToStr(LVFiles.Items.Count);
end;

procedure TFmMain.CreateArhive(FileName:String; Files:TListView);
var
 ToFile,FromFiles:TMemoryStream;
 I:Integer;
 FromFile:String;
begin
 ToFile:=TMemoryStream.Create;
 try
  FromFiles:=TMemoryStream.Create;
  try
   FromFiles.LoadFromFile(FileName+'.txt');
   AddToStream(FromFiles,ToFile);
   with FmProgress do begin
    Caption:='Создание библиотеки';
    L_Cap.Caption:='Добавление:';
    ShowRealPath(FileName,38,StT_Lib);
   end;
   Progress(Files.Items.Count-1,0);
   for I:=0 to Files.Items.Count-1 do begin
    Application.ProcessMessages;
    FromFile:=Files.Items[I].SubItems.Strings[0];
    ShowRealPath(FromFile,35,FmProgress.StT_File);
    ShowRealPath(FileName+'\'+Files.Items[I].Caption,35,FmProgress.StT_FSave);
    Progress(Files.Items.Count-1,I);
    FromFiles.LoadFromFile(FromFile);
    AddToStream(FromFiles,ToFile);
   end;
   {//=====
   FromFiles.LoadFromFile('D:\Медия\Клипы\Akon - Lonely.avi');
   AddToStream(FromFiles,ToFile);
   //=====}
  finally
   FromFiles.Free;
  end;
  ToFile.SaveToFile(FileName+'.sfa')
 finally
  ToFile.free;
  DeleteFile(FileName+'.txt');
  Progress(0,0);
 end;
end;

procedure TFmMain.OpenAndCreateFromArhiv(FileName,Files:String; Index:Integer);
var
 ToFile,FromFiles:TMemoryStream;
begin
 ToFile:=TMemoryStream.Create;
 try
  ToFile.LoadFromFile(FileName);
  FromFiles:=TMemoryStream.Create;
  try
   //=====
   GetFromStream(ToFile,FromFiles,Index);
   FromFiles.SaveToFile(Files);
   //FromFiles.
   //=====
  finally
   FromFiles.Free;
  end;
 finally
  ToFile.free;
 end;
end;

procedure TFmMain.AddToStream(Source,Dest:TStream);
var 
 Size:Integer;
begin
 Source.Position:=0;
 Size:=Source.Size;
 Dest.Write(Size,SizeOf(Integer));
 Dest.CopyFrom(Source,Source.size);
end;

procedure TFmMain.GetFromStream(Source,Dest:TStream; Index:Integer);
var
 Size,I:Integer;
begin
 Source.Position:=0;
 for I:=0 to Index-1 do begin
  Source.Read(Size,SizeOf(Integer));
  Source.Position:=Source.Position+Size;
 end;
 if Source.Position=Source.Size then Raise EAccessViolation.Create('Ошибочка');
 Source.Read(Size,SizeOf(Integer));
 Dest.Position:=0;
 Dest.Size:=0;
 Dest.CopyFrom(Source,Size); 
end;

procedure TFmMain.FormCreate(Sender: TObject);
begin
 DragAcceptFiles(Handle, True);
 PC_Inf.TabIndex:=-1;
 RegisterFileType('sfa',Application.ExeName);
end;

procedure TFmMain.DeleteItems;
var
 I:Integer;
begin
 I:=0;
 while I<=LVFiles.Items.Count-1 do
  if LVFiles.Items[I].Selected then LVFiles.Items.Delete(I) else Inc(I);
 StB.Panels[0].Text:='Объектов '+IntToStr(LVFiles.Items.Count);
end;

procedure TFmMain.LVFilesKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if Key=VK_DELETE then DeleteItems;
 if Key=VK_RETURN then LVFilesDblClick(Sender);
end;

function TFmMain.CreatePath(Path:String):String;
begin
 if Not DirectoryExists(Path) then CreateDir(Path);
 Result:=Path;
end;

procedure TFmMain.N_IzvlSelClick(Sender: TObject);
begin
 OpenAndCreateFromArhiv(StB.Panels[2].Text,CreatePath('C:\SFA_Temp\')+LVFiles.Items[LVFiles.ItemIndex].Caption,
  LVFiles.ItemIndex+1);
end;

procedure TFmMain.AddNewFileToLV(Name:String; Size:Integer);
var
 FileInfo:TFileInfo;
begin
 Application.ProcessMessages;
 with LVFiles.Items.Add do begin
  Caption:=ExtractFileName(Name);
  SubItems.Add(Name);
  SubItems.Add(FileSizeFrom_(Name,True));
  SubItems.Add(FileSizeFrom_(Name,False));
  New(FileInfo);
   FileInfo.fiName := Caption;
   FileInfo.fiPath := Name;
   //FileInfo.fiProg := '';
   FileInfo.fiSize := StrToInt(SubItems[2]);
   FileInfo.fiType := _FileType(Name);
  ImageIndex       := _fiTypeNum(FileInfo.fiType);
  Data:=FileInfo;
 end;
end;

procedure TFmMain.Find(S:String; LVFile:TListView);

 procedure FindS;
 var
  F:TSearchRec;
  fa:Integer;
 begin
  fa:=faAnyFile;
  if FindFirst(S+'\*',fa,F)<>0 then Exit;
  if (F.Name<>'.') and (F.Name<>'..') and (F.Attr<>faDirectory) then
   AddNewFileToLV(S+'\'+F.Name,F.Size);
  while FindNext(F)=0 do begin
   if (F.Name<>'.') and (F.Name<>'..') and (F.Attr<>faDirectory) then
    AddNewFileToLV(S+'\'+F.Name,F.Size);
  end;
  FindClose(F);
 end;
 
begin
 with LVFile do begin
  try
   Items.BeginUpdate; Clear;
   FindS;
  finally
   //AlphaSort;
   Items.EndUpdate;
   //LoadTV(glKategory);
   if Enabled and Visible then SetFocus;
  end;
 end;
end;

procedure TFmMain.N_IzvlAllClick(Sender: TObject);
var
 I:Integer;
 FName:String;
begin
 with FmProgress do begin
  Caption:='Извлечение из библиотеки';
  L_Cap.Caption:='Извлечение:';
  ShowRealPath(StB.Panels[2].Text,38,StT_Lib);
 end;
 Progress(LVFiles.Items.Count-1,0);
 try
  for I:=0 to LVFiles.Items.Count-1 do begin
   Application.ProcessMessages;
   FName:=LVFiles.Items[I].Caption;
   ShowRealPath(LVFiles.Items[I].Caption,35,FmProgress.StT_File);
   ShowRealPath('C:\SFA_Temp\'+FName,35,FmProgress.StT_FSave);
   Progress(LVFiles.Items.Count-1,I);
   OpenAndCreateFromArhiv(StB.Panels[2].Text,CreatePath('C:\SFA_Temp\')+FName,I+1);
  end;
 finally
  Progress(0,0);
 end;
end;

procedure TFmMain.PMPopup(Sender: TObject);
var
 Stat:Bool;
begin
 Stat:=Bool(LVFiles.Selected<>nil);
  N_Del.Enabled:=Stat;
  N_IzvlSel.Enabled:=Stat;
 Stat:=Bool(LVFiles.Items.Count>1);
  N_IzvlAll.Enabled:=Stat;
  N_Renamer.Enabled:=Stat;
end;

procedure TFmMain.N_DelClick(Sender: TObject);
begin
 DeleteItems;
end;

//Удаление каталога
function FullRemoveDir(Dir: String; DeleteAllFilesAndFolders,
  StopIfNotAllDeleted, RemoveRoot: Boolean): Boolean;
var
 i: Integer;
 SRec: TSearchRec;
 FN: string;
begin
 Result:=False;
 if not DirectoryExists(Dir) then exit;
 Result:=True;
 Dir:=IncludeTrailingBackslash(Dir);
 i:=FindFirst(Dir+'*',faAnyFile,SRec);
 try
  while i=0 do begin
   FN:=Dir+SRec.Name;
    if SRec.Attr=faDirectory then begin
     if (SRec.Name<>'') and (SRec.Name<>'.') and (SRec.Name<>'..') then begin
      if DeleteAllFilesAndFolders then FileSetAttr(FN, faArchive);
      Result:=FullRemoveDir(FN, DeleteAllFilesAndFolders, StopIfNotAllDeleted, True);
      if not Result and StopIfNotAllDeleted then exit;
     end;
    end else begin
     if DeleteAllFilesAndFolders then FileSetAttr(FN, faArchive);
      Result:=SysUtils.DeleteFile(FN);
      if not Result and StopIfNotAllDeleted then exit;
    end;
    i:=FindNext(SRec);
  end;
 finally
  SysUtils.FindClose(SRec);
 end;
 if not Result then exit;
 if RemoveRoot then if not RemoveDir(Dir) then Result:=false;
end;

procedure TFmMain.N_SaveBiblClick(Sender: TObject);

 function _fiName(FName:TFileInfo):String;
 begin
  Result:='name|'+FName.fiName+'|;';
 end;

 function _fiSize(FName:TFileInfo):String;
 begin
  Result:='size|'+IntToStr(FName.fiSize)+'|;';
 end;

 function _fiType(fType:TFileType):String;
 begin
  case fType of
   ftTXT:     Result:='type|1|;';
   ftIMAGE:   Result:='type|2|;';
   ftVIDEO:   Result:='type|3|;';
   ftMUSIK:   Result:='type|4|;';
   ftPROGRAM: Result:='type|5|;';
   ftWEB:     Result:='type|6|;';
   ftNONE:    Result:='type|0|;';
  else        Result:='type|0|;'
  end;
 end;
 
var
 I:Integer;
 Memo:TMemo;
 S:String;
 FileInfo:TFileInfo;
begin
 if SD.Execute then begin
  try
   Memo:=TMemo.Create(FmMain);
   with Memo do begin
    Parent:=FmMain;
    Visible:=False; Enabled:=False; Clear; WordWrap:=False;
    for I:=0 to LVFiles.Items.Count-1 do begin
     FileInfo:=TFileInfo(LVFiles.Items[I].Data);
     if FileInfo<>nil then
      Lines.Add(_fiName(FileInfo) + _fiSize(FileInfo) + _fiType(FileInfo.fiType));
    end;
    S:=SD.FileName;
    Lines.SaveToFile(S+'.txt');
    StB.Panels[2].Text:=S+'.sfa';
    CreateArhive(S,LVFiles);
   end;
  finally
   Memo.Free;
  end;
  if FileExists(S+'.sfa') then
   if MessageBox(Handle,PChar('Библиотека создана. Хотите удалить каталог-источник ('
    +PathToCreateBibl+')?'),'Подтверждение удаления',
    MB_YESNO+MB_ICONWARNING)=ID_Yes then
     FullRemoveDir(PathToCreateBibl, True, False, True);
 end;
end;

procedure TFmMain.N_OpenBiblClick(Sender: TObject);
begin
 if OD.Execute then OpenBibl(OD.FileName);
end;

procedure TFmMain.N_OpenDirClick(Sender: TObject);
var
 PathFind:String;
begin
 SelectDirectory('Выбери папку','',PathFind);
 if Trim(PathFind)<>'' then begin
  Find(PathFind,LVFiles);
  PathToCreateBibl:=PathFind;
  StB.Panels[0].Text:='Объектов '+IntToStr(LVFiles.Items.Count);
 end;
end;

procedure TFmMain.LVFilesDeletion(Sender: TObject; Item: TListItem);
begin
 if Item.Data<>nil then Dispose(TFileInfo(Item.Data));
end;

procedure TFmMain.N_RenamerClick(Sender: TObject);
var
 I:Integer;
 S_Res,Str:String;
 FileInfo:TFileInfo;
begin
 S_Res:=InputBox('Изменить расширение','Введите новое расширение','.jpg');
 with LVFiles do begin
  try
   Items.BeginUpdate;
   for I:=0 to Items.Count-1 do begin
    Application.ProcessMessages;
    New(FileInfo);
    Str:='Item_'+IntToStr(I+1)+S_Res;
    Items[I].Caption:=Str;
    Items[I].SubItems[0]:=StB.Panels[2].Text+'\'+Str;
    FileInfo.fiName:=Str;
    FileInfo.fiType:= _FileType(S_Res);
    Items[I].Data:=FileInfo;
    Items[I].ImageIndex:= _fiTypeNum(FileInfo.fiType);
   end;
  finally
   Items.EndUpdate;
  end; 
 end;
end;

procedure TFmMain.Progress(I_Max, I_Pos:Integer);
begin
 with FmProgress do begin
  if I_Max>0 then begin
   if I_Pos=0 then PB_Progress.Max:=I_Max;
   PB_Progress.Position:=I_Pos;
   if Not Showing then begin
    Show; Update;
    Showing:=True;
   end;
  end else begin
   if Showing then begin
    Showing:=False;
    Hide;
   end; 
  end;
 end;
end;

//Загружаем информацию для ее отображения
procedure TFmMain.LoadInfIMAGE(FF:TMemoryStream; Mode:Boolean);
var
 JpegIm:TJpegImage;
 bm:TBitMap;
begin
 try
  bm:=TBitMap.Create;
  JpegIm:=TJpegImage.Create;
  try
   JpegIm.LoadFromStream(FF);
   bm.Assign(JpegIm);
  except
   FF.Position:=0;
   bm.LoadFromStream(FF);
  end;
  Im_Info.Picture.Bitmap:=bm;
  if Mode then
   with FmImage do begin
    Image.Picture.Bitmap:=bm;
    Show;
   end;
 finally
  bm.Free;
  JpegIm.Free;
 end;
end;

procedure TFmMain.TextToWebBrowser(FF:TMemoryStream; var WB:TWebBrowser);
var
 Document:IHTMLDocument2;
 V:OleVariant;
 Txt:TMemo;
 S:String;
begin
 Txt:=TMemo.Create(nil);
 try
  with Txt do begin
   Parent:=FmMain;
   Visible:=False; Enabled:=False;
   if WB.Document = nil then WB.Navigate('about:blank');
   while WB.Document = nil do Application.ProcessMessages;
   Document := WB.Document as IHtmlDocument2;
   V:=VarArrayCreate([0, 0], varVariant);
   Lines.LoadFromStream(FF);
   S:=Text;
   V[0]:=S;
   Document.Write(PSafeArray(TVarData(v).VArray));
   Document.Close;
  end;
 finally
  Txt.Free;
 end;
end;
//

procedure TFmMain.TS_TXTHide(Sender: TObject);
begin
 RE_Info.Clear;
end;

procedure TFmMain.TS_IMAGEHide(Sender: TObject);
begin
 Im_Info.Picture.Graphic:=nil;
end;

procedure TFmMain.FormResize(Sender: TObject);
begin
 PC_Inf.Height:=FmMain.Height div 2;
end;

procedure TFmMain.LoadInfoFile(Mode:Boolean);
var
 ToFile,FromFiles:TMemoryStream;
 FileType:TFileType;
begin
 if LVFiles.Selected=nil then Exit;
 if NameBibl='' then Exit;
 ToFile:=TMemoryStream.Create;
 try
  ToFile.LoadFromFile(StB.Panels[2].Text);
  FromFiles:=TMemoryStream.Create;
  try
   GetFromStream(ToFile,FromFiles,LVFiles.ItemIndex+1);
   FromFiles.Position:=0;
   FileType:=TFileInfo(LVFiles.Selected.Data).fiType;
   case FileType of
    ftTXT:    RE_Info.Lines.LoadFromStream(FromFiles);
    ftIMAGE:  LoadInfIMAGE(FromFiles, Mode);
    ftVIDEO:;
    ftMUSIK:;
    ftPROGRAM:;
    ftWEB:    TextToWebBrowser(FromFiles,WBR_Info);
    ftNONE:;
   end;
   PC_Inf.TabIndex:=_fiTypeNum(FileType)-1;
  finally
   FromFiles.Free;
  end;
 finally
  ToFile.free;
 end;
end;

procedure TFmMain.TS_WEBHide(Sender: TObject);
begin
 WBR_Info.Navigate('about:blank');
end;

procedure TFmMain.LVFilesDblClick(Sender: TObject);
begin
 LoadInfoFile(True);
end;

procedure TFmMain.LVFilesChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
 LoadInfoFile(False);
end;

procedure TFmMain.N22Click(Sender: TObject);
 {procedure Eskiz(FF:TMemoryStream; var Im_Info:TImage);
 var
  JpegIm:TJpegImage;
  BM:TBitMap;
 begin
  try
   BM:=TBitMap.Create;
   JpegIm:=TJpegImage.Create;
   try
    JpegIm.LoadFromStream(FF);
    BM.Assign(JpegIm);
   except
    FF.Position:=0;
    BM.LoadFromStream(FF);
   end;
   Im_Info.Picture.Bitmap:=bm;
  finally
   BM.Free;
   JpegIm.Free;
  end;
 end;}
 function Eskiz(FF:TMemoryStream):TBitMap;
 var
  JpegIm:TJpegImage;
  BM:TBitMap;
 begin
  try
   BM:=TBitMap.Create;
   JpegIm:=TJpegImage.Create;
   try
    JpegIm.LoadFromStream(FF);
    BM.Assign(JpegIm);
   except
    FF.Position:=0;
    BM.LoadFromStream(FF);
   end;
   Result:=bm;
  finally
   //BM.Free;
   JpegIm.Free;
  end;
 end;
var
 ToFile,FromFiles:TMemoryStream;
 I{,X,Y}:Integer;
 //Im_Eskiz:TImage;
begin
 {with LVFiles do begin
  Visible:=False; Enabled:=False;
  ScrollBox1.Visible:=True;
  ScrollBox1.Enabled:=True;
  ScrollBox1.Align:=alClient;
  if NameBibl='' then Exit;
  ToFile:=TMemoryStream.Create;
  try
   ToFile.LoadFromFile(NameBibl);
   FromFiles:=TMemoryStream.Create;
   try
    X:=0; Y:=0;
    for I:=0 to Items.Count-1 do begin
     GetFromStream(ToFile,FromFiles,I+1);
     FromFiles.Position:=0;
     Im_Eskiz:=TImage.Create(FmMain);
     with Im_Eskiz do begin
      Parent:=ScrollBox1;
      Width:=64; Height:=64;
      Top:=Y; Left:=X; X:=X+Width;
      if X+Width>ScrollBox1.ClientWidth-20 then begin
       Y:=Y+Height;
       X:=0;
      end;
      Center:=True;
      Proportional:=True;
      Eskiz(FromFiles,Im_Eskiz);
     end;
    end;
   finally
    FromFiles.Free;
   end;
  finally
   ToFile.free;
  end;
 end;}
 with LVFiles do begin
  ViewStyle:=vsIcon;
  IL_Temp.Clear;
  if NameBibl='' then Exit;
  Application.ProcessMessages;
  ToFile:=TMemoryStream.Create;
  try
   ToFile.LoadFromFile(NameBibl);
   Items.BeginUpdate;
   for I:=0 to Items.Count-1 do begin
    //Application.ProcessMessages;
    try
     FromFiles:=TMemoryStream.Create;
     GetFromStream(ToFile,FromFiles,I+1);
     FromFiles.Position:=0;
     Items[I].ImageIndex:=IL_Temp.AddMasked(Eskiz(FromFiles),clFuchsia);
    finally
     FromFiles.Free;
    end;
   end;
   Items.EndUpdate;
  finally
   ToFile.free;
  end;
 end;

end;

procedure TFmMain.N_CloseClick(Sender: TObject);
begin
 Close;
end;

procedure TFmMain.OpenBibl(FilePath: String);

 function _fiNT(Kom,Str:String):String;
 var
  P:Integer;
  S,S_:String;
 begin
  P:=Pos(Kom+'|',Str);
  S_:=Copy(Str,P+Length(Kom)+1,Length(Str));
  if P<>0 then S:=Copy(Str,P+Length(Kom)+1,Pos('|;',S_)-1) else S:='0';
  Result:=S;
 end;

 function _fiType(Str:String):TFileType;
 var
  P,S:Integer;
  S_:String;
 begin
  P:=Pos('type|',Str);
  S_:=Copy(Str,P+5,Length(Str));
  if P<>0 then S:=StrToInt(Copy(Str,P+5,Pos('|;',S_)-1)) else S:=0;
  case S of
   1: Result:=ftTXT;
   2: Result:=ftIMAGE;
   3: Result:=ftVIDEO;
   4: Result:=ftMUSIK;
   5: Result:=ftPROGRAM;
   6: Result:=ftWEB;
   0: Result:=ftNONE;
  end;
 end;

 function _fiTypeNum(Str:String):Integer;
 var
  P,S:Integer;
  S_:String;
 begin
  P:=Pos('type|',Str);
  S_:=Copy(Str,P+5,Length(Str));
  if P<>0 then S:=StrToInt(Copy(Str,P+5,Pos('|;',S_)-1)) else S:=0;
  Result:=S;
 end;

var
 Memo:TMemo;
 I:Integer;
 LI:TListItem;
 S,FN:String;
 FileInfo:TFileInfo;
begin
 NameBibl:=FilePath;
 StB.Panels[2].Text:=NameBibl;
 try
  Memo:=TMemo.Create(FmMain);
  FN:=OD.FileName+'.txt';
  with Memo do begin
   Parent:=FmMain; Visible:=False; Enabled:=False; Clear;
   LVFiles.Clear; LVFiles.Items.BeginUpdate; WordWrap:=False;
   OpenAndCreateFromArhiv(OD.FileName,FN,0);
   Lines.LoadFromFile(FN);
   for I:=0 to Memo.Lines.Count-1 do begin
    S:=Memo.Lines[I];
    //
    LI:=LVFiles.Items.Add;
    New(FileInfo);
     FileInfo.fiName := _fiNT('name',S);
     //FileInfo.fiProg := _fiNT('prog',S);
    LI.Caption:=FileInfo.fiName;
     FileInfo.fiPath := OD.FileName+'\'+LI.Caption;
     FileInfo.fiSize := StrToInt(_fiNT('size',S));
     FileInfo.fiType := _fiType(S);
    LI.SubItems.Add(FileInfo.fiPath);
    LI.SubItems.Add(LongToSize(FileInfo.fiSize));
    LI.SubItems.Add(IntToStr(FileInfo.fiSize));
    LI.Data:=FileInfo;
    LI.ImageIndex := _fiTypeNum(S);
    //
   end;
  end;
 finally
  LVFiles.Items.EndUpdate;
  Memo.Free;
  DeleteFile(FN);
  StB.Panels[0].Text:='Объектов '+IntToStr(LVFiles.Items.Count);
  //StB.Panels[2].Text:=' '+OD.FileName;
 end;
end;

procedure TFmMain.FormShow(Sender: TObject);
begin
 if Trim(NameBibl)>'' then OpenBibl(NameBibl);
end;

end.
