#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} BKGCTR02
Faturamento x Previs�o de Faturamento

@Return
@author Marcos Bispo Abrah�o
@since 09/06/10
@version P11/P12
/*/
//-------------------------------------------------------------------
User Function BKGCTR02()

Local cTitulo   := "Previsto x Faturado - empresas: 01,02 e 14"
Local aTitulos  := {}
Local aCampos1  := {}
Local aCabs1    := {}
Local aCampos2  := {}
Local aCabs2    := {}

Local _nI       := 0
Local _nY       := 0
Local aDbf1     := {}
Local aDbf2     := {}
Local cArqTmp1  := ""
Local cArqTmp2  := ""
Local aJaPrv    := {}
Local nMes      := 0
Local nAno      := 0
Local cMes      := ""
Local cGraph    := ""
                  
Private cProg   := "BKGCTR02"
Private nMesI   := 1
Private nAnoI   := YEAR(dDataBase)
Private nMesF   := MONTH(dDataBase)
Private nAnoF   := YEAR(dDataBase)
Private cMesI   := ""
Private cMesF   := ""
Private nQtdCli := 15
Private nMeses  := 0
Private aMeses  := {}
Private l2010   := .F.

Private cTpRel  := "X"
Private aPlans  := {}

Private nOpcao  := 1
Private aParam	:= {}
Private aRet	:= {}
Private aTpRel  := {"XML", "CSV", "Gr�fico"}

/*
Param Box Tipo 1
1 - MsGet
  [2] : Descri��o
  [3] : String contendo o inicializador do campo
  [4] : String contendo a Picture do campo
  [5] : String contendo a valida��o
  [6] : Consulta F3
  [7] : String contendo a valida��o When
  [8] : Tamanho do MsGet
  [9] : Flag .T./.F. Par�metro Obrigat�rio ?
*/

aAdd(aParam, {2,"Gerar:",nOpcao,aTpRel, 50,'.T.',.T.})
aAdd(aRet, aTpRel[nOpcao])
 
aAdd(aParam, {1,"Mes inicial",nMesI,"99"  ,"mv_par02 > 0 .AND. mv_par02 <= 12"  ,"","",20,.F.})
aAdd(aRet, nMesI)

aAdd(aParam, {1,"Ano inicial",nAnoI,"9999","mv_par03 >= 2010 .AND. mv_par03 <= 2030","","",20,.F.})
aAdd(aRet, nAnoI)

aAdd(aParam, {1,"Mes final"  ,nMesF,"99"  ,"mv_par04 > 0 .AND. mv_par04 <= 12"  ,"","",20,.F.})
aAdd(aRet, nMesF)

aAdd(aParam, {1,"Ano final"  ,nAnoF,"9999","mv_par05 >= 2010 .AND. mv_par05 <= 2030","","",20,.F.})
aAdd(aRet, nAnoF)

aAdd(aParam, {1,"Qtd Maiores Clientes(s� Gr�fico)",nQtdCli,"99","mv_par06 >= 0","","",20,.F.})
aAdd(aRet, nQtdCli)

/*  
aParametros	 	Array of Record	 	Array contendo as perguntas
cTitle	 	 	Caracter	 	 	Titulo
aRet	 	 	Array of Record	 	Array container das respostas
bOk	 	 		Array of Record	 	Array contendo defini��es dos bot�es opcionais	 	 	 	 	 	 	 	 	 	 
aButtons	 	Array of Record	 	Array contendo defini��es dos bot�es opcionais	 	 	 	 	 	 	 	 	 	 
lCentered	 	L�gico	 	 		Indica se ser� centralizada a janela	 	 	 	 	 	 	 	 	 	 
nPosX	 	 	Num�rico	 	 	Coordenada X da janela	 	 	 	 	 	 	 	 	 	 
nPosy	 	 	Num�rico	 	 	Coordenada y da janela
oDlgWizard	 	Objeto	 	 		Objeto referente janela do Wizard	 	 	 	 	 	 	 	 	 	 
cLoad	 	 	Caracter	 	 	Nome arquivo para gravar respostas	 	 	 	 	 	 	 	 	 	 
lCanSave	 	L�gico	 	 		Indica se pode salvar o arquivo com respostas	 	 	 	 	 	 	 	 	 	 
lUserSave	 	Array of Record	 	Indica se salva nome do usuario no arquivo
*/

//   Parambox(aParametros,@cTitle ,@aRet,[ bOk ],[ aButtons ],[ lCentered ],[ nPosX ],[ nPosy ],[ oDlgWizard ],[ cLoad ] ,[ lCanSave ],[ lUserSave ] ) --> aRet
If !(Parambox(aParam     ,@cTitulo,@aRet,       ,            ,.T.          ,         ,         ,              ,cProg     ,.T.         ,.T.))
	Return Nil
EndIf  

If VALTYPE(aRet[1]) == "N"
	cTpRel := Substr(aTpRel[aRet[1]],1,1)
Else
	cTpRel := (Substr(aRet[1],1,1))
EndIf


nMesI  := aRet[2]
nAnoI  := aRet[3]
nMesF  := aRet[4]
nAnoF  := aRet[5]

cMesI  := STRZERO(nAnoI,4)+STRZERO(nMesI,2)
cMesF  := STRZERO(nAnoF,4)+STRZERO(nMesF,2)
nMes   := nMesI
nAno   := nAnoI

aMeses   := {}
aTMensal := {}
nMeses := 0
cMes   := cMesI
Do while cMes <= cMesF
	AADD(aMeses,cMes)
	//             Mes  Titulo                               ,P F M 
	AADD(aTMensal,{cMes,SUBSTR(cMes,5,2)+"/"+SUBSTR(cMes,1,4),0,0,0,""})
 	nMeses++
	nMes++
	If nMes > 12
		nMes := 1
		nAno++
	EndIf
	If nAno == 2010 .AND. nMes <= 4
		l2010 := .T.
	EndIf
	cMes := STRZERO(nAno,4)+STRZERO(nMes,2)
EndDo

If nMeses <= 0
   MsgStop("Data inicial deve ser menor que a final",cProg)
   Return Nil
EndIf

cTitulo1 := cTitulo+": "+STRZERO(nMesI,2)+"/"+STRZERO(nAnoI,4)+ " at� "+STRZERO(nMesF,2)+"/"+STRZERO(nAnoF,4)
aDbf1    := {}

Aadd( aDbf1, { 'XX_EMPRESA','C',  2,00 } )
Aadd( aDbf1, { 'XX_CLIENTE','C', TamSx3("A1_COD")[1],00 } )
Aadd( aDbf1, { 'XX_LOJA'   ,'C', TamSx3("A1_LOJA")[1],00 } )
Aadd( aDbf1, { 'XX_NOMCLI' ,'C', TamSx3("A1_NOME")[1],00 } )
Aadd( aDbf1, { 'XX_CONTRA' ,'C', TamSx3("CNF_CONTRA")[1],00 } )
Aadd( aDbf1, { 'XX_REVISAD','C',  1,00 } )
Aadd( aDbf1, { 'XX_DESC'   ,'C', TamSx3("CN9_XXDESC")[1],00 } )
Aadd( aDbf1, { 'XX_INICIO' ,'C',  7,00 } )
Aadd( aDbf1, { 'XX_FINAL'  ,'C',  7,00 } )
FOR _nI := 1 TO LEN(aMeses)
	cMes := aMeses[_nI]
	Aadd( aDbf1, { 'XX_P'+cMes,'N', 17,02 } )
	Aadd( aDbf1, { 'XX_F'+cMes,'N', 17,02 } )
