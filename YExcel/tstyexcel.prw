#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} tstyexcel
Teste da classe YExcel
@author Saulo Gomes Martins
@since 08/05/2017

@type function
@obs para leitura ver fun��o YxlsRead no fim do fonte
/*/
user function tstyexcel()
	Local oExcel	:= YExcel():new()
	Local oAlinhamento,oQuebraTxt,o45Graus
	Local nPosCor,nPosFont,nPosFont2,nPosStyle,nPosMoeda,nPosMoeda2,nPosQuebra,nPosBorVerm,nPosBorda,nPosBorda2,nPosFonts,nPosBordas,nPosBorDt
	Local nPosCorEfe,nPosCorEf2,nFmtNum3,nPos3Dec
	Local nCont
	Local oDateTime
	oExcel:new("TstYExcel")
	oExcel:ADDPlan(/*cNome*/)		//Adiciona uma planilha em branco

	//Defini��o de Cor Transparecia+RGB
	nPosCor			:= oExcel:CorPreenc("FF0000FF")	//Cor de Fundo Azul
					//EfeitoPreenc(nAngulo,aCores,ctype,nleft,nright,ntop,nbottom)
	nPosCorEfe		:= oExcel:EfeitoPreenc(90,{{"FFFFFF",0},{"0072C4",1}})							//Efeito linear
	nPosCorEf2		:= oExcel:EfeitoPreenc(,{{"FFFFFF",0},{"0072C4",1}},"path",0.2,0.8,0.2,0.8)		//Efeito do centro

						//cHorizontal,cVertical,lReduzCaber,lQuebraTexto,ntextRotation
	oAlinhamento	:= oExcel:Alinhamento("center","center")
	oQuebraTxt		:= oExcel:Alinhamento(,,,.T.)
	o45Graus		:= oExcel:Alinhamento(,,,,45)
						//cTipo,cCor,cModelo
	nPosBorda		:= oExcel:Borda("ALL","FFFF0000","thick")
	nPosBorda2		:= oExcel:Borda("ALL")

						//nTamanho,cCorRGB,cNome,cfamily,cScheme,lNegrito,lItalico,lSublinhado,lTachado
	nPosFont		:= oExcel:AddFont(20,"FFFFFFFF","Calibri","2")
	nPosFont2		:= oExcel:AddFont(20,56,"Calibri","2",,.T.,.T.,.T.,.T.)

	nFmtNum3		:= oExcel:AddFmtNum(3/*nDecimal*/,.T./*lMilhar*/,/*cPrefixo*/,/*cSufixo*/,"("/*cNegINI*/,")"/*cNegFim*/,/*cValorZero*/,/*cCor*/,"Red"/*cCorNeg*/,/*nNumFmtId*/)

	nPosStyle	:= oExcel:AddStyles(/*numFmtId*/,nPosFont/*fontId*/,nPosCor/*fillId*/,nPosBorda/*borderId*/,/*xfId*/,{oAlinhamento})
	nPos3Dec	:= oExcel:AddStyles(nFmtNum3/*numFmtId*/,/*fontId*/,/*fillId*/,/*borderId*/,/*xfId*/,)
	nPosMoeda	:= oExcel:AddStyles(44/*numFmtId*/,/*fontId*/,/*fillId*/,/*borderId*/,/*xfId*/,{o45Graus})
	nPosMoeda2	:= oExcel:AddStyles(44/*numFmtId*/,/*fontId*/,/*fillId*/,nPosBorda2/*borderId*/,/*xfId*/)
	nPosQuebra	:= oExcel:AddStyles(/*numFmtId*/,/*fontId*/,/*fillId*/,/*borderId*/,/*xfId*/,{oQuebraTxt})
	nPosBorVerm	:= oExcel:AddStyles(/*numFmtId*/,/*fontId*/,/*fillId*/,nPosBorda/*borderId*/,/*xfId*/,{oQuebraTxt})
	nPosFonts	:= oExcel:AddStyles(/*numFmtId*/,nPosFont2/*fontId*/,/*fillId*/,/*borderId*/,/*xfId*/,)
	nPosBordas	:= oExcel:AddStyles(/*numFmtId*/,/*fontId*/,/*fillId*/,nPosBorda2/*borderId*/,/*xfId*/,)
	nPosBorDt	:= oExcel:AddStyles(14/*numFmtId*/,/*fontId*/,/*fillId*/,nPosBorda2/*borderId*/,/*xfId*/,)	//borda com data
	nPosEfe		:= oExcel:AddStyles(/*numFmtId*/,/*fontId*/,nPosCorEfe/*fillId*/,/*borderId*/,/*xfId*/,)
	nPosEfe2	:= oExcel:AddStyles(/*numFmtId*/,/*fontId*/,nPosCorEf2/*fillId*/,/*borderId*/,/*xfId*/,)

	//Defini o tamanho das colunas
	//Primeira_coluna,Ultima_coluna,Largura,AjusteNumero,customWidth
	oExcel:AddTamCol(1,2,12.00)
	oExcel:AddTamCol(3,3,20.00)
	oExcel:AddTamCol(4,4,12.00)
	oExcel:AddTamCol(5,6,18.00)

	//Cadastra imagem
	nIDImg		:= oExcel:ADDImg("LGMID01.PNG")	//Imagem no Protheus_data
	//If File("\Star_Wars_Logo.png")
	//	nIDImg		:= oExcel:ADDImg("\Star_Wars_Logo.png")	//Imagem no Protheus_data

				//nID,nLinha,nColuna,nX,nY,cUnidade,nRot
		oExcel:Img(nIDImg,7,7,200,121,/*"px"*/,)	//Usa imagem cadastrada
	//EndIf

	oExcel:Cell(1,1,"TESTE EXCEL",,nPosStyle)
	For nCont:=2 to 6
		oExcel:Cell(1,nCont,"",,nPosStyle)
	Next
	For nCont:=1 to 6
		oExcel:Cell(2,nCont,"",,nPosStyle)
	Next
	oExcel:mergeCells(1,1,2,6)						//Mescla as c�lulas A1:F2
	oExcel:Cell(3,1,100,,nPos3Dec)					//A3	Numero
	oExcel:Cell(3,2,2,"1+1")						//B3	Formula simples
	oExcel:Cell(3,4,-100.2,,nPos3Dec)				//D3	Numero negativo
	oExcel:AddNome("VALOR1",3,1)					//Defini nome da referencia de c�lula
	oExcel:Cell(4,1,102,"VALOR1+B3")				//A4	Formula com c�lulas
	oExcel:AddNome("VALORES",3,1,4,1)				//Defini o nome do intervalo
	oExcel:Cell(4,2,202,"SUM(VALORES)")				//B4	Formula com fun��es
	oExcel:Cell(5,1,"Ol� Mundo!",,nPosBorVerm)		//A5	Texto simples
	oExcel:Cell(5,2,date())							//B5	Data
	oExcel:Cell(5,3,.T.,,nPosEfe)					//C5	Campo Logico
	oExcel:Cell(5,4,1000,,nPosMoeda)				//D5	Campo Numerico formato moeda
	oDateTime	:= oExcel:GetDateTime(date(),time())	//Formatando DateTime
	oExcel:Cell(5,5,oDateTime)						//E5	Date time
	FreeObj(oDateTime)
	oExcel:nTamLinha	:= 30.75					//Defini o tamanho das proximas linha criadas
	oExcel:Cell(6,3,.F.,,nPosEfe2)					//C6	Campo Logico falso
	oExcel:Cell(6,5,"Texto grande para quebra em linhas",,nPosQuebra)	//E6	Texto grande
	oExcel:Cell(6,6,0,oExcel:Ref(3,1)+"+"+oExcel:Ref(3,2),)				//F6	Usando metodo RefSTR para localizar posi��o da celula
	oExcel:Cell(6,7,"Negrito,Italico,Sublinhado,Tachado",,nPosFonts)	//G6	Texto grande
	oExcel:nTamLinha	:= nil

	oExcel:Cell(7,1,"FORMATA��O CONDICIONAL")
	oExcel:mergeCells(7,1,7,3)
	oExcel:Cell(8,1,-10)
	oExcel:Cell(9,1,0)
	oExcel:Cell(10,1,5)
	oExcel:Cell(11,1,10)
	oExcel:Cell(12,1,20)
	oExcel:Cell(13,1,25)

	//FORMATA��O CONDICIONAL
	//Cria objetos para ser usado na formata��o
	oFont	:= oExcel:Font(12,"FFFFFF","Calibri","2",,.T.,.F.,.F.,.F.)	//Cor Branca Negrito
	oCorPre	:= oExcel:Preenc("FF0000")									//Fundo Vermelho
	oCorPre2:= oExcel:Preenc("00FF00")									//Fundo Verde
	oCorPre3:= oExcel:Preenc("FFFF00")									//Fundo Amarelo
	oBorda	:= oExcel:ObjBorda("ALL","000000")							//Borda Preta
	//Cria o Estilo			oFont,oCorPreenc,oBorda
	nPosVerm	:= oExcel:ADDdxf(oFont,oCorPre,oBorda)
	nPosVerd	:= oExcel:ADDdxf(oFont,oCorPre2,oBorda)
	nPosAmar	:= oExcel:ADDdxf(,oCorPre3,oBorda)
	//OBS: Os estilos s�o criados para worksheet do arquivo, podendo ser usado em outras planilhas(abas)

	//Cria as regras	cRefDe,cRefAte,nEstilo,operator,xFormula
	oExcel:FormatCond(oExcel:Ref(8,1),oExcel:Ref(13,1),nPosVerm,"<",0)				//Numero negativo em vermelho
	oExcel:FormatCond(oExcel:Ref(8,1),oExcel:Ref(13,1),nPosVerd,"between",{10,20})	//Entre 10 e 20
	oExcel:FormatCond(oExcel:Ref(8,1),oExcel:Ref(13,1),nPosAmar,"=","0")			//igual a zero


	//Teste de 50mil c�lulas - 20 segundos
	oExcel:ADDPlan("Teste","00AA00")		//Adiciona nova planilha

	If File("\Star_Wars_Logo.png")
		oExcel:Img(nIDImg,2,5,121,200,/*"px"*/,270)	//Usa imagem com rota��o de 270
	EndIf
	oExcel:SetDefRow(.T.,{1,4})	//Definir a coluna inicial e final da linha, importante para performace da classe
	oExcel:Cell(1,1,"Linha",,nPosBordas)
	oExcel:Cell(1,2,"Filial",,nPosBordas)
	oExcel:Cell(1,3,"Venda",,nPosBordas)
	oExcel:Cell(1,4,"Data Venda",,nPosBordas)
