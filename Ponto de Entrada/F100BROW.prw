#include "protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � F100BROW �Autor  �Marcos B. Abrahao   � Data �  01/08/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada para criar op��es na tela de Func�es      ���
���          � Contas a Pagar                                             ���
�������������������������������������������������������������������������͹��
���Uso       � BK                                                         ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function F100BROW() 
//Local aRotY

IF __cUserId $ "000000/000012" // Administrador / Xavier
	AADD( aRotina, {OemToAnsi("Alt. dados cont�beis"), "U_BKFIN100", 0, 4 } )
ENDIF
//AADD( aRotina, {OemToAnsi("Impress�o Mov. Banc�rio"), "U_KFINR08", 0, 4 } )

Return Nil



// Altera��o de Dados Cont�beis do Movimento Banc�rio - Marcos - 18/08/16
User Function BKFIN100()
Local aArea := Getarea()             

Local oOk
Local oNo
Local oDlg
Local aButtons := {}
Local lOk      := .F.
Local cTitulo2 := "BKFINA100 - Altera��o dados Cont�beis - "+SE5->E5_PREFIXO+SE5->E5_NUMERO+" v18/08/16a"

Local cHistor  := SE5->E5_HISTOR

PRIVATE E5_DEBITO  := SE5->E5_DEBITO
PRIVATE E5_CCD     := SE5->E5_CCD
PRIVATE E5_CREDITO := SE5->E5_CREDITO
PRIVATE E5_CCC     := SE5->E5_CCC

oOk := LoadBitmap( GetResources(), "LBTIK" )
oNo := LoadBitmap( GetResources(), "LBNO" )

DO WHILE .T.	
	DEFINE MSDIALOG oDlg TITLE cTitulo2 FROM 000,000 TO 200,430 PIXEL 
		
	//@ 000,000 MSPANEL oPanelLeft OF oDlg SIZE 220,125
	//oPanelLeft:Align := CONTROL_ALIGN_LEFT
	
	@ 010, 005 SAY "Hist�rico: "       SIZE 45,07 OF oDlg PIXEL
	@ 010, 050 MSGET cHistor SIZE 120,10 PICTURE "@!" VALID !EMPTY(cHistor) OF oDlg PIXEL HASBUTTON

	@ 025, 005 SAY "Cta D�bito: "  SIZE 45,07 OF oDlg PIXEL
	@ 025, 050 MSGET M->E5_DEBITO SIZE 120,10 F3 "CT1" VALID (EMPTY(M->E5_DEBITO).or.CTB105CTA()) .and. fa100CtaIgual()  OF oDlg PIXEL HASBUTTON //When .F.
	
	@ 040, 005 SAY "C.C. D�bito: "  SIZE 45,07 OF oDlg PIXEL
	@ 040, 050 MSGET M->E5_CCD SIZE 120,10 F3 "CTT" VALID EMPTY(M->E5_CCD) .or. Ctb105CC() OF oDlg PIXEL HASBUTTON //When .F.

	@ 055, 005 SAY "Cta Cr�dito: "  SIZE 45,07 OF oDlg PIXEL
	@ 055, 050 MSGET M->E5_CREDITO SIZE 120,10 F3 "CT1" VALID (EMPTY(M->E5_CREDITO).or.CTB105CTA()) .and. fa100CtaIgual() OF oDlg PIXEL HASBUTTON
	
	@ 070, 005 SAY "C.C. Cr�dito: "  SIZE 45,07 OF oDlg PIXEL
	@ 070, 050 MSGET M->E5_CCC SIZE 120,10 F3 "CTT" VALID EMPTY(M->E5_CCC) .or. Ctb105CC() OF oDlg PIXEL HASBUTTON

	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{|| lOk:=.T., oDlg:End()},{|| oDlg:End()}, , @aButtons)
		
	If ( lOk )
		RecLock("SE5",.F.)
		SE5->E5_HISTOR  := cHistor
		SE5->E5_DEBITO  := M->E5_DEBITO
		SE5->E5_CCD     := M->E5_CCD
		SE5->E5_CREDITO := M->E5_CREDITO
		SE5->E5_CCC     := M->E5_CCC 
		MsUnlock()
	ENDIF
	EXIT

ENDDO
	                   
Restarea( aArea )

RETURN Nil

