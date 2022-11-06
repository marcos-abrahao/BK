#Include "Protheus.CH"
#Include "FWMVCDEF.CH"
  
User Function CN300AUTO()
Local oModel    := Nil
Local cContra   := "005000114"
  
Local cTipRev   := "015" // N�MERO_DA_REVISAO_ABERTA
Local cJustific := "Justificativa da revis�o aberta do contrato"
//Local cCond     := "CONDICAO_DE_PAGAMENTO"
  
Local lRet      := .F.
  
//=== Prepara��o do contrato para revis�o =============================================================================================
DbSelectArea("CN9")
CN9->(DBSetOrder(1))
If CN9->(DbSeek(xFilial("CN9")+cContra))             //- Posicionamento no contrato que ser� revisado.
    Do While !EOF() .AND. TRIM(CN9_NUMERO) == cContra .AND. !EMPTY(CN9->CN9_REVATU)
        dbSkip()
    EndDo
EndIf

If TRIM(CN9_NUMERO) == cContra .AND. EMPTY(CN9->CN9_REVATU)

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
 
    //oModel:SetValue( 'CXMDETAIL'    ,'CXM_VLMAX'   , 1000)       //- Alterando o valor m�ximo do agrupador de estoque

    oModelCNA:= oModel:getModel("CNADETAIL")
    oModelCNB:= oModel:getModel("CNBDETAIL")


    //Setando a linha atual das Planilhas
    oModelCNA:AddLine()
    //nLin := Len(oModelGrid:aCols)
    oModelCNA:SetValue("CNADETAIL", 'CNA_XXMOT', 'Motivo teste') 
    //oModelCNA:SetValue("CNADETAIL", 'A5_NOMPROD', oDet[nX]:_Prod:_xProd:TEXT)            
    oModelCNA:SetValue("CNADETAIL", 'CNA_CLIENT', '000005') 
    oModelCNA:SetValue("CNADETAIL", 'CNA_LOJACL', '01') 
    oModelCNA:SetValue("CNADETAIL", 'CNA_TIPPLA', '001') 
    oModelCNA:SetValue("CNADETAIL", 'CNA_FLREAJ', '2') 
    oModelCNA:SetValue("CNADETAIL", 'CNA_XXTPNF', 'N') 
    oModelCNA:SetValue("CNADETAIL", 'CNA_XXUF', 'SP') 
    oModelCNA:SetValue("CNADETAIL", 'CNA_XXCMUN', '50308') 
    oModelCNA:SetValue("CNADETAIL", 'CNA_XXMUN', 'SAO PAULO - TESTE') 
    //oModelCNA:SetValue("CNADETAIL", 'CNA_XXRISS', ' ') 
    oModelCNA:SetValue("CNADETAIL", 'CNA_XXTIPO', '2') 
    //oModelCNA:SetValue("CNADETAIL", 'CNA_XXNAT', ' ') 

    oModelCNB:AddLine()
    oModelCNB:SetValue("CNBDETAIL", 'CNB_PRODUT', '000000000000068') 
    oModelCNB:SetValue("CNBDETAIL", 'CNB_QUANT', 12) 
    oModelCNB:SetValue("CNBDETAIL", 'CNB_VLUNIT', 1000) 

    //== Valida��o e Grava��o do Modelo
    lRet := oModel:VldData() 
    If lRet
        lRet := oModel:CommitData()
    Endif
else
    MsgStop("Contrato n�o encontrado")
EndIf
   
Return lRet    