//	For nCont2:=5 to 50
//		oExcel:Cell(1,nCont2,"Coluna "+cValToChar(nCont2))
//	Next
	nCont2	:= 1
	cSubTotais	:= ""
	For nCont:=2 to 110
		oExcel:NivelLinha(1,,If(nCont2==1,.F.,.T.))	//NivelLinha(nNivel,lFechado,lOculto)
		oExcel:Cell(nCont,1,nCont,,nPosBordas)
		oExcel:Cell(nCont,2,"Filial "+cValToChar(nCont2),,nPosBordas)
		oExcel:Cell(nCont,3,Randomize(1,100),,nPosMoeda2)
		oExcel:Cell(nCont,4,date()+nCont,,nPosBorDt)
//		For nCont2:=5 to 50
//			oExcel:Cell(nCont,nCont2,nCont2)
//		Next
		If nCont % 10 ==0
			oExcel:AddNome("VENDA"+cValToChar(nCont2),nCont-8,3,nCont,3)
			nCont++
			oExcel:NivelLinha(nil,If(nCont2==1,.F.,.T.))
			oExcel:Cell(nCont,1,"Sub Total Filial "+cValToChar(nCont2),,nPosBordas)
			oExcel:Cell(nCont,3,0,"SUBTOTAL(9,VENDA"+cValToChar(nCont2)+")",nPosMoeda2)
			cSubTotais	+= oExcel:cPlanilhaAt+"!$C$"+cValToChar(nCont)+","
			nCont2++
		EndIf
	Next
	cSubTotais	:= SubStr(cSubTotais,1,Len(cSubTotais)-1)	//Teste!$C$11,Teste!$C$21,Teste!$C$31,Teste!$C$41,Teste!$C$51,Teste!$C$61,Teste!$C$71,Teste!$C$81,Teste!$C$91,Teste!$C$101,Teste!$C$111
	oExcel:AddNome("VENDA",,,,,cSubTotais)
	oExcel:Cell(nCont,1,"Total Geral",,nPosBordas)
	oExcel:Cell(nCont,3,0,"SUM(VENDA)",nPosMoeda2)

	oExcel:AutoFilter(1,1,nCont,4)	//Auto filtro
	oExcel:AddPane(1,1)	//Congela primeira linha e primeira coluna

	//TESTE COM FORMATAR COMO TABELA
	oExcel:ADDPlan("Tabela","0000FF")		//Adiciona nova planilha
	oExcel:SetPrintTitles(1,1)				//Linha de/ate que ir� repetir na impress�o de paginas
	oExcel:showGridLines(.F.)		//Oculta linhas de grade
	oExcel:SetDefRow(.T.,{1,4})		//Definir a coluna inicial e final da linha, importante para performace da classe
	//oExcel:Cell(1,1,"teste",,)
	oTabela	:= oExcel:AddTabela("Tabela1",1,1)	//Cria uma tabela de estilos
	oTabela:AddStyle("TableStyleMedium15"/*cNome*/,.T./*lLinhaTiras*/,/*lColTiras*/,/*lFormPrimCol*/,/*lFormUltCol*/)	//Cria os estilos,Cab:Preto|Linha:Cinza,Branco
	//oTabela:AddStyle("TableStyleMedium2"/*cNome*/,.T./*lLinhaTiras*/,/*lColTiras*/,.T./*lFormPrimCol*/,/*lFormUltCol*/)	//Cria os estilos,Cab:Azul|Linha:Azul,Branco
	oTabela:AddFilter()				//Adiciona filtros a tabela
	oTabela:AddColumn("Linha")		//Adiciona coluna Linha
	oTabela:AddColumn("Filial")		//Adiciona coluna Filial
	oTabela:AddColumn("Venda")		//Adiciona coluna Venda
	oTabela:AddColumn("Data Venda")	//Adiciona coluna Data Venda

	nTotalVenda	:= 0	//Valor Total da venda
	nCont2		:= 1	//Variavel de controle
	For nCont:=2 to 100
		oTabela:AddLine()				//Adiciona nova linha
		//Preenche as c�lulas
		oTabela:Cell("Linha",nCont,,)
		oTabela:Cell("Filial","Filial "+cValToChar(nCont2),,)
		nVenda		:= Randomize(1,100)
		nTotalVenda	+= nVenda
		oTabela:Cell("Venda",nVenda,,)
		oTabela:Cell(4,date()+nCont,,)
		If nCont % 10 ==0
			nCont2++
		EndIf
	Next
	oTabela:AddTotal("Linha","TOTAL","")							//Preenche texto TOTAL na linha totalizadora da coluna Linha
	oTabela:AddTotal("Filial",99,"SUBTOTAL(103,Tabela1[Filial])")	//Usa fun��o COUNTA(Contar Valores)
	oTabela:AddTotal("Venda",nTotalVenda,"SUM")		//Usa fun��o SUM(Somar) para totalizar a coluna venda
	oTabela:AddTotais()	//Adiciona linha de totais
	oTabela:Finish()	//Fecha a edi��o da tabela

	oExcel:Gravar(GetTempPath(),.T.,.T.)
