#INCLUDE "CTBR010.CH"
#INCLUDE "PROTHEUS.CH"


// 17/08/2009 -- Filial com mais de 2 caracteres

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � Ctbr010  � Autor � Pilar S Albaladejo    � Data � 10/01/00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Programa de Impressao do Plano de Contas              	  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � Ctbr010()                                                  ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SIGACTB                                                    ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
USER Function Ctbr010(lTReport)

Private titulo		:= ""
Private nomeprog	:= "CTBR010"
Private oTmpTb

Default lTReport := .F.

CtAjustSx1( "CTR010" )

If lTReport .Or. (FindFunction( "TRepInUse" ) .And. TRepInUse()) 
	CTBR010R4()
Else
	Return CTBR010R3()
EndIf

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � CTBR010R4 � Autor� Daniel Sakavicius		� Data � 01/08/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Programa de Impressao do Plano de Contas - R4			  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe	 � CTBR010R4												  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � SIGACTB                                    				  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
STATIC Function CTBR010R4( cMoeda )
Local oReport
Local lExterno	:= ( cMoeda <> Nil )

//������������������������������������������������������������������������Ŀ
//�Interface de impressao                                                  �
//��������������������������������������������������������������������������
oReport := ReportDef()

If ValType( oReport ) == "O"

	If ! Empty( oReport:uParam )
		Pergunte( oReport:uParam, .F. )
	EndIf	
	
	If ! lExterno
		oReport :PrintDialog()
	Else               
	    mv_par06 := iif( ! Empty( cMoeda ) , cMoeda , '01' )
	
	    // faz a impress�o do relatorio
	    oReport:Print()
	EndIf
Endif	

oReport := Nil

Return                                

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportDef � Autor � Daniel Sakavicius		� Data � 01/08/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Esta funcao tem como objetivo definir as secoes, celulas,   ���
���          �totalizadores do relatorio que poderao ser configurados     ���
���          �pelo relatorio.                                             ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � SIGACTB                                    				  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportDef()
Local cReport		:= "CTBR010"
Local cTitulo		:= STR0008				   			// "Listagem do Plano de Contas"
Local cDesc			:= STR0001//+STR002+STR003			// "Este programa ir� imprimir o Plano de Contas."
Local cPerg	   		:= "CTR010"			  
Local aOrdem 		:= {"Codigo","Descricao"}	// Cod,Descricao"       
Local cSeparador	:= "" 
Local aTamConta		:= TAMSX3("CT1_CONTA")
Local aTamDesc01	:= TAMSX3("CT1_DESC01")

*����������������������������������������������������������Ŀ
*�Add por Icaro Queiroz | Claudio - em 24 de Agosto de 2010 �
*�Variaveis para tratamento de tipificacao - CTBR015        �
*������������������������������������������������������������
Local bTitulo		:= { |cCampo| SX3->( dbSetOrder(2) ), SX3->( MsSeek( cCampo ) ), X3Titulo() }
Local cTitCpo
Local oSection11


//������������������������������������������������������������������������Ŀ
//�Criacao do componente de impressao                                      �
//�                                                                        �
//�TReport():New                                                           �
//�ExpC1 : Nome do relatorio                                               �
//�ExpC2 : Titulo                                                          �
//�ExpC3 : Pergunte                                                        �
//�ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  �
//�ExpC5 : Descricao                                                       �
//��������������������������������������������������������������������������
oReport	:= TReport():New( cReport,cTitulo,cPerg, { |oReport| ReportPrint( oReport ) }, cDesc ) 

//������������������������������������������������������������������������Ŀ
//�Criacao da secao utilizada pelo relatorio                               �
//�                                                                        �
//�TRSection():New                                                         �
//�ExpO1 : Objeto TReport que a secao pertence                             �
//�ExpC2 : Descricao da se�ao                                              �
//�ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   �
//�        sera considerada como principal para a se��o.                   �
//�ExpA4 : Array com as Ordens do relat�rio                                �
//�ExpL5 : Carrega campos do SX3 como celulas                              �
//�        Default : False                                                 �
//�ExpL6 : Carrega ordens do Sindex                                        �
//�        Default : False                                                 �
//�                                                                        �
//��������������������������������������������������������������������������
oSection1  := TRSection():New( oReport, STR0028, {"CT1"}, aOrdem, .F., .F. ) //"Conta Cont�bil"