NEXT
Aadd( aDbf1, { 'XX_TOTPRV','N', 17,02 } )
Aadd( aDbf1, { 'XX_TOTFAT','N', 17,02 } )

cArqTmp1 := CriaTrab( aDbf1, .t. )
dbUseArea( .t.,NIL,cArqTmp1,'TMPC',.f.,.f. )
		
IndRegua("TMPC",cArqTmp1,"XX_EMPRESA+XX_CONTRA",,,"Indexando Arquivo de Trabalho")
//IndRegua("TMPC",cArqTmp1,"-XX_TOTFAT",,,"Indexando Arquivo de Trabalho")
//		dbClearIndex()
//		dbSetIndex(cArqTmp1 + OrdBagExt())
dbSetOrder(1)		


aDbf2    := {}
Aadd( aDbf2, { 'XX_CLIENTE','C', TamSx3("A1_COD")[1],00 } )
Aadd( aDbf2, { 'XX_NOMCLI' ,'C', TamSx3("A1_NOME")[1],00 } )
Aadd( aDbf2, { 'XX_TOTPRV' ,'N', 17,02 } )
Aadd( aDbf2, { 'XX_TOTFAT' ,'N', 17,02 } )
Aadd( aDbf2, { 'XX_PERDIF' ,'N', 17,02 } )
cArqTmp2 := CriaTrab( aDbf2, .t. )

dbUseArea( .t.,NIL,cArqTmp2,'TMPD',.f.,.f. )
IndRegua("TMPD",cArqTmp2+"1","XX_CLIENTE",,,"Indexando Arquivo de Trabalho")
IndRegua("TMPD",cArqTmp2+"2","-XX_TOTPRV",,,"Indexando Arquivo de Trabalho")
dbClearIndex()
dbSetIndex(cArqTmp2+"1" + OrdBagExt())
dbSetIndex(cArqTmp2+"2" + OrdBagExt())
dbSetOrder(1)		


dbSelectArea("TMPC")

ProcRegua(1)
Processa( {|| ProcQuery("01") })
Processa( {|| ProcQuery("02") })
Processa( {|| ProcQuery("14") })

aCabs1   := {}
aCampos1 := {}
aTitulos := {}
   
AADD(aTitulos,cProg+"/"+TRIM(SUBSTR(cUsuario,7,15))+" - "+cTitulo1)

AADD(aCampos1,"TMPC->XX_EMPRESA")
AADD(aCabs1  ,"Empresa")

AADD(aCampos1,"TMPC->XX_CLIENTE")
AADD(aCabs1  ,"Cliente")

AADD(aCampos1,"TMPC->XX_LOJA")
AADD(aCabs1  ,"Loja")

AADD(aCampos1,"TMPC->XX_NOMCLI")
AADD(aCabs1  ,"Nome do Cliente")

AADD(aCampos1,"TMPC->XX_CONTRA")
AADD(aCabs1  ,"Contrato")

AADD(aCampos1,"TMPC->XX_DESC")
AADD(aCabs1  ,"Descri��o")

AADD(aCampos1,"TMPC->XX_INICIO")
AADD(aCabs1  ,"Inicio")

AADD(aCampos1,"TMPC->XX_FINAL")
AADD(aCabs1  ,"Final")

FOR _nI := 1 TO LEN(aMeses)
	cMes := aMeses[_nI]
	
	AADD(aCampos1,"TMPC->XX_P"+cMes)
	AADD(aCabs1  ,"Prv. "+SUBSTR(cMes,5,2)+"/"+SUBSTR(cMes,1,4))
	
	AADD(aCampos1,"TMPC->XX_F"+cMes)
	AADD(aCabs1  ,"Fat. "+SUBSTR(cMes,5,2)+"/"+SUBSTR(cMes,1,4))
NEXT

AADD(aCampos1,"TMPC->XX_TOTPRV")
AADD(aCabs1  ,"Total Prv.")
	
AADD(aCampos1,"TMPC->XX_TOTFAT")
AADD(aCabs1  ,"Total Fat.")


aCabs2   := {}
aCampos2 := {}

AADD(aCampos2,"TMPD->XX_CLIENTE")
AADD(aCabs2  ,"Cliente")

AADD(aCampos2,"TMPD->XX_NOMCLI")
AADD(aCabs2  ,"Nome do Cliente")

AADD(aCampos2,"TMPD->XX_TOTPRV")
AADD(aCabs2  ,"Total Prv.")
	
AADD(aCampos2,"TMPD->XX_TOTFAT")
AADD(aCabs2  ,"Total Fat.")

AADD(aCampos2,"TMPD->XX_PERDIF")
AADD(aCabs2  ,"%")
	            
If cTpRel == "C"
	// CSV
	ProcRegua(TMPC->(LASTREC()))
	Processa( {|| U_GeraCSV("TMPC",cProg,aTitulos,aCampos1,aCabs1,,,,.F.)})
ElseIf cTpRel == "X"
	// XML
	aPlans := {}
	AADD(aPlans,{"TMPC",cProg+"-A1","",cTitulo1,aCampos1,aCabs1,/*aImpr1*/, /* aAlign */,/* aFormat */, /*aTotal */, /*cQuebra*/, lClose:= .F. }) 
	TMPD->(dbSetOrder(2))
	AADD(aPlans,{"TMPD",cProg+"-A2","","Totais por Cliente",aCampos2,aCabs2,/*aImpr1*/, /* aAlign */,/* aFormat */, /*aTotal */, /*cQuebra*/, lClose:= .F. })
	MsAguarde({|| U_GeraXml(aPlans,cTitulo1,cProg,.F.)},"Aguarde","Gerando planilha...",.F.)
Else
 	// Gr�fico
	ProcRegua(TMPC->(LASTREC()))
	Processa( {|| cGraph := GeraChart1(aTMensal,cProg,aTitulos)})
	ViewGraph(cGraph)	
EndIf

dbSelectArea("TMPC")
dbCloseArea()
FErase(cArqTmp1+GetDBExtension())
FErase(cArqTmp1+OrdBagExt())

dbSelectArea("TMPD")
dbCloseArea()
FErase(cArqTmp2+GetDBExtension())
FErase(cArqTmp2+"1"+OrdBagExt())
FErase(cArqTmp2+"2"+OrdBagExt())

   
Return


Static Function ProcQuery(_cEmp)
Local cQuery,cQuery2,dDt

Private cCampo
Private _cEmpresa := _cEmp

