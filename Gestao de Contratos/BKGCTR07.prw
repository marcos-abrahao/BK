#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} BKGCTR15()
BK - Mapa de INSS retido

@author Marcos B. Abrah�o
@since 05/05/11
@version P12
@return Nil
/*/
//-------------------------------------------------------------------


User Function BKGCTR07()

Local titulo         := ""
Local aTitulos,aCampos,aCabs

Private cPerg        := "BKGCTR07"
Private cString      := "CN9"

Private cMesEmis     := "01"
Private cAnoEmis     := "2011"
Private nPlan        := 1
Private nTipo		 := 1
Private cMes
Private _cTXPIS  	 := STR(GetMv("MV_TXPIS"))
Private _cTXCOF  	 := STR(GetMv("MV_TXCOFINS"))

Public XX_PESSOA     := ""
Public cMotMulta     := "N"

dbSelectArea('SA1')
dbSelectArea(cString)
dbSetOrder(1)

ValidPerg(cPerg)
If !Pergunte(cPerg,.T.)
	Return
Endif

cMesEmis := mv_par01
cAnoEmis := mv_par02
cCompet  := cMesEmis+"/"+cAnoEmis
nPlan    := mv_par03
nTipo    := mv_par04

//nMes := VAL(cMesEmis) + 1
//nAno := VAL(cAnoEmis)
//IF nMes = 13
//   nMes := 1
//   nAno := nAno + 1
//ENDIF
//cMes := STR(nAno,4)+STRZERO(nMes,2)   
IF nTipo == 1
	cMes := cAnoEmis+cMesEmis
ELSE
	cMes := cAnoEmis
ENDIF

titulo   := "Mapa de INSS Retido :"+IIF(nTipo=1," Emiss�o "+cMesEmis+"/"+cAnoEmis," Anual "+cAnoEmis)

ProcRegua(1)
Processa( {|| ProcQuery() })

aCabs   := {}
aCampos := {}
aTitulos:= {}
   
AADD(aTitulos,titulo)

AADD(aCampos,"QTMP->XX_CLIENTE")
AADD(aCabs  ,"Cliente")

AADD(aCampos,"QTMP->XX_LOJA")
AADD(aCabs  ,"Loja")

AADD(aCampos,"Posicione('SA1',1,xFilial('SA1')+QTMP->XX_CLIENTE+QTMP->XX_LOJA,'A1_NOME')")
AADD(aCabs  ,"Nome")

AADD(aCampos,"M->XX_PESSOA := Posicione('SA1',1,xFilial('SA1')+QTMP->XX_CLIENTE+QTMP->XX_LOJA,'A1_PESSOA')")
AADD(aCabs  ,"Tipo Pes.")

AADD(aCampos,"Transform(Posicione('SA1',1,xFilial('SA1')+QTMP->XX_CLIENTE+QTMP->XX_LOJA,'A1_CGC'),IIF(M->XX_PESSOA=='J','@R 99.999.999/9999-99','@R 999.999.999-99'))")
//AADD(aCampos,"Transform(  Posicione('SA1',1,xFilial('SA1')+QTMP->XX_CLIENTE+QTMP->XX_LOJA,'A1_CGC'),PicPes(M->XX_PESSOA) )")
AADD(aCabs  ,"CNPJ/CPF")

AADD(aCampos,"QTMP->CNF_CONTRA")
AADD(aCabs  ,"Contrato")

AADD(aCampos,"QTMP->CNF_REVISA")
AADD(aCabs  ,"Revis�o")

AADD(aCampos,"QTMP->CTT_DESC01")
AADD(aCabs  ,"Centro de Custos")

AADD(aCampos,"QTMP->CNA_NUMERO")
AADD(aCabs  ,"Planilha")

AADD(aCampos,"QTMP->CNA_XXMUN")
AADD(aCabs  ,"Municipio")

AADD(aCampos,"QTMP->CNF_COMPET")
AADD(aCabs  ,"Competencia")

AADD(aCampos,"QTMP->CND_NUMMED")
AADD(aCabs  ,"Medi��o")

AADD(aCampos,"QTMP->C6_NUM")
AADD(aCabs  ,"Pedido")
   
AADD(aCampos,"QTMP->F2_DOC")
AADD(aCabs  ,"Nota Fiscal")

AADD(aCampos,"QTMP->F2_EMISSAO")
AADD(aCabs  ,"Emissao")
   
AADD(aCampos,"QTMP->XX_VENCTO")
AADD(aCabs  ,"Vencimento")

AADD(aCampos,"QTMP->XX_VENCORI")
AADD(aCabs  ,"Venc. Original")

AADD(aCampos,"QTMP->XX_BAIXA")
AADD(aCabs  ,"Recebimento")

AADD(aCampos,"QTMP->CNF_VLPREV")
AADD(aCabs  ,"Valor Previsto")

AADD(aCampos,"QTMP->CNF_SALDO")
AADD(aCabs  ,"Saldo Previsto")

AADD(aCampos,"QTMP->F2_VALFAT")
AADD(aCabs  ,"Valor faturado")

AADD(aCampos,"QTMP->CNF_VLPREV - QTMP->F2_VALFAT")
AADD(aCabs  ,"Previsto - Faturado")

AADD(aCampos,"QTMP->XX_BONIF")
AADD(aCabs  ,"Bonifica��es")

AADD(aCampos,"QTMP->XX_MULTA")
AADD(aCabs  ,"Multas")

AADD(aCampos,"QTMP->XX_E5DESC")
AADD(aCabs  ,"Desconto na NF")

IF FWCodEmp() == "12"  
	AADD(aCampos,"VAL(STR(((QTMP->F2_VALFAT*0.32)*0.15),14,02))")
	AADD(aCabs  ,"IRPJ Apura��o")
	
	AADD(aCampos,"VAL(STR(QTMP->F2_VALFAT*("+ALLTRIM(_cTXPIS)+"/100),14,02))")
	AADD(aCabs  ,"PIS Apura��o")
	
	AADD(aCampos,"VAL(STR(QTMP->F2_VALFAT*("+ALLTRIM(_cTXCOF)+"/100),14,02))")
	AADD(aCabs  ,"COFINS Apura��o")
	
	AADD(aCampos,"VAL(STR(((QTMP->F2_VALFAT*0.32)*0.09),14,02))")
	AADD(aCabs  ,"CSLL Apura��o")
	
ENDIF

AADD(aCampos,"QTMP->F2_VALIRRF")
AADD(aCabs  ,"IRRF Retido")

AADD(aCampos,"QTMP->F2_VALINSS")
AADD(aCabs  ,"INSS Retido")

AADD(aCampos,"QTMP->F2_VALPIS")
AADD(aCabs  ,"PIS Retido")

AADD(aCampos,"QTMP->F2_VALCOFI")
AADD(aCabs  ,"COFINS Retido")

AADD(aCampos,"QTMP->F2_VALCSLL")
AADD(aCabs  ,"CSLL Retido")

AADD(aCampos,"IIF(QTMP->F2_RECISS = '1',QTMP->F2_VALISS,0)")
AADD(aCabs  ,"ISS Retido")

AADD(aCampos,"QTMP->F2_VALFAT - QTMP->F2_VALIRRF - QTMP->F2_VALINSS - QTMP->F2_VALPIS - QTMP->F2_VALCOFI - QTMP->F2_VALCSLL - IIF(QTMP->F2_RECISS = '1',QTMP->F2_VALISS,0) - QTMP->XX_E5DESC")
AADD(aCabs  ,"Valor liquido")

IF cMotMulta = "S"
	AADD(aCampos,"U_BKCNR07(QTMP->CND_NUMMED,'1')")
	AADD(aCabs  ,"Motivo Bonifica��o")

	AADD(aCampos,"U_BKCNR07(QTMP->CND_NUMMED,'2')")
	AADD(aCabs  ,"Motivo Multa")
ENDIF

ProcRegua(QTMP->(LASTREC()))
Processa( {|| U_GeraCSV("QTMP",cPerg,aTitulos,aCampos,aCabs)})

Return


Static Function ProcQuery
Local cQuery

IncProc("Consultando o banco de dados...")

/*

SELECT CNF_CONTRA,CNF_REVISA,CNF_COMPET,CNF_VLPREV,CNF_SALDO,
         CTT_DESC01,
         CNA_NUMERO,CNA_XXMUN,
         CND_NUMMED,
         C6_NUM,
         (SELECT SUM(CNR_VALOR) FROM CNR010 CNR WHERE CND_NUMMED = CNR_NUMMED AND  CNR_FILIAL = '01' AND  CNR.D_E_L_E_T_ = ' ' AND CNR_TIPO = '1') AS XX_BONIF,
         (SELECT SUM(CNR_VALOR) FROM CNR010 CNR WHERE CND_NUMMED = CNR_NUMMED AND  CNR_FILIAL = '01' AND  CNR.D_E_L_E_T_ = ' ' AND CNR_TIPO = '2') AS XX_MULTA,
         F2_DOC,F2_EMISSAO,F2_VALFAT,F2_VALIRRF,F2_VALINSS,F2_VALPIS,F2_VALCOFI,F2_VALCSLL,F2_RECISS,F2_VALISS
  FROM CNF010 CNF 
         INNER JOIN CN9010 CN9 ON CN9_NUMERO = CNF_CONTRA AND CN9_REVISA = CNF_REVISA AND CN9_SITUAC = '05' AND CN9_FILIAL = '01' AND  CN9.D_E_L_E_T_ = ' '
         LEFT  JOIN CTT010 CTT ON CTT_CUSTO  = CNF_CONTRA AND CTT_FILIAL = '01' AND  CTT.D_E_L_E_T_ = ' '
         LEFT  JOIN CNA010 CNA ON CNA_CRONOG = CNF_NUMERO AND CNA_REVISA = CNF_REVISA AND  CNA_FILIAL = '01' AND CNA.D_E_L_E_T_ = ' ' 
         LEFT  JOIN CND010 CND ON CND_CONTRA = CNF_CONTRA AND CND_COMPET = CNF_COMPET AND CNA_NUMERO = CND_NUMERO AND CND_PARCEL = CNF_PARCEL AND CND_REVISA = CNA_REVISA AND  CND_FILIAL = '01' AND  CND.D_E_L_E_T_ = ' '
         LEFT  JOIN SC6010 SC6 ON CND_PEDIDO = C6_NUM     AND C6_FILIAL  = '01'  AND  SC6.D_E_L_E_T_ = ' ' 
         LEFT  JOIN SF2010 SF2 ON C6_SERIE   = F2_SERIE   AND C6_NOTA    = F2_DOC  AND  F2_FILIAL = '01'  AND  SF2.D_E_L_E_T_ = ' '
  WHERE CNF_COMPET = '05/2010' AND  CNF_FILIAL = '01' AND  CNF.D_E_L_E_T_ = ' ' 
  UNION ALL  
  SELECT 'XXXXXXXXX',' ',' ',0,0,         A1_NOME,         ' ',' ',         ' ',         ' ',         0,0,         
         F2_DOC,F2_EMISSAO,F2_VALFAT,F2_VALIRRF,F2_VALINSS,F2_VALPIS,F2_VALCOFI,F2_VALCSLL,F2_RECISS,F2_VALISS  
  FROM SF2010 SF2 
         LEFT JOIN SA1010 SA1 ON F2_CLIENTE = A1_COD AND F2_LOJA = A1_LOJA  AND  A1_FILIAL = '  ' AND  SA1.D_E_L_E_T_ = ' ' 
         WHERE ((SELECT TOP 1 C5_MDCONTR FROM SC6010 SC6 INNER JOIN SC5010 SC5 ON C6_FILIAL = '01' AND C5_FILIAL = C6_FILIAL AND C6_NUM = C5_NUM AND C6_SERIE = F2_SERIE AND C6_NOTA = F2_DOC AND SC6.D_E_L_E_T_ = ' ' AND SC5.D_E_L_E_T_ = ' ')  = ' ' OR
                (SELECT TOP 1 C5_MDCONTR FROM SC6010 SC6 INNER JOIN SC5010 SC5 ON C6_FILIAL = '01' AND C5_FILIAL = C6_FILIAL AND C6_NUM = C5_NUM AND C6_SERIE = F2_SERIE AND C6_NOTA = F2_DOC AND SC6.D_E_L_E_T_ = ' ' AND SC5.D_E_L_E_T_ = ' ')  IS NULL ) AND
                SUBSTRING(F2_EMISSAO,1,6) = 201006 AND F2_FILIAL = '01' AND SF2.D_E_L_E_T_ = ' ' 
  
  ORDER BY CNF_CONTRA,CNF_REVISA,CNF_COMPET,F2_DOC

CASE WHEN C5_XXPROMO = 'S' THEN (D2_QUANT*2) ELSE D2_QUANT END AS XX_QTDPLAN
*/

