#Include 'Protheus.ch'

/*/{Protheus.doc} MA103BUT
BK - Ponto de Entrada para adicionar bot�es no EnchoiceBar do Documento de Entrada

@Return
@author Marcos B Abrah�o
@since 31/05/21
@version P12
/*/

User Function MA103BUT()
Local aButtons := {}

If !Inclui
    aadd(aButtons, {'Conhecimento', {|| MsDocument("SF1",SF1->(Recno()),6)}, 'Conhecimento'})
EndIf

Return (aButtons)
