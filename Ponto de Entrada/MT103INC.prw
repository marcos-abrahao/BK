#Include "protheus.ch"
#Include "totvs.ch"
#Include "topconn.cH"

#define MB_ICONEXCLAMATION          48

/*/{Protheus.doc} MT103INC
P.E. - Verifica se pode-se classificar o documento.
===================================================
Fluxo de libera��o de Pr�-Notas - BK

---------------------------------------------------
Inclus�o da Pr� Nota: 
SF1140i: Gravar F1_XXLIB := "A"
MT140SAI: Gravar F1_XXLIB := "B" caso a pr� nota tenha sido bloqueada 
---------------------------------------------------
Inclus�o de Doc. de Entrada (permitida para administradores)
SF1100i: Gravar F1_XXLIB := "C" ou "B" caso o doc tenha sido bloqueado
---------------------------------------------------
Estorno da Classifica��o:
MT103FIM: Gravar F1_XXLIB := "E", e enviar e-mail
---------------------------------------------------
Libera��o do Bloqueio do Doc de entrada:
MT094END: Gravar F1_XXLIB := "L" (e avaliar fornecedor) ou "B" caso o doc tenha sido bloqueado
---------------------------------------------------
Classifica��o do Doc de Entrada: MT103INC
Se F1_XXLIB

	A: Libera ou N�o Libera (L ou N)
		Se n�o Libera-> enviar e-mail para quem incluiu (e quem liberou)

	L ou E: Somente Grupo User Fiscal ou Administradores podem classificar
		Op��es: Classifica
				Estorna (F1_XXLIB := "E") e envia e-mail a quem incluiu e quem liberou

	N: Permite aprovador Liberar novamente
	B: Nenhuma opera��o pode ser feita aqui
	
---------------------------------------------------
@author Marcos Bispo Abrah�o
@since 24/11/2020
@version 1.0
@type function
/*/
User Function MT103INC()
Local lClass    := Paramixb
Local lRet      := .F.
Local nOper     := 0
Local aUser     := {}
Local aArea		:= GetArea()
Local cEmail	:= ""
Local cLogDoc	:= SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA+" "+SF1->F1_ESPECIE

