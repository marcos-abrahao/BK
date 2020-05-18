#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} BKFINR12
BK - 
@Return
@author Adilson do Prado / Marcos Bispo Abrah�o
@since 
@version P12
/*/
User Function Nada()

Local oTmpTb
Local aDbf := {}
Local nStart := Time()
Local cQuery := ""

oTmpTb := FWTemporaryTable():New("TRB")
oTmpTb:SetFields( aDbf )
oTmpTb:AddIndex("indice1", {"XX_CHAVE"} )
oTmpTb:Create()


oTmpTb:Delete()

// Para gravar query quando admin
cQuery := "SELECT 1 "+ CRLF
u_LogMemo("BKGCTR07.SQL",cQuery)

/// Alterar U_GeraCSV para U_GeraXlsx

//ProcRegua(QTMP->(LASTREC()))
//Processa( {|| U_GeraCSV("QTMP",cPerg,aTitulos,aCampos,aCabs)})
AADD(aPlans,{"QTMP",cPerg,"",aTitulos,aCampos,aCabs,/*aImpr1*/, /* aAlign */,/* aFormat */, /*aTotal */, /*cQuebra*/, lClose:= .T. })
U_GeraXlsx(aPlans,Titulo,cPerg,.T.)

///


FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01", "JSON successfully parsed to Object", 0, (nStart - Seconds()), {}) // nStart � declarada no inicio da fun��o

Return NIL
