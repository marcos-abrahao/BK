#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �BKCOMF01   �Autor  �Adilson do Prado    � Data �  06/02/13  ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao para Gerar descri��o completa do Produto             ���
���          �SZI->ZI_XXDESC+SB1->B1_DESC                                 ���
�������������������������������������������������������������������������͹��
���Uso       �BK                                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/ 

User Function BKCOMF01(cCodProd)
Local cDescProd  := ""
Local cCodSubPro := ""
Local cDesSubPro := ""

u_LogPrw("BKCOMF01")

cDescProd := ALLTRIM(Posicione("SB1",1,xFilial("SB1")+cCodProd,"B1_DESC"))
cCodSubPro := Posicione("SB1",1,xFilial("SB1")+cCodProd,"B1_XXSGRP")
cDesSubPro := ALLTRIM(Posicione("SZI",1,xFilial("SZI")+cCodSubPro,"ZI_DESC"))

IF ALLTRIM(cDescProd) $ ALLTRIM(cDesSubPro)
	cDescProd  := ALLTRIM(cDescProd)
ELSE
	cDescProd  := ALLTRIM(cDesSubPro+" "+cDescProd)
ENDIF

Return(cDescProd)