IncProc("Consultando o banco de dados...")

/*

SELECT CNF_CONTRA,CNF_COMPET,CNF_VLPREV,CNF_SALDO,CTT_DESC01,CNA_NUMERO,CNA_XXMUN,CND_NUMMED,C6_NUM,         
    (SELECT SUM(CNR_VALOR) FROM CNR010 CNR WHERE CND_NUMMED = CNR_NUMMED  AND  CNR_FILIAL = '01' AND  CNR.D_E_L_E_T_ = ' ' AND CNR_TIPO = '1') AS XX_BONIF,
    (SELECT SUM(CNR_VALOR) FROM CNR010 CNR WHERE CND_NUMMED = CNR_NUMMED  AND  CNR_FILIAL = '01' AND  CNR.D_E_L_E_T_ = ' ' AND CNR_TIPO = '2') AS XX_MULTA,
    F2_DOC,F2_EMISSAO,F2_VALFAT,F2_VALIRRF,F2_VALINSS,F2_VALPIS,F2_VALCOFI,F2_VALCSLL,F2_RECISS,F2_VALISS  
 FROM CNF010 CNF 
    LEFT JOIN CTT010 CTT ON CTT_CUSTO = CNF_CONTRA  AND  CTT_FILIAL = '01' AND  CTT.D_E_L_E_T_ = ' ' 
    LEFT JOIN CNA010 CNA ON CNA_CRONOG = CNF_NUMERO AND  CNA_FILIAL = '01' AND  CNA.D_E_L_E_T_ = ' ' 
    LEFT JOIN CND010 CND ON CND_CONTRA = CNF_CONTRA AND CND_COMPET = CNF_COMPET AND CND_PARCEL = CNF_PARCEL AND CNA_NUMERO = CND_NUMERO AND  CND_FILIAL = '01' AND  CND.D_E_L_E_T_ = ' ' 
    LEFT JOIN SC6010 SC6 ON CND_PEDIDO = C6_NUM      AND  C6_FILIAL = '01'  AND  SC6.D_E_L_E_T_ = ' ' 
    LEFT JOIN SF2010 SF2 ON C6_SERIE = F2_SERIE AND C6_NOTA = F2_DOC      AND  F2_FILIAL = '01'  AND  SF2.D_E_L_E_T_ = ' ' 
    WHERE CNF_COMPET = '05/2010'      AND  CNF_FILIAL = '01' AND  CNF.D_E_L_E_T_ = ' ' 
 UNION ALL  
    SELECT         'XXXXXXXXX',' ',0,0,         A1_NOME,         ' ',' ',         ' ',         ' ',         0,0,         F2_DOC,F2_EMISSAO,F2_VALFAT,F2_VALIRRF,F2_VALINSS,F2_VALPIS,F2_VALCOFI,F2_VALCSLL,F2_RECISS,F2_VALISS  
    FROM SF2010 SF2 
    LEFT JOIN SA1010 SA1 ON F2_CLIENTE = A1_COD AND F2_LOJA = A1_LOJA      AND  A1_FILIAL = '  ' AND  SA1.D_E_L_E_T_ = ' ' 
    WHERE ((SELECT TOP 1 C5_MDCONTR FROM SC6010 SC6 INNER JOIN SC5010 SC5 ON C6_FILIAL = '01' AND C5_FILIAL = C6_FILIAL AND C6_NUM = C5_NUM AND C6_SERIE = F2_SERIE AND C6_NOTA = F2_DOC AND SC6.D_E_L_E_T_ = ' ' AND SC5.D_E_L_E_T_ = ' ')  = ' ' OR 
           (SELECT TOP 1 C5_MDCONTR FROM SC6010 SC6 INNER JOIN SC5010 SC5 ON C6_FILIAL = '01' AND C5_FILIAL = C6_FILIAL AND C6_NUM = C5_NUM AND C6_SERIE = F2_SERIE AND C6_NOTA = F2_DOC AND SC6.D_E_L_E_T_ = ' ' AND SC5.D_E_L_E_T_ = ' ')  IS NULL )
           AND SUBSTRING(F2_EMISSAO,1,6) = 201006      AND F2_FILIAL = '01' AND SF2.D_E_L_E_T_ = ' ' 
    ORDER BY CNF_CONTRA,CNF_COMPET,F2_DOC

*/


// Inicio da Implanta��o abril/2010 -> pegar cronogramas dos contratos originais (que sofreram revisoes ap�s 04/2010)

