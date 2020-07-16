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
IF !EMPTY(SC5->C5_MDCONTR)
   SC9->C9_XXORPED := "C" // A=Avulo;C=Contrato;2=Serie2

   //Gravar o numero do contrato na libera��o dos pedidos de venda
   //SC9->C9_XXCONTR := SC5->C5_MDCONTR
   //SC9->C9_XXDESC  := Posicione("CTT",1,xFilial("CTT")+SC5->C5_MDCONTR,"CTT_DESC01")
ELSE
   SC9->C9_XXORPED := "A" // A=Avulo;C=Contrato;2=Serie2
ENDIF

SC9->(MsUnlock())


Return Nil
