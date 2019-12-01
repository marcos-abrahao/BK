#include "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FA080CHK �Autor  �Marcos B. Abrahao   � Data �  25/02/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada para evitar que titulos incluidos pelo    ���
���          � liquidos BK sejam excluidos por esta rotina                ���
�������������������������������������������������������������������������͹��
���Uso       � BK                                                         ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function FA080CHK() 
Local lRet := .T.

If !lF080Auto
	IF TRIM(SE2->E2_XXTIPBK) = "PCT"
	    MsgStop("Este titulo se refere a uma presta��o de contas gerada pelo Liquidos BK, utilize a fun��o compensa��o", "Aten��o")
	    lRet := .F.
	ENDIF

	IF TRIM(SE2->E2_XXTIPBK) = "NDB"
		IF VAL(__CUSERID) == 0 .OR. VAL(__CUSERID) == 12 //.OR. ASCAN(aUser[1,10],cMDiretoria) > 0        
		   lRet := .T.
		ELSE   
		    MsgStop("A baixa deste titulo (tipobk = NDB) somente est� dispon�vel para os administradores do sistema", "Aten��o")
		    lRet := .F.
		ENDIF
	ENDIF

	IF TRIM(SE2->E2_TIPO) = "NDF"
	    MsgInfo("T�tulo a receber", "Aten��o")
	    lRet := .T.
	ENDIF

EndIf

Return lRet

