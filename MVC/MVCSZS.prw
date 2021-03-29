#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

//Vari�veis Est�ticas
Static cTitulo := "Facilitador Doc Entrada"

/*/{Protheus.doc} BkModSZS
Modelo 1 - Facilitador Doc Entrada 
@author Atilio
@since 31/07/2016
@version 1.0
	@return Nil, Fun��o n�o tem retorno
	@example
	u_MVCSZS()
/*/

User Function MVCSZS()
	Local aArea   := GetArea()
	Local oBrowse
	Local cFunBkp := FunName()
	
	SetFunName("MVCSZS")
	
	//Inst�nciando FWMBrowse - Somente com dicion�rio de dados
	oBrowse := FWMBrowse():New()
	
	//Setando a tabela de cadastro de Autor/Interprete
	oBrowse:SetAlias("SZS")

	//Setando a descri��o da rotina
	oBrowse:SetDescription(cTitulo)
	
	//Legendas
	// Setando Legenda cores dispon�veis: GREEN, RED, YELLOW, ORANGE, BLUE, GRAY, BROWNS, BLACK, PINK e WHITE
	// S�o criados filtros autom�ticos para as legendas
	oBrowse:AddLegend( "SZS->ZS_STATUS == '1'", "GREEN",  "Nota Gerada" )
	oBrowse:AddLegend( "SZS->ZS_STATUS == '2'", "RED",    "Nota n�o Gerada" )
	
	//Filtrando (n�o pode ser desabilitado pelo usu�rio)
	//oBrowse:SetFilterDefault("SZS->SZS_COD >= '000000' .And. SZS->SZS_COD <= 'ZZZZZZ'")
	
	//Ativa a Browse
	oBrowse:Activate()
	
	SetFunName(cFunBkp)
	RestArea(aArea)
Return Nil


// Defini��o do Menu MVC
Static Function MenuDef()
	Local aRot := {}
	
	//Adicionando op��es
	ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.MVCSZS' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
	ADD OPTION aRot TITLE 'Legenda'    ACTION 'u_SZSLeg'       OPERATION 6                      ACCESS 0 //OPERATION X
	ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.MVCSZS' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
	ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.MVCSZS' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
	ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.MVCSZS' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5

Return aRot