return

User Function tst2Excel()
	Local nStart, nElapsed
	Local nMemIni,nMemCon

	conout( "FwMsExcel")
	nStart := Seconds()
	nMemIni	:= GetUserInfoArray()[1][12]
	TestFwMsExcel()
	nElapsed	:= Seconds() - nStart
	nMemCon		:= GetUserInfoArray()[1][12] - nMemIni
	ntam		:= Directory("Pasta2.xml","HSD")[1][2]
	conout( "Tempo: " + LTrim( Str( nElapsed ) ) + " segundos" )
	conout( "Memoria: " + LTrim( Str( Round(nMemCon/1024/1024,3) ) ) + " MB" )
	conout( "Tamanho Arquivo: " + LTrim( Str( Round(ntam/1024/1024,3) ) ) + " MB" )

	conout( "YExcel")
	nStart := Seconds()
	nMemIni	:= GetUserInfoArray()[1][12]
	Test2yExcel()
	nElapsed	:= Seconds() - nStart
	nMemCon		:= GetUserInfoArray()[1][12] - nMemIni
	ntam		:= Directory("c:\temp\Pasta1.xlsx","HSD")[1][2]
	conout( "Tempo: " + LTrim( Str( nElapsed ) ) + " segundos" )
	conout( "Memoria: " + LTrim( Str( Round(nMemCon/1024/1024,3) ) ) + " MB" )
	conout( "Tamanho Arquivo: " + LTrim( Str( Round(ntam/1024/1024,3) ) ) + " MB" )

	conout( "Treport")
	nStart := Seconds()
	nMemIni	:= GetUserInfoArray()[1][12]
	TestTreport()
	nElapsed	:= Seconds() - nStart
	nMemCon		:= GetUserInfoArray()[1][12] - nMemIni
	ntam		:= Directory("Pasta3.xml","HSD")[1][2]
	conout( "Tempo: " + LTrim( Str( nElapsed ) ) + " segundos" )
	conout( "Memoria: " + LTrim( Str( Round(nMemCon/1024/1024,3) ) ) + " MB" )
	conout( "Tamanho Arquivo: " + LTrim( Str( Round(ntam/1024/1024,3) ) ) + " MB" )
