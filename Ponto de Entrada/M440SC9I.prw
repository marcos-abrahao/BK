#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} M440SC9I
BK - Ponto de Entrada - grava��o de dados na libera��o do pedido de venda 
@Return
@author  Marcos Bispo Abrah�o
@since 15/07/20
@version P12
/*/
User Function M440SC9I()

RecLock("SC9",.F.)
IF EMPTY(SC5->C5_XXTPNF)
   SC9->C9_XXORPED := "N"
ELSE
   SC9->C9_XXORPED := SC5->C5_XXTPNF // N=Normal;B=Balc�o;F=Filial
ENDIF
SC9->C9_XXRM := SC5->C5_XXRM

SC9->(MsUnlock())


Return Nil
