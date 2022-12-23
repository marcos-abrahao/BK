/*/{Protheus.doc} BKVlTes
BK - Valida��o TES
@Return
@author Marcos Bispo Abrah�o
@since  27/09/21 
@version P12
/*/

User Function BKVlTes()
Local lRet := .T.

If SA2->A2_TPJ == '3'
    If SF4->F4_CSTPIS == '50'
        u_MsgLog("BKVlTes","N�o utilize TES com cr�dito PIS/COFINS para MEI","E")
        lRet := .F.
    Endif
Endif

Return lRet