/*
IF l2010
	FOR _nI := 1 TO LEN(aMeses)
	
		cMes   := aMeses[_nI]
		cCompet:= SUBSTR(cMes,5,2)+"/"+SUBSTR(cMes,1,4)

		If cMes >= "201001" .AND. cMes <= "201004"

			//cQuery := " SELECT CNF_CONTRA,CNF_PARCEL,CN9_REVISA,CN9_SITUAC,CN9_NOMCLI,CN9_XXDESC,CNF_COMPET,CNF_VLPREV,F2_CLIENTE,F2_LOJA,F2_VALFAT,CN9_SITUAC,CN9_DTULST "
			cQuery := " SELECT CNF_CONTRA,CNF_PARCEL,CN9_REVISA,CN9_SITUAC,CN9_NOMCLI,CN9_XXDESC,CNF_COMPET,CNF_VLPREV,CN9_CLIENT,CN9_LOJACL,SUM(D2_TOTAL) AS D2_TOTAL,CN9_SITUAC,CN9_DTULST "
			cQuery += " FROM "+xRETSQLNAME("CNF")+" CNF"
		    cQuery += " INNER JOIN "+xRETSQLNAME("CN9")+ " CN9 ON CN9_NUMERO = CNF_CONTRA AND CN9_REVISA = CNF_REVISA AND CN9_SITUAC = '10' AND CNF_REVISA = ' ' "
			cQuery += "      AND  CN9_FILIAL = '"+xFilial("CN9")+"' AND  CN9.D_E_L_E_T_ = ' '"
			cQuery += " LEFT JOIN "+xRETSQLNAME("CTT")+ " CTT ON CTT_CUSTO = CNF_CONTRA"
			cQuery += "      AND  CTT_FILIAL = '"+xFilial("CTT")+"' AND  CTT.D_E_L_E_T_ = ' '"
			cQuery += " LEFT JOIN "+xRETSQLNAME("CNA")+ " CNA ON CNA_CRONOG = CNF_NUMERO AND CNA_CONTRA = CNF_CONTRA AND CNA_REVISA = CNF_REVISA"
			cQuery += "      AND  CNA_FILIAL = '"+xFilial("CNA")+"' AND  CNA.D_E_L_E_T_ = ' '"
	        cQuery += " LEFT JOIN "+xRETSQLNAME("CND")+ " CND ON CND_CONTRA = CNF_CONTRA AND CND_COMPET = CNF_COMPET AND CNA_NUMERO = CND_NUMERO AND CND_PARCEL = CNF_PARCEL AND CND_REVISA = CNA_REVISA"
			cQuery += "      AND  CND_FILIAL = '"+xFilial("CND")+"' AND  CND.D_E_L_E_T_ = ' '"
			//cQuery += " LEFT JOIN "+xRETSQLNAME("SC5")+ " SC5 ON CND_PEDIDO = C5_NUM"
			//cQuery += "      AND  C5_FILIAL = '"+xFilial("SC5")+"'  AND  SC5.D_E_L_E_T_ = ' '"
			//cQuery += " LEFT JOIN "+xRETSQLNAME("SF2")+ " SF2 ON C5_SERIE = F2_SERIE AND C5_NOTA = F2_DOC"
			//cQuery += "      AND  F2_FILIAL = '"+xFilial("SF2")+"'  AND  SF2.D_E_L_E_T_ = ' '"
			cQuery += " LEFT JOIN "+RETSQLNAME("SC6")+ " SC6 ON CND_PEDIDO = C6_NUM"
			cQuery += "      AND  C6_FILIAL = '"+xFilial("SC6")+"'  AND  SC6.D_E_L_E_T_ = ' '"
			cQuery += "	LEFT JOIN "+RETSQLNAME("SD2")+ " SD2 ON SC6.C6_NUM = SD2.D2_PEDIDO AND C6_ITEM = D2_ITEM  "
			cQuery += "      AND  D2_FILIAL = '"+xFilial("SD2")+"'  AND  SD2.D_E_L_E_T_ = ' ' "
			cQuery += " WHERE CNF_COMPET = '"+cCompet+"'"
			cQuery += "      AND  CNF_FILIAL = '"+xFilial("CNF")+"' AND  CNF.D_E_L_E_T_ = ' '"
			//cQuery += " ORDER BY CNF_CONTRA "  
			cQuery += " GROUP BY CNF_CONTRA,CNF_REVISA ORDER BY CNF_CONTRA"
		
			TCQUERY cQuery NEW ALIAS "QTMP"
			
			dbSelectArea("QTMP")
			dbGoTop()
			DO WHILE !EOF()
			   IncProc()
			
				IF QTMP->CN9_SITUAC $ "01/08" .AND. cMes > SUBSTR(QTMP->CN9_DTULST,1,6)
					dbSelectArea("QTMP")
	    			dbSkip()
	    			Loop
				ENDIF  
		
			   dbSelectArea("TMPC")
			   If !dbSeek(_cEmpresa+QTMP->CNF_CONTRA,.F.)
			      Reclock("TMPC",.T.)
				  TMPC->XX_EMPRESA := _cEmpresa
				  TMPC->XX_CONTRA  := QTMP->CNF_CONTRA
				  TMPC->XX_CLIENTE := QTMP->CN9_CLIENT //QTMP->F2_CLIENTE
				  TMPC->XX_LOJA    := QTMP->CN9_LOJACL //QTMP->F2_LOJA
				  TMPC->XX_NOMCLI  := QTMP->CN9_NOMCLI
				  TMPC->XX_DESC    := QTMP->CN9_XXDESC
				  TMPC->XX_REVISAD := "S"
		
				  cQuery := " SELECT CNF_CONTRA,MAX(SUBSTRING(CNF_COMPET,4,4)+SUBSTRING(CNF_COMPET,1,2)) AS XX_FIM,"
				  cQuery += "                   MIN(SUBSTRING(CNF_COMPET,4,4)+SUBSTRING(CNF_COMPET,1,2)) AS XX_INI "
						
				  cQuery += " FROM "+xRETSQLNAME("CNF")+" CNF"
					
			      cQuery += " WHERE CNF_CONTRA = '"+TRIM(QTMP->CNF_CONTRA)+"'"
			      cQuery += "      AND  CNF_FILIAL = '"+xFilial("CNF")+"' AND  CNF.D_E_L_E_T_ = ' '"
				
			      cQuery += " GROUP BY CNF_CONTRA "  
			      cQuery += " ORDER BY CNF_CONTRA "  
		
			      TCQUERY cQuery NEW ALIAS "TMP1"
			
			      dbSelectArea("TMP1")
			      dbGoTop()
				  TMPC->XX_INICIO  := SUBSTR(TMP1->XX_INI,5,2)+"/"+SUBSTR(TMP1->XX_INI,1,4)
				  TMPC->XX_FINAL   := SUBSTR(TMP1->XX_FIM,5,2)+"/"+SUBSTR(TMP1->XX_FIM,1,4)
		
		          TMP1->(dbCloseArea())
		
			   Else
			      Reclock("TMPC",.F.)
		       EndIf
			      
		       cCampo  := "TMPC->XX_P"+cMes
		       &cCampo += QTMP->CNF_VLPREV
		        
		       cCampo  := "TMPC->XX_F"+cMes
		       &cCampo += QTMP->D2_TOTAL  //QTMP->F2_VALFAT
			   
			   // Totalizador do Gr�fico
			   _nY := aScan(aTMensal, {|x| x[1] == cMes})
		       //If _nY > 0
		          aTMensal[_nY,3] += QTMP->CNF_VLPREV  
		          aTMensal[_nY,4] += QTMP->D2_TOTAL  //QTMP->F2_VALFAT  
		       //EndIf				  
				  	                      
			   TMPC->XX_TOTPRV += QTMP->CNF_VLPREV	
				TMPC->XX_TOTFAT += QTMP->F2_VALFAT	
		
				TMPC->(Msunlock())

				// Gravar total por cliente
			   dbSelectArea("TMPD")
			   If !dbSeek(QTMP->CN9_CLIENT,.F.)
					Reclock("TMPD",.T.)
					TMPD->XX_CLIENTE := QTMP->CN9_CLIENT
					TMPD->XX_NOMCLI  := QTMP->CN9_NOMCLI
               Else
			      Reclock("TMPD",.F.)
               EndIf
				TMPD->XX_TOTPRV += QTMP->CNF_VLPREV	
				TMPD->XX_TOTFAT += QTMP->F2_VALFAT	
				TMPD->(Msunlock())
				
				dbSelectArea("QTMP")
				dbSkip()
			ENDDO
		    QTMP->(dbCloseArea())
		EndIf
	NEXT
ENDIF	
*/

FOR _nI := 1 TO LEN(aMeses)

    aJaPrv := {}
	cMes   := aMeses[_nI]
	cCompet:= SUBSTR(cMes,5,2)+"/"+SUBSTR(cMes,1,4)
	//If cMes >= "201001" .AND. cMes <= "201004"
	//	LOOP
	//EndIf

	cQuery := " SELECT CNF_CONTRA,CNF_NUMERO,CNF_PARCEL,CN9_REVISA,CN9_SITUAC,CN9_CLIENT,CN9_LOJACL,CN9_NOMCLI,CN9_XXDESC,CNF_COMPET,CNF_VLPREV,SUM(D2_TOTAL) AS D2_TOTAL,CN9_DTULST "
