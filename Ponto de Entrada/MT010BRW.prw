#include "protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT010BRW �Autor  �Marcos B. Abrahao   � Data �  23/03/17   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada para criar op��es na tela de Func�es      ���
���          � no cadstro de produtos                                     ���
�������������������������������������������������������������������������͹��
���Uso       � BK                                                         ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MT010BRW() 
Local aRotY

AADD( aRotina, {OemToAnsi("Copiar p/ outras empresas"), "U_BKMAT010", 0, 4 } )

Return aRotY




// Incluir DNF na BK
User Function BKMAT010()
Local sAlias	  
Local aAreaAtu	  
Local aParametros := {}
Local aProd       := {}
Local cRetorno    := ""
Local cUsuario    := __cUserId
Local cSuper	  := "" 
Local aEmpr       := {}

If msgYesNo('Deseja incluir este produto em outras empresas?')
	
    aProd := {{"B1_TIPO"    ,SB1->B1_TIPO        ,Nil},;      
	          {"B1_COD"     ,SB1->B1_COD         ,Nil},;
	          {"B1_DESC"    ,SB1->B1_DESC        ,Nil},;                      
	          {"B1_UM"      ,SB1->B1_UM          ,Nil},;
	          {"B1_LOCPAD"  ,SB1->B1_LOCPAD      ,Nil},;                      
	          {"B1_GRUPO"   ,SB1->B1_GRUPO       ,Nil},;                      
	          {"B1_XXSGRP"  ,SB1->B1_XXSGRP      ,Nil},;                      
	          {"B1_CONTA"   ,SB1->B1_CONTA       ,Nil}}                      
                                   

	aParametros := {"11","01",aProd,cUsuario,cSuper}

		
	// Inicia o Job
	sAlias	  := Alias()
	aAreaAtu  := GetArea()
	nRecNo    := RECNO()

	aEmpr := U_EscEmpresa()
	For nI := 1 TO LEN(aEmpr)
	    
	    aParametros[1] := aEmpr[nI,1]
	    aParametros[2] := aEmpr[nI,2]
	    
		cRetorno := ""
		MsgRun("incluindo produto na empresa "+TRIM(aEmpr[nI,4])+", aguarde...","",{|| CursorWait(), cRetorno := StartJob("U_BKMATJ10",GetEnvServer(),.T.,aParametros) ,CursorArrow()})
        
		IF VALTYPE(cRetorno) <> "C"
			MsgStop("Erro provavelmente ocorrido por se ter excedido o n�mero de licen�as, tente novamente mais tarde.", "Aten��o")
		ELSE
			IF SUBSTR(cRetorno,1,2) <> "OK"
				If !EMPTY(cRetorno)
					MsgStop("Erro ao incluir o produto na empresa "+TRIM(aEmpr[nI,4]), "Aten��o")
					MsgStop(cRetorno, "Aten��o")
				Else
					MsgStop("Produto n�o inclu�do na empresa "+TRIM(aEmpr[nI,4]), "Aten��o")
				EndIf
			ENDIF
		ENDIF

	Next
	RestArea( aAreaAtu )

	dbSelectArea(sAlias)
	dbGoTo(nRecNo)
	
EndIf

Return



// Esta funcao e a funcao chamada pela funcao StartJob
// Erros desta fun��o somente aparecem no log do console do servidor
User Function BKMATJ10(_aParametros)

Local _cEmpresa  := _aParametros[1] // Usar o paramixb
Local _cFilial   := _aParametros[2]
Local _aProd     := _aParametros[3]
Local _cUsuario  := _aParametros[4]
Local _cSuper 	 := _aParametros[5]

Local cErro      := ""
Local cRetorno   := _aProd[2,2]
//Local aUser		 := {}

//RpcSetType(3)

// Prepara a empresa BK
//PREPARE ENVIRONMENT EMPRESA _cEmpresa FILIAL _cFilial TABLES "SF1","SD1"
RpcSetEnv( _cEmpresa, _cFilial )

lMsErroAuto := .F.    
          
MSExecAuto({|x,y| Mata010(x,y)},_aProd,3) //Inclus�o 

Conout(DtoC(Date())+" "+Time()+" "+__cUserId+": BKMATJ10 - Empresa: "+_cEmpresa+" - Produto: "+cRetorno)

If lMsErroAuto
    MostraErro() 
 	// Fun��o que retorna o evento de erro na forma de um array
	aAutoErro := GETAUTOGRLOG()
	cErro := (XCONVERRLOG(aAutoErro))
	Conout("BKMATJ10 - Erro em MSExecAuto: "+cErro)
	cRetorno := cErro
	lRet := .F.
Else
	cRetorno := "OK"
	Conout(DTOC(date())+' '+TIME()+" BKMATJ10 - Produto "+cRetorno)
EndIf

RpcClearEnv()
  
Return cRetorno



/*/
+-----------------------------------------------------------------------
| Fun��o | XCONVERRLOG | Autor | Arnaldo R. Junior | Data | |
+-----------------------------------------------------------------------
| Descri��o | CONVERTE O ARRAY AAUTOERRO EM TEXTO CONTINUO. |
+-----------------------------------------------------------------------
| Uso | Curso ADVPL |
+-----------------------------------------------------------------------
/*/
STATIC FUNCTION XCONVERRLOG(aAutoErro)
LOCAL cRet := ""
LOCAL nX := 1
FOR nX := 1 to Len(aAutoErro)
	cRet += aAutoErro[nX]+CHR(13)+CHR(10)
NEXT nX
RETURN cRet
