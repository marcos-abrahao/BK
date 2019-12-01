#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT120TEL �Autor  �Adilson/Marcos      � Data �  26/01/17   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��es do Pedido de Compras respons�veis para             ���
���          � manipular o cabe�alho do Pedido de Compras permitindo      ���
���          � a inclus�o e altera��o de campos.       					  ���
�������������������������������������������������������������������������͹��
���Uso       � BK                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
ExecBlock("MT120TEL",.F.,.F.,{@oDlg, aPosGet, aObj, nOpcx, nReg} )
*/

USER FUNCTION MT120TEL
Local oNewDialog := PARAMIXB[1]
Local aPosGet    := PARAMIXB[2]  
Local aNewObj    := PARAMIXB[3]
Local nOpcx      := PARAMIXB[4]
Local nReg       := PARAMIXB[5]
Local nLin       := 0

Public aSIM   := {}
Public cSim   := "N�o"

AADD(aSIM,"Sim")
AADD(aSIM,"N�o")

Public cXXOBS   := Space(TamSX3("C7_XXOBS")[1])
Public cXXURGEN := Space(TamSX3("C7_XXURGEN")[1])

IF nOpcx <> 3
    cXXOBS   := SC7->C7_XXOBS
    cXXURGEN := SC7->C7_XXURGEN
    IF cXXURGEN == "S"
    	cSim := "Sim"
    ELSE
    	cSim := "N�o"
    ENDIF
ENDIF 

If TYPE("CRELEASERPO") == "U"
	nLin := 45	// Protheus 11
Else
	nLin := 75	// Protheus 12
EndIf

@ nLin,aPosGet[1,1] SAY 'Pedido urgente?' PIXEL SIZE 50,10 Of oNewDialog
@ nLin,aPosGet[1,2] COMBOBOX cSim ITEMS aSIM SIZE 100,50  PIXEL SIZE 130,10 Of oNewDialog    

@ nLin,aPosGet[1,3] SAY 'Observa��o' PIXEL SIZE 50,10 Of oNewDialog
oMemo:= tMultiget():New(nLin,aPosGet[1,4],{|u|if(Pcount()>0,cXXOBS:=u,cXXOBS)},oNewDialog,250,20,,,,,,.T.) 

RETURN

 
//Manipula as dimens�es do cabe�alho d0 pedido
User Function MT120GET() 
Local aRet:= PARAMIXB[1] 

If TYPE("CRELEASERPO") == "U"  // P11
	aRet[2,1] := 90
	aRet[1,3] := 120 
Else   // P12
	aRet[2,1] := 120
	aRet[1,3] := 150 
EndIf
Return(aRet)


// MTA120G2 Grava em todos os itens
User Function MTA120G2()
     
If cSim == "Sim"
	cXXURGEN := "S"
Else
	cXXURGEN := "N"
EndIf
SC7->C7_XXOBS   := cXXOBS
SC7->C7_XXURGEN := cXXURGEN 
     
Return


User Function MT120BRW()

aAdd( aRotina, { "Pedido Urgente?", "U_BKALTSC7", 4, 0, 4 } )

Return Nil