//	cQuery += "    CASE WHEN CN9_SITUAC = '05' THEN CNF_VLPREV ELSE CNF_VLREAL END AS CNF_VLPREV,"

	cQuery += " FROM "+xRETSQLNAME("CNF")+" CNF"
    cQuery += " INNER JOIN "+xRETSQLNAME("CN9")+ " CN9 ON CN9_NUMERO = CNF_CONTRA AND CN9_REVISA = CNF_REVISA AND CN9_SITUAC <> '10' "
	cQuery += "      AND  CN9_FILIAL = '"+xFilial("CN9")+"' AND  CN9.D_E_L_E_T_ = ' '"
	cQuery += " LEFT JOIN "+xRETSQLNAME("CTT")+ " CTT ON CTT_CUSTO = CNF_CONTRA"
	cQuery += "      AND  CTT_FILIAL = '"+xFilial("CTT")+"' AND  CTT.D_E_L_E_T_ = ' '"
	cQuery += " LEFT JOIN "+xRETSQLNAME("CNA")+ " CNA ON CNA_CRONOG = CNF_NUMERO   AND CNF_CONTRA = CNA_CONTRA AND CNA_REVISA = CNF_REVISA"
	cQuery += "      AND  CNA_FILIAL = '"+xFilial("CNA")+"' AND  CNA.D_E_L_E_T_ = ' '"
	cQuery += " LEFT JOIN "+xRETSQLNAME("CND")+ " CND ON CND_CONTRA = CNF_CONTRA AND CND_COMPET = CNF_COMPET AND CND_PARCEL = CNF_PARCEL AND CNA_NUMERO = CND_NUMERO AND CND_REVISA = CNF_REVISA"
	cQuery += "      AND  CND_FILIAL = '"+xFilial("CND")+"' AND  CND.D_E_L_E_T_ = ' '"
	//cQuery += " LEFT JOIN "+xRETSQLNAME("SC5")+ " SC5 ON CND_PEDIDO = C5_NUM"
	//cQuery += "      AND  C5_FILIAL = '"+xFilial("SC5")+"'  AND  SC5.D_E_L_E_T_ = ' '"
	//cQuery += " LEFT JOIN "+xRETSQLNAME("SF2")+ " SF2 ON C5_SERIE = F2_SERIE AND C5_NOTA = F2_DOC"
	//cQuery += "      AND  F2_FILIAL = '"+xFilial("SF2")+"'  AND  SF2.D_E_L_E_T_ = ' '"
	cQuery += " LEFT JOIN "+xRETSQLNAME("SC6")+ " SC6 ON CND_PEDIDO = C6_NUM"
	cQuery += "      AND  C6_FILIAL = '"+xFilial("SC6")+"'  AND  SC6.D_E_L_E_T_ = ' '"
	cQuery += "	LEFT JOIN "+xRETSQLNAME("SD2")+ " SD2 ON SC6.C6_NUM = SD2.D2_PEDIDO AND C6_ITEM = D2_ITEM  "
	cQuery += "      AND  D2_FILIAL = '"+xFilial("SD2")+"'  AND  SD2.D_E_L_E_T_ = ' ' "
	cQuery += " WHERE CNF_COMPET = '"+cCompet+"'"
	cQuery += "      AND  CNF_FILIAL = '"+xFilial("CNF")+"' AND  CNF.D_E_L_E_T_ = ' '"
    IF _cEmpresa <> "14"  
    	cQuery += " AND CNF_CONTRA NOT IN ('302000508')"
    ENDIF  
	//cQuery += " ORDER BY CNF_CONTRA "  
	cQuery += " GROUP BY CNF_CONTRA,CNF_NUMERO,CNF_PARCEL,CN9_REVISA,CN9_SITUAC,CN9_CLIENT,CN9_LOJACL,CN9_NOMCLI,CN9_XXDESC,CNF_COMPET,CNF_VLPREV,CN9_DTULST"
	cQuery += " ORDER BY CNF_CONTRA"

	TCQUERY cQuery NEW ALIAS "QTMP"
	
	dbSelectArea("QTMP")
	QTMP->(dbGoTop())
	DO WHILE QTMP->(!EOF())

	   IncProc()

		nPrev   := QTMP->CNF_VLPREV
	   // Parar previs�o quando o contrato for cancelado ou encerrado
	   IF QTMP->CN9_SITUAC $ "01/08" .AND. cMes > SUBSTR(QTMP->CN9_DTULST,1,6)
			nPrev   := 0
       ENDIF
       
       IF nPrev == 0 .AND. QTMP->D2_TOTAL == 0
		  dbSelectArea("QTMP")
          dbSkip()
          Loop
       ENDIF

	   dbSelectArea("TMPC")
	   If !TMPC->(dbSeek(_cEmpresa+QTMP->CNF_CONTRA,.F.))

		  cQuery := " SELECT CNF_CONTRA,MAX(SUBSTRING(CNF_COMPET,4,4)+SUBSTRING(CNF_COMPET,1,2)) AS XX_FIM,"
		  cQuery += "                   MIN(SUBSTRING(CNF_COMPET,4,4)+SUBSTRING(CNF_COMPET,1,2)) AS XX_INI "
				
		  cQuery += " FROM "+xRETSQLNAME("CNF")+" CNF"
			
	      cQuery += " WHERE CNF_CONTRA = '"+TRIM(QTMP->CNF_CONTRA)+"'"
	      cQuery += "      AND  CNF_FILIAL = '"+xFilial("CNF")+"' AND  CNF.D_E_L_E_T_ = ' '"
		
	      cQuery += " GROUP BY CNF_CONTRA "  
	      cQuery += " ORDER BY CNF_CONTRA "  

	      TCQUERY cQuery NEW ALIAS "TMP1"
	
	      dbSelectArea("TMP1")
	      TMP1->(dbGoTop())
	      Reclock("TMPC",.T.)

		  TMPC->XX_EMPRESA := _cEmpresa
		  TMPC->XX_CONTRA  := QTMP->CNF_CONTRA
		  TMPC->XX_CLIENTE := QTMP->CN9_CLIENT
		  TMPC->XX_LOJA    := QTMP->CN9_LOJACL
		  TMPC->XX_NOMCLI  := QTMP->CN9_NOMCLI
		  TMPC->XX_DESC    := QTMP->CN9_XXDESC
		  
		  TMPC->XX_INICIO  := SUBSTR(TMP1->XX_INI,5,2)+"/"+SUBSTR(TMP1->XX_INI,1,4)
		  TMPC->XX_FINAL   := SUBSTR(TMP1->XX_FIM,5,2)+"/"+SUBSTR(TMP1->XX_FIM,1,4)

          TMP1->(dbCloseArea())

	   Else
	      Reclock("TMPC",.F.)
       EndIf
       
	   //IF SUBSTR(cMes,1,4) = '2010' .AND. VAL(SUBSTR(cMes,5,2)) <= 4 .AND. TMPC->XX_REVISAD = "S"
	      // N�o somar valores em vigencia para contrados revisados na competencia < 2010/04
	   //ELSE
		cCampo  := "TMPC->XX_P"+cMes
	       
		IF ASCAN(aJaPrv,QTMP->CNF_CONTRA+QTMP->CNF_NUMERO+QTMP->CNF_PARCEL) == 0
			&cCampo += nPrev
			AADD(aJaPrv,QTMP->CNF_CONTRA+QTMP->CNF_NUMERO+QTMP->CNF_PARCEL)
		ELSE
			nPrev := 0
		ENDIF
	        
	    cCampo  := "TMPC->XX_F"+cMes
	    &cCampo += QTMP->D2_TOTAL    //QTMP->F2_VALFAT

		// Totalizador do Gr�fico
		_nY := aScan(aTMensal, {|x| x[1] == cMes})
	    //If _nY > 0
	       aTMensal[_nY,3] += nPrev
	       aTMensal[_nY,4] += QTMP->D2_TOTAL  //QTMP->F2_VALFAT
	    //EndIf				  
         
		TMPC->XX_TOTPRV += nPrev	
		TMPC->XX_TOTFAT += QTMP->D2_TOTAL  //QTMP->F2_VALFAT	
	   
		TMPC->(Msunlock())
		
		// Gravar total por cliente
	   dbSelectArea("TMPD")
	   If !dbSeek(QTMP->CN9_CLIENT,.F.)
			Reclock("TMPD",.T.)
			TMPD->XX_CLIENTE := QTMP->CN9_CLIENT
			TMPD->XX_NOMCLI  := QTMP->CN9_NOMCLI
       Else
	        Reclock("TMPD",.F.)
       EndIf
	   TMPD->XX_TOTPRV += nPrev	
	   TMPD->XX_TOTFAT += QTMP->D2_TOTAL	
	   If TMPD->XX_TOTPRV > 0
	   		TMPD->XX_PERDIF := 100 - (TMPD->XX_TOTFAT * 100 / TMPD->XX_TOTPRV)
	   EndIf
	   
	   TMPD->(Msunlock())
	   
	   QTMP->(dbSkip())
	ENDDO
    QTMP->(dbCloseArea())

	/*
		cQuery2 := "SELECT C5_ESPECI1,A1_NOME,CTT_DESC01,SUM(D2_TOTAL) AS D2_TOTAL,SUM(D2_VALISS) AS D2_VALISS"
		cQuery2 += " FROM "+RETSQLNAME("SC5")+" SC5" 
		cQuery2 += " INNER JOIN "+RETSQLNAME("SC6")+" SC6 ON SC5.C5_NUM = SC6.C6_NUM" 
		
	    cQuery2 += " INNER JOIN "+RETSQLNAME("SD2")+" SD2 ON C6_NUM = D2_PEDIDO AND C6_ITEM = D2_ITEM"
		cQuery2 += " AND  SD2.D2_FILIAL = '"+xFilial("SD2")+"'  AND  SD2.D_E_L_E_T_ = ' '"
	    
	    cQuery2 += " INNER JOIN "+RETSQLNAME("SA1")+" SA1 ON SC5.C5_CLIENTE = SA1.A1_COD" 
	    cQuery2 += " AND SC5.C5_LOJACLI = SA1.A1_LOJA  AND  SA1.A1_FILIAL = '"+xFilial("SA1")+"' AND  SA1.D_E_L_E_T_ = ' '"
	    
	    cQuery2 += " INNER  JOIN "+RETSQLNAME("CTT")+" CTT ON SC5.C5_ESPECI1 = CTT.CTT_CUSTO AND CTT_FILIAL = '"+xFilial("CTT")+"' AND  CTT.D_E_L_E_T_ = ' '" 
	    cQuery2 += " WHERE SC5.D_E_L_E_T_ = ' ' AND SC5.C5_MDCONTR='' AND SC5.C5_XXCOMPT ='"+SUBSTR(aPeriodo[_nI,1],1,2)+SUBSTR(aPeriodo[_nI,1],4,4)+"'"
	   	cQuery2 += " AND C5_ESPECI1 <> '000000001'"
	    //IF !EMPTY(cContrato)
	    //	cQuery2 += " AND C5_ESPECI1 ='"+ALLTRIM(cContrato)+"'"
	    //ENDIF	
    	cQuery2 += " AND C5_ESPECI1 ='"+ALLTRIM(QTMP->CNF_CONTRA)+"'"
	    	
	    cQuery2 += " GROUP BY SC5.C5_ESPECI1,SA1.A1_NOME,CTT.CTT_DESC01" 
    */

    
	//*********Inclus�o para medi��o avulsa
	cQuery2 := "SELECT C5_ESPECI1,A1_COD,A1_LOJA,A1_NOME,CTT_DESC01,SUM(D2_TOTAL) AS MEDAVULSO  FROM "+xRETSQLNAME("SC5")+" SC5" 
	cQuery2 += " INNER JOIN "+xRETSQLNAME("SC6")+" SC6 ON SC5.C5_NUM = SC6.C6_NUM" 
    cQuery2 += " INNER JOIN "+xRETSQLNAME("SD2")+" SD2 ON SC6.C6_SERIE = SD2.D2_SERIE AND SC6.C6_NOTA = SD2.D2_DOC"
    cQuery2 += " AND  SD2.D2_FILIAL ='"+xFilial("SD2")+"'  AND  SD2.D_E_L_E_T_ = ' '" 
    cQuery2 += " INNER JOIN "+xRETSQLNAME("SA1")+" SA1 ON SD2.D2_CLIENTE = SA1.A1_COD" 
    cQuery2 += " AND SD2.D2_LOJA = SA1.A1_LOJA  AND  SA1.A1_FILIAL = '"+xFilial("SA1")+"' AND  SA1.D_E_L_E_T_ = ' '"
    cQuery2 += " INNER  JOIN "+xRETSQLNAME("CTT")+" CTT ON SC5.C5_ESPECI1 = CTT.CTT_CUSTO AND CTT_FILIAL = '"+xFilial("CTT")+"' AND  CTT.D_E_L_E_T_ = ' '" 
    cQuery2 += " WHERE SC5.D_E_L_E_T_ = ' ' AND SC5.C5_MDCONTR='' AND SC5.C5_XXCOMPT ='"+SUBSTR(cCompet,1,2)+SUBSTR(cCompet,4,4)+"'"
   	cQuery2 += " AND C5_ESPECI1 <> '000000001'"
    cQuery2 += " GROUP BY SC5.C5_ESPECI1,SA1.A1_COD,SA1.A1_LOJA,SA1.A1_NOME,CTT.CTT_DESC01" 
      	
	TCQUERY cQuery2 NEW ALIAS "TMPX2"
	
	dbSelectArea("TMPX2")
	TMPX2->(dbGoTop())
	DO While !TMPX2->(EOF())
		dbSelectArea("TMPC")
		If !TMPC->(dbSeek(_cEmpresa+TMPX2->C5_ESPECI1,.F.))
			Reclock("TMPC",.T.)
		    TMPC->XX_EMPRESA := _cEmpresa
			TMPC->XX_CONTRA  := TMPX2->C5_ESPECI1
		 	TMPC->XX_CLIENTE := TMPX2->A1_COD
		 	TMPC->XX_LOJA    := TMPX2->A1_LOJA
			TMPC->XX_NOMCLI  := TMPX2->A1_NOME
			TMPC->XX_DESC    := TMPX2->CTT_DESC01
		Else
			Reclock("TMPC",.F.)
	    EndIf

		cCampo  := "TMPC->XX_F"+cMes
		&cCampo += TMPX2->MEDAVULSO

	   // Totalizador do Gr�fico
	   _nY := aScan(aTMensal, {|x| x[1] == cMes})
       //If _nY > 0
          aTMensal[_nY,4] += TMPX2->MEDAVULSO
       //EndIf				  
		                      
		TMPC->XX_TOTFAT += TMPX2->MEDAVULSO	

		TMPC->(Msunlock())


		// Gravar total por cliente
		dbSelectArea("TMPD")
		If !dbSeek(TMPX2->A1_COD,.F.)
			Reclock("TMPD",.T.)
			TMPD->XX_CLIENTE := TMPX2->A1_COD
			TMPD->XX_NOMCLI  := TMPX2->A1_NOME
		Else
	        Reclock("TMPD",.F.)
		EndIf
		TMPD->XX_TOTFAT += TMPX2->MEDAVULSO	
		TMPD->(Msunlock())
		If TMPD->XX_TOTPRV > 0
			TMPD->XX_PERDIF := 100 - (TMPD->XX_TOTFAT * 100 / TMPD->XX_TOTPRV)
		EndIf
		
	   TMPX2->(dbSkip())
	ENDDO
	TMPX2->(dbCloseArea())


	//*********Inclus�o de NDCs
	/* Removido em 28/10/2019
	cQuery2 := "SELECT E1_XXCUSTO,E1_VALOR AS MEDAVULSO,A1_COD,A1_LOJA,A1_NOME,CTT_DESC01 FROM "+xRETSQLNAME("SE1")+" SE1" + CRLF
    cQuery2 += " INNER JOIN "+xRETSQLNAME("SA1")+" SA1 ON SE1.E1_CLIENTE = SA1.A1_COD" + CRLF
    cQuery2 += "  AND SE1.E1_LOJA = SA1.A1_LOJA  AND  SA1.A1_FILIAL = '"+xFilial("SA1")+"' AND  SA1.D_E_L_E_T_ = ' '" + CRLF
    cQuery2 += " INNER  JOIN "+xRETSQLNAME("CTT")+" CTT ON SE1.E1_XXCUSTO = CTT.CTT_CUSTO AND CTT_FILIAL = '"+xFilial("CTT")+"' AND  CTT.D_E_L_E_T_ = ' '" + CRLF
    cQuery2 += " WHERE SE1.D_E_L_E_T_ = ' ' AND SE1.E1_TIPO='NDC' AND SE1.E1_XXCOMPE ='"+SUBSTR(cCompet,4,4)+SUBSTR(cCompet,1,2)+"'" + CRLF
    cQuery2 += " ORDER BY E1_NUM" 

	MemoWrite("BKGCTR02-NDC.SQL",cQuery2)
	      	
	TCQUERY cQuery2 NEW ALIAS "TMPX2"
	
	dbSelectArea("TMPX2")
	TMPX2->(dbGoTop())
	DO While !TMPX2->(EOF())
		dbSelectArea("TMPC")
		If !TMPC->(dbSeek(_cEmpresa+TMPX2->E1_XXCUSTO,.F.))
			Reclock("TMPC",.T.)
		    TMPC->XX_EMPRESA := _cEmpresa
			TMPC->XX_CONTRA  := TMPX2->E1_XXCUSTO
		 	TMPC->XX_CLIENTE := TMPX2->A1_COD
		 	TMPC->XX_LOJA    := TMPX2->A1_LOJA
			TMPC->XX_NOMCLI  := TMPX2->A1_NOME
			TMPC->XX_DESC    := TMPX2->CTT_DESC01
		Else
			Reclock("TMPC",.F.)
	    EndIf

		cCampo  := "TMPC->XX_F"+cMes
		&cCampo += TMPX2->MEDAVULSO

	   // Totalizador do Gr�fico
	   _nY := aScan(aTMensal, {|x| x[1] == cMes})
       //If _nY > 0
          aTMensal[_nY,4] += TMPX2->MEDAVULSO
       //EndIf				  
		                      
		TMPC->XX_TOTFAT += TMPX2->MEDAVULSO	
		TMPC->(Msunlock())

		// Gravar total por cliente
		dbSelectArea("TMPD")
		If !dbSeek(TMPX2->A1_COD,.F.)
			Reclock("TMPD",.T.)
			TMPD->XX_CLIENTE := TMPX2->A1_COD
			TMPD->XX_NOMCLI  := TMPX2->A1_NOME
		Else
	        Reclock("TMPD",.F.)
		EndIf
		TMPD->XX_TOTFAT += TMPX2->MEDAVULSO	
		TMPD->(Msunlock())
		If TMPD->XX_TOTPRV > 0
			TMPD->XX_PERDIF := 100 - (TMPD->XX_TOTFAT * 100 / TMPD->XX_TOTPRV)
		EndIf
		
	   TMPX2->(dbSkip())
	ENDDO
	TMPX2->(dbCloseArea())
	*/
	
