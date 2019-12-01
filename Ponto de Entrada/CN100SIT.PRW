#include "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CN100SIT  �Autor  �Gilberto Sales      � Data �  04/09/08   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada valida��o altera��o situa��o do Contrato  ���
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
*/
User Function CN100SIT(cNewSituc)
Local aAreas  := GetArea()

dbSelectArea("CN9")
dbSetOrder(1)
If CN9->CN9_FLGCAU == '1' .and. CN9->CN9_SITUAC == '08'
	dbSelectArea("CN8")
	dbSetOrder(2)
	If dbSeek(xFilial("CN8")+CN9->(CN9_NUMERO+CN9_REVISA))
		If Empty(CN8->CN8_DTBX)
			dbSelectArea("CN9")
			dbSetOrder(1)
			//Retorna  a situa��o para Sol. Finaliza��o
			RecLock("CN9",.F.)
			CN9->CN9_SITUAC := '07'
			msUnlock()
			Aviso("CN100SIT",OemtoAnsi("Contrato com Cau��o em Aberto, Situacao n�o pode ser alterada!"),{"Ok"})
		EndIf
	Endif
Endif


dbSelectArea("CN9")
dbSetOrder(1)
If CN9->CN9_SITUAC == '05'
	dbSelectArea("SZG")
	dbSetOrder(1)
	IF !dbSeek(xFilial("SZG")+CN9->CN9_NUMERO,.F.) //+CN9->CN9_REVISA,.F.)
   		MsgStop(OemtoAnsi("Contrato n�o possui Ficha de Proje��o Financeira. Situacao n�o pode ser alterada!"),"Aten��o")
		dbSelectArea("CN9")
		dbSetOrder(1)
		//Retorna  a situa��o para Sol. Finaliza��o
		RecLock("CN9",.F.)
		CN9->CN9_SITUAC := '02'
		msUnlock()
	ENDIF
Endif

RestArea(aAreas)

Return()