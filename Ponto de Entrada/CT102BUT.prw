#include "protheus.ch"



User Function CT102BUT()
Local aBotao := {}
/*
O Layout do array aBotao deve sempre respeitar os itens abaixo:

[n][1]=T�tulo da rotina que ser� exibido no menu
[n][2]=Fun��o que ser� executada
[n][3]=Par�metro reservado, deve ser sempre 0 ( zero )
[n][4]=N�mero da opera��o que a fun��o vai executar sendo :

1=Pesquisa
2=Visualiza��o
3=Inclus�o
4=Altera��o
5=Exclus�o
*/

aAdd(aBotao, {'Filtro BK',"U_BKCTBC01", 0 , 3 })

Return(aBotao)