// ModelDef - Define as Regras de Neg�cios
// Cont�m:	Entidades envolvidas
//			Valida��es
//			Relacionamentos
//			Persist�ncia de dados
Static Function ModelDef()
	//Cria��o do objeto do modelo de dados
	Local oModel	:= Nil
	Local aGatilhos := {}
	//Local bPre 		:= {| | PreValid(oModel)}
	Local bPos		:= {|oModel| PosValid(oModel)}
	Local nI		:= 0
	
	//Cria��o da estrutura de dados utilizada na interface
	//Par�metro 1 (Model): traz todos os campos independente do n�vel, uso ou m�dulo
	Local oStSZS := FWFormStruct(1, "SZS")
	
	//Editando caracter�sticas do dicion�rio

	//Modo de Edi��o
	oStSZS:SetProperty('ZS_STATUS', MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))

	// Valida��o dos campos
	oStSZS:SetProperty('ZS_FORNEC', MODEL_FIELD_VALID,   FwBuildFeature(STRUCT_FEATURE_VALID,' ExistCpo("SA2",M->ZS_FORNEC+RTRIM(M->ZS_LOJA),,,,!EMPTY(M->ZS_LOJA))'))    //Valida��o de Campo
	oStSZS:SetProperty('ZS_COD',    MODEL_FIELD_VALID,   FwBuildFeature(STRUCT_FEATURE_VALID,' ExistCpo("SB1",M->ZS_COD)'))    //Valida��o de Campo
	oStSZS:SetProperty('ZS_CC',     MODEL_FIELD_VALID,   FwBuildFeature(STRUCT_FEATURE_VALID,' ExistCpo("CTT",M->ZS_CC)'))

	//oStSZS:SetProperty('SZS_COD',   MODEL_FIELD_INIT,    FwBuildFeature(STRUCT_FEATURE_INIPAD,  'GetSXENum("SZS", "SZS_COD")'))         //Ini Padr�o
	//oStSZS:SetProperty('SZS_DESC',  MODEL_FIELD_VALID,   FwBuildFeature(STRUCT_FEATURE_VALID,   'Iif(Empty(M->SZS_DESC), .F., .T.)'))   //Valida��o de Campo
	//oStSZS:SetProperty('SZS_DESC',  MODEL_FIELD_OBRIGAT, Iif(RetCodUsr()!='000000', .T., .F.) )                                         //Campo Obrigat�rio
	
	//Instanciando o modelo, n�o � recomendado colocar nome da user function (por causa do u_), respeitando 10 caracteres
	// MPFormModel � a classe utilizada para a cria��o de um objeto de modelo de dados
	// Ex:Loadmodel deve usar este ID (MVCSZSM)


	// Adicionar campos virtuais
	//-- Adiciona campos header do cronograma fisico
	oStSZS:AddField(	"Prox DOC?",;												// 	[01]  C   Titulo do campo	//"Redist. Val."
						"Sugere Pr�ximo Doc?",;										// 	[02]  C   ToolTip do campo	//"Redistribui��o de Valores"
						"ZS_PROXDOC",;												// 	[03]  C   Id do Field
						"C",;														// 	[04]  C   Tipo do campo
						1,;															// 	[05]  N   Tamanho do campo
						0,;															// 	[06]  N   Decimal do campo
						FwBuildFeature( STRUCT_FEATURE_VALID,"Pertence('SN')"),;	// 	[07]  B   Code-block de valida��o do campo
						{||.T.},;													// 	[08]  B   Code-block de valida��o When do campo
						{"S=Sim","N=N�o"},;										    //	[09]  A   Lista de valores permitido do campo	//{'1=Sim','2=N�o'}
						.F.,;														//	[10]  L   Indica se o campo tem preenchimento obrigat�rio
						FwBuildFeature( STRUCT_FEATURE_INIPAD, "'N'" ),;			//	[11]  B   Code-block de inicializacao do campo
						NIL,;														//	[12]  L   Indica se trata-se de um campo chave
						.F.,;														//	[13]  L   Indica se o campo pode receber valor em uma opera��o de update.
						.T.)														// 	[14]  L   Indica se o campo � virtual


	oModel := MPFormModel():New("MVCSZSM",/*bPre*/,bPos,/*bCommit*/,/*bCancel*/) 

	//Gatilhos:
	//Campo ZS_NOMEFOR virtual
	//aAdd(aGatilhos,FwStruTrigger("ZS_LOJA","ZS_NOMEFOR",'Posicione("SA2", 1, xFilial("SA2") + FwFldGet("ZS_FORNEC") + FwFldGet("ZS_LOJA"), "A2_NOME")'))
	aAdd(aGatilhos,FwStruTrigger("ZS_FORNEC","ZS_NOMEFOR","StaticCall(MVCSZS, GatForn)"))
	aAdd(aGatilhos,FwStruTrigger("ZS_LOJA","ZS_NOMEFOR","StaticCall(MVCSZS, GatForn)"))
	aAdd(aGatilhos,FwStruTrigger("ZS_PROXDOC","ZS_PROXDOC","StaticCall(MVCSZS, GatProx)"))


	//gatilho nome do produto
	//Campo ZS_DESCRPRD virtual
	aAdd(aGatilhos,FwStruTrigger("ZS_COD","ZS_DESCPRD","StaticCall(MVCSZS, GatProd)"))

	//gatilho nome do cc
	//Campo ZS_DESCCC virtual
	aAdd(aGatilhos,FwStruTrigger("ZS_CC","ZS_DESCCC",'Posicione("CTT", 1, xFilial("CTT") + FwFldGet("ZS_CC"), "CTT_DESC01")'))

	//gatilho zeros a esquerda Nr. Doc
	//oStSZS:AddTrigger('ZS_DOC'	 /*cIdField*/, 'ZS_DOC'	/*cTargetIdField*/, {||.T.} /*bPre*/,{||STRZERO(VAL(FwFldGet("ZS_DOC")),9)}/*bSetValue*/ )
	//Adicionando um gatilho, dele para ele mesmo
    aAdd(aGatilhos,FWStruTriggger("ZS_DOC",;                            //Campo Origem
                                  "ZS_DOC",;                            //Campo Destino
                                  "StaticCall(MVCSZS, GatDoc)",;        //Regra de Preenchimento
                                  .F.,;                                 //Ir� Posicionar?
                                  "",;                                  //Alias de Posicionamento
                                  0,;                                   //�ndice de Posicionamento
                                  '',;                                  //Chave de Posicionamento
                                  NIL,;                                 //Condi��o para execu��o do gatilho
                                  "01") )                               //Sequ�ncia do gatilho
 

    //Percorrendo os gatilhos e adicionando na Struct
    For nI := 1 To Len(aGatilhos)
        oStSZS:AddTrigger(  aGatilhos[nI][01],; //Campo Origem
                            aGatilhos[nI][02],; //Campo Destino
                            aGatilhos[nI][03],; //Bloco de c�digo na valida��o da execu��o do gatilho
                            aGatilhos[nI][04])  //Bloco de c�digo de execu��o do gatilho
    Next



	//Atribuindo formul�rios para o modelo
	oModel:AddFields("FORMSZS",/*cOwner*/,oStSZS)
	
	//Setando a chave prim�ria da rotina
	oModel:SetPrimaryKey({'ZS_FILIAL','ZS_FORNEC','ZS_LOJA'})
	
	//Adicionando descri��o ao modelo
	oModel:SetDescription("Modelo de Dados do Cadastro "+cTitulo)
	
	//Setando a descri��o do formul�rio
	oModel:GetModel("FORMSZS"):SetDescription("Formul�rio do Cadastro "+cTitulo)

	// Bloco a ser executado na ativa��o do modelo
	oModel:SetActivate({|oModel| SZSActiv(oModel)})

