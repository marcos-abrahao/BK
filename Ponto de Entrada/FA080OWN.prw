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
Local nOpc := 0

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

// Impede que exclusoes de baixa sejam feitas em data diferente da baixa, para nao causar erros na contabilidade. 
If lRet
	If dDatabase <> SE5->E5_DATA
		nOpc := u_AvisoLog("FA080OWN","Aten��o � data",;
					"A data do estorno est� diferente da data base do sistema."+Chr(13)+Chr(10)+;
					"Antes de cancelar/excluir a baixa, favor alterar a data base do sistema para "+Dtoc(SE5->E5_DATA)+".",;
					{"Sair","Estornar"}, 2 )
		lRet := (nOpc == 2)
	EndIf
EndIf

Return lRet

