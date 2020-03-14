#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"

User Function CNTA121()
	Local aParam := PARAMIXB
	Local xRet := .T.
	Local oObj := ""
	Local cIdPonto := ""
	Local cIdModel := ""
	Local lIsGrid := .F.
	Local nLinha := 0
	Local nQtdLinhas := 0
	Local cMsg := ""
	//Local nOp

	If (aParam <> NIL)
		oObj     := aParam[1]
		cIdPonto := aParam[2]
		cIdModel := aParam[3]
		lIsGrid  := (Len(aParam) > 3)

		nOpc := oObj:GetOperation() // PEGA A OPERA��O

		If (cIdPonto == "MODELPOS")
			/*
			cMsg := "Chamada na valida��o total do modelo." + CRLF
			cMsg += "ID " + cIdModel + CRLF
			IF nOp == 3
				Alert('inclus�o')
			ENDIF

			//xRet := MsgYesNo(cMsg + "Continua?")
			*/
			
			//MsgInfo(cMsg,cIdPonto)			
			//U_xCN130PGRV(nOpc)
		ElseIf (cIdPonto == "MODELVLDACTIVE")
			
			cMsg := "Chamada na ativa��o do modelo de dados."

			//xRet := MsgYesNo(cMsg + "Continua?")
			//MsgInfo(cMsg,cIdPonto)			
			
		ElseIf (cIdPonto == "FORMPOS")
			
			cMsg := "Chamada na valida��o total do formul�rio." + CRLF
			cMsg += "ID " + cIdModel + CRLF

			If (lIsGrid == .T.)
				cMsg += "� um FORMGRID com " + Alltrim(Str(nQtdLinhas)) + " linha(s)." + CRLF
				cMsg += "Posicionado na linha " + Alltrim(Str(nLinha)) + CRLF
			Else
				cMsg += "� um FORMFIELD" + CRLF
			EndIf

			//xRet := MsgYesNo(cMsg + "Continua?")
			//MsgInfo(cMsg,cIdPonto)			
			
		ElseIf (cIdPonto =="FORMLINEPRE")
			/*
			If aParam[5] =="DELETE"
				cMsg := "Chamada na pr� valida��o da linha do formul�rio." + CRLF
				cMsg += "Onde esta se tentando deletar a linha" + CRLF
				cMsg += "ID " + cIdModel + CRLF
				cMsg += "� um FORMGRID com " + Alltrim(Str(nQtdLinhas)) + " linha(s)." + CRLF
				cMsg += "Posicionado na linha " + Alltrim(Str(nLinha)) + CRLF

				xRet := MsgYesNo(cMsg + " Continua?")
			EndIf
			*/
		ElseIf (cIdPonto =="FORMLINEPOS")
			/*
			cMsg := "Chamada na valida��o da linha do formul�rio." + CRLF
			cMsg += "ID " + cIdModel + CRLF
			cMsg += "� um FORMGRID com " + Alltrim(Str(nQtdLinhas)) + " linha(s)." + CRLF
			cMsg += "Posicionado na linha " + Alltrim(Str(nLinha)) + CRLF

			xRet := MsgYesNo(cMsg + " Continua?")
			*/
		ElseIf (cIdPonto =="MODELCOMMITTTS")
			//MsgInfo("Chamada ap�s a grava��o total do modelo e dentro da transa��o.",cIdPonto)
		ElseIf (cIdPonto =="MODELCOMMITNTTS")
			//MsgInfo("Chamada ap�s a grava��o total do modelo e fora da transa��o.",cIdPonto)
		ElseIf (cIdPonto =="FORMCOMMITTTSPRE")
			//MsgInfo("Chamada ap�s a grava��o da tabela do formul�rio.",cIdPonto)
		ElseIf (cIdPonto =="FORMCOMMITTTSPOS")
			//MsgInfo("Chamada ap�s a grava��o da tabela do formul�rio.",cIdPonto)
		ElseIf (cIdPonto =="MODELCANCEL")
			
			//cMsg := cIdPonto+" - Deseja realmente sair?"

			//xRet := MsgYesNo(cMsg)
			
		ElseIf (cIdPonto =="BUTTONBAR")
			//MsgInfo("Chamada para inclus�o de bot�o.")
			//xRet := {{"Bot�o", "BOT�O", {|| MsgInfo("Buttonbar","BUTTONBAR")}}}
		EndIf
	EndIf
Return (xRet)
