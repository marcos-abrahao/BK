#include "totvs.ch"
#include "protheus.ch"

/*/{Protheus.doc} BKVARS
BK - Funcoes com par�metros embutidos no fonte

@Return
@author Marcos B. Abrah�o
@since 03/05/22
@version P12
/*/


// % Media de Impostos e Contribuicoes calculo Rentabilidade dos Contratos 
User Function MVXXMIMPC()
Local cPar := "1900/01;8.15|2015/07;10.7000|2019/01;9.50"

If cEmpAnt == '02'
    cPar := "1900/01;16.98000"
ElseIf cEmpAnt == '12'
    cPar := "1900/01;8.15|2015/07;10.7000"
ElseIf cEmpAnt == '15'
    cPar := "1900/01;8.15|2015/07;10.8877"
EndIf

Return cPar


// Parametro Proventos calculo Rentabilidade dos Contratos
User Function MVXXPROVE()

Local cVar := "|1|2|11|34|35|36|37|56|60|64|65|68|100|102|104|108|110|126|266|268|270|274|483|600|640|656|664|674|675|685|696|700|725|726|727|728|729|745|747|749|750|754|755|756|757|758|760|761|762|763|764|765|778|779|787|789|790|791|792|824|897|"

Return cVar

