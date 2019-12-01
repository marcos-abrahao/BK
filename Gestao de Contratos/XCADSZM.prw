#include "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#include "TopConn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �XCADSZM     � Autor � Adilson do Prado   � Data �  22/03/16 ���
�������������������������������������������������������������������������͹��
���Descricao � AXCADASTRO Tabela SZM Dados de reajuste proje��o           ���
���          � Financeira                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � BK                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function XCADSZM
Local 	cFiltra     := ""

Private cCadastro	:= "Cadastro Reajuste Projecao Financeira"
Private cDelFunc	:= ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
Private cString 	:= "SZM"
Private aIndexSz  	:= {}
PRIVATE aFixeFX     := {}
Private bFiltraBrw	:= { || FilBrowse(cString,@aIndexSz,@cFiltra) } 
Private aCores  := {}
Private aRotina	:= {}

AADD(aCores,{"SZM->ZM_STATUS<>'A'","BR_VERDE"})
AADD(aCores,{"SZM->ZM_STATUS=='A'","BR_VERMELHO"})

AADD(aRotina,{"Pesquisa"		,"AxPesquisa",0,1})
AADD(aRotina,{"Visualizar"		,"AxVisual",0,2})
AADD(aRotina,{"Incluir"			,"AxInclui",0,3})
AADD(aRotina,{"Alterar"			,"AxAltera",0,4})
AADD(aRotina,{"Excluir"			,"AxDeleta",0,5})
AADD(aRotina,{"Legenda"			,"U_SZMLEG",0,6})
AADD(aRotina,{"Aplicar Reajuste","U_REAJUSTSZM",0,7})


dbSelectArea(cString)
dbSetOrder(1)
//+------------------------------------------------------------
//| Cria o filtro na MBrowse utilizando a fun��o FilBrowse
//+------------------------------------------------------------
Eval(bFiltraBrw)

dbSelectArea(cString)
dbGoTop()

mBrowse(6,1,22,75,cString,aFixeFX,,,,,aCores)

//+------------------------------------------------
//| Deleta o filtro utilizado na fun��o FilBrowse
//+------------------------------------------------
EndFilBrw(cString,aIndexSz)

Return 


User Function SZMLEG()
Local aCores2 := {}
Local cLegenda := ""

cLegenda	:= "Legenda de Cores"

AADD(aCores2,{"BR_VERDE", "Reajuste n�o aplicado"})
AADD(aCores2,{"BR_VERMELHO", "Reajuste aplicado"})
             		
BrwLegenda(cLegenda,"Status - Reajuste Projecao Financeira",aCores2)

Return 



User Function REAJUSTSZM()

IF SZM->ZM_STATUS == 'A'
   MsgInfo("Reajuste Proje��o Financeira contrato: "+SZM->ZM_CONTRATO+"     j�  aplicado")
   RETURN NIL
ENDIF

IF MsgNoYes("Reajustar Proje��o Financeira contrato: "+SZM->ZM_CONTRATO)

ENDIF

RETURN NIL