TRCell():New( oSection1, "CCONTACT1"	,	   ,STR0009/*Titulo*/,/*Picture*/,aTamConta[1]/*Tamanho*/,/*lPixel*/,{|| EntidadeCTB(CT1->CT1_CONTA ,0,0,70,.F.,iif( Empty( mv_par08 ) , GetMv("MV_MASCARA") , RetMasCtb( mv_par08,@cSeparador) ) ,cSeparador,,,,,.F.) }/*CodeBlock*/)
TRCell():New( oSection1, "CT1_DC"		,"CT1" ,STR0019/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)
TRCell():New( oSection1, "CT1_RES"		,"CT1" ,STR0020/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)

TRCell():New( oSection1, "CT1_DESC01"	,"CT1" ,STR0021/*Titulo*/,/*Picture*/,aTamDesc01[1]+10,/*lPixel*/,{||If( ! Empty( mv_par06 ) , &("CT1_DESC" + mv_par06 ) , CT1->CT1_DESC01)})

TRCell():New( oSection1, "CT1_CLASSE"	,"CT1" ,STR0022/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)
TRCell():New( oSection1, "CT1_NORMAL"	,"CT1" ,STR0023/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)
TRCell():New( oSection1, "CT1_CTASUP"	,"CT1" ,STR0024/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)
TRCell():New( oSection1, "CT1_BLOQ"		,"CT1" ,STR0025/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)

*���������������������������������������������������������������Ŀ
*�Add por Icaro Queiroz | Claudio - em 24 de Agosto de 2010      �
*�Caso seja chamado do CTBR015, imprime as calunas de tipificacao�
*�����������������������������������������������������������������
If Upper( FunName() ) == 'CTBR015'
	If 	CT1->( FieldPos( "CT1_TPO01" ) ) > 0 .And.;
		CT1->( FieldPos( "CT1_TPO02" ) ) > 0 .And.;
		CT1->( FieldPos( "CT1_TPO03" ) ) > 0 .And.;
		CT1->( FieldPos( "CT1_TPO04" ) ) > 0

		oSection11  := TRSection():New( oSection1, "TipificaIII", {"CT1"}, aOrdem, .F., .F. ) //"Conta Cont�bil"

		If MV_TPO01 > 0
			cTitCpo := Eval( bTitulo, ( "CT1_TPO" + StrZero( MV_TPO01, 2 ) ) )
			TRCell():New( oSection11, "CT1_TPO01"		,"CT1" , cTitCpo,/*Picture*/,/*Tamanho*/,/*lPixel*/, { || &( "CT1->CT1_TPO" + StrZero( MV_TPO01, 2 ) ) } )
			oSection11:Cell( 'CT1_TPO01' ):SetHeaderAlign( 'LEFT' )
		EndIf

		If MV_TPO02 > 0
			cTitCpo := Eval( bTitulo, ( "CT1_TPO" + StrZero( MV_TPO02, 2 ) ) )
			TRCell():New( oSection11, "CT1_TPO02"		,"CT1" , cTitCpo,/*Picture*/,/*Tamanho*/,/*lPixel*/, { || &( "CT1->CT1_TPO" + StrZero( MV_TPO02, 2 ) ) } )
			oSection11:Cell( 'CT1_TPO02' ):SetHeaderAlign( 'LEFT' )
		EndIF

		If MV_TPO03 > 0
			cTitCpo := Eval( bTitulo, ( "CT1_TPO" + StrZero( MV_TPO03, 2 ) ) )
			TRCell():New( oSection11, "CT1_TPO03"		,"CT1" , cTitCpo,/*Picture*/,/*Tamanho*/,/*lPixel*/, { || &( "CT1->CT1_TPO" + StrZero( MV_TPO03, 2 ) ) } )
			oSection11:Cell( 'CT1_TPO03' ):SetHeaderAlign( 'LEFT' )
		EndIf

		If MV_TPO04 > 0
			cTitCpo := Eval( bTitulo, ( "CT1_TPO" + StrZero( MV_TPO04, 2 ) ) )
			TRCell():New( oSection11, "CT1_TPO04"		,"CT1" , cTitCpo,/*Picture*/,/*Tamanho*/,/*lPixel*/, { || &( "CT1->CT1_TPO" + StrZero( MV_TPO04, 2 ) ) } )
			oSection11:Cell( 'CT1_TPO04' ):SetHeaderAlign( 'LEFT' )
		EndIf

	Endif	
