#include "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FA050UPD �Autor  �Marcos B. Abrahao   � Data �  02/10/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada para evitar que titulos incluidos pelo    ���
���          � liquidos BK sejam excluidos por esta rotina                ���
�������������������������������������������������������������������������͹��
���Uso       � BK                                                         ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function FA050UPD() 
Local lRet := .T.

If !lF050Auto
	IF !EMPTY(SE2->E2_XXCTRID)  .AND. (_Opc == 4 .OR. _Opc == 5)
	    IF __cUserId <> "000000"
	    	//__cUserId <> "000012" .AND. 
	    	MsgStop("Este titulo foi gerado pelos Liquidos BK, utilize a rotina adequada", "Aten��o")
	    	lRet := .F.
	    ELSE
	    	If Aviso( "Atencao", "Este titulo foi gerado pelos Liquidos BK. Excluir Titulo?",{"Sim","Nao"} ) <> 1
	    		lRet := .F.
	    	ENDIF
	    ENDIF
	ENDIF
EndIf

Return lRet

