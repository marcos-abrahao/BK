#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT110VLD   �Autor  �Adilso do Prado     � Data �  07/05/13 ���
�������������������������������������������������������������������������͹��
���Ponto de Entrada: Valida usu�rio para altera��o e Exclus�o Solicita��o ���
���de Compras   														  ���
�������������������������������������������������������������������������͹��
���Uso       � BK                                                         ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function MT110VLD()
Local ExpN1     := Paramixb[1]
Local lValido   := .T.
Local lGCOM		:= .F. 

dbSelectArea("SAJ")
dbSetOrder(2)
IF dbSeek(xFilial("SAJ")+__cUserId,.F.)
	lGCOM := .T.
EndIf


IF ExpN1== 4
	IF SC1->C1_USER <> __cUserId  .AND.  SC1->C1_USER <> '' .AND. __cUserId <> "000000" .AND. !lGCOM
		MSGSTOP('Solicita��o n�o pode ser Alterada por outro usu�rio')
		lValido := .F.        
	EndIf
ENDIF

IF ExpN1 == 6
	IF SC1->C1_USER <> __cUserId  .AND.  SC1->C1_USER <> '' .AND. __cUserId <> "000000"
		MSGSTOP('Solicita��o n�o pode ser Excluida por outro usu�rio')
		lValido := .F.        
	EndIf
ENDIF

Return(lValido)
