#Include "Protheus.ch"
 
/*/{Protheus.doc} MDIOk
MDIOk - P.E. ao abrir o m�dulo SIGAMDI
@Return
@author Marcos Bispo Abrah�o
@since 19/08/21
@version P12.1.33
/*/

User Function MDIOk()
    
Local cToken
//Local dUltLog := FWUsrUltLog(__cUserId)[1] // Data do Ultimo login  

If nModulo = 5 .OR. nModulo = 69
	//              Admin /Teste /Xavier/Diego.o/Fabia/Vanderle/Bruno/Nelson/Jo�o Cordeiro/Marcelo Cavalari Alves
	If __cUserId $ "000000/000038/000012/000016/000023/000056/000153/000165/000170/00252" 
    	If u_MsgLog("MDIOk","Deseja abrir a Libera��o de Pedidos de Venda web?","Y")
			cToken  := u_BKEnCode()
			ShellExecute("open", u_BkRest()+"/RestLibPV/v2?userlib="+cToken, "", "", 1)
		EndIf
	EndIf
ElseIf nModulo = 6 .OR. nModulo = 2  .OR. nModulo = 9
	If u_IsSuperior(__cUserId) .OR. u_InGrupo(__cUserId,"000031") .OR. u_IsStaf(__cUserId) .OR. (__cUserId == "000000")
		If u_MsgLog("MDIOk","Deseja abrir a Libera��o de Docs de Entrada Eeb?","Y")
			cToken  := u_BKEnCode()
			ShellExecute("open", u_BkRest()+"/RestLibPN/v2?userlib="+cToken, "", "", 1)
		EndIf
	EndIf
EndIf

Return .T.