EndIf
oSection1:SetTotalInLine(.F.)

Return(oReport)   

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrint� Autor � Daniel Sakavicius	� Data � 01/08/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Imprime o relatorio definido pelo usuario de acordo com as  ���
���          �secoes/celulas criadas na funcao ReportDef definida acima.  ���
���          �Nesta funcao deve ser criada a query das secoes se SQL ou   ���
���          �definido o relacionamento e filtros das tabelas em CodeBase.���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ReportPrint(oReport)                                       ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �EXPO1: Objeto do relat�rio                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ReportPrint( oReport )
Local nIndexC 		:= 0
Local cFilter		:= ""
Local oSection1 	:= oReport:Section(1)
Local oSection11 

aCtbMoeda  	:= CtbMoeda( mv_par06 )
If Empty(aCtbMoeda[1])                       
	Help(" ",1,"NOMOEDA")
	Return
Endif

//*���������������������������������������������������������������Ŀ
//*�Add por Icaro Queiroz | Claudio - em 24 de Agosto de 2010      �
//*�Caso seja chamado do CTBR015, imprime as calunas de tipificacao�
//*�����������������������������������������������������������������
If Upper( FunName() ) == 'CTBR015'
	If 	CT1->( FieldPos( "CT1_TPO01" ) ) > 0 .And.;
		CT1->( FieldPos( "CT1_TPO02" ) ) > 0 .And.;
		CT1->( FieldPos( "CT1_TPO03" ) ) > 0 .And.;
		CT1->( FieldPos( "CT1_TPO04" ) ) > 0

		oSection11 	:= oReport:Section(1):Section(1)

		oSection11:SetParentFilter( {|cParam|	CT1->CT1_CONTA == cParam }, {|| CT1->CT1_CONTA } )
	Endif
Endif

titulo:= OemToAnsi(STR0008)
//Personalizal�ao BK
IF !EMPTY(mv_par12)
	titulo +="           Di�rio N�"+mv_par12
ENDIF

oReport:SetPageNumber( mv_par04 ) //mv_par04 - Pagina Inicial
oReport:SetCustomText( {|| CtCGCCabTR(,,,,,dDatabase,titulo,,,,,oReport) } )

cFilter := ""

cFilter :=  AddcFilter( cFilter , "CT1->CT1_FILIAL = '" + xFilial("CT1") + "'" )

IF ! Empty( mv_par01 ) .AND. ( mv_par01 <> NIL )
	cFilter :=  AddcFilter( cFilter , "CT1->CT1_CONTA  >= '" + mv_par01 + "'" )
Endif

If ! Empty( mv_par02 ) .And. ( mv_par02 <> NIL )
	cFilter :=  AddcFilter( cFilter , "CT1->CT1_CONTA  <= '" + mv_par02 + "'" )
Endif


IF mv_par03 == 2
	cFilter :=  AddcFilter( cFilter , "CT1->CT1_NCUSTO = 0" )
EndIF

If mv_par05 == 1
	cFilter :=  AddcFilter( cFilter , "CT1->CT1_CLASSE = '2'" )

Elseif mv_par05 == 2
	cFilter :=  AddcFilter( cFilter , "CT1->CT1_CLASSE = '1'" )
EndIf

If mv_par07 == 2
	cFilter :=  AddcFilter( cFilter , "CT1->CT1_BLOQ = '2'" )
EndIf

oSection1:SetFilter( cFilter )  

nIndexC := oSection1:GetOrder()

