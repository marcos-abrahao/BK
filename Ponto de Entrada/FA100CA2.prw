#include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa �FA100CA2 �Autor � Marcos B. Abrah�o � Data � 14/06/15        ���
�������������������������������������������������������������������������͹��
���Desc. � Impede que exclusoes de mov bancario ejam feitas em data       ���
���      � diferente da original, para nao causar erros na contabilidade. ���
�������������������������������������������������������������������������͹��
���Uso � Kloeckner                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FA100CA2()
Local lRet := .T.
Local nOpc := 0

If dDatabase <> SE5->E5_DATA
	nOpc := u_AvisoLog("FA100CA2","Aten��o � data",;
	               "A data do estorno est� diferente da data base do sistema."+Chr(13)+Chr(10)+;
	               "Antes de cancelar/excluir a baixa, favor alterar a data base do sistema para "+Dtoc(SE5->E5_DATA)+".",;
	               {"Sair","Estornar"}, 2 )
	lRet := (nOpc == 2)
EndIf

Return lRet
