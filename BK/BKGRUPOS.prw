#include "totvs.ch"
#include "protheus.ch"
 
/*/{Protheus.doc} BKGRUPO
BK - Array com as empresas do grupo BK

@Return
@author Marcos B. Abrah�o
@since 24/08/21
@version P12
/*/

User Function BKGrupo()

Local aEmpresas	:= {    {"01","BK"},;
                        {"02","BKTER"},;
                        {"14","BALSA NOVA"},;
                        {"15","BHG INT 3"} }
Return aEmpresas


/*/{Protheus.doc} IsSuperior
    Retorna se o usuario informado � superior de algum outro
    @type  Function
    @author Marcos Bispo Abrah�o
    @since 30/08/2021
    @version version
    @param cId (Id do usu�rio)
    @return lRet
    /*/
User Function IsSuperior(cId)
Local nx,ny
Local aAllusers := FWSFALLUSERS()
Local aSup		:= {}
Local lRet := .F.

For nx := 1 To Len(aAllusers)
	aSup := FWSFUsrSup(aAllusers[nx][2])
	For ny := 1 To Len(aSup)
		If cId == aSup[ny]
			lRet := .T.
			Exit
		EndIf
	Next
	If lRet
		Exit
	Endif
Next
Return (lRet)



// Retorna se o usu�rio pertence ao grupo informado
User Function IsGrupo(cId,cIdGrupo)
Local nx
Local aGrp := FWSFUsrGrps(cId)
Local lRet := .F.

For nx := 1 To Len(aGrp)
	If cIdGrupo == aGrp[nx]
		lRet := .T.
		Exit
	EndIf
Next

Return (lRet)


// Retorna se o usu�rio pertence ao STAF 
// MV_XXUSER - Parametro especifico BK - Usuarios que visualizam doc de entrada de seus superiores e do depto todo
User Function IsStaf(cId)
Local lRet := .F.
If cId $ "000011/000016/000076/000093/000194/000056/000165/000116/"
    lRet := .T.
EndIf
Return (lRet)


