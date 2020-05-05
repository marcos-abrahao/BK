/*/{Protheus.doc} MT110LOK
// Valida��o das entidades cont�beis quando n�o for utilizado rateio.
@author Marcos Bispo Abrah�o
@since 05/04/2019
@version 1.0
@return .F. / .T.
@type function
/*/
User Function MT110LOK()
	
	// Declara��o de variaveis
	Local _lRet	:= .T.
	
	// Busca posi��o do campos
	Local _nPosLcV	:= aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_XXLCVAL'})
	Local _nPosPrd	:= aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_PRODUTO'})
	Local _nPosDesc	:= aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_DESCRI'})
	Local dDataInc
	Local cAlmox	:= "000093/000160/000126"   //SuperGetMV("MV_XXGRALX",.F.,"000021")	

	If Empty( aCols[n][_nPosDesc] )
		aCols[n][_nPosDesc] := Posicione("SB1",1,xFilial("SB1")+aCols[n][_nPosPrd],"B1_DESC")
	EndIf

	// Valida��o a ser executada
	If __cUserId $ cAlmox
		aCols[n][_nPosLcV] := 0
	ElseIf Empty( aCols[n][_nPosLcV] ) // Valor licitado n�o informado
		If "UNI" $ aCols[n][_nPosPrd] .OR. "EPI" $ aCols[n][_nPosPrd]
			CN9->(dbSetOrder(1))
			If CN9->(dbSeek(xFilial("CN9")+cCC,.F.))  // Existe contrato para este centro de custo
				dDataInc := CTOD(CN9->(FWLeUserlg("CN9_USERGI", 2)))
				If EMPTY(CN9->CN9_REVISA) .AND. dDataInc > CTOD("04/04/2019")
					MsgStop("Preencha o valor previsto na licita��o","MT110LOK - A T E N � � O !!")
					_lRet := .F. // Quando false o sistema n�o permitir� que o usu�rio prossiga para a proxima linha
				EndIf
			Else
				CTT->(dbSetOrder(1))
				If CTT->(dbSeek(xFilial("CTT")+cCC,.F.))
					dDataInc := CTOD(CTT->(FWLeUserlg("CTT_USERGI", 2)))
					If dDataInc > CTOD("04/04/2019")
						MsgStop("Preencha o valor previsto na licita��o","MT110LOK - A T E N � � O !!")
						_lRet := .F. // Quando false o sistema n�o permitir� que o usu�rio prossiga para a proxima linha
					EndIf
				EndIf
			EndIf	                                                               
		EndIf
		//If Empty( aCols[n][_nPosCc] ) // Se o campo Centro de Custo estiver vazio
		//	MsgStop("Preencha o campo Centro de Custo"	,"A T E N � � O !!")
		//	_lRet := .F. // Quando false o sistema n�o permitir� que o usu�rio prossiga para a proxima linha
		//EndIf
	EndIf
Return _lRet