If nIndexC > 1
	oSection1:SetIdxOrder(6)
Endif
                                                 
oSection1:OnPrintLine( {|| CT10onprint( oReport ) })

oSection1:Print()

Return


/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Programa  �CT10onprint �Autor  �Renato F. Campos    � Data �  03/27/07   ���
���������������������������������������������������������������������������͹��
���Desc.     � Regra para pular linha do relatorio                          ���
���          �                                                              ���
���������������������������������������������������������������������������͹��
���Uso       � AP                                                           ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/

Static Function CT10onprint( oReport )
Local lPula	:= Iif( mv_par10 == 1 , .T. , .F. )

IF lPula .And. CT1->CT1_CLASSE == "1"
	oReport:skipLine()	
Endif     

If mv_par09 == 1 .And. Empty(CT1->CT1_CTASUP)
	oReport:EndPage()
Endif

Return

/*
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������ͻ��
���Programa  �AddcFilter �Autor  �Renato F. Campos    � Data �  03/15/07      ���
�����������������������������������������������������������������������������͹��
���Desc.     � Fun��o para adicionar no filtro uma nova condi��o, respeitando ���
���          � a string jah informada                                         ���
�����������������������������������������������������������������������������͹��
���Uso       � AP                                                             ���
�����������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
*/
Static FUNCTION AddcFilter( cStrFilter , cStrAdd )
	LOCAL cCond := " "

	DEFAULT cStrFilter := ""
	
	If cStrAdd == Nil .OR. Empty( cStrAdd )
	   Return " "
	Endif
	
	IF ! Empty( cStrFilter ) .And. ( cStrFilter <> Nil )
		cCond += " .And. "
	Endif
	
	cStrFilter := cStrFilter + cCond + cStrAdd

RETURN cStrFilter

/*
-------------------------------------------------------- RELEASE 3 -------------------------------------------------------------
*/

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �Ctbr010R3 � Autor � Pilar S Albaladejo    � Data � 10/01/00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Programa de Impressao do Plano de Contas              	  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � Ctbr010()                                                  ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SIGACTB                                                    ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function Ctbr010R3(wnRel,dDataRef,cMoeda)

//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
LOCAL cString	:="CT1"
LOCAL aOrd	 	:= {OemToAnsi(STR0004),OemToAnsi(STR0005)}  //"Conta"###"Descri��o"
LOCAL cDesc1 	:= OemToAnsi(STR0001)  //"Este programa ir� imprimir o Plano de Contas."
LOCAL cDesc2 	:= OemToAnsi(STR0002)  //"Ser� impresso de acordo com os par�metros solicitados pelo"
LOCAL cDesc3 	:= OemToAnsi(STR0003)  //"usu�rio."
Local lExterno 	:= wnRel <> Nil

DEFAULT dDataRef:= dDataBase

//PRIVATE Tamanho	:=If(lExterno, "M", "G")
PRIVATE Tamanho := "M"
PRIVATE aReturn := { OemToAnsi(STR0006), 1,OemToAnsi(STR0007), 2, 2, 1, "",1 }  //"Zebrado"###"Administracao"
PRIVATE nomeprog:="CTBR010"
PRIVATE aLinha  := { },nLastKey := 0
PRIVATE cPerg   :="CTR010"

li       := 80

Pergunte( "CTR010" , .F.)
//�������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                        �
//� mv_par01		// da conta                             	�
//� mv_par02      	// ate a conta                          	�
//� mv_par03      	// imprime centro de custo               	� 
//� mv_par04      	// folha inicial		         			�
//� mv_par05		// Analitica - Sintetica - Todas        	� 
//� mv_par06		// Desc na Moeda						   	� 
//� mv_par07		// Imprime Bloqueadas?         	       		� 
//� mv_par08		// Mascara                    	       		� 
//� mv_par09		// Salta Pagina Novo Grupo?    	       		� 
//� mv_par10		// Salta linha sintetica ?			    	�
//���������������������������������������������������������������

