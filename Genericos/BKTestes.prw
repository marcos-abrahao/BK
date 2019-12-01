#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*/
Programa     : Autor: Marcos B. Abrahao - Data: 29/01/2011
Objetivo     : Acertos diversos 
/*/

User Function BKTestes()
Private cRot  := PAD("U_TmpTable",20)

@ 200,01 TO 285,450 DIALOG oDlg1 TITLE "Teste de User Functions"
@ 15,015 SAY "Func�o: "
@ 15,046 GET cRot SIZE 180,10
@ 30,060 BMPBUTTON TYPE 01 ACTION ProcRot()   
@ 30,110 BMPBUTTON TYPE 02 ACTION Close(Odlg1)
ACTIVATE DIALOG oDlg1 CENTER

RETURN


Static FUNCTION ProcRot()
Private nProc := 0

cRot:= ALLTRIM(cRot)+"(@lEnd)"

If MsgBox("Confirma a execu��o do processo ?",cRot,"YESNO")
   x:= &(cRot)
Endif   

MsgBox("Registros processados: "+STR(nProc,6),cRot,"INFO")

Close(oDlg1)
Return 


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




//#include 'protheus.ch'

User Function TmpTable()
Local aFields := {}
Local oTempTable
Local nI
Local cAlias := "MEUALIAS"
Local cQuery

//-------------------
//Cria��o do objeto
//-------------------
oTempTable := FWTemporaryTable():New( cAlias )

//--------------------------
//Monta os campos da tabela
//--------------------------
aadd(aFields,{"DESCR","C",30,0})
aadd(aFields,{"CONTR","N",3,1})
aadd(aFields,{"ALIAS","C",3,0})

oTemptable:SetFields( aFields )
oTempTable:AddIndex("indice1", {"DESCR"} )
oTempTable:AddIndex("indice2", {"CONTR", "ALIAS"} )
//------------------
//Cria��o da tabela
//------------------
oTempTable:Create()


Conout("Executando a c�pia dos registros da tabela: " + RetSqlName("CT0") )

//--------------------------------------------------------------------------
//Caso o INSERT INTO SELECT preencha todos os campos, este ser� um m�todo facilitador
//Caso contr�rio dever� ser chamado o InsertIntoSelect():
 // oTempTable:InsertIntoSelect( {"DESCR", "CONTR" } , RetSqlName("CT0") , { "CT0_DESC", "CT0_CONTR" } )
//--------------------------------------------------------------------------
oTempTable:InsertSelect( RetSqlName("CT0") , { "CT0_DESC", "CT0_CONTR", "CT0_ALIAS" } )


//------------------------------------
//Executa query para leitura da tabela
//------------------------------------
cQuery := "select * from "+ oTempTable:GetRealName()
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
oTempTable:Delete() 

return