cQuery := " SELECT DISTINCT CN9_CLIENT AS XX_CLIENTE,CN9_LOJACL AS XX_LOJA,CNF_CONTRA,CNF_REVISA,CNF_COMPET,"+ CRLF
cQuery += "    CASE WHEN CN9_SITUAC = '05' THEN CNF_VLPREV ELSE CNF_VLREAL END AS CNF_VLPREV,"+ CRLF
cQuery += "    CASE WHEN CN9_SITUAC = '05' THEN CNF_SALDO  ELSE 0 END AS CNF_SALDO, "+ CRLF
cQuery += "    CTT_DESC01, "+ CRLF
cQuery += "    CNA_NUMERO,CNA_XXMUN, "+ CRLF
cQuery += "    CND_NUMMED, "+ CRLF
cQuery += "    C6_NUM, "+ CRLF

// 18/11/14 - Campos XX_BONIF alterado de '2' para '1' e XX_MULTA alrterado de '1' para '2'
cQuery += "    (SELECT SUM(CNR_VALOR) FROM "+RETSQLNAME("CNR")+" CNR WHERE CND_NUMMED = CNR_NUMMED"+ CRLF
cQuery += "         AND  CNR_FILIAL = '"+xFilial("CNR")+"' AND  CNR.D_E_L_E_T_ = ' ' AND CNR_TIPO = '1') AS XX_BONIF,"+ CRLF