Return oModel



Static Function SZSActiv(oModel)
If oModel:GetOperation() == MODEL_OPERATION_UPDATE
	// LoadValue n�o valida e nem executa gatilhos
	// Na altera��o, mudar sempre o status para 2
	oModel:GetModel("FORMSZS"):LoadValue("ZS_STATUS", "2")
EndIf
Return


Static Function PosValid(oModel)
//Local oModel	:= FWModelActive()
Local cFornec	:= oModel:GetModel("FORMSZS"):GetValue("ZS_FORNEC")
Local cLoja		:= oModel:GetModel("FORMSZS"):GetValue("ZS_LOJA")
Local lRet 		:= .T.

If !ExistCpo("SA2",cFornec+cLoja)
	Help( ,, 'Help',, 'Fornecedor n�o encontrado',1,0)
	lRet := .F.
EndIf


Return lRet





// ViewDef: Respons�vel por renderizar o modelo de dados (Model)
//			Intera��o do usu�rio, visualiza��po dos dados
Static Function ViewDef()
	//Local aStruSZS	:= SZS->(DbStruct())
	
	//Cria��o do objeto do modelo de dados da Interface 
	//Par�metro 2 (View): traz todos os campos CONFORME n�vel, uso ou m�dulo
	Local oModel := FWLoadModel("MVCSZS")
	
	//Cria��o da estrutura de dados utilizada na interface do cadastro de Autor
	Local oStSZS := FWFormStruct(2, "SZS")  //pode se usar um terceiro par�metro para filtrar os campos exibidos { |cCampo| cCampo $ 'SSZS_NOME|SSZS_DTAFAL|'}
	
	//Criando oView como nulo
	Local oView := Nil

	//Adicionando campos virtuais
	oStSZS:AddField(	"ZS_PROXDOC",;					// [01]  C   Nome do Campo
						"06",;							// [02]  C   Ordem
						"Prox DOC?",;					// [03]  C   Titulo do campo	//"Redist. Val."
						"Sugere Pr�ximo Doc?",;			// [04]  C   Descricao do campo	//"Redistribui��o de Valores"
						{"Sugere Pr�ximo Doc?"},;		// [05]  A   Array com Help
						"C",;							// [06]  C   Tipo do campo
						"@!",;							// [07]  C   Picture
						NIL,;							// [08]  B   Bloco de Picture Var
						NIL,;							// [09]  C   Consulta F3
						.T.,;							// [10]  L   Indica se o campo � alteravel
						"1",;							// [11]  C   Pasta do campo
						"",;							// [12]  C   Agrupamento do campo
						{"S=Sim","N=N�o"},;				// [13]  A   Lista de valores permitido do campo (Combo)	//{'1=Sim','2=N�o'}
						NIL,;							// [14]  N   Tamanho maximo da maior op��o do combo
						NIL,;							// [15]  C   Inicializador de Browse
						.T.,;							// [16]  L   Indica se o campo � virtual
						NIL,;							// [17]  C   Picture Variavel
						NIL)							// [18]  L   Indica pulo de linha ap�s o campo


	//Criando a view que ser� o retorno da fun��o e setando o modelo da rotina
	oView := FWFormView():New()
	oView:SetModel(oModel)
	
	//Atribuindo formul�rios para interface (antiga Enchice)
	oView:AddField("VIEW_SZS", oStSZS, "FORMSZS")
	
	//Criando um container com nome tela com 100%
	oView:CreateHorizontalBox("TELA",100)
	
	//Colocando t�tulo do formul�rio
	oView:EnableTitleView('VIEW_SZS', 'Dados - '+cTitulo )  
	
	//For�a o fechamento da janela na confirma��o
	oView:SetCloseOnOk({||.T.})
	
	//O formul�rio da interface ser� colocado dentro do container
	oView:SetOwnerView("VIEW_SZS","TELA")

	//oView:SetFieldAction( 'ZS_COD' , {|| M->ZS_TES  := FExeTrg( 'B1_TE'  , 'ZS_COD' )} )


	/*
	//Tratativa para remover campos da visualiza��o
	For nAtual := 1 To Len(aStruSZS)
		cCampoAux := Alltrim(aStruSZS[nAtual][01])
		
		//Se o campo atual n�o estiver nos que forem considerados
		If Alltrim(cCampoAux) $ "SZS_COD;"
			oStSZS:RemoveField(cCampoAux)
		EndIf
	Next
	*/
