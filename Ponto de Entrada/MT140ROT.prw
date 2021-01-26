#include "rwmake.ch"

/*/{Protheus.doc} MT140ROT
BK - Ponto de Entrada para criar bot�es na pre-nota
@Return
@author Marcos Bispo Abrah�o
@since 24/11/2009
@version P12
/*/

User Function MT140ROT()
AADD( aRotina, {OemToAnsi("Benef�cios "+FWEmpName(cEmpAnt)), "U_BKCOMA03", 0, 4 } )
AADD( aRotina, {OemToAnsi("Dados Pgto "+FWEmpName(cEmpAnt)), "U_AltFPgto", 0, 4 } )
Return Nil