Return

Static Function TesteyExcel()
	Local nCont,nCont2
	Local oExcel		:= YExcel():new("Pasta1")
	Local nPosBorda2	:= oExcel:Borda("ALL")
	Local nPosBordas	:= oExcel:AddStyles(/*numFmtId*/,/*fontId*/,/*fillId*/,nPosBorda2/*borderId*/,/*xfId*/,)
	Local nPosMoeda2	:= oExcel:AddStyles(44/*numFmtId*/,/*fontId*/,/*fillId*/,nPosBorda2/*borderId*/,/*xfId*/)
	Local nPosBorDt		:= oExcel:AddStyles(14/*numFmtId*/,/*fontId*/,/*fillId*/,nPosBorda2/*borderId*/,/*xfId*/,)	//borda com data
	oExcel:ADDPlan(/*cNome*/)		//Adiciona uma planilha em branco
	oExcel:SetDefRow(.F.,{1,4})	//Definir a coluna inicial e final da linha, importante para performace da classe
	oExcel:Cell(1,1,"Linha",,nPosBordas)
	oExcel:Cell(1,2,"Filial",,nPosBordas)
	oExcel:Cell(1,3,"Venda",,nPosBordas)
	oExcel:Cell(1,4,"Data Venda",,nPosBordas)
	nCont2	:= 1
	cSubTotais	:= ""
	For nCont:=2 to 10000
		oExcel:Cell(nCont,1,nCont,,nPosBordas)
		oExcel:Cell(nCont,2,"Filial "+cValToChar(nCont2),,nPosBordas)
		oExcel:Cell(nCont,3,Randomize(1,100),,nPosMoeda2)
		oExcel:Cell(nCont,4,date()+nCont,,nPosBorDt)
	Next
	oExcel:Gravar("c:\temp",.F.,.T.)
