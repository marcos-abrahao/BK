#include "rwmake.ch"

/*/{Protheus.doc} MT140CAB
BK - Ponto de entrada que permite o preenchimento autom�tico dos dados do cabe�alho 
     da pre-nota e define se continua a rotina
     Solicitado por Xavier
@Return
@author Marcos Bispo Abrah�o
@since 23/08/2022
@version P12
/*/

User Function MT140CAB()
Local lRet := .T.
Local cMsg := ""

If __cUserId <> "000000" .AND. __cUserId <> "000012"
    If SUBSTR(TIME(),1,2) > '18' .OR. SUBSTR(TIME(),1,2) < '07'
        cMsg := "N�o � permitido incluir pr�-notas entre 18h e 7h"
        u_LogPrw("MT140CAB",cMsg)
        MsgStop(cMsg,"MT140CAB")
        lRet := .F.
    EndIf
EndIf

Return lRet


