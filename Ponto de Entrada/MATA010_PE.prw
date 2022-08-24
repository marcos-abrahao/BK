#Include "Protheus.ch" 
/*/{Protheus.doc} MATA010_PE
BK - Ponto de entrada MVC - Cadastro de Produtos
@Return
@author Marcos Bispo Abrah�o
@since 24/08/2022
@version P12.33
/*/
 
User Function ITEM() 
    Local aParam := PARAMIXB 
    Local xRet := .T. 
    Local oObj := Nil 
    Local cIdPonto := ""
    Local cIdModel := ""
    Local nOper := 0 
    Local cCod  := ""
    //Local cCampo := ""
    //Local cTipo := ""
    //Local lEnd

    Local oModel
    Local oModelSB1
 
    //Se tiver par�metros
    If aParam != Nil 
        ConOut("> "+aParam[2]) 
 
        //Pega informa��es dos par�metros
        oObj := aParam[1] 
        cIdPonto := aParam[2] 
        cIdModel := aParam[3] 
 
        //Valida a abertura da tela
        If cIdPonto == "MODELVLDACTIVE"
            xRet := .T. 
            //nOper := oObj:nOperation
 
            //Pr� configura��es do Modelo de Dados
        ElseIf cIdPonto == "MODELPRE"
            xRet := .T. 
 
            //Pr� configura��es do Formul�rio de Dados
        ElseIf cIdPonto == "FORMPRE"
            xRet := .T. 
 
            //nOper := oObj:GetModel(cIdPonto):nOperation
            //cTipo := aParam[4]
            //cCampo := aParam[5]
 
            //Se for Altera��o
            //If nOper == 4
            //N�o permite altera��o dos campos
            //    If cTipo == "CANSETVALUE" .And. Alltrim(cCampo) $ ("CAMPO1;CAMPO2;CAMPO3")
            //        xRet := .F.
            //    EndIf
            //EndIf
 
            //Adi��o de op��es no A��es Relacionadas dentro da tela

            // Copy
            /*
            If cIdModel == "SB1MASTER"
                oModelX := FwModelActive()// Instancia modelo ativo
                //oModelB1 := oModelX:GetModel("SB1MASTER") //Instancia sub-modelo SB1
                
                If oModelX:IsCopy() //Verifica se � uma opera��o de copia
                
                    // CUSTOMIZA��ES DO USU�RIO (VALIDA��O DE CAMPO, INSER��O DE VALORES E ETC)
                
                    //MsgInfo("FORMPRE - Opera��o de c�pia","MATA010_PE")
                    Public B1_XXCODCP := SB1->B1_COD
                    xRet := .T.//Mantem o retorno para valida��o FORMPOS como .T., alterar se for necess�rio 
                EndIf
            EndIf
            */

        ElseIf cIdPonto == "BUTTONBAR"
            xRet := {}
            //aAdd(xRet, {"* Titulo 1", "", {|| Alert("Bot�o 1")}, "Tooltip 1"})
            //aAdd(xRet, {"* Titulo 2", "", {|| Alert("Bot�o 2")}, "Tooltip 2"})
            //aAdd(xRet, {"* Titulo 3", "", {|| Alert("Bot�o 3")}, "Tooltip 3"})
 
            //P�s configura��es do Formul�rio
        ElseIf cIdPonto == "FORMPOS"
            nOper := oObj:GetModel(cIdPonto):nOperation
 
            xRet := .T. 
            /*
            If nOper == 3 .OR. nOper == 4
                //Valida��o ao clicar no Bot�o Confirmar
                oModel		:= FwModelActivate()
                oModelSB1	:= oModel:GetModel('SB1MASTER') 

                cPrefix    	:= ALLTRIM(oModelSB1:GetValue('B1_XPREFIX'))
                cEstruc    	:= ALLTRIM(oModelSB1:GetValue('B1_XESTRUC'))

                If cPrefix == "TOD" .AND. Empty(cEstruc)
                    MsgStop("Para produtos TOD, � obrigat�rio informar a Estrutura",cIdPonto)
                    xRet := .F.
                EndIf
            EndIf
            */
        ElseIf cIdPonto == "MODELPOS"
            xRet := .T. 
 
            //Pr� valida��es do Commit
        ElseIf cIdPonto == "FORMCOMMITTTSPRE"
 
            //P�s valida��es do Commit
        ElseIf cIdPonto == "FORMCOMMITTTSPOS"
 
            //Commit das opera��es (antes da grava��o)
        ElseIf cIdPonto == "MODELCOMMITTTS"
 
            //Commit das opera��es (ap�s a grava��o)
        ElseIf cIdPonto == "MODELCOMMITNTTS"
            nOper := oObj:nOperation

            oModel		:= FwModelActivate()
            oModelSB1	:= oModel:GetModel('SB1MASTER') 

            cCod   	:= ALLTRIM(oModelSB1:GetValue('B1_COD'))+"-"+ALLTRIM(oModelSB1:GetValue('B1_DESC'))

            //Mostrando mensagens no fim da opera��o
            
            If nOper == 3
                u_LogPrw("MATA010_PE","Inclus�o do produto "+cCod)                 
            ElseIf nOper == 4  
                u_LogPrw("MATA010_PE","Altera��o do produto "+cCod)                 
            ElseIf nOper == 5
                u_LogPrw("MATA010_PE","Exclus�o do produto "+cCod)                 
            Else
                u_LogPrw("MATA010_PE","Produto "+cCod+" opera��o "+STR(nOper))                 
            EndIf
            
        EndIf 
    EndIf 
Return xRet
