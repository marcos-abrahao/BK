#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �KK00004   �Autor  �Gilberto Sales       � Data �  22/08/08  ���
�������������������������������������������������������������������������͹��
���Desc.     �Tela para gera�ao do codigo do contrato padrao BK           ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������͹��
���Data      �Analista/Altera��es                                         ���
�������������������������������������������������������������������������ͼ��
���  /  /    �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/ 

// Chamado no gatilho do campo CN9_CLIENT

User Function KK00004()

Local cQuery    := ""
Local _xRetorno := ""
Local _aAreas 	:= {}

       
If (ReadVar() == "M->CN9_CLIENT")

	//C�digo do Contrato
	cQuery := " "
	cQuery := "SELECT MAX("+M->CN9_CLIENT+" CASE WHEN LEN(SUBSTRING("+M->CN9_NUMERO+",7,3)) = 1 THEN '00'+CAST(SUBSTRING("+M->CN9_NUMERO+",7,3) AS CHAR(3)) "
	cQuery += " WHEN LEN(SUBSTRING("+M->CN9_NUMERO+",7,3)) = 2 THEN '00'+CAST(SUBSTRING("+M->CN9_NUMERO+",7,3) AS CHAR(3)) "
	cQuery += " ELSE CAST(SUBSTRING(CN9_NUMERO,7,3)AS CHAR(3))  END) + 1 AS NUM "
	cQuery += " FROM " + RetSqlName("CN9")+" "
	cQuery += " WHERE CN9_CLIENT ='"+M->CN9_CLIENT+"' "

	If SELECT("TRB") > 0
		dbSelectArea("TRB")
		dbCloseArea()
	EndIf

	TCQuery cQuery NEW ALIAS "TRB"

	dbSelectArea("TRB")
	_xRetorno := TRB->NUM

EndIf

//Restaura as �reas
RestArea(_aAreas)

Return(_xRetorno)