Return oView


/*/{Protheus.doc} zSZSLeg
Fun��o para mostrar a legenda
@author Atilio
@since 31/07/2016
@version 1.0
	@example
	u_zSZSLeg()
/*/
User Function SZSLeg()
	Local aLegenda := {}
	
	//Monta as cores
	AADD(aLegenda,{"BR_VERDE",		"Nota Gerada"  })
	AADD(aLegenda,{"BR_VERMELHO",	"Nota n�o Gerada"})
	
	BrwLegenda(cTitulo, "Status", aLegenda)
Return



Static Function GatForn
Local oModel	:= FWModelActive()
Local cFornec	:= oModel:GetModel("FORMSZS"):GetValue("ZS_FORNEC")
Local cLoja		:= oModel:GetModel("FORMSZS"):GetValue("ZS_LOJA")
Local cNome		:= ""

If !Empty(cLoja)
	cNome := Posicione("SA2", 1, xFilial("SA2") + cFornec + cLoja, "A2_NOME")
EndIf
Return cNome



Static Function GatProx
Local oModel	:= FWModelActive()
Local cFornec	:= oModel:GetModel("FORMSZS"):GetValue("ZS_FORNEC")
Local cLoja		:= oModel:GetModel("FORMSZS"):GetValue("ZS_LOJA")
Local cPrxDoc	:= oModel:GetModel("FORMSZS"):GetValue("ZS_PROXDOC")
Local cNextDoc	:= ""
Local cNome		:= ""
Local cQuery 	:= ""
Local dIni   	:= dDataBase - 90
//Local nTotal 	:= 0
Local aArea  	:= {}
Local cTmpAlias	:= ""

