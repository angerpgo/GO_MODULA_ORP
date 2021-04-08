unit GGMENU;

interface

uses
  inifiles, windows, messages, sysutils, variants, classes, graphics, controls, forms, mask,
  dialogs, grids, stdctrls, extctrls, buttons, toolwin, comctrls, rztabs,
  db, xlsreadwriteii5, strutils, shellapi, math,
  myaccess, imglist, dxgdiplusclasses, menus,
  idbasecomponent, idcomponent, idtcpconnection, idtcpclient, ggbase,
  idexplicittlsclientserverbase, idftp, jpeg,
  rzbutton, dmarc, rzlabel, rzpanel, rzdbedit, rzlistvw, rztreevw, rzdbchk,
  rzradchk, rzsplit, rzcmbobx, rzprgres,
  rzspnedt, rzshelldialogs, rzdbcmbo, raizeedit_go, memds, dbaccess, rzedit,
  cxgraphics, cxcontrols, cxlookandfeels, cxlookandfeelpainters, cxstyles,
  cxcustomdata, cxfilter, cxdata, cxdatastorage, cxedit, cxdbdata, cxgridlevel,
  cxclasses, cxgridcustomview, cxgridcustomtableview, cxgridtableview,
  cxgriddbtableview, cxgrid, ipwcore, ipwhtmlmailer, query_go,
  Vcl.DBGrids, RzDBGrid, Data.Win.ADODB, XLSSheetData5;

type

  tmenugg = class(tform)
    panel3: trzpanel;
    label1: trzlabel;
    comboedit1: trzedit_go;
    label2: trzlabel;
    comboedit6: trzedit_go;
    label7: trzlabel;
    comboedit2: trzedit_go;
    label8: trzlabel;
    comboedit4: trzedit_go;
    label9: trzlabel;
    comboedit5: trzedit_go;
    label10: trzlabel;
    comboedit3: trzedit_go;
    label11: trzlabel;
    comboedit7: trzedit_go;
    pni: tmyquery;
    pnr: tmyquery;
    pnt: tmyquery;
    tco: tmyquery;
    tma: TMyQuery;
    cli: tmyquery;
    cfg: tmyquery;
    pat: tmyquery;
    tna: tmyquery;
    tpa: tmyquery;
    gen: tmyquery;
    tiv: tmyquery;
    tva: tmyquery;
    twe: tmyquery;
    groupbox1: tgroupbox;
    rzlabel1: trzlabel;
    twe_ds: tdatasource;
    rzlabel2: trzlabel;
    rzlabel3: trzlabel;
    timer1: ttimer;
    clp: tmyquery;
    query: tmyquery;
    v_hostname_go: trzedit_go;
    v_databasename_go: trzedit_go;
    v_username_go: trzedit_go;
    tng: tmyquery;
    v_griglia: trzdbgrid_go;
    modula: TMyQuery;
    v_parametri: TButton;
    dbModula: TADOConnection;
    adoQuery: TADOQuery;
    exp_movimenti: TADOQuery;
    query_ds: TDataSource;
    tabella: TMyQuery;
    ovt: TMyQuery;
    ADOCancella: TADOQuery;
    exp_giacenze: TADOQuery;
    modula_giacenze: TMyQuery;
    XLSWrite: TXLSReadWriteII5;
    mag: TMyQuery;
    v_log: TMemo;

    procedure formcreate(sender: tobject);
    procedure formkeydown(sender: tobject; var key: word; shift: tshiftstate);
    procedure timer1timer(sender: tobject);
  protected
    schedulato: boolean;
    procedure aggiorna_dati_go_cla_frn;
    procedure sincronizza_dati_go_modula(nome_tabella: string);
    procedure sincronizza_magazzino_modula_go(nome_tabella: string);
    function assegna_approntato(quantita: double; gestione: boolean; controllo_quantita: boolean = true): double;
    procedure controlla_giacenze_magazzino_modula_go(nome_tabella: string);

  public
    flag_log: string;
    cartella_exe: string;
    ese_codice: string;
    operazione: string;
    ultimo_id: integer;
    programma_preferito: string;
    procedure taskbar_aggiungi_programma(nome_programma, descrizione_programma: string; nome_form: tbase);
    procedure taskbar_attivazione(nome: string; attivazione: boolean);
    procedure taskbar_rimuovi_programma(nome_programma: string);
    procedure gestione_programmi_preferiti;
  end;

