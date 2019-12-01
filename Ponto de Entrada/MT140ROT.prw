#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT140ROT  �Autor  �Marcos B Abrahao    � Data �  24/11/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada para criar bot�o conhecimento na pre-nota ���
�������������������������������������������������������������������������͹��
���Uso       � BK                                                         ���
�������������������������������������������������������������������������͹��
���Data      �Analista/Altera��es                                         ���
�������������������������������������������������������������������������ͼ��
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT140ROT()
AADD( aRotina, {OemToAnsi("Conhecimento "+ALLTRIM(SM0->M0_NOME)), "U_MT140DOCBK", 0, 4 } )
AADD( aRotina, {OemToAnsi("Benef�cios  "+ALLTRIM(SM0->M0_NOME)), "U_BKCOMA03", 0, 4 } )
Return Nil


User function MT140DOCBK
Local _nReg
Private cCadastro := "Teste msDocument"
Dbselectarea("SF1")
Dbsetorder(1)
_nReg:=Recno()
msdocument("SF1",_nReg,6)
Return
