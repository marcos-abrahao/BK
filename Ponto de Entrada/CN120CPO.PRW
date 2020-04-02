#include "rwmake.ch"

/*/{Protheus.doc} CNA130INC
BK - Ponto de Entrada para carregar campos na inclus�o das medi�oes

@Return
@author Marcos B Abrah�o
@since 01/12/11
@version P11/P12
/*/

User Function C121VCPO()

//Local oStruCND := PARAMIXB[1]
//Local oStruCXN := PARAMIXB[2]
//Local oStruCNE := PARAMIXB[3]

Local X
X:=0

Return

User Function CN120CPO()
Local aCpo  := {"CNA_XXMOT","CNA_XXMUN"}
IF FWIsInCallStack("CNTA121")
    FWFLDPUT("CND_XXMUN",CNA->CNA_XXMUN)
ENDIF
Return aCpo


User Function CN120CMP()

Local aCpo  := {"CNA_XXMOT","CNA_XXMUN"}

Return aCpo           


User Function CN120SXB()
// Pesquisa padr�o de contratos na medi��o
Return "CN9001"