var
  menugg: tmenugg;

implementation

{$r *.dfm}


uses ggmail;

procedure tmenugg.formcreate(sender: tobject);

var
  i: integer;
  attesa: integer;
begin
  cartella_exe := extractfilepath(Application.exename);
  forcedirectories('c:\temp');

  schedulato := false;
  assegna_parametri_lavoro;

  // --------------------------------------------------------------------------------------------------
  // routine di assegnazione ambiente di lavoro
  // usa l'utente passato come parametro dal comando di esecuzione (es. ...\collegato.exe GO
  // --------------------------------------------------------------------------------------------------
  Self.Caption := Self.caption + ' ' + versione_procedura;

  attesa := 0;
  for i := 1 to system.paramcount do
  begin

    case i of
      3:
        begin
          operazione := estrai_tag(paramstr(i), 'operazione');
        end;
      4:
        begin
          attesa := strtoint(estrai_tag(paramstr(i), 'attesa')) * 1000;
        end;

    end; // for

  end;
  timer1.interval := attesa;
  timer1.enabled := true;


  // --------------------------------------------------------------------------------------------------
  // fine routine di assegnazione ambiente di lavoro
  // --------------------------------------------------------------------------------------------------

  inherited;

  comboedit1.text := ditta;
  comboedit2.text := esercizio;
  comboedit3.text := utente;
  comboedit4.text := datetostr(data_inizio);
  comboedit5.text := datetostr(data_fine);
  comboedit6.text := arc.dit.fieldbyname('descrizione1').asstring;
  comboedit7.text := arc.utn.fieldbyname('descrizione').asstring;

  v_hostname_go.text := arc.arcdit.server;
  v_databasename_go.text := arc.arcdit.database;
  v_username_go.text := arc.arcdit.username;

end;

procedure tmenugg.formkeydown(sender: tobject;
  var
  key: word;
  shift:
  tshiftstate);
begin
  if (key = vk_escape) and (shift = []) then
  begin
    close;
  end;
end;

procedure tmenugg.taskbar_aggiungi_programma(nome_programma, descrizione_programma: string;
  nome_form: tbase);
begin
  // presente perché referenziato da TARC
end;

procedure tmenugg.taskbar_attivazione(nome: string;
  attivazione:
  boolean);
begin
  // presente perché referenziato da TARC
end;

procedure tmenugg.taskbar_rimuovi_programma(nome_programma: string);
begin
  // presente perché referenziato da TARC
end;

procedure tmenugg.timer1timer(sender: tobject);
begin
  timer1.enabled := false;

  v_log.lines.clear;
  v_log.lines.add('utente :' + utente);
  v_log.lines.add('operaz :' + operazione);

  v_log.lines.add('inizio timer');
  dbmodula.connected := false;
  dbmodula.connectionstring := 'FILE NAME=' + cartella_exe + 'MODULA.udl';
  dbmodula.connected := true;

  modula.close;
  modula.parambyname('nome_tabella').asstring := 'art';
  modula.open;

  screen.cursor := crhourglass;
  if operazione = '*' then
  begin

    if modula.eof then
    begin
      modula.append;
      modula.fieldbyname('nome_tabella').asstring := 'art';
      modula.fieldbyname('ultimo_id').asinteger := 0;
      modula.fieldbyname('data_ultimo_aggiornamento').asdatetime := now - 30;
      modula.post;
    end;

    ultimo_id := modula.fieldbyname('ultimo_id').asinteger;

    aggiorna_dati_go_cla_frn;
    sincronizza_dati_go_modula('art');
    sincronizza_magazzino_modula_go('art');
    controlla_giacenze_magazzino_modula_go('art');

  end
  else if operazione = 'ART' then
  begin
    sincronizza_dati_go_modula('art');

    modula.edit;
    modula.fieldbyname('data_ultimo_aggiornamento').asdatetime := now;
    modula.fieldbyname('ultimo_id').asinteger := ultimo_id;
    modula.post;

  end
  else if operazione = 'CLA' then
  begin
    aggiorna_dati_go_cla_frn;
  end
  else if operazione = 'SCA' then
  begin
    sincronizza_magazzino_modula_go('art');

    modula.edit;
    modula.fieldbyname('ultimo_id').asinteger := ultimo_id;
    modula.post;

  end
  else if operazione = 'GIA' then
  begin
    controlla_giacenze_magazzino_modula_go('art');
  end;

  dbmodula.connected := false;

  screen.cursor := crdefault;

  close;