PRIVATE titulo:= OemToAnsi(STR0008)  //"Listagem do Plano de Contas"
PRIVATE cabec1 := ""  //"CONTA                          DC COD.RES.   D E N O M I N A C A O                    CLASSE COND NORMAL CTA SUPERIOR         BLOQ"
PRIVATE cabec2 := " "
PRIVATE cCancel:= OemToAnsi(STR0010)  //"***** CANCELADO PELO OPERADOR *****"

If ! lExterno
	wnrel:="CTBR010"            //Nome Default do relatorio em Disco
	wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)
Else
	mv_par01 := Repl(" ", Len(mv_par01))
	mv_par02 := Repl("Z", Len(mv_par02))
	mv_par06 := cMoeda
Endif

If nLastKey == 27
	Set Filter To
	Return
Endif

RptStatus({|lEnd| CTr010Imp(@lEnd,wnRel,cString,lExterno)})

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � Ctr010Imp� Autor � Pilar S Albaladejo    � Data � 10/01/00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Programa de Impressao do Plano de Contas              	  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � Ctbr010(lEnd,wnRel,cString)                                ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CTBR010                                                    ���
�������������������������������������������������������������������������Ĵ��
���Parametros� lEnd    - A��o do Codeblock                                ���
���          � wnRel   - T�tulo do relat�rio                              ���
���          � cString - Mensagem                                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function Ctr010Imp(lEnd,WnRel,cString,lExterno)

Local aCtbMoeda	:= {}
Local cMascara
Local cSeparador 	:= "", nImprime := 1
Local lPula			:= Iif(mv_par10==1,.T.,.F.) 
Local lJaPulou		:= .F.
Local nLenMasc		:= TAMSX3("CT1_CONTA")[1]
Local nMaxCol		:= 220
Local lImprime 		:= .T. 
Local cAlias		:= "CT1"
Local aDbf			:= {}

If Tamanho == "M"
	nMaxCol := 132
Endif

//Verifica moeda 
aCtbMoeda  	:= CtbMoeda( mv_par06 )

If Empty( aCtbMoeda[1] )
	Help( " " , 1 , "NOMOEDA" )
	Return
Endif

If Empty( mv_par08 )
	cMascara := GetMv( "MV_MASCARA" )
Else
	cMascara := RetMasCtb( mv_par08 , @cSeparador )
EndIf

// Verifica ordem a ser impressa                                
nOrdem := aReturn[8]

dbSelectArea( "CT1" )

IF nOrdem == 2
	cChave 	:= "CT1_FILIAL + CT1_DESC" + mv_par06
	cIndex	:= GetNextAlias() 

	IndRegua("CT1",cIndex,cChave,, "CT1_CONTA >= '" + mv_par01 + "' .And. " +;
									"CT1_CONTA <= '" + mv_par02 + "'",OemToAnsi(STR0011)) //"Selecionando Registros..."
	nIndex	:= RetIndex("CT1")

	#IFNDEF TOP
		dbSetIndex(cIndex+OrdBagExt())
	#ENDIF

	dbSetOrder( nIndex + 1 )
	dbSeek( xFilial("CT1" ) )
Else
	dbSetOrder( 1 )
	dbSeek( xFilial("CT1") + mv_par01 , .T. )
End

SetRegua(LastRec())   						// Total de elementos da regua

