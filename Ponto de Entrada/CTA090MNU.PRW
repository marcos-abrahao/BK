#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWIZARD.CH"       


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CTA090MNU�Autor  �Adilson do Prado    � Data �  08/08/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto Baixa Cau��o Contrato                                ���
�������������������������������������������������������������������������͹��
���Uso       � BK                                                         ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function XXCTA090MNU()  //rotina desabilitada, corrigido padrao pela TOTVS - Adilson 19/05/2015

aRotina := {}

aRotina	:= { 	{ "Perquisar", "AxPesqui"  	 , 0, 1, 0, .F.},;	//"Pesquisar"
				{ "Visualizar", "CN090Manut" , 0, 2, 0, nil},;	//"Visualizar"
				{ "Incluir", "CN090Manut"    , 0, 3, 0, nil},;	//"Incluir"
				{ "Alterar", "CN090Manut"	 , 0, 4, 0, nil},;	//"Alterar"
				{ "Excluir", "CN090Manut"	 , 0, 5, 0, nil},;	//"Excluir"
				{ "Baixar", "U_CN090Bx_BK"	 , 0, 6, 0, nil} }	//"Baixar"	

Return Nil


/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun�ao    �CN090Bx    � Autor � Sergio Silveira       � Data �17/04/2006���
��������������������������������������������������������������������������Ĵ��
���Descri�ao � Baixa a caucao                                              ���
��������������������������������������������������������������������������Ĵ��
���Sintaxe   � ExpL1 := CN090Bx( ExpC1, ExpN2, ExpN3 )                     ���
��������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 -> Alias / ExpN2 -> Recno / ExpN3 -> Opcao do arotina ���
��������������������������������������������������������������������������Ĵ��
���Retorno   � ExpL1 -> .T. - Validacao / .F. - Insucesso                  ���
��������������������������������������������������������������������������Ĵ��
��� Uso      �                                                             ���
��������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.              ���
��������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                      ���
��������������������������������������������������������������������������Ĵ��
���            �        �      �                                           ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/

USER Function CN090Bx_BK(cAlias,nReg,nOpcx)

Local cPicValor  := PesqPict("CN8","CN8_VLEFET")
Local nOpcA      := 0
Local lCaucDinhe := .T.
Local lRet       := .T.
Local oBold


Private oDlg
Private nValorJur := 0
Private nValorResg := 0

If !Empty(CN8->CN8_DTBX)
	//Aviso( STR0026, STR0032, { STR0028 } ) // "Atencao", "Esta Cau��o j� esta Baixada.", "Ok"
	Aviso( "Atencao", "Esta Cau��o j� esta Baixada.", { "OK" } )
	
	lRet := .F.
EndIf

//�������������������������������������������������������Ŀ
//� verifica se existe contrato                           �
//���������������������������������������������������������

If lRet .And. !Empty(CN8->CN8_CONTRA)
	dbSelectArea("CN9")
	dbSetOrder(1)
	If !MsSeek(xFilial("CN9")+CN8->CN8_CONTRA)
		//Aviso( STR0026 , STR0033, { STR0028 } )  // "Atencao","Contrato n�o encontrado.", "Ok"
  		Aviso("Atencao","Contrato n�o encontrado.", {"Ok"})
		lRet := .F.
	EndIf
EndIf