cQuery += "    (SELECT SUM(CNR_VALOR) FROM "+RETSQLNAME("CNR")+" CNR WHERE CND_NUMMED = CNR_NUMMED"+ CRLF
cQuery += "         AND  CNR_FILIAL = '"+xFilial("CNR")+"' AND  CNR.D_E_L_E_T_ = ' ' AND CNR_TIPO = '2') AS XX_MULTA,"+ CRLF

cQuery += "    F2_DOC,F2_EMISSAO,F2_VALFAT,F2_VALIRRF,F2_VALINSS,F2_VALPIS,F2_VALCOFI,F2_VALCSLL,F2_RECISS,F2_VALISS, " + CRLF

cQuery += "    (SELECT TOP 1 E1_VENCTO FROM "+RETSQLNAME("SE1")+ " SE1 WHERE E1_PREFIXO = F2_SERIE AND E1_NUM = F2_DOC"+ CRLF
cQuery += "        AND  E1_FILIAL = '"+xFilial("SE1")+"'  AND  SE1.D_E_L_E_T_ = ' ') AS XX_VENCTO, "+ CRLF

cQuery += "    (SELECT TOP 1 E1_VENCORI FROM "+RETSQLNAME("SE1")+ " SE1 WHERE E1_PREFIXO = F2_SERIE AND E1_NUM = F2_DOC"+ CRLF
cQuery += "        AND  E1_FILIAL = '"+xFilial("SE1")+"'  AND  SE1.D_E_L_E_T_ = ' ') AS XX_VENCORI, "+ CRLF

