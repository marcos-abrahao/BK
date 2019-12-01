// Marcos B. Abrah�o - 31/10/14
#include "rwmake.ch"        

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � DIGVER   � Autor � Marcos B. Abrahao     � Data � 31/10/14 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Este Rdmake compoe as Rotinas de geracao do SISPAG, arquivo���
���          � 341REM.PAG e 341RET.PAG                                    ���
���          � Calcula o layout para o DV do Codigo de Barras             ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Exclusivo para KLOECKNER / BK                              ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/

User Function DIGVER()        

Local _cDigCamp

If     Len(Alltrim(SE2->E2_CODBAR)) == 44        // Alterado de 44 p/ 47. Comtempla o Fator de Vencimento. Por Alexandre em 20.10.00 
         _cDigCamp := Substr(SE2->E2_CODBAR,5,1)
ElseIf Len(Alltrim(SE2->E2_CODBAR)) == 47
        _cDigCamp := Substr(SE2->E2_CODBAR,33,1)
ElseIf Len(Alltrim(SE2->E2_CODBAR)) >= 36 .and. Len(Alltrim(SE2->E2_CODBAR)) <= 43
        _cDigCamp := Substr(SE2->E2_CODBAR,33,1)
Else
        _cDigCamp := "0"
Endif

Return(_cDigCamp)       