If cPrxDoc == "S"
	cNome := Posicione("SA2", 1, xFilial("SA2") + cFornec + cLoja, "A2_NOME")
	If !Empty(cNome)

		aArea  	:= GetArea()
		cTmpAlias := GetNextAlias()

		cQuery  := "SELECT TOP 1 "+CRLF
		cQuery  += "  D1_DOC,"+CRLF
		cQuery  += "  D1_SERIE,"+CRLF
		cQuery  += "  D1_FORNECE,"+CRLF
		cQuery  += "  D1_LOJA,"+CRLF
		//cQuery  += "  D1_DTDIGIT,"+CRLF
		cQuery  += "  D1_COD,"+CRLF
		cQuery  += "  D1_TES,"+CRLF
		cQuery  += "  D1_CC,"+CRLF
		cQuery  += "  CONVERT(VARCHAR(6000),CONVERT(Binary(6000),D1_XXHIST)) D1_XXHIST,"+CRLF
		cQuery  += "  F1_ESPECIE,"+CRLF
		cQuery  += "  F1_COND,"+CRLF
		cQuery  += "  F1_VALBRUT,"+CRLF
		cQuery  += "  F1_XXPVPGT,"+CRLF
		cQuery  += "  F1_XTIPOPG,"+CRLF
		cQuery  += "  F1_XAGENC,"+CRLF
		cQuery  += "  F1_XBANCO,"+CRLF
		cQuery  += "  F1_XNUMCON,"+CRLF
		cQuery  += "  F1_XNUMPA,"+CRLF
		cQuery  += "  F1_XXJSPGT"+CRLF

		cQuery  += "FROM "+RETSQLNAME("SD1")+" SD1"+CRLF
		cQuery  += "  INNER JOIN "+RETSQLNAME("SF1")+" SF1 ON F1_FILIAL = D1_FILIAL AND F1_DOC = D1_DOC AND F1_SERIE = D1_SERIE AND F1_FORNECE = D1_FORNECE AND F1_LOJA = D1_LOJA AND F1_TIPO = D1_TIPO"
		cQuery  += "    AND SF1.D_E_L_E_T_ = ' ' "+CRLF  // AND F1_STATUS = 'A' 
		cQuery  += "  WHERE SD1.D_E_L_E_T_='' AND D1_FORNECE='"+cFornec+"' AND D1_LOJA='"+cLoja+"'"
		cQuery  += "    AND D1_DTDIGIT >='"+DTOS(dIni)+"'"
		cQuery  += " ORDER BY D1_DOC DESC"
		u_LogMemo("BKFINR28.SQL",cQuery)

		cQuery := ChangeQuery( cQuery )
		dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), cTmpAlias, .F., .T. )
		TCSetField( cTmpAlias, "F1_XXPVPGT", "D" )	

		If (cTmpAlias)->(!EOF())
			cNextDoc := STRZERO(VAL((cTmpAlias)->(D1_DOC))+1,TamSX3("ZS_DOC")[1])
			oModel:GetModel("FORMSZS"):LoadValue("ZS_DOC",cNextDoc)
			oModel:GetModel("FORMSZS"):SetValue("ZS_SERIE",(cTmpAlias)->(D1_SERIE))
			oModel:GetModel("FORMSZS"):SetValue("ZS_ESPECIE",(cTmpAlias)->(F1_ESPECIE))
			oModel:GetModel("FORMSZS"):SetValue("ZS_COND",(cTmpAlias)->(F1_COND))
			oModel:GetModel("FORMSZS"):SetValue("ZS_COD",(cTmpAlias)->(D1_COD))
			oModel:GetModel("FORMSZS"):SetValue("ZS_TES",(cTmpAlias)->(D1_TES))
			oModel:GetModel("FORMSZS"):SetValue("ZS_TOTAL",(cTmpAlias)->(F1_VALBRUT))
			oModel:GetModel("FORMSZS"):SetValue("ZS_CC",(cTmpAlias)->(D1_CC))
			oModel:GetModel("FORMSZS"):SetValue("ZS_XXHIST",(cTmpAlias)->(D1_XXHIST))

			oModel:GetModel("FORMSZS"):SetValue("ZS_XXPVPGT",MonthSum((cTmpAlias)->(F1_XXPVPGT),1))
			oModel:GetModel("FORMSZS"):SetValue("ZS_XTIPOPG",(cTmpAlias)->(F1_XTIPOPG))
			oModel:GetModel("FORMSZS"):SetValue("ZS_XAGENC",(cTmpAlias)->(F1_XAGENC))
			oModel:GetModel("FORMSZS"):SetValue("ZS_XBANCO",(cTmpAlias)->(F1_XBANCO))
			oModel:GetModel("FORMSZS"):SetValue("ZS_XNUMCON",(cTmpAlias)->(F1_XNUMCON))
			oModel:GetModel("FORMSZS"):SetValue("ZS_XNUMPA",(cTmpAlias)->(F1_XNUMPA))
			oModel:GetModel("FORMSZS"):SetValue("ZS_XXJSPGT",(cTmpAlias)->(F1_XXJSPGT))

		Else
			Help( ,, 'Help',, 'N�o foram encontrados documentos anteriores para este fornecedor',1,0)				
		EndIf

		(cTmpAlias)->(DbCloseArea())

		RestArea(aArea)

	EndIf

	//FwFldPut("ZS_PROXDOC","N"	,,,,.T.)
	oModel:GetModel("FORMSZS"):LoadValue("ZS_PROXDOC","N")

