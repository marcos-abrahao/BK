#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A103CND2  �Autor  �Marcos B Abrahao    � Data �  04/11/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada para nao permitir vencimentos com data    ���
���          � anterior a 2 dias uteis                                    ���
���          � Alterado para n�o aceitar data inferior ao prox dia util   ���
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

User Function A103CND2()
Local nV
Local dDtUtil

dDtUtil := DataValida(dDatabase,.T.)
//dDtUtil := DataValida(dDatabase+1,.T.)
//dDtUtil := DataValida(dDtUtil+1,.T.)
FOR nV := 1 TO LEN(PARAMIXB)
    IF PARAMIXB[nV,1] < dDtUtil
       PARAMIXB[nV,1] := dDtUtil
    ENDIF
NEXT

Return(PARAMIXB)


User Function BkVencto(dVenBk)
Local dDtUtil,lRet := .T.

IF nModulo = 2
	dDtUtil := DataValida(dDatabase,.T.)
	//dDtUtil := DataValida(dDatabase+1,.T.)
	//dDtUtil := DataValida(dDtUtil+1,.T.)
	IF dVenBk < dDtUtil
	   lRet := .F.
	ENDIF
ENDIF

RETURN lRet
