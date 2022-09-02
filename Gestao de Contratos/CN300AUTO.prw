#Include "Protheus.CH"
#Include "FWMVCDEF.CH"
  
User Function CN300AUTO()
Local oModel    := Nil
Local cContra   := " < N�MERO_DO_CONTRATO > "
  
Local cTipRev   := "015" // N�MERO_DA_REVISAO_ABERTA
Local cJustific := "Justificativa da revis�o aberta do contrato"
//Local cCond     := "CONDICAO_DE_PAGAMENTO"
  
Local lRet      := .F.
  
//=== Prepara��o do contrato para revis�o =============================================================================================
CN9->(DBSetOrder(1))
If CN9->(DbSeek(xFilial("CN9")+cContra))             //- Posicionamento no contrato que ser� revisado.
      
    A300STpRev("G")                                 //- Define o tipo de revis�o que ser� realizado.
      
    oModel := FWLoadModel("CNTA300")                //- Carrega o modelo de dados do contrato.
    oModel:SetOperation(MODEL_OPERATION_INSERT)     //- Define opera��o do modelo. Ser� INSERIDA uma revis�o.
       
    oModel:Activate(.T.)                            //- Ativa o modelo. � necess�ria a utiliza��o do par�metro como true (.T.) para realizar uma copia.
  
  
    //=== Preenchimento das altera��es da revis�o. =======================================================================================
    //== Cabe�alho
    oModel:SetValue( 'CN9MASTER'    , 'CN9_TIPREV' , cTipRev)       //- � obrigat�rio o preenchimento do tipo de revis�o do contrato.
  
    oModel:SetValue( 'CN9MASTER'    , 'CN9_JUSTIF' , cJustific)    //- � obrigat�rio o preenchimento da justificativa de revis�o do contrato.
 
    //oModel:SetValue( 'CN9MASTER'    , 'CN9_CONDPG' , cCond)       //- Nesse exemplo, estamos utilizando a revis�o aberta para alterar a condi��o de pagamento
      
    //== Qualquer altera��o poss�vel na execu��o manual pode ser automatizada.
 
    oModel:SetValue( 'CXMDETAIL'    ,'CXM_VLMAX'   , 1000)       //- Alterando o valor m�ximo do agrupador de estoque
      
    //== Valida��o e Grava��o do Modelo
    lRet := oModel:VldData() .And. oModel:CommitData()
EndIf
   
Return lRet    
