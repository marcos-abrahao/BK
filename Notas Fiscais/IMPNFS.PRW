#include "rwmake.ch"

// -------------------------------------------------------------------------------------------
// A T E N C A O 
// Esta rotina � para impressao de Notas Fiscais 
// -------------------------------------------------------------------------------------------

/*/
�������������������������������������������������������������������
�������������������������������������������������������������������
���������������������������������������������������������������Ŀ��
���Fun��o    �IMPNFS � Microsiga				  �Data�18/07/07���
���������������������������������������������������������������Ĵ��
���Descri��o � Chamada do fonte de emissao de nota fiscal.      ���
���������������������������������������������������������������Ĵ��
��� Uso      � PETECH - PROTHEUS8					            ���
����������������������������������������������������������������ٱ�
�������������������������������������������������������������������
�������������������������������������������������������������������
�����������������������������������������������������������������Ŀ
� Emissao de NF de Saida :                                        �
� . selecao por serie e numero de N.F.                            �
� . verificacao de filial                                         �
� . posicionamento na proxima folha do formulario continuo        �
� . consideracoes p/ diversos pedidos,aliquotas de icms, vend.    �
� . total de volumes somados pelos totais de volumes dos PV       �
� . mensagem padrao com varias linhas no arquivo SZZ              �
� .    deve seguir padrao cod=xxy   xx=cod.mens. / y=linha msg    �
�������������������������������������������������������������������
/*/
User Function IMPNFS()

//������������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                             �
//� mv_par01             // De Nota                                  �
//� mv_par02             // Ate a Nota                               �
//� mv_par03             // Serie                                    �
//� mv_par04             // Tipo - 1-Entrada / 2-Saida               �
//� mv_par05             // Fornecedor                               �
//� mv_par06             // Loja                                     �	
//��������������������������������������������������������������������

U_PRTNFBK()

/*
cPerg      := "IMPNFS"
ValidPerg()
      
If Pergunte(cPerg,.T.)
	If mv_par04 == 1       // Imprime nota fiscal de entrada
		//U_SCRENF(mv_par01,mv_par02,mv_par03,mv_par04,mv_par05,mv_par06,cPerg)
	ElseIf mv_par04 == 2   //Imprime nota fiscal de saida
		//U_SCRSNF(mv_par01,mv_par02,mv_par03,mv_par04,mv_par05,mv_par06,cPerg)
	ElseIf mv_par04 == 3   // NF de Servi�os
		U_SCRNFS(mv_par01,mv_par02,mv_par03,mv_par04,mv_par05,mv_par06,cPerg)
	EndIf	
EndIf
*/
                                                             
Return


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �VALIDPERG � Autor � AP7 IDE            � Data �  15/08/2001 ���
�������������������������������������������������������������������������͹��
���Descri��o � Verifica a existencia das perguntas criando-as caso seja   ���
���          � necessario (caso nao existam).                             ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
/*
Static Function ValidPerg()

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)


// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{cPerg,"01","Da N.Fiscal " ,"Da N.Fiscal " ,"Da N.Fiscal " ,"mv_ch1","C",09,0,0,"G",""        ,"mv_par01","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Ate N.Fiscal" ,"Ate N.Fiscal" ,"Ate N.Fiscal" ,"mv_ch2","C",09,0,0,"G",""        ,"mv_par02","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Da Serie    " ,"da Serie    " ,"Da Serie    " ,"mv_ch3","C",03,0,0,"G",""        ,"mv_par03","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Tipo   "      ,"Tipo   "      ,"Tipo        " ,"mv_ch4","N",01,0,0,"C",""        ,"mv_par04","Entrada","Entrada","Entrada","","","Saida","Saida","Saida","","Servico-SP","Servico-SP","Servico-SP","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Fornecedor  " ,"Fornecedor  " ,"Fornecedor   " ,"mv_ch5","C",06,0,0,"G",""        ,"mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SA2"})
aAdd(aRegs,{cPerg,"06","Loja        " ,"Loja        " ,"Loja         " ,"mv_ch6","C",02,0,0,"G",""        ,"mv_par06","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)

Return
*/

