#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA440SC9I �Autor  �Marcos B Abrah�o    � Data �  01/06/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada para gravar o centro de custo do contrato ���
���          � na grava��o da libera��o do pedido de venda                ���
�������������������������������������������������������������������������͹��
���Uso       � BK                                                         ���
�������������������������������������������������������������������������͹��
���Data      �Analista/Altera��es                                         ���
�������������������������������������������������������������������������ͼ��
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

/*
User Function M440SC9I()

IF !EMPTY(SC5->C5_MDCONTR)
// Gravar o numero do contrato na libera��o dos pedidos de venda
   RecLock("SC9",.F.)
   SC9->C9_XXCONTR := SC5->C5_MDCONTR
   SC9->C9_XXDESC  := Posicione("CTT",1,xFilial("CTT")+SC5->C5_MDCONTR,"CTT_DESC01")
   MsUnlock()
ENDIF

Return Nil


User Function MTA410T()

IF !EMPTY(SC5->C5_MDCONTR)
// Gravar o nome do contrato na libera��o dos pedidos de venda
   RecLock("SC5",.F.)
   SC5->C5_XXDESC  := Posicione("CTT",1,xFilial("CTT")+SC5->C5_MDCONTR,"CTT_DESC01")
   MsUnlock()
ENDIF

Return Nil
*/


