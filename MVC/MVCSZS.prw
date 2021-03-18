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
	oBrowse:AddLegend( "SZS->ZS_STATUS == '1'", "GREEN",  "Nota Gerada" )
	oBrowse:AddLegend( "SZS->ZS_STATUS == '2'", "RED",    "Nota n�o Gerada" )
	
	//Filtrando
	//oBrowse:SetFilterDefault("SZS->SZS_COD >= '000000' .And. SZS->SZS_COD <= 'ZZZZZZ'")
	
	//Ativa a Browse
	oBrowse:Activate()
	
	SetFunName(cFunBkp)
	RestArea(aArea)
Return Nil

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  31/07/2016                                                   |
 | Desc:  Cria��o do menu MVC                                          |
 *---------------------------------------------------------------------*/

Static Function MenuDef()
	Local aRot := {}
	
	//Adicionando op��es
	ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.MVCSZS' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
	ADD OPTION aRot TITLE 'Legenda'    ACTION 'u_zSZSLeg'        OPERATION 6                      ACCESS 0 //OPERATION X
	ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.MVCSZS' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
	ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.MVCSZS' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
	ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.MVCSZS' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5

Return aRot

/*---------------------------------------------------------------------*
 | Func:  ModelDef                                                     |
 | Autor: Daniel Atilio                                                |
 | Data:  31/07/2016                                                   |
 | Desc:  Cria��o do modelo de dados MVC                               |
 *---------------------------------------------------------------------*/

Static Function ModelDef()
	//Cria��o do objeto do modelo de dados
	Local oModel := Nil
	
	//Cria��o da estrutura de dados utilizada na interface
	Local oStSZS := FWFormStruct(1, "SZS")
	
	//Editando caracter�sticas do dicion�rio
	//oStSZS:SetProperty('SZS_COD',   MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))                                 //Modo de Edi��o
	//oStSZS:SetProperty('SZS_COD',   MODEL_FIELD_INIT,    FwBuildFeature(STRUCT_FEATURE_INIPAD,  'GetSXENum("SZS", "SZS_COD")'))         //Ini Padr�o
	//oStSZS:SetProperty('SZS_DESC',  MODEL_FIELD_VALID,   FwBuildFeature(STRUCT_FEATURE_VALID,   'Iif(Empty(M->SZS_DESC), .F., .T.)'))   //Valida��o de Campo
	//oStSZS:SetProperty('SZS_DESC',  MODEL_FIELD_OBRIGAT, Iif(RetCodUsr()!='000000', .T., .F.) )                                         //Campo Obrigat�rio
	
	//Instanciando o modelo, n�o � recomendado colocar nome da user function (por causa do u_), respeitando 10 caracteres
	oModel := MPFormModel():New("MVCSZSM",/*bPre*/, /*bPos*/,/*bCommit*/,/*bCancel*/) 
	
	//Atribuindo formul�rios para o modelo
	oModel:AddFields("FORMSZS",/*cOwner*/,oStSZS)
	
	//Setando a chave prim�ria da rotina
	oModel:SetPrimaryKey({'ZS_FILIAL','ZS_FORNEC','ZS_LOJA'})
	
	//Adicionando descri��o ao modelo
	oModel:SetDescription("Modelo de Dados do Cadastro "+cTitulo)
	
	//Setando a descri��o do formul�rio
	oModel:GetModel("FORMSZS"):SetDescription("Formul�rio do Cadastro "+cTitulo)
Return oModel

/*---------------------------------------------------------------------*
 | Func:  ViewDef                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  31/07/2016                                                   |
 | Desc:  Cria��o da vis�o MVC                                         |
 *---------------------------------------------------------------------*/

Static Function ViewDef()
	//Local aStruSZS	:= SZS->(DbStruct())
	
	//Cria��o do objeto do modelo de dados da Interface do Cadastro de Autor/Interprete
	Local oModel := FWLoadModel("MVCSZS")
	
	//Cria��o da estrutura de dados utilizada na interface do cadastro de Autor
	Local oStSZS := FWFormStruct(2, "SZS")  //pode se usar um terceiro par�metro para filtrar os campos exibidos { |cCampo| cCampo $ 'SSZS_NOME|SSZS_DTAFAL|'}
	
	//Criando oView como nulo
	Local oView := Nil

	//Criando a view que ser� o retorno da fun��o e setando o modelo da rotina
	oView := FWFormView():New()
	oView:SetModel(oModel)
	
	//Atribuindo formul�rios para interface
	oView:AddField("VIEW_SZS", oStSZS, "FORMSZS")
	
	//Criando um container com nome tela com 100%
	oView:CreateHorizontalBox("TELA",100)
	
	//Colocando t�tulo do formul�rio
	oView:EnableTitleView('VIEW_SZS', 'Dados - '+cTitulo )  
	
	//For�a o fechamento da janela na confirma��o
	oView:SetCloseOnOk({||.T.})
	
	//O formul�rio da interface ser� colocado dentro do container
	oView:SetOwnerView("VIEW_SZS","TELA")
	
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

User Function zSZSLeg()
	Local aLegenda := {}
	
	//Monta as cores
	AADD(aLegenda,{"BR_VERDE",		"Nota Gerada"  })
	AADD(aLegenda,{"BR_VERMELHO",	"Nota n�o Gerada"})
	
	BrwLegenda(cTitulo, "Status", aLegenda)
Return
