#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT150FIX �Autor  �Adilso do Prado   � Data �  06/02/13     ���
�������������������������������������������������������������������������͹��
���Desc.     � LOCALIZA��O : Function MATA150() - Respons�vel pela		  ���
��� atualiza��o manual das cota��es de compra.EM QUE PONTO : Ponto de	  ���
��� entrada para manipular a ordem dos campos do array aFixe.			  ���
�������������������������������������������������������������������������͹��
���Uso       � BK                                                         ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

USER FUNCTION MT150FIX()
Local afixe 		:=	{{"Numero","C8_NUM    " },;			//"Numero"
						{ "Fornecedor","C8_FORNECE" },;		//"Fornecedor"
						{ "Loja","C8_LOJA   " },;			//"Loja"
						{ "Nome Fornec.","C8_FORNOME" },;	//"Loja"
						{ "Proposta","C8_NUMPRO" },;		//"Proposta"
						{ "Cod.Produto","C8_PRODUTO" },;	//"Cod.Produto"
						{ "Desc.Produto","C8_DESCRI" },;	//"Desc.Produto"
						{ "Pre�o","C8_PRECO" },;			//"Preco"
						{ "Validade ","C8_VALIDA " }}		//"Validade "
RETURN aFixe
