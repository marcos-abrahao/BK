
#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} FA100TRF
    Ponto de entrada: Impede que exclusoes de transfer�ncias banc�rias sejam feitas em data diferente da original, para nao causar erros na contabilidade.
    @type  Ponto de Entrada - Movimentos banc�rios FINA100 - Valida estorno da transferencia
    @author Marcos B. Abrah�o
    @since 14/06/2015
    @version Kloeckner
/*/

User Function FA100VET()
Local lRet := .T.
Local nOpc := 0

If dDatabase <> SE5->E5_DATA
	nOpc := u_AvisoLog("FA100VET","Aten��o � data",;
	               "A data do estorno da transferencia est� diferente da data base do sistema."+Chr(13)+Chr(10)+;
	               "Antes de cancelar/excluir a baixa, favor alterar a data base do sistema para "+Dtoc(SE5->E5_DATA)+".",;
	               {"Sair"}, 1 )
//	               {"Sair","Estornar"}, 2 )
	lRet := (nOpc == 2)
EndIf

Return lRet