cQuery += "    (SELECT TOP 1 E1_BAIXA FROM "+RETSQLNAME("SE1")+ " SE1 WHERE E1_PREFIXO = F2_SERIE AND E1_NUM = F2_DOC"+ CRLF
cQuery += "        AND  E1_FILIAL = '"+xFilial("SE1")+"'  AND  SE1.D_E_L_E_T_ = ' ') AS XX_BAIXA, "+ CRLF

cQuery += "    (SELECT SUM(E5_VALOR) FROM "+RETSQLNAME("SE5")+" SE5 WHERE E5_PREFIXO = F2_SERIE AND E5_NUMERO = F2_DOC  AND E5_TIPO = 'NF' AND  E5_CLIFOR = F2_CLIENTE AND E5_LOJA = F2_LOJA AND E5_TIPODOC = 'DC' AND E5_RECPAG = 'R' AND E5_SITUACA <> 'C' " + CRLF
cQuery += "      AND  E5_FILIAL = '"+xFilial("SE5")+"'  AND  SE5.D_E_L_E_T_ = ' ') AS XX_E5DESC "+ CRLF

cQuery += " FROM "+RETSQLNAME("CNF")+" CNF"+ CRLF

cQuery += " INNER JOIN "+RETSQLNAME("CN9")+ " CN9 ON CN9_NUMERO = CNF_CONTRA AND CN9_REVISA = CNF_REVISA AND CN9_SITUAC <> '10' AND CN9_SITUAC <> '09' "+ CRLF
cQuery += "      AND  CN9_FILIAL = '"+xFilial("CN9")+"' AND  CN9.D_E_L_E_T_ = ' '"+ CRLF
cQuery += " LEFT JOIN "+RETSQLNAME("CTT")+ " CTT ON CTT_CUSTO = CNF_CONTRA"+ CRLF
cQuery += "      AND  CTT_FILIAL = '"+xFilial("CTT")+"' AND  CTT.D_E_L_E_T_ = ' '"+ CRLF
cQuery += " LEFT JOIN "+RETSQLNAME("CNA")+ " CNA ON CNA_CRONOG = CNF_NUMERO AND CNA_REVISA = CNF_REVISA"+ CRLF
cQuery += "      AND  CNA_FILIAL = '"+xFilial("CNA")+"' AND  CNA.D_E_L_E_T_ = ' '"+ CRLF
cQuery += " LEFT JOIN "+RETSQLNAME("CND")+ " CND ON CND_CONTRA = CNF_CONTRA AND CND_COMPET = CNF_COMPET AND CND_PARCEL = CNF_PARCEL AND CNA_NUMERO = CND_NUMERO AND CND_REVISA = CNF_REVISA"+ CRLF
cQuery += "      AND  CND_FILIAL = '"+xFilial("CND")+"' AND  CND.D_E_L_E_T_ = ' '"+ CRLF
cQuery += " LEFT JOIN "+RETSQLNAME("SC6")+ " SC6 ON CND_PEDIDO = C6_NUM"+ CRLF
cQuery += "      AND  C6_FILIAL = '"+xFilial("SC6")+"'  AND  SC6.D_E_L_E_T_ = ' '"+ CRLF
cQuery += " LEFT JOIN "+RETSQLNAME("SF2")+ " SF2 ON C6_SERIE = F2_SERIE AND C6_NOTA = F2_DOC"+ CRLF
cQuery += "      AND  F2_FILIAL = '"+xFilial("SF2")+"'  AND  SF2.D_E_L_E_T_ = ' '"+ CRLF

