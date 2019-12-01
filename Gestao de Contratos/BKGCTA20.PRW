#include "totvs.ch"
#include "protheus.ch"
#include "TopConn.ch"
#INCLUDE "rwmake.ch"
 
                                       
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � BKGCTA20 � Autor � Adilson do Prado          Data �31/05/16���
�������������������������������������������������������������������������͹��
���Descricao � Valida Vencimento do Contrato Chamada do Centro de Custo   ���
���          � Contratos                                                  ���
�������������������������������������������������������������������������͹��
���Uso       � BK                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function BKGCTA20(cContrato)
Local lRet := .T.
Local cVig := ""
Local aArea      := GetArea()

Conout("BKGCTA20: "+funname())
IF  ALLTRIM(funname()) == 'RPC'   // GERA APORT BK
	RestArea(aArea)
	Return lRet
ENDIF

cVig := U_Vig2Contrat(cContrato,Date())
IF !EMPTY(cVig)
   IF !MsgYesNo("Contrato "+cContrato+cVig+"  !!    Confirma Inclus�o deste C.Custo ??","Aten��o")
		lRet := .F.
   ENDIF
ENDIF

RestArea(aArea)

Return lRet