NEXT

Return



// Substituir a fun��o padrao RESTSQLNAME
Static Function xRETSQLNAME(cAlias)
Return cAlias+_cEmpresa+"0"



Static Function GeraChart1(aTMensal,cArq,aTitulos)

Local aHtml   := {}
Local _nY     := 0
Local aPlanH  := {}
Local aCabecH := {}
Local cHtml   := ""
Local _nZ     := 0

aAdd(aHtml,"<html>")
aAdd(aHtml,"  <head>")
aAdd(aHtml,'    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>')
aAdd(aHtml,'    <script type="text/javascript">')
aAdd(aHtml,"      google.charts.load('current', {'packages':['corechart']});")
aAdd(aHtml,"      google.charts.setOnLoadCallback(drawVisualization);")
aAdd(aHtml,"")
aAdd(aHtml,"      function drawVisualization() {")
aAdd(aHtml,"        // Some raw data (not necessarily accurate)")
aAdd(aHtml,"        var data = google.visualization.arrayToDataTable([")
aAdd(aHtml,"          ['Mes', 'Contratado', 'Faturado', 'Contratado/Faturado',{type: 'string', role: 'annotation'}],") 

For _nY := 1 To Len(aTMensal)
	aTMensal[_nY,5] := aTMensal[_nY,3] - aTMensal[_nY,4]     // Mostrar no gr�fico apenas a diferen�a
	aTMensal[_nY,6] := ROUND((aTMensal[_nY,3] * 100 / aTMensal[_nY,4]) - 100,1)
	aAdd(aHtml,"          ['"+aTMensal[_nY,2]+"',"+ALLTRIM(STR(aTMensal[_nY,3],17,2))+","+ALLTRIM(STR(aTMensal[_nY,4],17,2))+","+ALLTRIM(STR(aTMensal[_nY,5],17,2))+",'"+ALLTRIM(STR(aTMensal[_nY,6],4,1))+"%'],")