//cQuery += " WHERE CNF_COMPET = '"+cCompet+"'"

cQuery += " WHERE CNF_FILIAL = '"+xFilial("CNF")+"' AND  CNF.D_E_L_E_T_ = ' '"+ CRLF

IF nTipo == 1
	cQuery += " AND SUBSTRING(F2_EMISSAO,1,6) = '"+cMes+"' "+ CRLF
ELSE
	cQuery += " AND SUBSTRING(F2_EMISSAO,1,4) = '"+cMes+"' "+ CRLF
ENDIF

cqContr:= "(SELECT TOP 1 C5_MDCONTR FROM "+RETSQLNAME("SC6")+ " SC6 INNER JOIN "+RETSQLNAME("SC5")+" SC5 ON C6_FILIAL = '"+xFilial("SC6")+ "' AND C5_FILIAL = C6_FILIAL AND C6_NUM = C5_NUM AND C6_SERIE = F2_SERIE AND C6_NOTA = F2_DOC AND SC6.D_E_L_E_T_ = ' ' AND SC5.D_E_L_E_T_ = ' ') "
cqEspec:= "(SELECT TOP 1 C5_ESPECI1 FROM "+RETSQLNAME("SC6")+ " SC6 INNER JOIN "+RETSQLNAME("SC5")+" SC5 ON C6_FILIAL = '"+xFilial("SC6")+ "' AND C5_FILIAL = C6_FILIAL AND C6_NUM = C5_NUM AND C6_SERIE = F2_SERIE AND C6_NOTA = F2_DOC AND SC6.D_E_L_E_T_ = ' ' AND SC5.D_E_L_E_T_ = ' ') "


