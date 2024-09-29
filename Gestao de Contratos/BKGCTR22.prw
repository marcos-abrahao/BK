#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"

/*/{Protheus.doc} BKGCTR22
BK - Rentabilidade Contratos
@Return
@author Marcos Bispo Abrah�o
@since 10/07/2024
@version P12
/*/

User Function BKGCTR22

/*
Local cDescricao	:= "Objetivo deste relat�rio � a emiss�o de relat�rio de acompanhamento das rentabilidades dos contratos "+CRLF+"Solicitado pelo Planejamento em junho de 2024."
Local cVersao 		:= "10/07/24 - Vers�o inicial"
Local oRExcel		AS Object
Local oPExcel		AS Object
*/
Local lRet			:= .T.

Private aParam		:= {}
Private cTitulo		:= "Rentabilidade Contratos"
Private cProg		:= "BKGCTR22"
Private cVersao		:= "10/09/24 - RExcel"
Private cDescr		:= "Rentabilidade Contratos (via PowerBk)"


Private cContrato   := SPACE(9)
Private dDataI		:= dDataBase
Private dDataF		:= dDataBase
Private nPeriodo    := 0
Private aAnoMes 	:= {}
Private aColMes		:= {}
Private nColIni		:= 9 // Quantidade de Colunas Iniciais antes dos valores
Private aMatriz 	:= {}
Private nMesRef		:= Month(Date())
Private nAnoRef		:= Year(Date())
Private cAMesRef	:= StrZero(nAnoRef,4)+StrZero(nMesRef,2)
Private cMAnoRef	:= StrZero(nMesRef,2)+"/"+StrZero(nAnoRef,4)

// Linhas do relatorio
Private nLinFat		:= 0
Private nLinImp		:= 0
Private nLinIss		:= 0


aAdd( aParam, { 1, "Contrato:" 	, cContrato	, ""    , ""                                       , "CTT", "", 70, .T. })
aAdd( aParam, { 1, "Mes ref."   , nMesRef   ,"99"   , "mv_par02 > 0 .AND. mv_par02 <= 12"      , ""   , "", 20, .T. })
aAdd( aParam, { 1, "Ano ref."   , nAnoRef   ,"9999" , "mv_par03 >= 2010 .AND. mv_par03 <= 2040", ""   , "", 20, .T. })

If !BkPar()
	Return .F.
EndIf

u_WaitLog(cProg, {|| lRet := PrcPer() },"Definindo per�odo...")


If lRet
	u_WaitLog(cProg, {|| lRet := PrcMatriz() }	,"Inicializando a matriz...")
	u_WaitLog(cProg, {|| lRet := PrcFat() }		,"Dados de Faturamento...")
EndIf

If lRet
	u_WaitLog(cProg, {|| lRet := PrcPlan() }	,"Construindo a planilha...")
EndIf

Return lRet


Static Function BkPar
Local aRet  :=	{}
Local lRet  := .F.

//   Parambox(aParametros,@cTitle          ,@aRet,[ bOk ],[ aButtons ],[ lCentered ],[ nPosX ],[ nPosy ],[ oDlgWizard ],[ cLoad ] ,[ lCanSave ],[ lUserSave ] ) --> aRet
If (Parambox(aParam     ,cProg+" - "+cTitulo,@aRet,       ,            ,.T.          ,         ,         ,              ,cProg,.T.         ,.T.))
	lRet := .T.
	cContrato	:= mv_par01
	nMesRef 	:= mv_par02
	nAnoRef		:= mv_par03

	cAMesRef	:= StrZero(nAnoRef,4)+StrZero(nMesRef,2)
	cMAnoRef	:= StrZero(nMesRef,2)+"/"+StrZero(nAnoRef,4)
Endif
Return lRet


Static Function PrcPer
Local cQuery := ""
Local dAux   := Date()
Local lRet	 := .T.
Local nPer	 := 0
Local cAnoMes:= ""

