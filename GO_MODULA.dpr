program GO_MODULA;

{$R 'ZZVERSIONE_GO_EXE.res' '..\..\..\go_1011\src\ZZVERSIONE_GO_EXE.rc'}


uses
  madExcept,
  Vcl.Forms,
  ZZACCESSO in '..\..\..\go_1011\src\ZZACCESSO.pas',
  DMARC in '..\..\..\go_1011\src\DMARC.pas' {ARC: TDataModule} ,
  GGLOGIN in '..\..\..\go_1011\src\GGLOGIN.pas' {LOGIN} ,
  GGBASE in '..\..\..\go_1011\src\GGBASE.pas' {BASE} ,
  GGFORMBASE in '..\..\..\go_1011\src\GGFORMBASE.pas' {FORMBASE} ,
  GGELABORA in '..\..\..\go_1011\src\GGELABORA.pas' {ELABORA} ,
  GGSTAMPA in '..\..\..\go_1011\src\GGSTAMPA.pas' {STAMPA} ,
  DMCLOUD in 'DMCLOUD.pas' {CLOUD: TDataModule} ,
  FRMDITTA in 'FRMDITTA.pas' {DITTA: TFrame} ,
  GGMENU in 'GGMENU.pas' {MENUGG};

{$r *.res}


begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TCLOUD, CLOUD);

  Application.CreateForm(TARC, ARC);
  Application.CreateForm(TLOGIN, LOGIN);
  Application.Run;

end.