cQuery += " UNION ALL "+ CRLF
cQuery += " SELECT DISTINCT F2_CLIENTE AS XX_CLIENTE,F2_LOJA AS XX_LOJA,"+ CRLF
cQuery += "        CASE WHEN "+cqEspec+" = ' ' THEN 'XXXXXXXXXX' ELSE "+cqEspec+" END,"+ CRLF
cQuery += "        ' ',' ',0,0, "  // CNF_CONTRA,CNF_REVISA,CNF_COMPET,CNF_VLPREV,CNF_SALDO
cQuery += "        A1_NOME, "  // CTT_DESC01
cQuery += "        ' ',' ', "  // CNA_NUMERO,CNA_XXMUN
cQuery += "        ' ', "      // CND_NUMMED
cQuery += "        ' ', "      // C6_NUM
cQuery += "        0,0, "  + CRLF   // XX_BONIF,XX_MULTA
cQuery += "        F2_DOC,F2_EMISSAO,F2_VALFAT,F2_VALIRRF,F2_VALINSS,F2_VALPIS,F2_VALCOFI,F2_VALCSLL,F2_RECISS,F2_VALISS, " + CRLF
cQuery += "        (SELECT TOP 1 E1_VENCTO FROM "+RETSQLNAME("SE1")+" SE1 WHERE E1_PREFIXO = F2_SERIE AND E1_NUM = F2_DOC" + CRLF
cQuery += "            AND  E1_FILIAL = '"+xFilial("SE1")+"'  AND  SE1.D_E_L_E_T_ = ' ') AS XX_VENCTO, " + CRLF
cQuery += "        (SELECT TOP 1 E1_VENCORI FROM "+RETSQLNAME("SE1")+ " SE1 WHERE E1_PREFIXO = F2_SERIE AND E1_NUM = F2_DOC" + CRLF
cQuery += "            AND  E1_FILIAL = '"+xFilial("SE1")+"'  AND  SE1.D_E_L_E_T_ = ' ') AS XX_VENCORI, " + CRLF
cQuery += "        (SELECT TOP 1 E1_BAIXA FROM "+RETSQLNAME("SE1")+ " SE1 WHERE E1_PREFIXO = F2_SERIE AND E1_NUM = F2_DOC" + CRLF
cQuery += "            AND  E1_FILIAL = '"+xFilial("SE1")+"'  AND  SE1.D_E_L_E_T_ = ' ') AS XX_BAIXA, " + CRLF
cQuery += "        (SELECT SUM(E5_VALOR) FROM "+RETSQLNAME("SE5")+" SE5 WHERE E5_PREFIXO = F2_SERIE AND E5_NUMERO = F2_DOC  AND E5_TIPO = 'NF' AND  E5_CLIFOR = F2_CLIENTE AND E5_LOJA = F2_LOJA AND E5_TIPODOC = 'DC' AND E5_RECPAG = 'R' AND E5_SITUACA <> 'C' "  + CRLF
cQuery += "            AND  E5_FILIAL = '"+xFilial("SE5")+"'  AND  SE5.D_E_L_E_T_ = ' ') AS XX_E5DESC " + CRLF

cQuery += " FROM "+RETSQLNAME("SF2")+" SF2" + CRLF
//cQuery += " LEFT JOIN "+RETSQLNAME("CTT")+ " CTT ON CTT_CUSTO = "+cqContr
//cQuery += "      AND  CTT_FILIAL = '"+xFilial("CTT")+"' AND  CTT.D_E_L_E_T_ = ' '""
cQuery += " LEFT JOIN "+RETSQLNAME("SA1")+ " SA1 ON F2_CLIENTE = A1_COD AND F2_LOJA = A1_LOJA" + CRLF
cQuery += "      AND  A1_FILIAL = '"+xFilial("SA1")+"' AND  SA1.D_E_L_E_T_ = ' '" + CRLF
cQuery += " WHERE ("+cqContr+" = ' ' OR "
cQuery +=           cqContr+" IS NULL ) " + CRLF
IF nTipo == 1
	cQuery += "      AND SUBSTRING(F2_EMISSAO,1,6) = '"+cMes+"' " 
ELSE
	cQuery += "      AND SUBSTRING(F2_EMISSAO,1,4) = '"+cMes+"' " 
ENDIF

