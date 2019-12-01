#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTA130C8 �Autor  �Adilson do Prao          Data �  06/02/13 ���
�������������������������������������������������������������������������͹��
��� Desc.     � LOCALIZA��O : Function  A130Grava - Fun��o principal	  ���
��� do Programa que efetua a Grava��o das Cotac�es .					  ���
��� EM QUE PONTO : APOS GRAVACAO NO SC8Executado apos gravacao de		  ���
���  cada item no SC8. A Tabela se encontra posicionada.   				  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � BK                                                         ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MTA130C8() 
Local aArea      := GetArea()

	SC8->(RecLock("SC8",.F.))
	SC8->C8_XXDESCP  := Posicione("SB1",1,Xfilial("SB1")+SC8->C8_PRODUTO,"B1_DESC")  //U_BKCOMF01(SC8->C8_PRODUTO)
	SC8->C8_XXNFOR	:= Posicione("SA2",1,Xfilial("SA2")+SC8->C8_FORNECE+SC8->C8_LOJA,"A2_NOME")
	SC8->(MSUNLOCK())

RestArea(aArea)

Return Nil