end;

procedure tmenugg.aggiorna_dati_go_cla_frn;
begin

  query.close;
  query.sql.clear;
  query.sql.add('update cla ');
  query.sql.add('set frn_codice=( select orp_frn_codice from fas where fas.codice=cla.fas_codice )');
  query.sql.add('where cla.frn_codice='''' ');
  query.execsql;
end;

procedure tmenugg.sincronizza_dati_go_modula(nome_tabella: string);
var
  nr_record: integer;
begin

  try
    ADOCancella.close;
    ADOCancella.sql.clear;
    ADOCancella.sql.add('delete from IMP_ARTICOLI');
    ADOCancella.execsql;
  except
  end;

  query_ds.dataset := query;

  query.close;
  query.sql.clear;
  query.sql.add('select * from ' + nome_tabella);
  query.sql.add('where');
  query.sql.add('1=1');
  if nome_tabella = 'art' then
  begin
    query.sql.add('and ( obsoleto=' + quotedstr('no') + ' )');
  end;

  query.sql.add('and ( ( data_ora_creazione >:data_ora_01 ) or ');
  query.sql.add('      ( data_ora >:data_ora_02 ) )  ');
  query.sql.add('order by 2 ');

  query.parambyname('data_ora_01').asdatetime := modula.fieldbyname('data_ultimo_aggiornamento').asdatetime;
  query.parambyname('data_ora_02').asdatetime := modula.fieldbyname('data_ultimo_aggiornamento').asdatetime;
  query.sql.savetofile('c:\temp\modula_art.sql');
  query.open;

  while not query.eof do
  begin
    adoquery.parameters.parambyname('ART_OPERAZIONE').value := 'I';
    adoquery.parameters.parambyname('ART_ARTICOLO').value := query.fieldbyname('codice').asstring;
    adoquery.parameters.parambyname('ART_DES').value := query.fieldbyname('descrizione1').asstring + ' ' + query.fieldbyname('descrizione2').asstring;
    adoquery.parameters.parambyname('ART_UMI').value := 'PZ'; // query.fieldbyname('tum_codice').asstring;
    adoquery.parameters.parambyname('ART_SOTTOSCO').value := 0;
    adoquery.parameters.parambyname('ART_PMU').value := 0;
    adoquery.parameters.parambyname('ART_AREEABI').value := '';
    adoquery.parameters.parambyname('RT_TIPOGESTART').value := 'V';
    adoquery.parameters.parambyname('ART_FIFOP').value := 0;
    adoquery.parameters.parambyname('ART_FIFOV').value := 0;
    adoquery.parameters.parambyname('ART_NOTE').value := '';
    adoquery.parameters.parambyname('ART_CLAMOV').value := 2;
    adoquery.parameters.parambyname('ART_GRUPPO').value := 0;
    adoquery.parameters.parambyname('ART_TIPOSTOCK').value := '';
    adoquery.parameters.parambyname('RT_ATTR1').value := '';
    adoquery.parameters.parambyname('ART_ATTR2').value := '';
    adoquery.parameters.parambyname('ART_ATTR3').value := '';
    adoquery.parameters.parambyname('ART_ATTR4').value := '';
    adoquery.parameters.parambyname('ART_ATTR5').value := '';
    adoquery.parameters.parambyname('ART_ATTR6').value := '';
    adoquery.parameters.parambyname('ART_ATTR7').value := '';
    adoquery.parameters.parambyname('RT_ATTR8').value := '';
    adoquery.parameters.parambyname('ART_FAMIGLIA').value := '';
    adoquery.parameters.parambyname('ART_RUOLO').value := '';
    adoquery.parameters.parambyname('ART_CATEGORIA1').value := '';
    adoquery.parameters.parambyname('ART_CATEGORIA2').value := '';
    adoquery.parameters.parambyname('ART_CATEGORIA3').value := '';
    adoquery.parameters.parambyname('ART_CATEGORIA4').value := '';
    adoquery.parameters.parambyname('RT_CATEGORIA5').value := '';
    adoquery.parameters.parambyname('ART_VITAUTILE').value := 0;
    adoquery.parameters.parambyname('ART_SCAD_DPRO').value := 0;
    adoquery.parameters.parambyname('ART_TOLLP').value := 0;
    adoquery.parameters.parambyname('ART_TOLLV').value := 0;
    adoquery.parameters.parambyname('ART_TOLLI').value := 0;
    adoquery.parameters.parambyname('ART_CREASCO_TIPO').value := 'NO';
    adoquery.parameters.parambyname('RT_CREASCO_USAABISCO').value := 0;
    adoquery.parameters.parambyname('ART_CREASCO_DIMX').value := 0;
    adoquery.parameters.parambyname('ART_CREASCO_DIMY').value := 0;
    adoquery.parameters.parambyname('ART_CREASCO_DIMZ').value := 0;
    adoquery.parameters.parambyname('ART_CREASCO_LIM').value := 0;
    adoquery.parameters.parambyname('ART_CREASCO_CAP').value := 0;
    adoquery.parameters.parambyname('ART_MAGAZZINO').value := 0;
    adoquery.parameters.parambyname('ART_ERRORE').value := '';
    adoquery.ExecSQL;

    query.next;
  end;

  query.close;
end;

procedure tmenugg.sincronizza_magazzino_modula_go(nome_tabella: string);
var
  nr_record: integer;
  nr_col: integer;
  numero_documento: integer;

begin

  query_ds.dataset := exp_movimenti;

  exp_movimenti.close;
  exp_movimenti.parameters.parambyname('tipo_operazione').value := modula.fieldbyname('causale_scarico').asstring;
  exp_movimenti.parameters.parambyname('ultimo_id').value := ultimo_id;
  exp_movimenti.open;

  while not exp_movimenti.eof do
  begin
    ultimo_id := exp_movimenti.fieldbyname('MOV_ID').asinteger;

    nr_record := nr_record + 1;

    if nr_record > 10 then
    begin
      application.processmessages;
      nr_record := 0;
    end;

    nr_col := ansipos('/', exp_movimenti.fieldbyname('MOV_REQ_NOTE').asstring);

    if nr_col > 0 then
    begin
      ese_codice := '20' + copy(exp_movimenti.fieldbyname('MOV_REQ_NOTE').asstring, nr_col + 1, length(exp_movimenti.fieldbyname('MOV_REQ_NOTE').asstring));

      try
        numero_documento := StrtoInt(trim(copy(exp_movimenti.fieldbyname('MOV_REQ_NOTE').asstring, 1, nr_col - 1)));
      except
        numero_documento := 0;
      end;

    end
    else
    begin
      ese_codice := esercizio;

      try
        numero_documento := exp_movimenti.fieldbyname('MOV_REQ_NOTE').asinteger;
      except
        numero_documento := 0;
      end;

    end;

    ovt.close;
    ovt.parambyname('ese_codice').value := ese_codice;
    ovt.parambyname('numero_documento').value := numero_documento;
    ovt.open;
    if not ovt.eof then
    begin
      tabella.close;
      tabella.parambyname('progressivo').asinteger := ovt.fieldbyname('progressivo').asinteger;
      tabella.parambyname('art_codice').asstring := exp_movimenti.fieldbyname('MOV_ARTICOLO').asstring;
      tabella.open;
      if not tabella.eof then
      begin
        assegna_approntato(exp_movimenti.fieldbyname('MOV_QTA').asfloat, false, false);
      end;
    end;

    exp_movimenti.next;
  end;

  adoquery.close;
  adoquery.sql.clear;
  adoquery.sql.add('delete from EXP_MOVIMENTI');
  adoquery.sql.add('where');
  adoquery.sql.add('MOV_ID<=:ID');
  adoquery.parameters.parambyname('ID').value := ultimo_id;
  adoquery.execsql;

  tabella.close;
  query.close;

end;

function Tmenugg.assegna_approntato(quantita: double; gestione: boolean; controllo_quantita: boolean = true): double;
var
  vecchio_quantita: double;
begin
  result := 0;
  if quantita <> 0 then
  begin
    if controllo_quantita and (quantita > tabella.fieldbyname('quantita').asfloat - tabella.fieldbyname('quantita_approntata').asfloat) then
    begin
      quantita := tabella.fieldbyname('quantita').asfloat - tabella.fieldbyname('quantita_approntata').asfloat;
    end;
    result := quantita;

    vecchio_quantita := tabella.fieldbyname('tum_quantita_approntata_base').asfloat;
    if tabella_edit(tabella) then
    begin
      if not gestione then
      begin
        tabella.fieldbyname('quantita_approntata').asfloat := arrotonda
          (tabella.fieldbyname('quantita_approntata').asfloat + quantita, decimali_max_quantita);
        tabella.fieldbyname('numero_colli_approntato').asinteger := tabella.fieldbyname('numero_colli').asinteger;
        tabella.fieldbyname('numero_confezioni_approntato').asinteger := tabella.fieldbyname('numero_confezioni').asinteger;
      end;
      if tabella.fieldbyname('quantita_approntata').asfloat = 0 then
      begin
        tabella.fieldbyname('saldo_acconto_approntato').asstring := '';
        tabella.fieldbyname('evadere_approntato').asstring := '';
        tabella.fieldbyname('numero_colli_approntato').asinteger := 0;
        tabella.fieldbyname('numero_confezioni_approntato').asinteger := 0;
      end
      else
      begin
        if arrotonda(tabella.fieldbyname('quantita_approntata').asfloat, 4) >= quantita then
        begin
          tabella.fieldbyname('saldo_acconto_approntato').asstring := 'saldo';
          tabella.fieldbyname('evadere_approntato').asstring := 'si';
        end
        else
        begin
          tabella.fieldbyname('saldo_acconto_approntato').asstring := 'acconto';
          tabella.fieldbyname('evadere_approntato').asstring := 'no';
        end;
      end;
      tabella.post;
    end;
  end
  else
  begin
    if tabella.fieldbyname('quantita_approntata').asfloat = 0 then
    begin
      if tabella_edit(tabella) then
      begin
        tabella.fieldbyname('saldo_acconto_approntato').asstring := '';
        tabella.fieldbyname('evadere_approntato').asstring := '';
        tabella.fieldbyname('numero_colli_approntato').asinteger := 0;
        tabella.fieldbyname('numero_confezioni_approntato').asinteger := 0;
        tabella.post;
      end;
    end;
  end;
end;

procedure Tmenugg.controlla_giacenze_magazzino_modula_go(nome_tabella: string);
var
  riga: integer;
  filetesto: textfile;
  stringa: string;
begin
  v_log.lines.add('cancella modula giacenze');

  query.close;
  query.sql.clear;
  query.sql.add('delete from modula_giacenze');
  query.execsql;

  query_ds.dataset := exp_giacenze;

  v_log.lines.add('seleziona exp giacenze');
  exp_giacenze.close;
  exp_giacenze.sql.clear;
  exp_giacenze.sql.add('select *');
  exp_giacenze.sql.add('FROM EXP_GIACENZE');
  exp_giacenze.sql.add('order by GIA_ARTICOLO');
  exp_giacenze.open;

  v_log.lines.add('articoli modula ' + inttostr(exp_giacenze.recordcount));

  while not exp_giacenze.eof do
  begin
    application.processmessages;

    modula_giacenze.close;
    modula_giacenze.parambyname('art_codice').asstring := exp_giacenze.fieldbyname('GIA_ARTICOLO').asstring;
    modula_giacenze.open;

    if modula_giacenze.eof then
    begin
      modula_giacenze.append;
      modula_giacenze.fieldbyname('art_codice').asstring := exp_giacenze.fieldbyname('GIA_ARTICOLO').asstring;
      modula_giacenze.fieldbyname('giacenza_modula').asfloat := exp_giacenze.fieldbyname('GIA_GIAC').asfloat;
      modula_giacenze.fieldbyname('giacenza_go').asfloat := 0;
      modula_giacenze.post;
    end;

    exp_giacenze.next;
  end;

  exp_giacenze.close;

  query_ds.dataset := mag;

  mag.close;
  mag.sql.clear;
  mag.sql.add('select art.codice_alternativo, sum(mag.esistenza) esistenza');
  mag.sql.add('from mag');
  mag.sql.add('inner join tma on tma.codice=mag.tma_codice');
  mag.sql.add('inner join art on art.codice=mag.art_codice');
  mag.sql.add('where');
  mag.sql.add('tma.proprieta=''si'' ');
  mag.sql.add('group by art.codice_alternativo');
  mag.sql.add('order by art.codice_alternativo');
  // mag.parambyname('tma_codice').asstring := 'SEDE'; // modula.fieldbyname('tma_codice').asstring;
  mag.open;

  while not mag.eof do
  begin
    application.processmessages;

    modula_giacenze.close;
    modula_giacenze.parambyname('art_codice').asstring := mag.fieldbyname('codice_alternativo').asstring;
    modula_giacenze.open;

    if not modula_giacenze.eof then
    begin
      modula_giacenze.edit;
      modula_giacenze.fieldbyname('giacenza_go').asfloat := mag.fieldbyname('esistenza').asfloat;
      modula_giacenze.fieldbyname('delta').asfloat := modula_giacenze.fieldbyname('giacenza_modula').asfloat - modula_giacenze.fieldbyname('giacenza_go').asfloat;
      modula_giacenze.fieldbyname('articolo_go').asstring := 'si';
      modula_giacenze.post;
    end;

    mag.next;
  end;

  mag.close;



  xlswrite.filename := cartella_report + 'esporta\controllo_giacenze_modula_go.xls';

  xlsWrite.Sheets[0].AsString[0, 0] := 'Codice articolo';
  xlsWrite.Sheets[0].AsString[1, 0] := 'Descrizione articolo';
  xlsWrite.Sheets[0].AsString[2, 0] := 'giacenza modula';
  xlsWrite.Sheets[0].AsString[3, 0] := 'giacenza articolo';
  xlsWrite.Sheets[0].AsString[4, 0] := 'Differenza';
  xlsWrite.Sheets[0].AsString[5, 0] := 'articolo in go';
  riga := 0;

  query_ds.dataset := query;
  query.close;
  query.sql.clear;
  query.sql.add('select g.*, art.codice art_codice_articolo,art.descrizione1 art_descrizione1');
  query.sql.add('from modula_giacenze g');
  query.sql.add('inner join art on art.codice_alternativo = g.art_codice');
  query.sql.add('where g.articolo_go=''si'' ');
  query.sql.add('order by art.codice');
  query.open;

  while not query.eof do
  begin
    application.ProcessMessages;

    riga := riga + 1;
    xlsWrite.Sheets[0].AsString[0, riga] := query.fieldbyname('art_codice_articolo').asstring;
    xlsWrite.Sheets[0].AsString[1, riga] := query.fieldbyname('art_descrizione1').asstring;
    xlsWrite.Sheets[0].Asinteger[2, riga] := query.fieldbyname('giacenza_modula').asinteger;
    xlsWrite.Sheets[0].Asinteger[3, riga] := query.fieldbyname('giacenza_go').asinteger;
    xlsWrite.Sheets[0].Asinteger[4, riga] := query.fieldbyname('delta').asinteger;
    xlsWrite.Sheets[0].AsString[5, riga] := query.fieldbyname('articolo_go').asstring;
    query.next;
  end;

  xlsWrite.Write;

  assignfile(filetesto, cartella_report + 'esporta\controllo_giacenze_modula_go.csv');
  rewrite(filetesto);
  query.first;
  while not query.eof do
  begin
    if query.fieldbyname('delta').asinteger <> 0 then
    begin
      stringa := query.fieldbyname('art_codice').asstring + ';' + query.fieldbyname('delta').asstring;
      writeln(filetesto, stringa);
    end;
    query.next;
  end;
  query.close;
  closefile(filetesto);

  // creo file di testo per inventario
  // 27.06.2014 aggiunta cancellazione tabella
  exp_giacenze.close;
  exp_giacenze.sql.clear;
  exp_giacenze.sql.add('TRUNCATE TABLE EXP_GIACENZE');
  exp_giacenze.execsql;

end;

procedure tmenugg.gestione_programmi_preferiti;
begin

end;

initialization

registerclass(tmenugg);

end.
