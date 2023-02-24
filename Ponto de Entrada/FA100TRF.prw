#include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa �FA100TRF �Autor � Marcos B. Abrah�o � Data � 14/06/15        ���
�������������������������������������������������������������������������͹��
���Desc. � Impede que exclusoes de mov bancario sejam feitas em data      ���
���      � diferente da original, para nao causar erros na contabilidade. ���
�������������������������������������������������������������������������͹��
���Uso � Kloeckner                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FA100TRF()
Local lRet := .T.
Local nOpc := 0
Local lEstorno  := ParamIXB[15]
Local ddtdisp   := ParamIXB[16]
//Local ddtcred   := ParamIXB[17]

If lEstorno
	//If ddtcred <> ddtdisp
	If dDatabase <> ddtdisp
		nOpc := u_AvisoLog("FA100TRF","Aten��o � data",;
			               "A data do estorno est� diferente da data base do sistema."+Chr(13)+Chr(10)+;
	        		       "Antes de cancelar/excluir a baixa, favor alterar a data base do sistema para "+Dtoc(SE5->E5_DATA)+".",;
	               		{"Sair","Estornar"}, 2 )
		lRet := (nOpc == 2)
	EndIf
EndIf

Return lRet