If lClass
	If !IsBlind() .AND. __cUserId <> "000000" .AND. __cUserId <> "000012" ;
    		.AND. (SUBSTR(TIME(),1,2) > '18' .OR. SUBSTR(TIME(),1,2) < '07')
		
		u_LogPrw("MT103INC","Doc n�o liberado, fora do horario: "+cLogDoc)
    	MsgStop("N�o � permitido incluir, classificar e liberar documentos entre 18h e 7h","MT103INC")
        lRet := .F.
	Else
		If SF1->F1_XXLIB == 'A'
			nOper := Aviso("MT103INC","Libera��o para classifica��o fiscal:",{"Liberar","N�o Liberar","Cancelar"})
			If nOper <> 3
				RecLock("SF1",.F.)
				If nOper == 1
					SF1->F1_XXLIB  := "L"
				Else
					SF1->F1_XXLIB  := "N"
				EndIf
				SF1->F1_XXULIB := __cUserId
				SF1->F1_XXDLIB := DtoC(Date())+"-"+Time()
				MsUnLock("SF1")

				If nOper == 1
					// Avalia��o do Fornecedor

					If u_IsAvalia(__cUserId)
						MsAguarde({|| prcD1Aval() },"Aguarde","Pesquisando pedidos para avalia��o...",.F.)

						dbSelectArea("TMPSD1")
						dbGoTop()
						If !TMPSD1->(EOF())
							U_AvalForn(.F.)
						EndIf
						TMPSD1->(DbCloseArea())
					EndIf

					u_LogPrw("MT103INC","Doc liberado: "+cLogDoc)

				ElseIf nOper == 2

					// Caso n�o libere, enviar e-mail para quem incluiu o Documento
					PswOrder(1)
					PswSeek(SF1->F1_XXUSER) 
					aUser  := PswRet(1)
					IF !EMPTY(aUser[1,14]) .AND. !aUser[1][17]
						cEmail += ALLTRIM(aUser[1,14])+';'
					ENDIF
					u_SF1Email("Pr�-Nota n�o liberada pelo aprovador")

					u_LogPrw("MT103INC","Doc n�o liberado: "+cLogDoc)
				EndIf
			EndIf
		ElseIf SF1->F1_XXLIB == 'L' .OR. SF1->F1_XXLIB == 'E'
			PswOrder(1) 
			PswSeek(__cUserId) 
			aUser  := PswRet(1)
			If ASCAN(aUser[1,10],"000000") <> 0 .OR. ASCAN(aUser[1,10],"000031") <> 0 .OR. ASCAN(aUser[1,10],"000005") <> 0 .OR. ASCAN(aUser[1,10],"000007") <> 0//.OR. lMDiretoria 
				If .F. //ASCAN(aUser[1,10],"000031") <> 0 .AND. __cUserId == SF1->F1_XXULIB // REMOVIDO EM 03/09/21
					MessageBox("Usu�rio sem permiss�o para classificar este Doc.","MT103INC",MB_ICONEXCLAMATION)
				Else
					If SF1->F1_XXLIB == 'L'
						nOper := Aviso("MT103INC","Classifica��o fiscal:",{"Classifica","Estorna Lib.","Cancelar"})
					Else
						nOper := Aviso("MT103INC","Classifica��o fiscal (documento estornado):",{"Classifica","Cancelar"})
					EndIf
					If nOper == 1
						// Segue a classifica��o
						lRet := .T.
					ElseIf nOper == 2 .AND. SF1->F1_XXLIB == 'L'
						RecLock("SF1",.F.)
						SF1->F1_XXLIB   := "E"
						SF1->F1_XXUCLAS := __cUserId
						SF1->F1_XXDCLAS := DtoC(Date())+"-"+Time()
						MsUnLock("SF1")
						u_SF1Email("Pr�-Nota Estornada pelo Fiscal")
						u_LogPrw("MT103INC","Doc estornado: "+cLogDoc)

					EndIf
				EndIf
			Else
				If SF1->F1_XXLIB == 'E'
					MessageBox("Documento estornado pelo classificador: "+SF1->F1_XXUCLAS,"MT103INC",MB_ICONEXCLAMATION)
				Else
					MessageBox("Documento j� foi liberado, aguarde a classifica��o pelo Depto Fiscal.","MT103INC",MB_ICONEXCLAMATION)
				EndIf
			EndIf
		ElseIf SF1->F1_XXLIB == 'N'
			PswOrder(1) 
			PswSeek(__cUserId) 
			aUser  := PswRet(1)
			//If !EMPTY(aUser[1,11])
			//    cSuper := SUBSTR(aUser[1,11],1,6)
			//EndIf
			If SF1->F1_XXULIB == __cUserId .OR. ASCAN(aUser[1,10],"000000") <> 0
				nOper := Aviso("MT103INC - N�o Liberado","Libera��o para classifica��o fiscal:",{"Liberar","Cancelar"})
				If nOper == 1
					RecLock("SF1",.F.)
					SF1->F1_XXLIB  := "L"
					SF1->F1_XXULIB := __cUserId
					SF1->F1_XXDLIB := DtoC(Date())+"-"+Time()
					MsUnLock("SF1")
					u_LogPrw("MT103INC","Doc liberado: "+cLogDoc)
				EndIf
			Else
				MessageBox("Documento bloqueado para classifica��o: "+SF1->F1_XXUCLAS,"MT103INC",MB_ICONEXCLAMATION)
			EndIf
		//ElseIf SF1->F1_XXLIB == 'E'
		//	MessageBox("Documento estornado pelo classificador: "+SF1->F1_XXUCLAS,"MT103INC",MB_ICONEXCLAMATION)
		ElseIf SF1->F1_XXLIB == 'B'
			MessageBox("Documento bloqueado, aguarde libera��o da diretoria: "+SF1->F1_XXULIB,"MT103INC",MB_ICONEXCLAMATION)
		ElseIf SF1->F1_XXLIB == 'C'
			MessageBox("Documento j� foi classificado: "+SF1->F1_XXUCLAS,"MT103INC",MB_ICONEXCLAMATION)
		EndIf
	EndIf
