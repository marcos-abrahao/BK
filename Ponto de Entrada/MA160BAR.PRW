#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWIZARD.CH"       

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MA160BAR�Autor  �Adilson do Prado     � Data �  07/02/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada utilizado para inserir novas opcoes no    ���
���            array aBot�es na Analise de Cota��o.                       ���
�������������������������������������������������������������������������͹��
���Uso       � BK                                                         ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MA161BAR() 

Local aBotao := {}

Aadd(aBotao, { "Alt. Prazo Entrega", {|| U_PRAZOENT() }, OemToAnsi("Alterar Prazo de Entrega"), "Alt. Prazo Entrega"} )

Return aBotao


User Function PRAZOENT() 

Local aArea      := GetArea()
Local oDlgEx
Local aButtons 	:= {}
//Local nPRAZO 	:= 11
Local nDias 	:= 	SC8->C8_PRAZO
Local cCotacao 	:= 	SC8->C8_NUM
Local lOk		:= .F.

IF !Empty(SC8->C8_NUMPED) 
	MSGSTOP("Cota��o j� foi Analisada")
	RETURN NIL
ENDIF

Define MsDialog oDlgEx Title "Alterar Prazo de Entrega Cota��o: "+SC8->C8_NUM From 000,000 To 120,400 Of oDlgEx Pixel Style DS_MODALFRAME

@ 040,005 Say  'Prazo de Entrega (em dias): ' Of oDlgEx Pixel                                  	
@ 040,080 MsGet nDias Picture "@E 999"  Valid Positivo(nDias) Size 060,007 Pixel Of oDlgEx

Activate MsDialog oDlgEx Centered ON INIT EnchoiceBar(oDlgEx,{|| lOk:=.T., oDlgEx:End()},{|| oDlgEx:End()}, , aButtons)

If ( lOk )
	Processa( {|| GRVPRAZO(cCotacao,nDias)})
ENDIF	

RestArea(aArea)

Return Nil


STATIC Function GRVPRAZO(cCotacao,nDias) 


DbSelectArea("SC8")
SC8->(DbSetOrder(1))
SC8->(DbSeek(xFilial("SC8")+cCotacao,.T.))
Do While SC8->(!eof()) .AND. SC8->C8_NUM==cCotacao

	RecLock( "SC8", .F. )
	SC8->C8_PRAZO  := nDias
	SC8->(MsUnLock())

	SC8->(DbSkip())
ENDDO
Return NIL


