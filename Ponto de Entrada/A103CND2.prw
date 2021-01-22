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
// Valida��o da condi�ao de pgto na tela de doc de entrada
User Function A103CND2()
Local nV
Local dDtUtil

dDtUtil := DataValida(dDatabase,.T.)
//dDtUtil := DataValida(dDatabase+1,.T.)
//dDtUtil := DataValida(dDtUtil+1,.T.)
FOR nV := 1 TO LEN(PARAMIXB)
	If LEN(PARAMIXB) == 1 .AND. cCondicao == "999"
		If !Empty(SF1->F1_XXPVPGT)
			PARAMIXB[nV,1] := SF1->F1_XXPVPGT
		EndIf
	EndIf

    IF PARAMIXB[nV,1] < dDtUtil
       PARAMIXB[nV,1] := dDtUtil
    ENDIF
NEXT

Return(PARAMIXB)


// Valida��o da altera��o data de vencimento na tela de Doc. de Sa�da - duplicatas
User Function BkVencto(dVenBk)
Local dDtUtil,lRet := .T.

IF nModulo = 2
	dDtUtil := DataValida(dDatabase,.T.)
	//dDtUtil := DataValida(dDatabase+1,.T.)
	//dDtUtil := DataValida(dDtUtil+1,.T.)
	If Len(aCols) == 1 .AND. cCondicao == "999"
		If !Empty(SF1->F1_XXPVPGT)
			aCols[1,2] := SF1->F1_XXPVPGT
		EndIf
	EndIf
	IF dVenBk < dDtUtil
	   lRet := .F.
	ENDIF
ENDIF

RETURN lRet
