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

If !u_IsLibDPH("MT140CAB",__cUserId)
    lRet := .F.
EndIf

Return lRet