cQuery := "SELECT TOP 1" + CRLF
cQuery += "   MIN(CN9_DTOSER) AS CN9_DTOSER" + CRLF
cQuery += "  ,MIN(CN9_DTINIC) AS CN9_DTINIC" + CRLF
cQuery += "  ,MIN(CNF_DTVENC) AS CNF_INICIO" + CRLF
cQuery += "  ,MAX(CNF_DTVENC) AS CNF_FIM" + CRLF
cQuery += "  ,CN9_SITUAC" + CRLF
cQuery += "  ,CN9_REVISA" + CRLF
cQuery += "  ,MAX(CN9_XXDVIG) AS CN9_XXDVIG" + CRLF
cQuery += "  ,MAX((SUBSTRING(CNF_COMPET,4,4))+SUBSTRING(CNF_COMPET,1,2))+'01' AS MAXCOMPET" + CRLF
cQuery += " FROM "+RETSQLNAME("CNF")+" CNF" + CRLF
cQuery += " INNER JOIN "+RETSQLNAME("CN9") + " CN9 ON " + CRLF
cQuery += "    CN9_NUMERO = CNF_CONTRA " + CRLF
cQuery += "    AND CN9_REVISA = CNF_REVISA " + CRLF
cQuery += "    AND CN9_FILIAL = '"+xFilial("CN9")+"' AND  CN9.D_E_L_E_T_ = ''" + CRLF
cQuery += " WHERE CNF.D_E_L_E_T_=''" + CRLF
cQuery += "    AND CNF_CONTRA ='"+ALLTRIM(cContrato)+"'" + CRLF
cQuery += " GROUP BY CN9_REVISA,CN9_SITUAC" + CRLF
cQuery += " ORDER BY CN9_REVISA DESC" + CRLF

