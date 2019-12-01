#include "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FA080CHK �Autor  �Marcos B. Abrahao   � Data �  02/10/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada para evitar que titulos incluidos pelo    ���
���          � liquidos BK sejam excluidos por esta rotina                ���
�������������������������������������������������������������������������͹��
���Uso       � BK                                                         ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function FA080OWN() 
Local lRet := .T.

If !lF080Auto
	IF VAL(__CUSERID) == 0 .OR. VAL(__CUSERID) == 12 //.OR. ASCAN(aUser[1,10],cMDiretoria) > 0        
	   lRet := .T.
	ELSE   
		IF TRIM(SE2->E2_XXTIPBK) = "NDB"
		    MsgStop("O cancelamento titulo tipobk = NDB somente est� dispon�vel para o Administrador do sistema", "Aten��o")
		    lRet := .F.
		ENDIF
	ENDIF
EndIf

Return lRet

