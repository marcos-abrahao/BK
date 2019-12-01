// Marcos B. Abrah�o - 31/10/14
#include "rwmake.ch"     

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � VALIMP   � Autor � Marcos B. Abrahao     � Data � 31/10/14 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Este Rdmake compoe as Rotinas de geracao do SISPAG, arquivo���
���          � 341REM.PAG e 341RET.PAG                                    ���
���          � Calcula o layout para o Valor no Codigo de Barras          ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Exclusivo para Kloeckner/BK                                ���
���          �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/

User Function VALIMP()    

Local _cValCamp

If     Len(Alltrim(SE2->E2_CODBAR)) == 44             // Alterado de 44 p/ 47. Comtempla o Fator de Vencimento. Por Alexandre em 20.10.00 
       _cValCamp := Substr(SE2->E2_CODBAR,10,10)
ElseIf Len(Alltrim(SE2->E2_CODBAR)) == 47
       _cValCamp := Substr(SE2->E2_CODBAR,38,10)
ElseIf Len(Alltrim(SE2->E2_CODBAR)) >= 36 .and. Len(Alltrim(SE2->E2_CODBAR)) <= 43
       _cValCamp := Alltrim(Substr(SE2->E2_CODBAR,34,10))
       //MSGBOX("Valor "+_cValCamp)
Else
       _cValCamp := "0000000000"                 
EndIf	

//_cValCamp := Strzero(Val(cCampo),14)
  _cValCamp := Strzero(Val(_cValCamp),10) // Alterado em 18/10/00

Return(_cValCamp) 
