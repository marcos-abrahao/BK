#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �KK00001   �Autor  � Gilberto Sales     � Data � 29/04/2008  ���
�������������������������������������������������������������������������͹��
���Descricao � Funcao para rodar uma Query e retornar como Array          ���
�������������������������������������������������������������������������͹��
���Parametros� cQuery - Query SQL a ser executado                         ���
���          � cTipo  - A=Array (Default) / V=Variavel (Par.N.Obrigat.)   ���
�������������������������������������������������������������������������͹��
���Retorno   � aTrb   - Array com o conteudo da Query                     ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������͹��
���Data      �Analista/Altera��es                                         ���
�������������������������������������������������������������������������͹��
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function KK00001(cQuery,cTipo)    //QryArr(cQuery,cTipo)

Local aEstou := GetArea()

//��������������������������������������������������������������������������ͻ
//� Gravacao do Ambiente Atual e Variaveis para Utilizacao                   �
//�������������������������������������������������������������Silvio Cazelaͼ
Local aRet    := {}
Local aRet1   := {}
Local nRegAtu := 0
Local x       := 0
cTipo := iif(cTipo==NIL,"A","V")

//��������������������������������������������������������������������������ͻ
//� Ajustes e Execucao da Query                                              �
//�������������������������������������������������������������Silvio Cazelaͼ
If SELECT("TRB") > 0 
	dbSelectArea("TRB")
   	dbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TRB"

//��������������������������������������������������������������������������ͻ
//� Montagem do Array para Retorno                                           �
//�������������������������������������������������������������Silvio Cazelaͼ
DbSelectArea("TRB")
aRet1   := Array(fcount())
nRegAtu := 1

While !eof()
	For x:=1 to fcount()
		aRet1[x] := FieldGet(x)
	Next
	AADD(aRet,aclone(aRet1))
	DbSkip()
	nRegAtu += 1
Enddo

//��������������������������������������������������������������������������ͻ
//� Verifica e Ajusta o Tipo de Retorno                                      �
//�������������������������������������������������������������Silvio Cazelaͼ
If cTipo=="V" .and. len(aRet)>0
	aRet := aRet[1,1]
Elseif cTipo=="V"
	aRet := NIL
Endif

//��������������������������������������������������������������������������ͻ
//� Encerra Query e Retorna Ambiente                                         �
//�������������������������������������������������������������Silvio Cazelaͼ
DbSelectArea("TRB")
TRB->(DbCloseArea())

RestArea(aEstou)

Return(aRet)