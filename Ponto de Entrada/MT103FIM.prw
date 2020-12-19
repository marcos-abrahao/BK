#Include "TOTVS.Ch"
#Include "Protheus.Ch"

/*/{Protheus.doc} MT103FIM
P.E. - Ap�s o destravamento de todas as tabelas envolvidas na grava��o das NF Entrada.
@author Marcos Bispo Abrah�o
@since 25/11/2020
@version 1.0
@type function
/*/
User Function MT103FIM()
Local nOpcao	:= ParamIxb[1]
Local nConfirma	:= ParamIxb[2]
Local aArea		:= GetArea()

If nOpcao == 5 .AND. nConfirma == 1

	RecLock("SF1",.F.)
	SF1->F1_XXLIB  := "E"
	MsUnLock("SF1")
	u_SF1Email("Pr�-Nota Estornada")
EndIf

RestArea(aArea)
Return