Return

Static Function Test2yExcel()
	Local nCont,nCont2
	Local oExcel		:= YExcel():new("Pasta1")
	Local oTabela
	oExcel:ADDPlan(/*cNome*/)
	oExcel:SetDefRow(.T.,{1,4})		//Definir a coluna inicial e final da linha, importante para performace da classe
	oTabela	:= oExcel:AddTabela("Tabela1",1,1)	//Cria uma tabela de estilos
	oTabela:AddStyle("TableStyleMedium15"/*cNome*/,.T./*lLinhaTiras*/,/*lColTiras*/,/*lFormPrimCol*/,/*lFormUltCol*/)	//Cria os estilos,Cab:Preto|Linha:Cinza,Branco
	oTabela:AddFilter()				//Adiciona filtros a tabela
	oTabela:AddColumn("Linha")		//Adiciona coluna Linha
	oTabela:AddColumn("Filial")		//Adiciona coluna Filial
	oTabela:AddColumn("Venda")		//Adiciona coluna Venda
	oTabela:AddColumn("Data Venda")	//Adiciona coluna Data Venda

	nTotalVenda	:= 0	//Valor Total da venda
	nCont2		:= 1	//Variavel de controle
	For nCont:=2 to 10000
		oTabela:AddLine()				//Adiciona nova linha
		//Preenche as c�lulas
		oTabela:Cell("Linha",nCont,,)
		oTabela:Cell("Filial","Filial "+cValToChar(nCont2),,)
		nVenda		:= Randomize(1,100)
		nTotalVenda	+= nVenda
		oTabela:Cell("Venda",nVenda,,)
		oTabela:Cell(4,date()+nCont,,)
	Next
	oTabela:AddTotal("Linha","TOTAL","")							//Preenche texto TOTAL na linha totalizadora da coluna Linha
	oTabela:AddTotal("Filial",nCont-2,"SUBTOTAL(103,Tabela1[Filial])")	//Usa fun��o COUNTA(Contar Valores)
	oTabela:AddTotal("Venda",nTotalVenda,"SUM")		//Usa fun��o SUM(Somar) para totalizar a coluna venda
	oTabela:AddTotais()	//Adiciona linha de totais
	oTabela:Finish()	//Fecha a edi��o da tabela
	oExcel:Gravar("c:\temp",.F.,.T.)
