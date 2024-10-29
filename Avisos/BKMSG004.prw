#INCLUDE 'PROTHEUS.CH'
#INCLUDE "TOTVS.CH"

/*/{Protheus.doc} BKMSG004
BK - Aviso de Clientes sem Conta Banc�ria para Dep�sito
@Return
@author Marcos Bispo Abrah�o
@since 25/04/24
@version P12.1.2310
/*/

User Function BKMSG004
Local cQuery	:= ""
Local aEmpresas := u_BKGrpFat()
Local nE 		:= 0
Local cTabSA1	:= ""
Local cEmail 	:= ""
Local cAssunto  := "Aviso de Clientes sem Conta Banc�ria para Dep�sito"
Local cEmailCC  := u_EmailAdm()
Local aCabs   	:= {"Empresa","C�digo","Identifica��o","Endere�o","Bairro","Municipio","UF"}
Local aEmail 	:= {}
Local cMsg		:= ""
Local aUsers 	:= {}
Local aGrupos 	:= {}
Local aDeptos 	:= {"Financeiro"}

Private cProg := "BKMSG004"

cEmail := u_GprEmail("",@aUsers,@aGrupos,@aDeptos)

cQuery := "WITH MSG AS ( " + CRLF

For nE := 1 TO Len(aEmpresas)

	cEmpresa := aEmpresas[nE,1]
	cNomeEmp := aEmpresas[nE,2]

	cTabSA1 := "SA1"+cEmpresa+"0"

	If nE > 1
		cQuery += "UNION ALL "+CRLF
	EndIf

	cQuery += " SELECT"+CRLF
	cQuery += "  '"+cEmpresa+"' AS EMPRESA" + CRLF
	cQuery += " ,'"+cNomeEmp+"' AS NOMEEMP" + CRLF
	cQuery += "	,A1_COD+'-'+A1_LOJA AS CODIGO" + CRLF
	cQuery += "	,A1_NOME" + CRLF
	cQuery += "	,A1_END" + CRLF
	cQuery += "	,A1_BAIRRO" + CRLF
	cQuery += "	,A1_MUN" + CRLF
	cQuery += "	,A1_EST" + CRLF
	cQuery += "FROM "+cTabSA1+" SA1" + CRLF
	cQuery += "WHERE D_E_L_E_T_ = '' AND A1_XXCTABC = ' ' AND A1_MSBLQL = '2'" + CRLF

Next

cQuery += ")"+CRLF
cQuery += "SELECT * " + CRLF
cQuery += "  FROM MSG " + CRLF

cQuery += " ORDER BY" + CRLF
cQuery += "    EMPRESA,CODIGO" + CRLF

u_LogMemo("BKMSG004.SQL",cQuery)

//cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QTMP",.T.,.T.)

dbSelectArea("QTMP")
dbGoTop()

aEmail := {}
Do While !Eof()
	AADD(aEmail,{QTMP->NOMEEMP,QTMP->CODIGO,QTMP->A1_NOME,QTMP->A1_END,QTMP->A1_BAIRRO,QTMP->A1_MUN,QTMP->A1_EST})
	dbSkip()
EndDo

cMsg   := u_GeraHtmA(aEmail,cAssunto,aCabs,cProg,"",cEmail,cEmailCC)
U_BkSnMail(cProg,cAssunto,cEmail,cEmailCC,cMsg)

// Grava o anexo html
u_GrvAnexo(cProg+".html",cMsg,.T.)

// Gravar no SZ0 - Avisos Web
u_BKMsgUs(cEmpAnt,cProg,{},aGrupos,"Clientes sem Conta bancaria: "+ALLTRIM(STR(LEN(aEmail))),"Clientes sem Conta bancaria: "+ALLTRIM(STR(LEN(aEmail))),"F",cProg+".html")

u_MsgLog(cProg,"Clientes sem Conta bancaria: "+ALLTRIM(STR(LEN(aEmail))))

QTMP->(dbCloseArea())

Return

