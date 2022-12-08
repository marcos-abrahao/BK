#INCLUDE "PROTHEUS.CH"
#INCLUDE "topconn.ch"

User Function NumSf1()
Local lRet := .T.
Local nPar := 0
Local cPar := ""

// Numero sequencial DNF - BK (doc de entrada)
/*
If !FWIsInCallStack("MSEXECAUTO")   //ALLTRIM(ProcName(9)) <> "MSEXECAUTO" // MSEXECAUTO da funcao BKCOMA03 - Inclusao Benef�cios VT/VR/VA Pr�-Documento de Entrada e Assist�ncia M�dica
	If VAL(cNFiscal) == 0 
		If cSerie == "DNF"
			If !SX6->(DBSEEK("  MV_XXNUMF1",.F.))
				RecLock("SX6",.T.)
				SX6->X6_VAR     := "MV_XXNUMF1"
				SX6->X6_TIPO    := "N"
				SX6->X6_DESCRIC := "Numero sequencial DNF - "+ALLTRIM(FWEmpName(cEmpAnt))+" (doc de entrada)"
				SX6->X6_CONTEUD := STRZERO(_nI,9)
				SX6->(MsUnlock())
			Else
				RecLock("SX6",.F.)
				nI := VAL(SX6->X6_CONTEUD)+1
				SX6->X6_CONTEUD := STRZERO(nI,9)
				SX6->(MsUnlock())
			EndIf
			cNFiscal := STRZERO(nI,9)
		Else
			_lRet := .F.
			MsgStop("N�mero do Documento n�o pode ser zero","NumSf1")
		EndIf
	EndIf
ENDIF
*/

If !FWIsInCallStack("MSEXECAUTO")   // MSEXECAUTO da funcao BKCOMA03 - Inclusao Benef�cios VT/VR/VA Pr�-Documento de Entrada e Assist�ncia M�dica
	If VAL(cNFiscal) == 0 
		If cSerie == "DNF"
			nPar := GetMv("MV_XXNUMF1",.F.,STRZERO(0,9))
			nPar++
			cPar := STRZERO(nPar,9)
			cNFiscal := cPar
			PutMv("MV_XXNUMF1",cPar)
		Else
			lRet := .F.
			u_MsgLog("NumSf1","N�mero do Documento n�o pode ser zero","E")
		EndIf
	EndIf
ENDIF

Return lRet



User Function ExistNF()
Local lOk     := .T.
Local cQuery1 := ""
Local cXDOC    := ""
Local cXSerie  := ""
Local cXFORNECE:= ""
Local cXLoja   := ""


cXDOC     := CNFISCAL
cXSerie   := CSERIE
cXFORNECE := CA100FOR
cXLoja    := IIF(!EMPTY(CLOJA),CLOJA,"01")
                                                     
cQuery1 := "SELECT F1_DOC,F1_SERIE"
cQuery1 += " FROM "+RETSQLNAME("SF1")+" SF1" 
cQuery1 += " WHERE SF1.D_E_L_E_T_='' AND SF1.F1_FILIAL='"+xFilial('SF1')+"'  AND SF1.F1_DOC='"+cXDOC+"' "
cQuery1 += " AND SF1.F1_FORNECE='"+cXFORNECE+"' AND SF1.F1_LOJA='"+cXLoja+"' AND SF1.F1_SERIE<>'"+cXSerie+"'"
        
        
TCQUERY cQuery1 NEW ALIAS "TMPSF1"

dbSelectArea("TMPSF1")
TMPSF1->(dbGoTop())
DO While !TMPSF1->(EOF())
	lOk := .F.
	cXSerie := TMPSF1->F1_SERIE
	TMPSF1->(dbskip())
Enddo
TMPSF1->(DbCloseArea())

IF !lOk
	IF MSGNOYES("J� existe a NF "+cXDoc+" lan�ada para o Fornecedor "+cXFORNECE+" com a s�rie: "+cXSerie+"! Incluir assim mesmo?")
		lOk := .T.
	ENDIF
ENDIF

Return lOk