Next
//aAdd(aHtml,"          ['2004/05',  165,      938,         614.6],")
//aAdd(aHtml,"          ['2005/06',  135,      1120,        682],")
//aAdd(aHtml,"          ['2006/07',  157,      1167,        623],")
//aAdd(aHtml,"          ['2007/08',  139,      1110,        609.4],")
//aAdd(aHtml,"          ['2008/09',  136,      691,         569.6]")
aAdd(aHtml,"        ]);")
aAdd(aHtml,"")
aAdd(aHtml,"        var options = {")
aAdd(aHtml,"          title : '"+aTitulos[1]+"',")
aAdd(aHtml,"          vAxis: {title: 'R$'},")
aAdd(aHtml,"          hAxis: {title: 'Mes'},")
aAdd(aHtml,"          seriesType: 'line',")
aAdd(aHtml,"          series: {2: {type: 'bars'}}")
aAdd(aHtml,"        };")
aAdd(aHtml,"")
aAdd(aHtml,"        var chart = new google.visualization.ComboChart(document.getElementById('chart_div'));")
aAdd(aHtml,"        chart.draw(data, options);")
aAdd(aHtml,"      }")
aAdd(aHtml,"    </script>")
aAdd(aHtml,"  </head>")
aAdd(aHtml,"  <body>")
aAdd(aHtml,'    <div id="chart_div" style="width: 900px; height: 500px;"></div>')
aAdd(aHtml,"  </body>")
aAdd(aHtml,"</html>")

