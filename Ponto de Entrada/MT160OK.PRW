#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT160LOK   �Autor  �Adilso do Prado     � Data �  24/04/13 ���
�������������������������������������������������������������������������͹��
���Ponto de Entrada: Ap�s a montagem da dialog da analise de cota��o.     ���
��� � acionado quando o usuario clica no bot�o OK (Ctrl O) confirmando    ���
��� a analise da cota��o, deve ser utilizado para validar se a Analise    ���
��� da cota��o deve continuar 'retorno .T.' ou n�o 'retorno .F.' , ap�s   ���
��� a confirma��o do sistema.    										  ���
�������������������������������������������������������������������������͹��
���Uso       � BK                                                         ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function  MT161OK()

Return .t.

// Desabilitada em 11/11/19
User Function  MT160OK()
Local aPlanilha := PARAMIXB // Array contendo todos os dados da Planilha de Cota��o para valida��o
Local lContinua := .T.
Local aCota := {}


aCota := {}
For IX_ := 1 TO LEN(aPlanilha)
	For IY_ := 1 TO LEN(aPlanilha[IX_])
		IF aPlanilha[IX_][IY_][1] == "XX" 
    		AADD(aCota,aPlanilha[IX_][IY_][2])
  		ENDIF
    NEXT
NEXT

IF LEN(aCota) <> LEN(aPlanilha)
	MSGSTOP("H� cota��o n�o selecionada. Favor refazer analise selecionando um vencedor para cada item da cota��o!!")
	lcontinua := .F.
ENDIF

Return ( lContinua ) 