If nOrdem == 1
	dbSelectArea("CT1")
	dbSetOrder(1)

	cCondicao:=	"CT1->CT1_FILIAL == xFilial('CT1') .And. CT1->CT1_CONTA <= mv_par02 .And. ! CT1->( Eof() )"

	If SuperGetMv("MV_CTASUP") = "S"

		aDbf:= {{ "CONTA",    "C", Len(CT1->CT1_CONTA), 0 },;
				{ "SUPERIOR", "C", Len(CT1->CT1_CONTA), 0 },;
				{ "ORDEMPRN", "N", 6, 0 },;
				{ "RECNO",    "N", 6, 0 } }

		oTmpTb := FWTemporaryTable():New("cArqTmpI")
		oTmpTb:SetFields( aDbf )
		oTmpTb:AddIndex("indiceA", {"CONTA"} )
		oTmpTb:AddIndex("indiceB", {"ORDEMPRN"} )
		oTmpTb:AddIndex("indiceC", {"SUPERIOR"} )
		oTmpTb:Create()

		///dbUseArea( .T.,, cIndex, "cArqTmpI", .F., .F. )

		///IndRegua("cArqTmpI",Left(cIndex, 7) + "A","CONTA",,,OemToAnsi(STR0011)) //"Selecionando Registros..."
		///IndRegua("cArqTmpI",Left(cIndex, 7) + "B","ORDEMPRN",,,OemToAnsi(STR0011)) //"Selecionando Registros..."
		///IndRegua("cArqTmpI",Left(cIndex, 7) + "C","SUPERIOR",,,OemToAnsi(STR0011)) //"Selecionando Registros..."

		///DbClearIndex()

		///dbSetIndex(Left(cIndex,7)+"A"+OrdBagExt())
		///dbSetIndex(Left(cIndex,7)+"B"+OrdBagExt())
		///dbSetIndex(Left(cIndex,7)+"C"+OrdBagExt())

		DbSetOrder(0)
        
		dbSelectArea("CT1")
        DbGoTop()
		DbSetOrder(1)
		CT1->(dbSeek(xFilial("CT1")))

		While &cCondicao
			cArqTmpI->( DbAppend() )

			Replace cArqTmpI->CONTA    With CT1->CT1_CONTA ;
			 	  , cArqTmpI->SUPERIOR With CT1->CT1_CTASUP;
				  ,	cArqTmpI->RECNO    With CT1->( Recno() )

			DbSkip()
		EndDo
		
		cCondicao := "! Eof()"
		DbSelectArea("cArqTmpI")

		DbGoTop()
		While ! Eof()
			If Empty( cArqTmpI->SUPERIOR )
				CtGerSup( cArqTmpI->CONTA , @nImprime)
			Endif

			DbSkip()
		Enddo

		DbSetOrder(2)
		DbGoTop()

		cAlias := "cArqTmpI"
	Endif
Else
	dbSelectarea( "CT1" )
	dbSetOrder( nIndex + 1 )
	CT1->(dbSeek(xFilial("CT1")))
	cCondicao := "CT1_FILIAL == xFilial('CT1') .And. !Eof()"

	cAlias := "CT1"
EndIF

If ! lExterno
	m_pag:=mv_par04
Endif

nColDC		:= nLenMasc+1
nColRES		:= nLenMasc+4
nColDESC	:= nLenMasc+15
nColCLASSE	:= nLenMasc+56
nColNORMAL	:= nLenMasc+68
nColCTASUP	:= nLenMasc+78
nColBLOQ	:= nColCTASUP+Len(CT1->CT1_CTASUP)+1

cabec1 := PADR(STR0009,nLenMasc)+" "+Padr(STR0019,nColRES-nColDC)+PADR(STR0020,nColDESC-nColRES)
cabec1 += PADR(STR0021,nColCLASSE-nColDESC)+PADR(STR0022,nColNORMAL-nColCLASSE)
cabec1 += PADR(STR0023,nColCTASUP-nColNORMAL)+PADR(STR0024,nColBLOQ-nColCTASUP)
If ! lExterno
	SetDefault(aReturn,cString)
	Cabec1 += STR0025
Else
	Cabec1 += STR0018 //"CL/CON"
Endif
cabec1 := OemToAnsi(cabec1)

If nOrdem == 1

	DbSelectArea( cAlias )

EndIf	
	