cQuery += "      AND F2_FILIAL = '"+xFilial("SF2")+"' AND SF2.D_E_L_E_T_ = ' '" + CRLF

//cQuery += " LEFT JOIN "+RETSQLNAME("CTT")+ " CTT ON CTT_CUSTO = C6_CONTRA"
//cQuery += "      AND  CTT_FILIAL = '"+xFilial("CTT")+"' AND  CTT.D_E_L_E_T_ = ' '""

//cQuery += " ORDER BY F2_DOC"  

cQuery += " ORDER BY CNF_CONTRA,CNF_REVISA,CNF_COMPET,F2_DOC"   + CRLF

TCQUERY cQuery NEW ALIAS "QTMP"
TCSETFIELD("QTMP","F2_EMISSAO","D",8,0)
TCSETFIELD("QTMP","XX_VENCTO","D",8,0)
TCSETFIELD("QTMP","XX_VENCORI","D",8,0)
TCSETFIELD("QTMP","XX_BAIXA","D",8,0)

IF __cUserId == "000000"
	MemoWrite("C:\TEMP\BKGCTR07.SQL",cQuery)
EndIf


//U_SendMail(PROCNAME(),PROCNAME(1),"marcos@rkainformatica.com.br","",cQuery,"",.F.)

/*
dbSelectArea("QTMP")
dbGoTop()
DO WHILE !EOF()


	dbSelectArea("QTMP")
	dbSkip()
ENDDO
*/


Return



Static Function  ValidPerg(cPerg)

Local aArea      := GetArea()
Local aRegistros := {}

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)

AADD(aRegistros,{cPerg,"01","Mes de Emissao  "  ,"" ,"" ,"mv_ch1","C",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","S","",""})
AADD(aRegistros,{cPerg,"02","Ano de Emissao  "  ,"" ,"" ,"mv_ch2","C",04,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","S","",""})
AADD(aRegistros,{cPerg,"03","Gerar Planilha? "  ,"" ,"" ,"mv_ch3","N",01,0,2,"C","","mv_par03","Sim","Sim","Sim","","","Nao","Nao","Nao","","","","","","","","","","","","","","","","",""})
AADD(aRegistros,{cPerg,"04","Tipo? "  ,"" ,"" ,"mv_ch4","N",01,0,2,"C","","mv_par04","Mensal","Mensal","Mensal","","","Anual","Anual","Anual","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegistros)
	If !dbSeek(cPerg+aRegistros[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegistros[i])
				FieldPut(j,aRegistros[i,j])
			Endif
		Next
		MsUnlock()
	//Else	
	//	RecLock("SX1",.F.)
	//	For j:=1 to FCount()
	//		If j <= Len(aRegistros[i])
	//			FieldPut(j,aRegistros[i,j])
	//		Endif
	//	Next
	//	MsUnlock()
	Endif
Next

RestArea(aArea)

Return(NIL)


USER FUNCTION BKCNR07(cNumMed,cTipo)
LOCAL cQuery,cMotivo := ""

cQuery := " SELECT CNR_DESCRI FROM "+RETSQLNAME("CNR")+" CNR WHERE CNR_NUMMED = '"+cNumMed+"' "
cQuery += "             AND  CNR_FILIAL = '"+xFilial("CNR")+"' AND  CNR.D_E_L_E_T_ = ' ' AND CNR_TIPO = '"+cTipo+"' "
TCQUERY cQuery NEW ALIAS "QTMP1"
dbSelectArea("QTMP1")
dbGoTop()
DO WHILE !EOF()
    cMotivo += ALLTRIM(QTMP1->CNR_DESCRI)+" "
	dbSelectArea("QTMP1")
	dbSkip()
ENDDO

QTMP1->(Dbclosearea())
Return cMotivo


//cQuery += "        (SELECT SUM(CNR_VALOR) FROM CNR010 CNR WHERE CND_NUMMED = CNR_NUMMED
//cQuery += "             AND  CNR_FILIAL = '"+xFilial("CNR")+"' AND  CNR.D_E_L_E_T_ = ' ' AND CNR_TIPO = '2') AS XX_MULTA,
//cQuery += " ORDER BY CNF_CONTRA,CNF_REVISA,CNF_COMPET,F2_DOC"  

                        