EndIf


Return "N"



// Preenche ZS_DOC com zeros a esquerda
Static Function GatDoc()
    Local cCampo    := "ZS_DOC"
    Local nTamanho  := TamSX3(cCampo)[1]
    Local cConteudo := STRZERO(VAL(AllTrim(FwFldGet(cCampo))), nTamanho)
    //Local cRetorno  := 'Grupo Teste'
 
    //Voc� pode usar o mesmo gatilho para atualizar outros campos com o FwFldPut
    FwFldPut(cCampo, cConteudo,,,, .T.)
Return cConteudo





Static Function GatProd()
Local oModel	:= FWModelActive()
Local cProd		:= oModel:GetModel("FORMSZS"):GetValue("ZS_COD")
Local cTes		:= oModel:GetModel("FORMSZS"):GetValue("ZS_TES")
Local cDesc		:= ""

If !Empty(cProd)
	cDesc := Posicione("SB1", 1, xFilial("SB1") + cProd, "B1_DESC")
	If Empty(cTes)
		oModel:GetModel("FORMSZS"):LoadValue("ZS_TES",SB1->B1_TE)
	EndIf
EndIf
Return cDesc




Static Function ExistDoc()
Local lOk     := .T.
Local cQuery1 := ""
Local cXDOC    := ""
Local cXSerie  := ""
Local cXFORNECE:= ""
Local cXLoja   := ""


cXDOC     := CNFISCAL
cXSerie   := CSERIE
cXFORNECE := CA100FOR
cXLoja    := IIF(!EMPTY(CLOJA),CLOJA,"01")
                                                     