While &cCondicao 

	lImprime := .T. 

	If lEnd 	
		@Prow()+1,001 PSAY cCancel
		Exit
	EndIF
     
	IncRegua()

	If ( cAlias == "cArqTmpI" )
		CT1->( MsGoto( cArqTmpI->RECNO ))
	Endif

	IF ! Empty( mv_par01 ) .And. mv_par01 <> nil
	    IF CT1->CT1_CONTA < mv_par01
			lImprime := .F. 
	    ENDIF
	EndIf

	IF mv_par03 == 2
 		IF CT1->CT1_NCUSTO > 0
			lImprime := .F. 
		EndIF
	EndIF

	If mv_par07 == 2
		If CT1->CT1_BLOQ == "1"				// Conta Bloqueada
			lImprime := .F. 
		EndIf
	EndIf

	If mv_par05 == 1						// Imprime Analiticas
		If CT1->CT1_CLASSE == "1"
			lImprime := .F. 
		EndIf

	ElseIF mv_par05 == 2					// Imprime Sinteticas
		IF CT1->CT1_CLASSE = "2"
			lImprime := .F. 
		EndIf
	
	EndIf

    If lImprime // verifica se imprime a linha
		If nOrdem == 1
			If mv_par09 == 1						// Salta pagina quando muda de grupo 
				If Empty(CT1->CT1_CTASUP)
					li := 65
				EndIf
			EndIf		
		EndIf
		
	
		IF li > 55
			CtCGCCabec(,,,Cabec1,Cabec2,dDataBase,Titulo,,"2",Tamanho)
			li--
		EndIF
	
		cCodigo	:=	Alltrim(CT1->CT1_CONTA)
		cDesc := &('CT1->CT1_DESC' + mv_par06 )
	
		li++
	
		EntidadeCTB(CT1->CT1_CONTA,li,000,nLenMasc,.F.,cMascara,cSeparador)
		
		@li, nColDC 	PSAY CT1->CT1_DC        
		@li, nColRES 	PSAY Left(CT1->CT1_RES,10)
		@li, nColDESC 	PSAY Left(cDesc,40)
		
		If CT1->CT1_CLASSE == '1'
			@li, nColCLASSE PSAY STR0014
		ElseIf CT1->CT1_CLASSE == '2'
			@li, nColCLASSE PSAY STR0015
		EndIf
	
		If ! lExterno	
			If CT1->CT1_NORMAL == '1'
				@li, nColNORMAL PSAY STR0016
			ElseIf CT1->CT1_NORMAL =='2'
				@li, nColNORMAL PSAY STR0017
			EndIf
			
			@li, nColCTASUP PSAY CT1->CT1_CTASUP
			If CT1->CT1_BLOQ == "1"	
				@li, nColBLOQ PSAY OemToAnsi(STR0012)	//Sim
	
			ElseIf CT1->CT1_BLOQ == "2"	
				@li, nColBLOQ PSAY OemToAnsi(STR0013)	// Nao
			EndIf
		Else
			If CT1->CT1_NORMAL == '1'
				@li, nColNORMAL PSAY "- " + STR0016
	
			ElseIf CT1->CT1_NORMAL =='2'
				@li, nColNORMAL PSAY "- " + STR0017
			EndIf
		Endif
		
		lJaPulou := .F.
    Endif

	( cAlias )->( dbSkip() )

	If ( cAlias == "cArqTmpI" )
		CT1->( MsGoto( cArqTmpI->RECNO ))
	Endif

	// Pula linha entre sinteticas
	IF ! lJaPulou .And. lPula .And. ( CT1->CT1_CLASSE == "1" )
		li += 1
		@li,00 PSAY REPLICATE( " "  , nMaxCol )		
		lJaPulou := .T.
	EndIf			

EndDO

//��������������������������������������������������������������Ŀ
//� Se emissao foi alfabetica, deleta arquivo de trabalho        �
//����������������������������������������������������������������
If nOrdem == 2
	dbSelectArea("CT1")
	dbClearFilter()
	RetIndex( "CT1" )
	If !Empty(cIndex)
		FErase (cIndex+OrdBagExt())
	Endif
	dbSetOrder(1)
EndIf

dbSelectarea( "CT1" )
dbSetOrder( 1 )

Set Filter To
If aReturn[5] = 1 .And. ! lExterno
	Set Printer To
	Commit
	ourspool(wnrel)
Endif

If Select("cArqTmpI") > 0
	If !Empty(oTmpTb)
		oTmpTb:Delete()
	Else
		("cArqTmpI")->(DbCloseArea())
	EndIf
Endif

If lExterno .and. Select("cArqTmp") > 0
	("cArqTmp")->(DbCloseArea())
Endif

If ! lExterno
	MS_FLUSH()
Endif

Return
