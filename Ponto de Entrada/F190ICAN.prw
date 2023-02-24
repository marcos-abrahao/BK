#include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa �F190ICAN �Autor � Marcos B. Abrah�o � Data � 08/09/15        ���
�������������������������������������������������������������������������͹��
���Desc. � Impede cancelamentos de cheques      sejam feitos em data      ���
���      � diferente da original, para nao causar erros na contabilidade. ���
�������������������������������������������������������������������������͹��
���Uso � Kloeckner                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function F190ICAN()
Local lRet := .T.
Local nOpc := 0

If dDatabase <> SEF->EF_DATA
	nOpc := u_AvisoLog("F190ICAN","Aten��o � data",;
	               "A data do estorno do cheque est� diferente da data base do sistema."+Chr(13)+Chr(10)+;
	               "Antes de cancelar o cheque, altere a data base do sistema para "+Dtoc(SEF->EF_DATA)+".",;
	               {"Sair","Estornar"}, 2 )
	lRet := (nOpc == 2)
EndIf

Return lRet
