#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M410ALOK  �Autor  �Ewerton C Tomaz     � Data �  09/12/03   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada antes da exclusao do pedido pelo fat.     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������͹��
���Data      �Analista/Altera��es                                         ���
�������������������������������������������������������������������������ͼ��
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
M410ALOK Revis�o: 01/01/2002
Sintaxe M410ALOK ( < UPAR > ) --> URET
Par�metros
Argumento	Tipo	Descri��o
UPAR 	 (Qualquer)	Nenhum
Retorno
Tipo	    Descri��o
(Qualquer)	Variavel logica, sendo:.T. Prossegue alteracao do Pedido de Venda
.F. Impede alteracao no pedido de venda
Descri��o
EXECUTA ANTES DE ALTERAR PEDIDO VENDA
Executado antes de iniciar a alteracao do pedido de venda
Grupos Relacionados
Principal / Sistemas / Pontos de Entrada / Vendas e Fiscal / SIGAFAT / MATA410 */

User Function M410ALOK()
Local _lRet := .T.

If !Empty(SC5->C5_NOTA) .and. ALTERA
	MsgBox("Nota Fiscal j� gerada pedido n�o pode ser Alterado!","TI - BK","ALERT")
	_lRet := .F.
Else
	If !Empty(SC5->C5_MDCONTR) .and. ALTERA
		MsgBox("Pedido de Origem na Gest�o de Contratos nao pode ser Alterado no Faturamento!","TI - BK","ALERT")
		_lRet := .F.
	Endif
Endif

Return(_lRet)

