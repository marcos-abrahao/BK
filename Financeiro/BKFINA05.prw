#Include "Protheus.ch"
 
/*/{Protheus.doc} BKFINA05
BKFINA05 - Abrir tela REST - Titulos a Pagar
@Return
@author Marcos Bispo Abrah�o
@since 24/08/23
@version P12
/*/

User Function BKFINA05()
    
Local cToken  := u_BKEnCode()

If u_MsgLog("BKFINA05","Deseja abrir os T�tulos a Pagar Web?","Y")
	ShellExecute("open", u_BkRest()+'/RestTitCP/v2?empresa='+cEmpAnt+'&vencreal='+DTOS(DATAVALIDA(dDataBase+1))+'&userlib='+cToken, "", "", 1)
EndIf

Return .T.