cQuery1 := "SELECT F1_DOC,F1_SERIE"
cQuery1 += " FROM "+RETSQLNAME("SF1")+" SF1" 
cQuery1 += " WHERE SF1.D_E_L_E_T_='' AND SF1.F1_FILIAL='"+xFilial('SF1')+"'  AND SF1.F1_DOC='"+cXDOC+"' "
cQuery1 += " AND SF1.F1_FORNECE='"+cXFORNECE+"' AND SF1.F1_LOJA='"+cXLoja+"' AND SF1.F1_SERIE<>'"+cXSerie+"'"
        
cQuery1 := ChangeQuery( cQuery1 )
dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), "TMPSF1", .F., .T. )
        
dbSelectArea("TMPSF1")
TMPSF1->(dbGoTop())
DO While !TMPSF1->(EOF())
	lOk := .F.
	cXSerie := TMPSF1->F1_SERIE
	TMPSF1->(dbskip())
Enddo
TMPSF1->(DbCloseArea())

IF !lOk
	IF MSGNOYES("J� existe NF lan�ada para este Fornecedor com a SERIE: "+cXSerie+"!! Incluir assim mesmo?")
		lOk := .T.
	ENDIF
ENDIF

Return lOk




/*/{Protheus.doc} User Function MVCSZS
TESTE
@author Marcos Bispo Abrahao
@since 27/03/2021
@version 1.0
@type function
@obs Codigo gerado automaticamente pelo Autumn Code Maker
     *-------------------------------------------------*
     Por se tratar de um p.e. em MVC, salve o nome do 
     arquivo diferente, por exemplo, MVCSZS_pe.prw 
     *-----------------------------------------------*
     A documentacao de como fazer o p.e. esta disponivel em https://tdn.totvs.com/pages/releaseview.action?pageId=208345968 
@see http://autumncodemaker.com
/*/

User Function MVCSZSM()
	Local aArea := GetArea()
	Local aParam := PARAMIXB 
	Local xRet := .T.
	Local oObj := Nil
	Local cIdPonto := ""
	Local cIdModel := ""
	
	//Se tiver parametros
	If aParam != Nil
		
		//Pega informacoes dos parametros
		oObj := aParam[1]
		cIdPonto := aParam[2]
		cIdModel := aParam[3]
		
		//Antes da alteracao de qualquer campo do modelo 
		If cIdPonto == "MODELPRE" 
			xRet := .T. 
			
		//Antes da alteracao de qualquer campo do formulario 
		ElseIf cIdPonto == "FORMPRE" 
			xRet := .T. 
			
		//Na validacao total do modelo 
		ElseIf cIdPonto == "MODELPOS" 
			xRet := .T. 
			
		//Na validacao total do formulario 
		ElseIf cIdPonto == "FORMPOS" 
			xRet := .T. 
			
		//Antes da alteracao da linha do formulario FWFORMGRID 
		ElseIf cIdPonto == "FORMLINEPRE" 
			xRet := .T. 
			
		//Na validacao total da linha do formulario FWFORMGRID 
		ElseIf cIdPonto == "FORMLINEPOS" 
			xRet := .T. 
			
		//Apos a gravacao total do modelo e dentro da transacao 
		ElseIf cIdPonto == "MODELCOMMITTTS" 
			
		//Apos a gravacao total do modelo e fora da transacao 
		ElseIf cIdPonto == "MODELCOMMITNTTS" 
			
		//Antes da gravacao da tabela do formulario 
		ElseIf cIdPonto == "FORMCOMMITTTSPRE" 
			
		//Apos a gravacao da tabela do formulario 
		ElseIf cIdPonto == "FORMCOMMITTTSPOS" 
			
		//No cancelamento do botao 
		ElseIf cIdPonto == "MODELCANCEL" 
			xRet := .T. 
			
		//Para a inclusao de botoes na ControlBar 
		ElseIf cIdPonto == "BUTTONBAR" 
			xRet := {} 
			
		EndIf
		
	EndIf
	
	RestArea(aArea)
Return xRet
