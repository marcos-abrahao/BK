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

aAdd(aBotao, {'Filtro Historico',"U_BKCTB02", 0 , 3 })
Return(aBotao)

User Function BKCTB02()
Local oDlg,oPanelLeft,oSay1,oTexto
Local aButtons := {}
Local nLin 
Local oBrowse := GetObjBrow()// Seta o filtro para o browse
Static cTexto := SPACE(30)
Static lOk1 := .T.

If !lOk1
   lOk1 := .T.
   Return
EndIf

Private cFilt,xVar

DEFINE MSDIALOG oDlg TITLE "Filtro para o hist�rico" FROM 000,000 TO 100,320 PIXEL 

@ 000,000 MSPANEL oPanelLeft OF oDlg SIZE 320,225
oPanelLeft:Align := CONTROL_ALIGN_LEFT

nLin := 15

@ nLin, 010 SAY oSay1 PROMPT "Texto:" SIZE 040, 010 OF oPanelLeft PIXEL
@ nLin, 060 MSGET oTexto  VAR cTexto    SIZE 070, 010 OF oPanelLeft PIXEL

ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{|| lOk1:=.T., oDlg:End()},{|| lOk1:=.F.,oDlg:End()}, , aButtons)

//dbSelectArea("CT2")
//dbSetOrder(0)
//dbClearFilter()

If ( lOk1 )
	If !EMPTY(cTexto)
		cFilt := " CT2_HIST LIKE '%"+ALLTRIM(cTexto)+"%'"          	 
		SetMBTopFilter("CT2", cFilt, .T.)// Atualiza as informa��es do browse
	Else
		cFilt := ""
		SetMBTopFilter("CT2", cFilt, .T.)// Atualiza as informa��es do browse

		//cExpFilter := "" 
		//aIndex := {} 
		//EndFilBrw( "CT2" , @aIndex ) 
		//CT2->( dbClearFilter() ) 
		//bFiltraBrw := { || FilBrowse( "CT2" , @aIndex , @cExpFilter ) } 
		//Eval( bFiltraBrw ) 

	EndIf
	oBrowse:ResetLen()
	oBrowse:Gotop()
	oBrowse:Refresh()

	//cFilt := ' dbSetFilter( { || '+cFilt+" },'"+cFilt+"')"
	//xVar := &(cFilt)
Endif
 

lOk1 := .F.
//RestArea(aAreaIni)
Return .T.