u_LogTxt(cProg+".SQL",cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QTMP1",.T.,.T.)

TCSETFIELD("QTMP1","CNF_INICIO","D",8,0)
TCSETFIELD("QTMP1","CNF_FIM"   ,"D",8,0)
TCSETFIELD("QTMP1","CN9_DTINIC","D",8,0)
TCSETFIELD("QTMP1","CN9_DTOSER","D",8,0)
TCSETFIELD("QTMP1","CN9_XXDVIG","D",8,0)

dbSelectArea("QTMP1")

// Calculo das datas iniciais e finais

dDataI		:= QTMP1->CN9_DTOSER
If Empty(dDataI)
	dDataI	:= QTMP1->CN9_DTINIC
EndIf
If !Empty(QTMP1->CNF_INICIO) .AND. QTMP1->CNF_INICIO < dDataI
	dDataI	:= QTMP1->CNF_INICIO
EndIf

dDataF  := QTMP1->CN9_XXDVIG
If QTMP1->CNF_FIM > dDataF
	dDataF	:= QTMP1->CNF_FIM
EndIf

dAux  := STOD(QTMP1->MAXCOMPET)
If dAux > dDataF
	dDataF := dAux
EndIf

If EMPTY(DTOS(dDataI)) .OR. EMPTY(DTOS(dDataF))
	u_MsgLog(cProg,"Contrato "+cContrato+" n�o encontrado!!","E")
	lRet := .F.
Else
	// Voltar 1 mes na data inicial (lan�amentos pr� contrato)
	dDataI := dDataI - Day(dDataI)
	dDataI := dDataI - Day(dDataI)+1

	// Ultimo dia do mes do fim do contrato
	dDataF := LastDay(dDataF)

	//Determina quantos Meses utilizar no calculo
	nPeriodo := DateDiffMonth( dDataI , dDataF ) + 1

	// Cria o array com o periodo
	dAux := dDataI
	For nPer := 1 To nPeriodo

		cAnoMes := StrZero(Year(dAux),4)+StrZero(Month(dAux),2)

		aAdd(aAnoMes,cAnoMes)

		aAdd(aColMes,"P"+cAnoMes)
		aAdd(aColMes,"R"+cAnoMes)

		dAux := MonthSum(dAux,1)
	Next
EndIf

QTMP1->(Dbclosearea())

Return lRet


// Cria a Matriz geral do Relat�rio
Static Function PrcMatriz
Local aLinha	:= {}


////// Linha de Faturamento----------------- 
aLinha	:= {}
aAdd(aLinha,cContrato)
// Chave
aAdd(aLinha,"03")
// Descri��o
aAdd(aLinha,"FATURAMENTO BRUTO")
// Campos de Previsto e relizado por m�s
IncPer(aLinha)
aAdd(aMatriz,aLinha)
nLinFat := Len(aMatriz)
////// -------------------------------------

// Impostos e Contribui��es
aLinha	:= {}
aAdd(aLinha,cContrato)
// Chave
aAdd(aLinha,"04")
// Descri��o
aAdd(aLinha,"(-) Impostos e Contribui��es")
// Campos de Previsto e relizado por m�s
IncPer(aLinha)
aAdd(aMatriz,aLinha)
nLinImp := Len(aMatriz)


// ISS
aLinha	:= {}
aAdd(aLinha,cContrato)
// Chave
aAdd(aLinha,"05")
// Descri��o
aAdd(aLinha,"(-) ISS")
// Campos de Previsto e relizado por m�s
IncPer(aLinha)
aAdd(aMatriz,aLinha)
nLinIss := Len(aMatriz)

Return .T.


// Montar os valores iniciais das linhas
Static Function IncPer(aLinha)
Local nI := 0

// Previsto Mes
aAdd(aLinha,0)
// Realizado Mes
aAdd(aLinha,0)
// Realizado / Previsto Mes
aAdd(aLinha,0)

// Total Previsto
aAdd(aLinha,0)
// Total Realizado
aAdd(aLinha,0)
// Total Realizado / Previsto
aAdd(aLinha,0)

For nI := 1 To nPeriodo
	// Previsto
	aAdd(aLinha,0)
	// Realizado
	aAdd(aLinha,0)
Next
Return


#DEFINE FAT_EMPRESA			1
#DEFINE FAT_CONTRATO		2
#DEFINE FAT_COMPETAM		3
#DEFINE FAT_VALPREV			4
#DEFINE FAT_VALFAT			5
#DEFINE FAT_VALISS			6

Static Function PrcFat

Local lRet 			:= .T.
Local nX 			:= 0
Local cQuery 		:= ""
Local nCol 			:= 0
Local cAnoMes 		:= ""
Local nMImp			:= 0
Local aReturn       := {}
Local aBinds        := {}
Local aSetFields    := {}
Local nRet          := 0
Local cFormula 		:= ""

//SELECT CONTRATO,COMPETAM,SUM(VALFAT),SUM(CXN_VLPREV) FROM FATURAMENTO WHERE CONTRATO = 386000609 GROUP BY CONTRATO,COMPETAM ORDER BY CONTRATO,COMPETAM

cQuery := " SELECT " + CRLF
cQuery += "   EMPRESA" + CRLF
cQuery += "  ,CONTRATO" + CRLF
cQuery += "  ,COMPETAM" + CRLF
cQuery += "  ,SUM(CXN_VLPREV) AS VALPREV" + CRLF
cQuery += "  ,SUM(VALFAT)     AS VALFAT" + CRLF
cQuery += "  ,SUM(F2_VALISS)  AS VALISS" + CRLF
cQuery += " FROM PowerBk.dbo.FATURAMENTO" + CRLF
cQuery += " WHERE CONTRATO = ? " + CRLF
cQuery += " GROUP BY EMPRESA,CONTRATO,COMPETAM" + CRLF
cQuery += " ORDER BY EMPRESA,CONTRATO,COMPETAM" + CRLF

aAdd(aBinds,cContrato)

// Ajustes de tratamento de retorno
aadd(aSetFields,{"EMPRESA"	,"C",  2,0})
aadd(aSetFields,{"CONTRATO"	,"C",  9,0})
aadd(aSetFields,{"COMPETAM"	,"C",  6,0})
aadd(aSetFields,{"VALPREV"	,"N", 14,2})
aadd(aSetFields,{"VALFAT"	,"N", 14,2})
aadd(aSetFields,{"VALISS"	,"N", 14,2})

nRet := TCSqlToArr(cQuery,@aReturn,aBinds,aSetFields)

u_LogTxt(cProg+".SQL",cQuery,aBinds)

If nRet < 0
	lRet := .F.
	u_MsgLog(cProg,TCSqlError()+" - Falha ao executar a Query: "+cQuery,"E")
Else

	For nX := 1 TO LEN(aReturn)
		cAnoMes := aReturn[nX,FAT_COMPETAM]
		nCol    := Ascan(aColMes,"P"+cAnoMes)
		nMImp	:= u_MVNMIMPC(aReturn[nX,FAT_EMPRESA],cAnoMes)

		If nCol > 0
			// Valor Previsto
			aMatriz[nLinFat,nCol+nColIni] += aReturn[nX,FAT_VALPREV]
			// Impostos
			//cFormula:= "'=-"+cValToChar(nMImp)+"% * #!0,-1#!'"  
			cFormula:= "'=-"+cValToChar(nMImp)+"% * #!0,nLinFat#!'"  
			aMatriz[nLinImp,nCol+nColIni] := cFormula

			// ISS
			cFormula:= "'=-IFERROR(#!1,0#! / #!1,nLinFat#! * #!0,nLinFat#!,0)'"  //=+K6/K4*J4
			aMatriz[nLinIss,nCol+nColIni] := cFormula

		Else
			lRet := .F.
		EndIf

		nCol    := Ascan(aColMes,"R"+cAnoMes)
		If nCol > 0
			// Valor Realizado
			aMatriz[nLinFat,nCol+nColIni] += aReturn[nX,FAT_VALFAT]
			// Impostos
			//cFormula:= "'=-"+cValToChar(nMImp)+"% * "+ cValToChar(aMatriz[nLinFat,nCol+nColIni])+"'"
			cFormula:= "'=-"+cValToChar(nMImp)+"% * #!0,-1#!'"    //+ cValToChar(aMatriz[nLinFat,nCol+nColIni])+"'"
			aMatriz[nLinImp,nCol+nColIni] := cFormula

			// ISS
			aMatriz[nLinIss,nCol+nColIni] := aReturn[nX,FAT_VALISS]

		Else
			lRet := .F.
		EndIf
	Next

Endif

Return lRet



Static Function PrcPlan()
Local nI 		:= 0
Local cCol 		:= ""
Local cColsP	:= ""
Local cColsR	:= ""
Local cColAP	:= ""
Local cColAR	:= ""
Local cCab		:= ""

// Defini��o do Arq Excel
oRExcel := RExcel():New(cProg)
oRExcel:SetTitulo(cTitulo)
oRExcel:SetVersao(cVersao)
oRExcel:SetDescr(cDescr)
oRExcel:SetParam(aParam)

// Defini��o da Planilha 1
oPExcel:= PExcel():New(cProg,aMatriz)

// Colunas da Planilha 1
oPExcel:AddCol("CONTRATO","","Contrato","")
oPExcel:GetCol("CONTRATO"):SetTamCol(10)

oPExcel:AddCol("CHAVE","","Chave","")
oPExcel:GetCol("CHAVE"):SetTamCol(20)

oPExcel:AddCol("DESCRICAO","","Descricao","")
oPExcel:GetCol("DESCRICAO"):SetTamCol(50)

// Cria��o das f�rmulas de soma do previsto e realizado at� o mes de ref
cColsP := cColsR:= "'="
For nI := 1 To Len(aColMes)
	cCol := aColMes[nI]
	If SUBSTR(cCol,2,6) <= cAMesRef

		// Mes Atual
		If SUBSTR(cCol,2,6) == cAMesRef
			If "P" $ cCol
				cColAP := "'=##"+cCol+"##'"
			Else
				cColAR := "'=##"+cCol+"##'"
			EndIf
		EndIf

		// Soma dos mesese
		If "P" $ cCol
			If "##" $ cColsP
				cColsP += "+"
			EndIf
			cColsP += "##"+cCol+"##"
		Else
			If "##" $ cColsR
				cColsR += "+"
			EndIf
			cColsR += "##"+cCol+"##"
		EndIf
	EndIf
Next
cColsP += "'"
cColsR += "'"

oPExcel:AddCol("PREVMES",cColAP,"Previsto em "+cMAnoRef,"")
oPExcel:GetCol("PREVMES"):SetTipo("FN")
oPExcel:GetCol("PREVMES"):SetTotal(.T.)

oPExcel:AddCol("REALMES",cColAR,"Realizado em "+cMAnoRef,"")
oPExcel:GetCol("REALMES"):SetTipo("FN")
oPExcel:GetCol("REALMES"):SetTotal(.T.)

oPExcel:AddCol("MPREVREAL","'=IFERROR(#!REALMES,0#! / #!PREVMES,0#!,0)'","Previsto / Realizado em "+cMAnoRef,"")
oPExcel:GetCol("MPREVREAL"):SetTipo("FP")
oPExcel:GetCol("MPREVREAL"):SetTotal(.F.)


oPExcel:AddCol("TOTPREV",cColsP,"Total Previsto at� "+cMAnoRef,"")
oPExcel:GetCol("TOTPREV"):SetTipo("FN")
oPExcel:GetCol("TOTPREV"):SetTotal(.T.)

oPExcel:AddCol("TOTREAL",cColsR,"Total Realizado at� "+cMAnoRef,"")
oPExcel:GetCol("TOTREAL"):SetTipo("FN")
oPExcel:GetCol("TOTREAL"):SetTotal(.T.)

oPExcel:AddCol("PPREVREAL","'=#!TOTREAL,0#! / #!TOTPREV,0#!'","Previsto / Realizado at� "+cMAnoRef,"")
oPExcel:GetCol("PPREVREAL"):SetTipo("FP")
oPExcel:GetCol("PPREVREAL"):SetTotal(.F.)

For nI := 1 To Len(aColMes)
	cCol := aColMes[nI]
	If "P" $ cCol
		cCab := "Previsto "+SUBSTR(aColMes[nI],6,2)+"/"+SUBSTR(aColMes[nI],2,4)
	Else
		cCab := "Realizado "+SUBSTR(aColMes[nI],6,2)+"/"+SUBSTR(aColMes[nI],2,4)
	EndIf
	oPExcel:AddCol(cCol,"",cCab,"")
	oPExcel:GetCol(cCol):SetTipo("FN")	
	oPExcel:GetCol(cCol):SetTotal(.T.)
	oPExcel:GetCol(cCol):SetDecimal(2)
Next

// Adiciona a planilha 1
oRExcel:AddPlan(oPExcel)
oPExcel:SetTitulo("Contrato: "+cContrato+" - "+Posicione("CTT",1,xFilial("CTT")+cContrato,"CTT_DESC01"))

// Cria arquivo Excel
oRExcel:Create()

Return Nil

