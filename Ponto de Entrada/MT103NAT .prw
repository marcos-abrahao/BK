/*/{Protheus.doc} MT103NAT 
    Ponto de entrada para validar Natureza no Documento de Entrada
    Criado para bloquear naturezas que n�o podem ser alteradas na BK
    @type  Function
    @author Marcos Bispo Abrah�o
    @since 26/09/2021
    @version 12.1.25
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function MT103NAT
Local lRet := .T.
Local cNat := PARAMIXB

If SA2->A2_XXBLNAT = "S"
    If cNat <> SA2->A2_NATUREZ
        u_MsgLog("MT103NAT","Natureza n�o pode ser alterada: "+TRIM(SA2->A2_XXOBNAT),"E")
        lRet := .F.
    EndIf
EndIf

Return lRet