//������������������������������������������������������������Ŀ
//� verifica se tipo de caucao eh dinheiro pra baixar a caucao �
//��������������������������������������������������������������
dbSelectArea("CN3")
dbSetOrder(1)
If lRet .And. CN3->( MsSeek(xFilial("CN3")+CN8->CN8_TPCAUC) )
	If !(CN3->CN3_LIGFIN = "1" .and. CN3->CN3_ABATI # "1")
		nValorResg := CN8->CN8_VLEFET
//		If Aviso( STR0026, STR0034,{ STR0035, STR0036 } ) <> 1 // "Atencao", "Confirma a Baixa da Cau��o?","Sim","Nao"
		If Aviso( "Atencao", "Confirma a Baixa da Cau��o?",{"Sim","Nao"} ) <> 1
			lRet := .F.
		EndIf
		lCaucDinhe := .F.
	EndIf
EndIf

//������������������������������������������������������������Ŀ
//� valor do resgate quando a cau��o for em dinheiro           �
//��������������������������������������������������������������
If lRet
	
	If lCaucDinhe
		
		//��������������Ŀ
		//� Monta a Tela �
		//����������������
		
//		DEFINE MSDIALOG oDlg TITLE STR0037 FROM 0,0 TO 280, 360 OF oMainWnd PIXEL // "Baixa da caucao"
		DEFINE MSDIALOG oDlg TITLE "Baixa da Cau��o" FROM 0,0 TO 280, 360 OF oMainWnd PIXEL // "Baixa da Cau��o"
		
		DEFINE FONT oBold NAME "Arial" SIZE 0, -13 BOLD
		
		@  0, -25 BITMAP oBmp RESNAME "PROJETOAP" oF oDlg SIZE 55, 1000 NOBORDER WHEN .F. PIXEL
		
//		@ 03, 40 SAY STR0037 FONT oBold PIXEL // "Baixa da caucao"
		@ 03, 40 SAY "Baixa da Cau��o" FONT oBold PIXEL // "Baixa da caucao"
		
		@ 14, 30 TO 16 ,400 LABEL '' OF oDlg   PIXEL
		
//		@ 30, 40 Say STR0038 Size 80,8 PIXEL // "Digite o Valor Total do Resgate"
		@ 30, 40 Say "Digite o Valor Total do Resgate" Size 80,8 PIXEL // "Digite o Valor Total do Resgate"
		
//		@ 45,  40 Say STR0039 Size 60,8 PIXEL // "C�digo da Cau��o :"
		@ 45,  40 Say "C�digo da Cau��o :" Size 60,8 PIXEL // "C�digo da Cau��o :"
		@ 45, 100 MsGet CN8->CN8_CODIGO SIZE 55,8 WHEN .F. PIXEL
		
//		@ 60,  40 Say STR0040 Size 60,8 PIXEL // "Valor Efetivo :"
		@ 60,  40 Say "Valor Efetivo :" Size 60,8 PIXEL // "Valor Efetivo :"
		@ 60, 100 MsGet CN8->CN8_VLEFET Picture cPicValor SIZE 55,8 WHEN .F. PIXEL
		
//		@ 75,  40 Say STR0041 Size 60,8 PIXEL // "Valor do Resgate :"
		@ 75,  40 Say "Valor do Resgate :" Size 60,8 PIXEL // "Valor do Resgate :"
		@ 75, 100 MsGet nValorResg Picture cPicValor Valid CN090VlBaix() SIZE 55,8 WHEN .T. PIXEL
		
//		@ 90,  40 Say STR0042 Size 60,8 Of oDlg PIXEL // "Valor dos Juros :"
		@ 90,  40 Say "Valor dos Juros :" Size 60,8 Of oDlg PIXEL // "Valor dos Juros :"
		@ 90, 100 MsGet nValorJur Picture cPicValor SIZE 55,8 WHEN .F. PIXEL
		
//		DEFINE SBUTTON FROM 110,090 TYPE 1 ACTION (nOpcA := 1,If( Aviso( STR0026, STR0034, { STR0035, STR0036 } )==1,; // "Atencao", "Confirma a Baixa da Cau��o?", Sim","Nao"
		DEFINE SBUTTON FROM 110,090 TYPE 1 ACTION (nOpcA := 1,If( Aviso( "Atencao", "Confirma a Baixa da Cau��o?", {"Sim","Nao"} )==1,;
		oDlg:End(), nOpcA:=0)) ENABLE OF oDlg
		DEFINE SBUTTON FROM 110,125 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
		
		ACTIVATE MSDIALOG oDlg CENTERED
		
		If nOpcA ==  1
			
			Begin Transaction
			
			//������������������������������������������������������������Ŀ
			//� Gera Titulo a Pagar/Receber para o total baixado           �
			//��������������������������������������������������������������    
//	      Processa({|| lRet := CN090GrPgto(CN8->CN8_VLEFET, nValorJur)},,If(!Empty(CN8->CN8_CLIENT),STR0044,STR0055)) // "Gerando Titulo a Pagar..."##"Gerando Titulo a Receber..."
	      Processa({|| lRet := CN090GrPgto(CN8->CN8_VLEFET, nValorJur)},,If(!Empty(CN8->CN8_CLIENT),"Gerando Titulo a Pagar...","Gerando Titulo a Receber...")) // "Gerando Titulo a Pagar..."##"Gerando Titulo a Receber..."
			
			If lRet
				If nValorJur > 0
					//������������������������������������������������������������Ŀ
					//� Gera a Movimentacao Bancaria de Entrada para os Juros      �
					//��������������������������������������������������������������
//					Processa({|| CN090MvEntr(nValorJur,NIL,.T.)},,STR0043) // "Gerando Movimento de Juros..."
					Processa({|| CN090MvEntr(nValorJur,NIL,.T.)},,"Gerando Movimento de Juros...") // "Gerando Movimento de Juros..."
				EndIf
							
				//������������������������������������������������������������Ŀ
				//� baixa a caucao                                             �
				//��������������������������������������������������������������
				dbSelectArea("CN8")
				dbSetOrder(1)
				RecLock("CN8",.F.)
				CN8->CN8_DTBX := dDataBase
				CN8->CN8_VLBX := nValorResg
				MsUnlock()
				
				//������������������������������������������������������������Ŀ
				//� contabilizar baixa caucao                                  �
				//��������������������������������������������������������������
				CN090Contab(3)
				
				If (__lSX8)
					ConfirmSX8()
				EndIf
				EvalTrigger()
			EndIf
			
			End Transaction
			
		Else
			lRet := .F.
		EndIf
	EndIf
	
	If lRet .And. !lCaucDinhe
		
		Begin transaction
		
		//������������������������������������������������������������Ŀ
		//� baixa a caucao                                             �
		//��������������������������������������������������������������
		dbSelectArea("CN8")
		dbSetOrder(1)
		RecLock("CN8",.F.)
		CN8->CN8_DTBX := dDataBase
		CN8->CN8_VLBX := nValorResg
		MsUnlock()
		
		//������������������������������������������������������������Ŀ
		//� contabilizar baixa caucao                                  �
		//��������������������������������������������������������������
		CN090Contab(3)
		
		End transaction
		
	EndIf
	
EndIf

return( lRet )
