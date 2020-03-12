#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao: Rateia        Marcos Bispo / Adilson Prado - RKA Data �14/02/14���
�������������������������������������������������������������������������͹��
���Descricao � 	Fun��o Generica para rateio de valores conforme           ���
��� 			parametro informado 					                  ���
�������������������������������������������������������������������������͹��
���Uso       � 	BK Consultoria                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
         
/*/

USER FUNCTION Rateia(aRTot,nVal)
Local aRat:= {}
Local nTot:= 0
Local nRes:= 0
Local nTot1 := 0
Local IX_ := 0

FOR IX_ := 1 TO LEN(aRTot)
	nTot += aRTot[IX_,2]
Next

FOR IX_ := 1 TO LEN(aRTot)
	nRes := ROUND( (aRTot[IX_,2] * 100 / nTot ) * nVal / 100,2)
	AADD(aRAT, {aRTot[IX_,1],nRes})
	nTot1 += nRes
Next

Return aRat