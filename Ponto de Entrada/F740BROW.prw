#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � F740BROW �Autor  �Adilson do Prado    � Data �  15/01/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada para criar op��es na tela de Func�es      ���
���          � Contas a Receber                                           ���
�������������������������������������������������������������������������͹��
���Uso       � BK                                                         ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function F740BROW() 
           
AADD( aRotina, {OemToAnsi("Baixa Portal Transpar�ncia "+FWEmpName(cEmpAnt)),   "U_BKFINA16", 0, 4 } )
AADD( aRotina, {OemToAnsi("Baixa Portal Petrobras "+FWEmpName(cEmpAnt)),   "U_BKFINA23", 0, 4 } )
AADD( aRotina, {OemToAnsi("Alterar data de Antecipa��o "+FWEmpName(cEmpAnt)),   "U_BKFINA24", 0, 4 } )
AADD( aRotina, {OemToAnsi("Incluir NDC - Nota de Debito "+FWEmpName(cEmpAnt)),  "U_FN40INCMNU", 0, 4 } )
AADD( aRotina, {OemToAnsi("Imprimir NDC - Nota de Debito "+FWEmpName(cEmpAnt)),  "U_BKFINR24", 0, 4 } )
AADD( aRotina, {OemToAnsi("Anexar Arq. "+FWEmpName(cEmpAnt)),   "U_BKANXA01('1','SE1')", 0, 4 } )
AADD( aRotina, {OemToAnsi("Abrir Anexos "+FWEmpName(cEmpAnt)),  "U_BKANXA02('1','SE1')", 0, 4 } )

Return Nil