Else
	// Inclus�o permitida apenas para administradores e master financeiro
	PswOrder(1) 
	PswSeek(__cUserId) 
	aUser  := PswRet(1)
	If ASCAN(aUser[1,10],"000000") <> 0 .OR. ASCAN(aUser[1,10],"000005") <> 0
		lRet := .T.
	Else
		u_LogPrw("MT103INC","Usu�rio sem permiss�o: "+cLogDoc)
		If !IsBlind()
    		MsgStop("Usu�rio sem permiss�o para incluir Documentos de Entrada","MT103INC")
		EndIf
		lRet := .F.
	EndIf
EndIf
RestArea(aArea)
Return lRet


Static Function prcD1Aval()
Local cQryD1

cQryD1 := "SELECT D1_PEDIDO"
cQryD1 += " FROM "+RetSqlName("SD1")+" SD1" 
cQryD1 += " WHERE "+RetSqlCond("SD1")  //D1_FILIAL = '" + xFilial("SD1") + "' AND D_E_L_E_T_ = ' ' " 
cQryD1 += "  AND SD1.D1_DOC='"+SF1->F1_DOC+"' AND SD1.D1_SERIE='"+SF1->F1_SERIE+"'"
cQryD1 += "  AND SD1.D1_FORNECE='"+SF1->F1_FORNECE+"' AND SD1.D1_LOJA='"+SF1->F1_LOJA+"' AND SD1.D1_PEDIDO<>''"
TCQUERY cQryD1 NEW ALIAS "TMPSD1"

Return Nil


User Function SF1Email(cAssunto)
Local cEmail    := "microsiga@bkconsultoria.com.br;"
Local cEmailCC  := "" 
Local aCabs   	:= {}
Local aEmail 	:= {}
Local cMsg		:= ""
Local cJust		:= ""

If !IsBlind()
	cJust := "("+DTOC(DATE())+"-"+TIME()+") "+JustBlq(cAssunto)
EndIf

RecLock("SF1",.F.)
SF1->F1_HISTRET := cJust
MsUnLock("SF1")

cAssunto += " n�.:"+SF1->F1_DOC+" S�rie:"+SF1->F1_SERIE+"    "+DTOC(DATE())+"-"+TIME()+" - "+FWEmpName(cEmpAnt)

If !Empty(SF1->F1_XXUSER)
	cEmail += UsrRetMail(SF1->F1_XXUSER)+';'
EndIf
If !Empty(SF1->F1_XXUSERS)
	cEmail += UsrRetMail(SF1->F1_XXUSERS)+';'
EndIf

cEmailCC += UsrRetMail(__cUserId)+';'

// Incluir usuarios do almoxarifado 28/09/2021 - Fabio Quirino
cEmail  += u_EmEstAlm(SF1->F1_XXUSER,.F.)

aCabs   := {"Pr�-Nota n�.:" + TRIM(SF1->F1_DOC) + " S�rie:" + SF1->F1_SERIE+ " Valor: "+ALLTRIM(TRANSFORM(U_GetValTot(.F.),"@E 99,999,999,999.99"))}
aEmail 	:= {}
AADD(aEmail,{"Fornecedor: "+SA2->A2_COD+"-"+SA2->A2_LOJA+" - "+SA2->A2_NOME})
AADD(aEmail,{"Reprovador:"+UsrFullName(RetCodUsr())})
AADD(aEmail,{"Motivo    :"+cJust})

cMsg    := u_GeraHtmA(aEmail,cAssunto,aCabs,"MT103INC")
U_BkSnMail("MT103INC",cAssunto,cEmail,cEmailCC,cMsg)

Return Nil


// Tela para justifiar o estorno/n�o libera��o
Static Function JustBlq(cTexto)
Local oDlg  as Object
Local oFont as Object
Local oMemo as Object

//Define Font oFont Name "Mono AS" Size 5, 12
Define MsDialog oDlg Title "Complemente o Motivo:" From 3, 0 to 340, 417 Pixel

@ 5, 5 Get oMemo Var cTexto Memo Size 200, 145 Of oDlg Pixel
oMemo:bRClicked := { || AllwaysTrue() }
oMemo:oFont     := oFont

Define SButton From 153, 160 Type  1 Action oDlg:End() Enable Of oDlg Pixel

Activate MsDialog oDlg Center

Return cTexto