Return

Static Function TestFwMsExcel()
	Local oExcel := FWMSEXCEL():New()
	Local nCont
	oExcel:AddworkSheet("Pasta2")
	oExcel:AddTable ("Pasta2","Tabela1")
	oExcel:AddColumn("Pasta2","Tabela1","Linha",1,1)
	oExcel:AddColumn("Pasta2","Tabela1","Filial",1,2)
	oExcel:AddColumn("Pasta2","Tabela1","Venda",1,3)
	oExcel:AddColumn("Pasta2","Tabela1","Data Venda",1,1)
	nTotalVenda	:= 0	//Valor Total da venda
	nCont2		:= 1	//Variavel de controle
	For nCont:=2 to 10000
		nVenda		:= Randomize(1,100)
		nTotalVenda	+= nVenda
		oExcel:AddRow("Pasta2","Tabela1",{nCont,"Filial "+cValToChar(nCont2),nVenda,date()+nCont})
	Next
	oExcel:AddRow("Pasta2","Tabela1",{"TOTAL",nCont-2,nTotalVenda,})

	oExcel:Activate()
	oExcel:GetXMLFile("Pasta2.xml")
Return

Static Function TestTreport()
	Local nCont
	RPCSetEnv("01","010101","","","","",{},,,.T.)
	oReport:= TReport():New("Excel","Excel Teste",nil, ,"")
	oSection1 := TRSection():New(oReport,"Estruturas",{"SG1","SC2","SB1","SB2"},/*Ordem*/) //"Estruturas"
	TRCell():New(oSection1,'Linha' 	,,"Linha"/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,'Filial'	,,"Filial"/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,'Venda' 	,,"Venda"/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,'Data' 	,,"Data Venda"/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	oReport:SetPreview(.F.)
	oReport:SetEnvironment(2)		//Server
	oReport:SetDevice(4)
	oReport:nDevice := 4			//Excel
	oReport:SetPreview(.F.)			//N�o visualiza
	oReport:cFile		:= "Pasta3.xml"	//Nome para gravar em disco
	oReport:Init()

	nTotalVenda	:= 0	//Valor Total da venda
	nCont2		:= 1	//Variavel de controle
	oSection1:Init()
	For nCont:=2 to 10000
		nVenda		:= Randomize(1,100)
		nTotalVenda	+= nVenda
		oSection1:Cell('Linha'):SetValue( nCont )
		oSection1:Cell('Filial'):SetValue( "Filial "+cValToChar(nCont2) )
		oSection1:Cell('Venda'):SetValue( nVenda )
		oSection1:Cell('Data'):SetValue( date()+nCont )
		oSection1:PrintLine()
	Next
	oSection1:Cell('Linha'):SetValue( "" )
	oSection1:Cell('Filial'):SetValue( "TOTAL")
	oSection1:Cell('Venda'):SetValue( nTotalVenda )
	oSection1:Cell('Data'):SetValue( "" )
	oSection1:PrintLine()
	oSection1:Finish()
	oReport:Finish()
	oReport:FreeAllObjs()
Return

/*/{Protheus.doc} YxlsRead
Testa leitura simples do xlsx
@author Saulo Gomes Martins
@since 03/03/2018
@version 1.0

@type function
/*/
User Function YxlsRead()
	Local oExcel	:= YExcel():new("TesteXlsx")	//Cria teste
	Local cTexto	:= "Texto teste"
	Local nNumero	:= 123.09
	Local lLogico	:= .T.
	Local dData		:= date()
	Local oDateTime := oExcel:GetDateTime(date(),time())	//Formatando DateTime
	Local nColuna,nLinha
	oExcel:ADDPlan()
	oExcel:Cell(1,1,cTexto,,)
	oExcel:Cell(2,1,nNumero,,)
	oExcel:Cell(3,1,lLogico,,)
	oExcel:Cell(4,1,dData,,)
	oExcel:Cell(5,1,oDateTime)
	oExcel:ADDPlan()
	oExcel:Cell(1,1,"OK",,)
	cArquivo	:= oExcel:Gravar(GetTempPath(),.F.)	//N�o abrir arquivo
	ConOut(cArquivo)
	oExcel	:= YExcel():new()
	oExcel:OpenRead(cArquivo)
	For nLinha	:= 1 to oExcel:adimension[1][1]
		For nColuna	:= 1 to oExcel:adimension[1][2]
			ConOut("Tipo:"+ValType(oExcel:CellRead(nLinha,nColuna)))
			ConOut(oExcel:CellRead(nLinha,nColuna))
		Next
		If nLinha==5
			oDateTime	:= oExcel:GetDateTime(,,oExcel:CellRead(nLinha,1))
			ConOut("Formato data")
			ConOut(oDateTime:GetDate())
			ConOut(oDateTime:GetTime())
			ConOut(oDateTime:GetStrNumber())
		EndIf
	Next
//	ConOut("Tipo:"+ValType(oExcel:CellRead(1,1)))
//	ConOut(oExcel:CellRead(1,1))
//	ConOut("Tipo:"+ValType(oExcel:CellRead(2,1)))
//	ConOut(oExcel:CellRead(2,1))
//	ConOut("Tipo:"+ValType(oExcel:CellRead(3,1)))
//	ConOut(oExcel:CellRead(3,1))
//	ConOut("Tipo:"+ValType(oExcel:CellRead(4,1)))
//	ConOut(oExcel:CellRead(4,1))
	ConOut("Ler planilha 2")
//	oExcel:OpenRead(cArquivo,2)
	For nLinha	:= 1 to oExcel:adimension[1][1]
		For nColuna	:= 1 to oExcel:adimension[1][2]
			ConOut("Tipo:"+ValType(oExcel:CellRead(nLinha,nColuna)))
			ConOut(oExcel:CellRead(nLinha,nColuna))
		Next
	Next
	ConOut("Tipo:"+ValType(oExcel:CellRead(1,1)))
	ConOut(oExcel:CellRead(1,1))
	oExcel:CloseRead()
	FreeObj(oDateTime)
Return


User Function yTstDB()
	Local aStruct	:= {}
	Local nH
	Local lSqlLite	:= .T.
	Local cAliasTMP
	aAdd(aStruct,{"LINHA"	,	"N", 10		, 00})
	aAdd(aStruct,{"COLUNA"	,	"N", 10		, 00})
	If TYPE("__TTSInUse")=="U"
		CriaPublica()
	EndIf
	If lSqlLite
		cAliasTMP	:= CriaTrab(,.F.)
		cRealName	:= cAliasTMP
		DBCreate( cAliasTMP , aStruct, 'SQLITE_TMP' ) // SQLLITE_MEM -> Mem�ria
		DBUseArea( .T., 'SQLITE_TMP', cRealName, cAliasTMP, .F., .F. )
	Else
		If !TCIsConnected()
			nH := TCLink()
			If nH < 0
			  MsgStop("DBAccess - Erro de conexao "+cValToChar(nH))
			  QUIT
			Endif
		EndIf
		oTabTmp	:= FWTemporaryTable():New( )
		oTabTmp:SetFields( aStruct )
		oTabTmp:Create()
		cAliasTMP	:= oTabTmp:GetAlias()
	EndIf

	RecLock(cAliasTMP,.T.)
	(cAliasTMP)->LINHA	:= 1
	(cAliasTMP)->COLUNA	:= 1
	MsUnLock()
	Alert((cAliasTMP)->LINHA)
	cQuery	:= "SELECT * FROM "+cRealName
//	MPSysOpenQuery(cQuery)

	DBSqlExec("QRY",cQuery,'SQLITE_TMP')

	Alert(QRY->LINHA)

	QRY->(DbCloseArea())
	(cAliasTMP)->(DbCloseArea())
	If lSqlLite
		DBSqlExec(cRealName, 'DROP TABLE ' + cRealName , 'SQLITE_TMP')
		//TCDelFile(cAliasTMP)
	Else
		oTabTmp:Delete()
	EndIf
Return