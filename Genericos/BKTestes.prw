#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*/
Programa     : Autor: Marcos B. Abrahao - Data: 29/01/2011
Objetivo     : Acertos diversos 
/*/


User Function BKTESTE()
u_BKFATR5A()
Return Nil


User Function BKTestes()
Private cRot  := PAD("U_BKTESTE",20)

@ 200,01 TO 330,450 DIALOG oDlg1 TITLE "Teste de User Functions"
@ 15,015 SAY "Func�o: "
@ 15,046 GET cRot SIZE 180,10

@ 30,015 SAY "Exemplos:"
@ 30,046 SAY "U_BKPARFIS,U_BKPARGEN,U_NIVERSADVPL,U_TSTYEXCEL"

@ 50,060 BMPBUTTON TYPE 01 ACTION ProcRot()   
@ 50,110 BMPBUTTON TYPE 02 ACTION Close(Odlg1)

ACTIVATE DIALOG oDlg1 CENTER

RETURN


Static FUNCTION ProcRot()
Local bError 
Private nProc := 0

cRot:= ALLTRIM(cRot)+"(@lEnd)"

If MsgBox("Confirma a execu��o do processo ?",cRot,"YESNO")
	//-> Recupera e/ou define um bloco de c�digo para ser avaliado quando ocorrer um erro em tempo de execu��o.
	//bError := ErrorBlock( {|e| cError := e:Description, Break(e) } ) //, Break(e) } )
		
	//-> Inicia sequencia.
	BEGIN SEQUENCE
      x:= &(cRot)
	//RECOVER
		//-> Recupera e apresenta o erro.
		//ErrorBlock( bError )
		//MsgStop( cError )
	END SEQUENCE

Endif   

If nProc > 0
   MsgBox("Registros processados: "+STR(nProc,6),cRot,"INFO")
EndIf

Close(oDlg1)
Return 

/*
Static Function FuncUser1()
Local lEnd := .F.
MsAguarde({|lEnd| FuncUser(@lEnd) },"Processando...",cRot,.T.)
Return

Static Function FuncUser(lEnd)

   dbSelectArea("SX5")
   dbSetOrder(1)
   dbGoTop()
   
   While !EOF()
      If lEnd
        MsgInfo(cCancel,"T�tulo da janela")
        Exit
      Endif
      MsProcTxt("Lendo tabela: "+SX5->X5_TABELA)
      ProcessMessage()
      dbSkip()

      nProc++

   End

Return lEnd
// fim do exemplo
*/



//#include 'protheus.ch'

User Function TmpTable()
Local aFields := {}
Local oTmpTb
Local nI
Local cAlias := "MEUALIAS"
Local cQuery

//-------------------
//Cria��o do objeto
//-------------------
oTmpTb := FWTemporaryTable():New( cAlias )

//--------------------------
//Monta os campos da tabela
//--------------------------
aadd(aFields,{"DESCR","C",30,0})
aadd(aFields,{"CONTR","N",3,1})
aadd(aFields,{"ALIAS","C",3,0})

oTmpTb:SetFields( aFields )
oTmpTb:AddIndex("indice1", {"DESCR"} )
oTmpTb:AddIndex("indice2", {"CONTR", "ALIAS"} )
//------------------
//Cria��o da tabela
//------------------
oTmpTb:Create()


Conout("Executando a c�pia dos registros da tabela: " + RetSqlName("CT0") )

//--------------------------------------------------------------------------
//Caso o INSERT INTO SELECT preencha todos os campos, este ser� um m�todo facilitador
//Caso contr�rio dever� ser chamado o InsertIntoSelect():
 // oTmpTb:InsertIntoSelect( {"DESCR", "CONTR" } , RetSqlName("CT0") , { "CT0_DESC", "CT0_CONTR" } )
//--------------------------------------------------------------------------
oTmpTb:InsertSelect( RetSqlName("CT0") , { "CT0_DESC", "CT0_CONTR", "CT0_ALIAS" } )


//------------------------------------
//Executa query para leitura da tabela
//------------------------------------
cQuery := "select * from "+ oTmpTb:GetRealName()
MPSysOpenQuery( cQuery, 'QRYTMP' )

DbSelectArea('QRYTMP')

while !eof()
	for nI := 1 to fcount()
		varinfo(fieldname(nI),fieldget(ni))
	next
	dbskip()
Enddo

	
//---------------------------------
//Exclui a tabela 
//---------------------------------
oTmpTb:Delete() 

return