OpenHtml(cArq,aHtml)
aCabecH := {"Codigo","Mes","Contratado","Faturado","Contratado/Faturado","%"}

MsAguarde({|| U_ArrToCsv(aTMensal,aCabecH,aTitulos[1],cProg+"-totais","\http")},"Aguarde","Gerando planilha...",.F.)

FOR _nZ := 1 TO LEN(aHtml)
	cHtml += aHtml[_nZ]
NEXT
	
Return cHtml




// Abre o Gr�fico no navegador Web
Static Function OpenHtml(cArq,aHtml) 
Local cDirHtml  := "http"
Local cArqHtml  := cDirHtml+"\"+cArq+".html"
Local aArea     := GetArea()
Local nHandle   := 0
Local cCrLf     := Chr(13) + Chr(10)
Local cTxt      := ""
Local _nI       := 0

IF !EMPTY(cDirHtml)
   MakeDir(cDirHtml)
ENDIF   
 
fErase(cArqHtml)

nHandle := MsfCreate(cArqHtml,0)
   
If nHandle > 0

	FOR _nI := 1 TO LEN(aHtml)
		fWrite(nHandle, aHtml[_nI] + cCrLf )
	NEXT
      
	fClose(nHandle)

	ShellExecute("open", "http:\\vmsiga:81\"+cArq+".html", "", "", 1)

EndIf

RestArea(aArea)

Return






User Function ArrToCsv( _aPlan,_aCabs,_cTitulo,_cProg, _cDirHttp )

Local nHandle
Local cCrLf   := Chr(13) + Chr(10)
Local _ni,_nj
Local cPicN   := "@E 9999999999.999999"

Local cArq       := ""
Local cDir       := GetSrvProfString("Startpath","")
Local cDirTmp    := "C:\TMP"  //GetTempPath()

If !Empty(_cDirHttp)
	cDirTmp := _cDirHttp
EndIf

MakeDir(cDirTmp)

cArq := cDirTmp+"\"+_cProg+".csv"
fErase(cArq)

nHandle := MsfCreate(cArq,0)
   
If nHandle > 0
      
   IncProc("Gerando arquivo: "+cArq)   

   FOR _nI := 1 TO LEN(_aCabs)
       fWrite(nHandle, _aCabs[_nI] + IIF(_nI < LEN(_aCabs),";",""))
   NEXT

   fWrite(nHandle, cCrLf ) // Pula linha

   For _nJ := 1 To Len(_aPlan)

      For _ni :=1 to LEN(_aPlan[_nJ])

         xCampo := _aPlan[_nJ,_nI]
            
         _uValor := ""
            
         If VALTYPE(xCampo) == "D" // Trata campos data
            _uValor := dtoc(xCampo)
         Elseif VALTYPE(xCampo) == "N" // Trata campos numericos
            _uValor := transform(xCampo,cPicN)
         Elseif VALTYPE(xCampo) == "C" // Trata campos caracter
         	//IF LEN(ALLTRIM(xCampo)) > 250
            	_uValor := OEMTOANSI(ALLTRIM(xCampo))
            //ELSE
            //	_uValor := '="'+OEMTOANSI(ALLTRIM(xCampo))+'"'
            //ENDIF
         Endif
            
      	fWrite(nHandle, _uValor + IIF(_nI < Len(_aPlan[_nJ]),";",""))

      Next _nI 
      
      fWrite(nHandle, cCrLf )

   Next _nJ
      
   fClose(nHandle)
      
   //IF MsgYesNo("Deseja abrir o arquivo "+cArq+" pelo aplicativo associado?")
   //   ShellExecute("open", cArq,"","",1)
   //ENDIF	
Else
   MsgAlert("Falha na cria��o do arquivo "+cArq)
Endif
   
Return


Static Function ViewGraph(cGraph)
Local oDlg
Local oFont
Local cTextHtml
Local lHtml
Local oSay

DEFINE MSDIALOG oDlg TITLE "Gr�fico" FROM 180,180 TO 650,800 PIXEL
   
// Cria fonte para ser usada no TSay
oFont := TFont():New('Courier new',,-18,.T.)
   
// Monta o Texto no formato HTML
/*
cTextHtml := '<hr size="1">'+;
               '<H1>POKEAGENDA</H1>'+;
               '<h5>Pok�mon selecionado</h5><br/>'+;
               '<table border="1" cellpadding="1" cellspacing="0">'+;
               '<tr>'+;
               '<td width="100" bgcolor="#FFFF87">Pokedex</td>'+;
               '<td width="200" bgcolor="#FFFF87">Nome</td>'+;
               '<td width="100" bgcolor="#FFFF87">Tipo</td>'+;
               '</tr>'+;
               '<tr>'+;
               '<td>'+ cValTochar(self:nPokedex) +'</td>'+;
               '<td>'+ self:cNome +'</td>'+;
               '<td>'+ self:cTipo+'</td>'+;
               '</tr>'+;
               '</table>'
*/

// Cria o TSay permitindo texto no formato HMTL
cTextHtml := cGraph
lHtml := .T.
oSay := TSay():New(01,01,{||cTextHtml},oDlg,,oFont,,,,.T.,,,400,300,,,,,,lHtml)

ACTIVATE MSDIALOG oDlg CENTERED

Return Nil


 