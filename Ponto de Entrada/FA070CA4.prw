#include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa �FA070CA4 �Autor � Marcos B. Abrah�o � Data � 02/06/15        ���
�������������������������������������������������������������������������͹��
���Desc. � Impede que exclusoes de baixa sejam feitas em data             ���
���      � diferente da baixa, para nao causar erros na contabilidade.    ���
�������������������������������������������������������������������������͹��
���Uso � Kloeckner                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FA070CA4()
Local lRet := .T.
Local nOpc := 0

If dDatabase <> SE5->E5_DATA
	nOpc := u_AvisoLog("FA070CA4","Aten��o � data",;
	               "A data do estorno est� diferente da data base do sistema."+Chr(13)+Chr(10)+;
	               "Antes de cancelar/excluir a baixa, favor alterar a data base do sistema para "+Dtoc(SE5->E5_DATA)+".",;
	               {"Sair","Estornar"}, 2 )
	lRet := (nOpc == 2)
EndIf

Return lRet
