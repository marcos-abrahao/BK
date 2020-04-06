#INCLUDE "xCNTR010.CH" 
#INCLUDE "PROTHEUS.CH"

/*----------Versao TReport-------------*/
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    � CNTR010  � Autor � Marcelo Custodio      � Data � 23.05.06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Contratos - Convertido com base no fonte da rotina CNTR010R3���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���            �        �      �                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function xCNTR010(lUnico)

Default lUnico := .T.

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� MV_PAR01     // Contrato de:                                 �
//� mv_par02     // Revisao de                                   �
//� mv_par03     // Vigencia de:                                 �
//� mv_par04     // Vigencia ate:                                �
//� mv_par05     // Situacao de:                                 �
//� mv_par06     // Fornecedor de:                               �
//� mv_par07     // Tipo de Contrato ?                           �
//� mv_par08     // Exibir Textos do Contrato					 �
//� mv_par09     // Exibir Detalhes da Medicao					 �
//� mv_par10     // Cliente de: 		                         �
//| mv_par11     // Imprimir valores - Moeda do ctr/Outra moeda  �
//| mv_par12     // Moeda: 										 �
//| mv_par13     // Data de Referencia:							 �
//| mv_par15     // Exibir Aprovadores Contrato? Sim/N�o: 		 �
//| mv_par16     // Exibir Aprovadores Itens? Sim/N�o: 			 �
//����������������������������������������������������������������

Pergunte("CNR011",.F.)

If lUnico
	//CN9->(dbGoTo(nRecNo))
	
	MV_PAR01 := CN9->CN9_NUMERO								
	MV_PAR02 := CN9->CN9_REVISA
	MV_PAR03 := CN9->CN9_DTINIC
	MV_PAR04 := CN9->CN9_DTFIM
	MV_PAR05 := CN9->CN9_SITUAC
	MV_PAR06 := ""
	MV_PAR07 := CN9->CN9_TPCTO
	MV_PAR08 := 1
	MV_PAR09 := 1
	MV_PAR10 := ""
	MV_PAR11 := 1
	MV_PAR12 := 1
	MV_PAR13 := CTOD("  /  /  ")
	MV_PAR14 := Iif(Cn300RetSt('COMPRA'),1,2)
	MV_PAR15 := 1
	MV_PAR16 := 1
EndIf

oReport := ReportDef()
oReport:PrintDialog()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    � ReportDef� Autor � Marcelo Custodio      � Data � 23.05.06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Define a configuracao do relatorio de contratos            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���            �        �      �                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ReportDef()
Local oReport
Local oSectCab// Sessao Cabecalho
Local oSectPla// Sessao Planilhas
Local oSectItm// Sessao Itens de Planilhas
Local oSectAgr// Sessao Agrupadores
Local oSectCac// Sessao Caucoes
Local oSectFrn// Sessao Fornecedores
Local oSectCli// Sessao Cliente
Local oSectCro// Sessao Cronograma
Local oSectMul// Sessao Multas
Local oSectMed// Sessao Medicoes
Local oSectIMe// Sessao Itens de medicoes
Local oSectBon// Sessao Multas/Bonificacoes
Local oSectDes// Sessao Descontos
Local oSectCtb// Sessao Cronograma Contabil

Local nCNBTamPrd:= TamSX3("CNB_PRODUT")[1]
Local nCNETamPrd:= TamSX3("CNE_PRODUT")[1]

oReport := TReport():New("CNTR010",OemToAnsi(STR0001),"CNR011",{|oReport| CR010Imp(oReport)},"Imprime relatorio de contratos")

//����������������������������������������������������Ŀ
//� Cabecalho do contrato                              �
//������������������������������������������������������
oSectCab := TRSection():New(oReport,OemToAnsi(STR0067),{"CN9","SE4","CN1"})

TRCell():New(oSectCab,"CN9_NUMERO","CN9",,,TamSx3("CN9_NUMERO"	)[1]+11)
TRCell():New(oSectCab,"CN9_REVISA","CN9",,,TamSx3("CN9_REVISA"	)[1])
TRCell():New(oSectCab,"CN1_DESCRI","CN1","Tipo",,TamSx3("CN1_DESCRI"	)[1])
TRCell():New(oSectCab,"CN9_SITUAC","CN9",,,TamSx3("CN9_SITUAC")[1],,{|| QA_CBox("CN9_SITUAC",AllTrim(QRYCN9->CN9_SITUAC))})

TRCell():New(oSectCab,"CN9_DTPROP","CN9")
TRCell():New(oSectCab,"CN9_DTINIC","CN9")
TRCell():New(oSectCab,"CN9_ASSINA","CN9")
TRCell():New(oSectCab,"CN9_DTREV" ,"CN9")
TRCell():New(oSectCab,"CN9_DTFIM" ,"CN9")

TRCell():New(oSectCab,"CN9_VLINI","CN9",,,,,{|| QRYCN9->(C010xMoeda(.T.,CN9_NUMERO,CN9_REVISA,"CN9_VLINI"))})
TRCell():New(oSectCab,"CN9_VLATU","CN9",,,,,{|| QRYCN9->(C010xMoeda(.T.,CN9_NUMERO,CN9_REVISA,"CN9_VLATU"))})
TRCell():New(oSectCab,"CN9_SALDO","CN9",,,,,{|| QRYCN9->(C010xMoeda(.T.,CN9_NUMERO,CN9_REVISA,"CN9_SALDO"))})

TRCell():New(oSectCab,"CN9_FLGREJ","CN9",,,TamSx3("CN9_FLGREJ")[1],,{|| QA_CBox("CN9_FLGREJ",AllTrim(QRYCN9->CN9_FLGREJ))})
TRCell():New(oSectCab,"CN6_DESCRI","CN6","Indice",,TamSx3("CN6_DESCRI")[1],,{||Alltrim(QRYCN9->CN6_DESCRI)})

oSectCab:Cell("CN1_DESCRI"):SetLineBreak()

//����������������������������������������������������Ŀ
//- Aprovadores Contrato
//������������������������������������������������������
oSectApC := TRSection():New(oSectCab,OemToAnsi(STR0069))
oSectApC:lHeaderVisible := .T.
TrCell():New(oSectApC,"CR_NUM",		"SCR",/*4*/,/*5*/,35,/*7*/,/*8*/)
TrCell():New(oSectApC,"CR_TIPO",	"SCR",OemToAnsi(STR0072),/*5*/,TamSx3("CR_TIPO")[1]	,/*7*/,/*8*/)
TrCell():New(oSectApC,"CR_NIVEL",	"SCR",/*4*/,/*5*/,TamSx3("CR_NIVEL")[1],/*7*/,/*8*/)
TrCell():New(oSectApC,"CR_USER",	"SCR",OemToAnsi(STR0070),/*5*/,TamSx3("AK_NOME")[1]	,/*7*/,{|| QRYSCR->(UsrRetName(CR_USER))})
TrCell():New(oSectApC,"CR_USERLIB","SCR",OemToAnsi(STR0073),/*5*/,TamSx3("AK_NOME")[1]	,/*7*/,{|| QRYSCR->(UsrRetName(CR_USERLIBE))})
TrCell():New(oSectApC,"CR_STATUS",	"SCR",OemToAnsi(STR0071),/*5*/,/*6*/,/*7*/,/*8*/)
TrCell():New(oSectApC,"CR_DATALIB","SCR",/*4*/,/*5*/,/*6*/,/*7*/,/*8*/)
TrCell():New(oSectApC,"CR_OBS",		"SCR",/*4*/,/*5*/,/*6*/,/*7*/,{|| QRYSCR->(C010GtMemo(R_E_C_N_O_))})

//����������������������������������������������������Ŀ
//� Fornecedores                                       �
//������������������������������������������������������
oSectFrn := TRSection():New(oSectCab,OemToAnsi(STR0041),{"CNC","SA2"})
oSectFrn:lHeaderVisible := .T.
TRCell():New(oSectFrn,"CNC_CODIGO","CNC")
TRCell():New(oSectFrn,"CNC_LOJA","CNC")
TRCell():New(oSectFrn,"A2_NOME","SA2",RetTitle("CNC_NOME"))

//����������������������������������������������������Ŀ
//� Cliente                                            �
//������������������������������������������������������
oSectCli := TRSection():New(oSectCab,OemToAnsi(STR0063),{"CNC","SA1"})
TRCell():New(oSectCli,"CNC_CLIENT","CNC")
TRCell():New(oSectCli,"CNC_LOJACL","CNC")
TRCell():New(oSectCli,"A1_NOME","SA1",RetTitle("A1_NOME"))
oSectCli:lHeaderVisible := .T.

//����������������������������������������������������Ŀ
//� Multas                                             �
//������������������������������������������������������
oSectMul := TRSection():New(oSectCab,OemToAnsi(STR0042),{"CNH","CN4"})
oSectMul:lHeaderVisible := .T.
TRCell():New(oSectMul,"CNH_CODIGO","CNH")
TRCell():New(oSectMul,"CN4_DESCRI","CN4")

//����������������������������������������������������Ŀ
//� Caucoes                                            �
//������������������������������������������������������
oSectCac := TRSection():New(oSectCab,OemToAnsi(STR0043),{"CN8","CN3"})
oSectCac:lHeaderVisible := .T.
TRCell():New(oSectCac,"CN8_CODIGO","CN8")
TRCell():New(oSectCac,"CN3_DESCRI","CN3")
TRCell():New(oSectCac,"CN8_FORNECE","CN8")
TRCell():New(oSectCac,"CN8_LOJA","CN8")
TRCell():New(oSectCac,"CN8_NUMDOC","CN8")
TRCell():New(oSectCac,"CN8_DTINVI","CN8")
TRCell():New(oSectCac,"CN8_DTFIVI","CN8")
TRCell():New(oSectCac,"CN8_VLEFET","CN8",,,,,{|| QRYCN8->(C010xMoeda(.T.,CN8_CONTRA,CN8_REVISA,"CN8_VLEFET"))})
TRCell():New(oSectCac,"CN8_MOEDA","CN8")
TRCell():New(oSectCac,"CN8_EMITEN","CN8")

//����������������������������������������������������Ŀ
//� Cabecalho das Planilhas                            �
//������������������������������������������������������
oSectPla := TRSection():New(oSectCab,OemToAnsi(STR0044),{"CNA","CNL"})
oSectPla:lHeaderVisible := .T.
TRCell():New(oSectPla,"CNA_NUMERO","CNA")
TRCell():New(oSectPla,"CNL_DESCRI","CNL","Tipo")
TRCell():New(oSectPla,"CNA_XXMOT","CNA")
TRCell():New(oSectPla,"CNA_XXMUN","CNA")
TRCell():New(oSectPla,"CNA_FORNEC","CNA")
TRCell():New(oSectPla,"CNA_LJFORN","CNA")
TRCell():New(oSectPla,"CNA_CLIENT","CNA")
TRCell():New(oSectPla,"CNA_LOJACL","CNA")
TRCell():New(oSectPla,"CNA_DTINI" ,"CNA")
TRCell():New(oSectPla,"CNA_DTFIM" ,"CNA")
TRCell():New(oSectPla,"CNA_VLTOT","CNA",,,,,{|| QRYCNA->(C010xMoeda(.T.,CNA_CONTRA,CNA_REVISA,"CNA_VLTOT"))})
TRCell():New(oSectPla,"CNA_SALDO","CNA",,,,,{|| QRYCNA->(C010xMoeda(.T.,CNA_CONTRA,CNA_REVISA,"CNA_SALDO"))})
TRCell():New(oSectPla,"CNA_FLREAJ","CNA",,,TamSx3("CNA_FLREAJ")[1],,{|| QA_CBox("CNA_FLREAJ",AllTrim(QRYCNA->CNA_FLREAJ))})

//����������������������������������������������������Ŀ
//� Itens das planilhas                                �
//������������������������������������������������������
oSectItm := TRSection():New(oSectPla,OemToAnsi(STR0045),{"CNB"})
oSectItm:lHeaderVisible := .T.
TRCell():New(oSectItm,"CNB_ITEM","CNB")
TRCell():New(oSectItm,"CNB_PRODUT","CNB",,,nCNBTamPrd)
TRCell():New(oSectItm,"CNB_QUANT","CNB")
TRCell():New(oSectItm,"CNB_VLUNIT","CNB",,,,,{|| QRYCNB->(C010xMoeda(.T.,CNB_CONTRA,CNB_REVISA,"CNB_VLUNIT"))})
TRCell():New(oSectItm,"CNB_VLTOT","CNB",,,,,{|| QRYCNB->(C010xMoeda(.T.,CNB_CONTRA,CNB_REVISA,"CNB_VLTOT"))})
TRCell():New(oSectItm,"CNB_DESC","CNB")
TRCell():New(oSectItm,"CNB_VLDESC","CNB",,,,,{|| QRYCNB->(C010xMoeda(.T.,CNB_CONTRA,CNB_REVISA,"CNB_VLDESC"))})
TRCell():New(oSectItm,"CNB_QTDMED","CNB")
TRCell():New(oSectItm,"CNB_SLDMED","CNB")

oSectItm:Cell("CNB_PRODUT"):SetLineBreak()

//- Agrupadores de estoque -------------------------------------------
oSectAgr	:= TRSection():New(oSectPla,OemToAnsi(STR0068),{"CXM"})
//oSectAgr:= TRSection():New(oSectPla,'Agrupadores de Estoque',{"CXM"})
oSectAgr:lHeaderVisible := .T.
TRCell():New(oSectAgr,"CXM_ITEMID","CXM")
TRCell():New(oSectAgr,"CXM_AGRTIP","CXM",,,nCNBTamPrd)
TRCell():New(oSectAgr,"CXM_AGRGRP","CXM",,,nCNBTamPrd)
TRCell():New(oSectAgr,"CXM_AGRCAT","CXM",,,nCNBTamPrd)
TRCell():New(oSectAgr,"CXM_VLMAX ","CXM",,,,,{|| QRYCXM->(C010xMoeda(.T.,CXM_CONTRA,CXM_REVISA,"CXM_VLMAX"))})
TRCell():New(oSectAgr,"CXM_VLMED ","CXM",,,,,{|| QRYCXM->(C010xMoeda(.T.,CXM_CONTRA,CXM_REVISA,"CXM_VLMED"))})

oSectAgr:Cell("CXM_ITEMID"):SetLineBreak()


//����������������������������������������������������Ŀ
//� Cronogramas                                        �
//������������������������������������������������������
oSectCro := TRSection():New(oSectPla,OemToAnsi(STR0046),{"CNF"})
oSectCro:lHeaderVisible := .T.
TRCell():New(oSectCro,"CNF_NUMERO","CNF")
TRCell():New(oSectCro,"CNF_PARCEL","CNF")
TRCell():New(oSectCro,"CNF_COMPET","CNF")
TRCell():New(oSectCro,"CNF_VLPREV","CNF",,,,,{|| QRYCNF->(C010xMoeda(.T.,CNF_CONTRA,CNF_REVISA,"CNF_VLPREV"))})
TRCell():New(oSectCro,"CNF_VLREAL","CNF",,,,,{|| QRYCNF->(C010xMoeda(.T.,CNF_CONTRA,CNF_REVISA,"CNF_VLREAL"))})
TRCell():New(oSectCro,"CNF_SALDO","CNF",,,,,{|| QRYCNF->(C010xMoeda(.T.,CNF_CONTRA,CNF_REVISA,"CNF_SALDO"))})
TRCell():New(oSectCro,"CNF_DTVENC","CNF")
TRCell():New(oSectCro,"CNF_PRUMED","CNF")
TRCell():New(oSectCro,"CNF_DTREAL","CNF")

//����������������������������������������������������Ŀ
//� Parcelas do Cronograma Contabil                    �
//������������������������������������������������������
oSectCtb := TRSection():New(oSectPla,OemToAnsi(STR0055),{"CNW"})
oSectCtb:lHeaderVisible := .T.
TRCell():New(oSectCtb,"CNW_NUMERO","CNW")
TRCell():New(oSectCtb,"CNW_PARCEL","CNW")
TRCell():New(oSectCtb,"CNW_DTPREV","CNW")
TRCell():New(oSectCtb,"CNW_VLPREV","CNW",,,,,{|| QRYCNW->(C010xMoeda(.T.,CNW_CONTRA,CNW_REVISA,"CNW_VLPREV"))})
TRCell():New(oSectCtb,"CNW_HIST","CNW")
TRCell():New(oSectCtb,"CNW_CC","CNW")
TRCell():New(oSectCtb,"CNW_DTLANC","CNW")
TRCell():New(oSectCtb,"CNW_ITEMCT","CNW")
TRCell():New(oSectCtb,"CNW_CLVL","CNW")

//����������������������������������������������������Ŀ
//� Cabecalho das Medicoes                             �
//������������������������������������������������������
oSectMed := TRSection():New(oSectCab,OemToAnsi(STR0047),{"CND"})
oSectMed:lHeaderVisible := .T.
TRCell():New(oSectMed,"CND_NUMMED","CND")
TRCell():New(oSectMed,"CND_NUMERO","CND")
TRCell():New(oSectMed,"CND_FORNEC","CND")
TRCell():New(oSectMed,"CND_LJFORN","CND")
TRCell():New(oSectMed,"CND_COMPET","CND")
TRCell():New(oSectMed,"CND_VLTOT","CND",,,,,{|| QRYCND->(C010xMoeda(.T.,CND_CONTRA,CND_REVISA,"CND_VLTOT"))})

//����������������������������������������������������Ŀ
//� Itens de Medicoes                                  �
//������������������������������������������������������
oSectIMe := TRSection():New(oSectMed,OemToAnsi(STR0048),{"CNE"})
oSectIMe:lHeaderVisible := .T.
TRCell():New(oSectIMe,"CNE_ITEM","CNE")
TRCell():New(oSectIMe,"CNE_PRODUT","CNE",,,nCNETamPrd)
TRCell():New(oSectIMe,"CNE_QTDSOL","CNE")
TRCell():New(oSectIMe,"CNE_QUANT","CNE")
TRCell():New(oSectIMe,"CNE_VLUNIT","CNE",,,,,{|| QRYCNE->(C010xMoeda(.T.,CNE_CONTRA,CNE_REVISA,"CNE_VLUNIT"))})
TRCell():New(oSectIMe,"CNE_VLTOT","CNE",,,,,{|| QRYCNE->(C010xMoeda(.T.,CNE_CONTRA,CNE_REVISA,"CNE_VLTOT"))})

oSectIMe:Cell("CNE_PRODUT"):SetLineBreak()

//����������������������������������������������������Ŀ
//� Multas/Bonificacoes                                �
//������������������������������������������������������
oSectBon := TRSection():New(oSectMed,OemToAnsi(STR0058),{"CNR"})
oSectBon:lHeaderVisible := .T.
oSectBon:SetTotalText("")
TRCell():New(oSectBon,"CNR_TIPO","CNR")
TRCell():New(oSectBon,"CNR_DESCRI","CNR")
TRCell():New(oSectBon,"CNR_VALOR","CNR",,,,,{|| QRYCNR->(C010xMoeda(.T.,QRYCND->CND_CONTRA,QRYCND->CND_REVISA,"CNR_VALOR"))})
TRFunction():New(oSectBon:Cell("CNR_VALOR"),NIL,"SUM",/*oBreak*/,OemToAnsi(STR0060),/*cPicture*/,/*uFormula*/,.T.,.F.,,oSectBon,{|| IIf( QRYCNR->CNR_TIPO == "1" , .T. , .F. ) } )
TRFunction():New(oSectBon:Cell("CNR_VALOR"),NIL,"SUM",/*oBreak*/,OemToAnsi(STR0061),/*cPicture*/,/*uFormula*/,.T.,.F.,,oSectBon,{|| IIf( QRYCNR->CNR_TIPO == "2" , .T. , .F. ) } )

//����������������������������������������������������Ŀ
//� Descontos                                          �
//������������������������������������������������������
oSectDes := TRSection():New(oSectMed,OemToAnsi(STR0059),{"CNQ","CNP"})
oSectDes:lHeaderVisible := .T.
oSectDes:SetTotalText("")
TRCell():New(oSectDes,"CNQ_TPDESC","CNQ")
TRCell():New(oSectDes,"CNP_DESCRI","CNP")
TRCell():New(oSectDes,"CNQ_VALOR","CNQ",,,,,{|| QRYCNQ->(C010xMoeda(.T.,QRYCND->CND_CONTRA,QRYCND->CND_REVISA,"CNQ_VALOR"))})
TRFunction():New(oSectDes:Cell("CNQ_VALOR"),NIL,"SUM",,OemToAnsi(STR0062),,,.T.,.F.,,oSectDes)

Return oReport

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    �CR010Imp  � Autor � Marcelo Custodio      � Data � 23.05.06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Executa impressao do relatorio de contratos                ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CNTR010                                                    ���
�������������������������������������������������������������������������Ĵ��
���Parametros� oExp01 - Objeto principal do relatorio - TReport           ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���            �        �      �                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CR010Imp(oReport)
Local oSectCab := oReport:Section(1)//Cabecalho do contrato
Local oSectApC := oReport:Section(1):Section(1)//Aprovadores do contrato
Local oSectFrn := oReport:Section(1):Section(2)//Fornecedores
Local oSectCli := oReport:Section(1):Section(3)//Cliente
Local oSectMul := oReport:Section(1):Section(4)//Multas
Local oSectCac := oReport:Section(1):Section(5)//Caucoes

Local oSectPla := oReport:Section(1):Section(6)//Cabecalho da planilha
Local oSectItm := oReport:Section(1):Section(6):Section(1)//Itens de Planilhas
Local oSectAgr := oReport:Section(1):Section(6):Section(2)//Agrupadores de Estoque
Local oSectCro := oReport:Section(1):Section(6):Section(3)//Cronogramas
Local oSectCtb := oReport:Section(1):Section(6):Section(4)//Cronograma Contabil

Local oSectMed := oReport:Section(1):Section(7)//Medicoes
Local oSectIMe := oReport:Section(1):Section(7):Section(1)//Itens de Medicoes
Local oSectBon := oReport:Section(1):Section(7):Section(2)//Multas e Bonificacoes de Medicoes
Local oSectDes := oReport:Section(1):Section(7):Section(3)//Descontos de Medicoes
Local nTotLinha
Local nX

oSectCab:SetTitle(Upper(oSectCab:Title())) //Cabecalho do contrato
oSectApC:SetTitle(Upper(oSectApC:Title()))
oSectFrn:SetTitle(Upper(oSectFrn:Title()))
oSectCli:SetTitle(Upper(oSectCli:Title()))
oSectMul:SetTitle(Upper(oSectMul:Title()))
oSectCac:SetTitle(Upper(oSectCac:Title()))

oSectPla:SetTitle(Upper(oSectPla:Title())) //Cabecalho da planilha
oSectItm:SetTitle(Upper(oSectItm:Title()))
oSectAgr:SetTitle(Upper(oSectAgr:Title()))
oSectCro:SetTitle(Upper(oSectCro:Title()))
oSectCtb:SetTitle(Upper(oSectCtb:Title()))

oSectMed:SetTitle(Upper(oSectMed:Title())) //Medicoes
oSectIMe:SetTitle(Upper(oSectIMe:Title()))
oSectBon:SetTitle(Upper(oSectBon:Title()))
oSectDes:SetTitle(Upper(oSectDes:Title()))

If mv_par11 == 2
	oReport:SetTitle(oReport:Title() +STR0065 +AllTrim(GetMv("MV_SIMB" +Ltrim(Str(mv_par12)))) +")")
	oSectCac:Cell("CN8_MOEDA"):Disable()
EndIf

//����������������������������������������������������Ŀ
//� Configura perguntas do tipo Range                  �
//������������������������������������������������������
MakeSqlExpr(PadR("CNR011",10))

//�������������������������������������������Ŀ
//� Define querys para impressao do relatorio �
//���������������������������������������������
CR010Cab(oSectCab) //-- Cabe�alho

If mv_par15 == 1 .Or. mv_par16 == 1
	CR010ApC(oSectApC) //-- Aprovadores
Else
	oSectApC:Disable()
EndIf

If mv_par14 == 1
	CR010Frn(oSectFrn) //-- Fornecedores
	oSectCli:Disable()
	oSectPla:Cell("CNA_CLIENT"):Disable()
	oSectPla:Cell("CNA_LOJACL"):Disable()
Else
	CR010Cli(oSectCli) //-- Clientes
	oSectFrn:Disable()
	oSectPla:Cell("CNA_FORNEC"):Disable()
	oSectPla:Cell("CNA_LJFORN"):Disable()
EndIf

CR010Mul(oSectMul) //-- Multas e Bonifica��es
CR010Cac(oSectCac) //-- Cau��es
CR010Pla(oSectPla) //-- Planilhas
CR010Itm(oSectItm) //-- Itens da Planilha
CR010Agr(oSectAgr) //-- Agrupadore de Estoque
CR010Cro(oSectCro) //-- Cronograma
CR010Ctb(oSectCtb) //-- Cronograma Cont�bil
CR010Med(oSectMed) //-- Medi��es
CR010IMe(oSectIMe) //-- Itens da Medi��o

If MV_PAR09 == 1
	CR010Bon(oSectBon) //-- Multas e Bonifica��es da Medi��o
	CR010Des(oSectDes) //-- Descontos da Medi��o
Else
	oSectBon:Disable()
	oSectDes:Disable()
EndIf

//����������������������������������������������������Ŀ
//� Processa relatorio                                 �
//������������������������������������������������������
oSectCab:Init()
While !QRYCN9->(Eof())
	If oReport:Cancel()
		Exit
	EndIf

	//����������������������������������������������������Ŀ
	//� Imprime cabecalho do contrato                      �
	//������������������������������������������������������
	oSectCab:PrintLine()

	If MV_PAR08 == 1
		oReport:SkipLine()
		//������������������������������������������������������������Ŀ
		//� Imprime Texto do Objeto do Contrato   						   �
		//��������������������������������������������������������������
		nTotLinha := MlCount(MSMM(QRYCN9->CN9_CODOBJ,,,,,160))
		oReport:PrintText(STR0023)
		oReport:SkipLine()
		For nX := 1 To nTotLinha
			oReport:PrintText(MemoLine(MSMM(QRYCN9->CN9_CODOBJ,,,,,160),160,nX))
			oReport:SkipLine()
		Next nX
		If nTotLinha == 0
			oReport:PrintText(OemToAnsi(STR0040))
		EndIf
		oReport:SkipLine()

		//������������������������������������������������������������Ŀ
		//� Imprime Texto de Clausulas do Contrato					      �
		//��������������������������������������������������������������
		nTotLinha := MlCount(MSMM(QRYCN9->CN9_CODCLA,,,,,160))
		oReport:PrintText(STR0024)
		oReport:SkipLine()
		For nX := 1 To nTotLinha
			oReport:PrintText(MemoLine(MSMM(QRYCN9->CN9_CODCLA,,,,,160),160,nX))
			oReport:SkipLine()
		Next nX
		If nTotLinha == 0
			oReport:PrintText(OemToAnsi(STR0040))
		EndIf
		oReport:SkipLine()

		//������������������������������������������������������������Ŀ
		//� Imprime Texto de Justificativas do Contrato				      �
		//��������������������������������������������������������������
		nTotLinha := MlCount(MSMM(QRYCN9->CN9_CODJUS,,,,,160))
		oReport:PrintText(STR0025)
		oReport:SkipLine()
		For nX := 1 To nTotLinha
			oReport:PrintText(MemoLine(MSMM(QRYCN9->CN9_CODJUS,,,,,160),160,nX))
			oReport:SkipLine()
		Next nX
		If nTotLinha == 0
			oReport:PrintText(OemToAnsi(STR0040))
		EndIf
		oReport:SkipLine()
	EndIf

	//- Imprime listagem de Aprovadores do contrato
	If oSectApC:lEnabled
		oSectApC:Print()
	EndIf

	//����������������������������������������������������Ŀ
	//� Imprime listagem de fornecedores                   �
	//������������������������������������������������������
	If mv_par14 == 1
		oSectFrn:Print()
	Else
		oSectCli:Print()
	EndIf

	//����������������������������������������������������Ŀ
	//� Imprime listagem de multas do contrato             �
	//������������������������������������������������������
	If oSectMul:lEnabled
		oSectMul:Print()
	EndIf

	//����������������������������������������������������Ŀ
	//� Imprime caucoes do contrato                        �
	//������������������������������������������������������
	If oSectCac:lEnabled
		oSectCac:Print()
	EndIf

	//����������������������������������������������������Ŀ
	//� Imprime planilhas/itens/cronogramas                �
	//������������������������������������������������������
	If oSectPla:lEnabled
		oSectPla:Print()
	EndIf

	//����������������������������������������������������Ŀ
	//� Imprime medicoes do contrato                       �
	//������������������������������������������������������
	If oSectMed:lEnabled
		oSectMed:Print()
	EndIf

	QRYCN9->(dbSkip())

	//����������������������������������������������������Ŀ
	//� Pula pagina quando quebrar contrato                �
	//������������������������������������������������������
	If !QRYCN9->(Eof())
		oReport:EndPage()
	EndIf
EndDo

oSectCab:Finish()

Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    �CR010Box  � Autor � Marcelo Custodio      � Data � 23.05.06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime box com texto centralizado                         ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � CR010Box(oExp01,cExp02)                                    ���
�������������������������������������������������������������������������Ĵ��
���Parametros� oExp01 - Objeto do relatorio                               ���
���          � cExp02 - Texto impresso                                    ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���            �        �      �                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
/*
Static Function CR010Box(oReport,cTexto)
Local nCol1 := 7
Local nCol2 := oReport:PageWidth()-40

oReport:Box(oReport:Row()-10,2,oReport:Row()+38,oReport:PageWidth()-35)
oReport:Box(oReport:Row()-5,nCol1,oReport:Row()+33,nCol2)
oReport:PrintText(cTexto,oReport:Row(),((nCol2-nCol1)/2)-((Len(alltrim(cTexto))/2)*20))
oReport:SkipLine()
Return
*/

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    �CR010Cab  � Autor � Marcelo Custodio      � Data � 23.05.06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Configura sessao do cabecalho de contratos                 ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CNTR010Imp                                                 ���
�������������������������������������������������������������������������Ĵ��
���Parametros� oExp01 - Sessao do cabecalho - TRSection                   ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���            �        �      �                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function CR010Cab(oSectCab)
Local cContra	:= Replace(MV_PAR01,"CN9_NUMERO","CN9_NUMERO")
Local cRevisa	:= Replace(mv_par02,"CN9_REVISA","CN9_REVISA")
Local cPart	:= "%"
Local cCamp	:= "%"

cCamp += ",CN9_FILCTR"

If !Empty(mv_par07)
	cPart += "AND CN9.CN9_TPCTO = '" +mv_par07 +"' "
EndIf
If !Empty(mv_par14)
	cPart += "AND CN1.CN1_ESPCTR = '" +Str(mv_par14,1) +"' "
EndIf

cPart += '%'
cCamp += '%'

oSectCab:BeginQuery()
//����������������������������������������������������Ŀ
//� Gera query de filtro dos contratos                 �
//������������������������������������������������������
BeginSql alias "QRYCN9"

SELECT CN9_FILIAL,
		CN9_NUMERO,
		CN9_REVISA,
		CN9_DTINIC,
		CN9_SITUAC,
		CN9_DTFIM,
		CN9_DTPROP,
		CN9_ASSINA,
		CN9_DTENCE,
		CN9_CONDPG,
		CN9_TPCTO,
		CN9_DTULST,
		CN9_VIGE,
		CN9_INDICE,
		CN9_FLGCAU,
		CN9_MINCAU,
		CN9_FLGREJ,
		CN9_REVATU,
		CN9_VLINI,
		CN9_VLATU,
		CN9_SALDO,
		CN9_CODOBJ,
		CN9_CODCLA,
		CN9_CODJUS,
		CN9_UNVIGE,
		CN9_CLIENT,
		CN9_LOJACL,
		CN9_DTREV, 
		CN6_DESCRI
		%Exp:cCamp%

FROM 	%table:CN9% CN9

JOIN 	%Table:CN1% CN1 ON
		CN1.%NotDel% AND
		CN1.CN1_FILIAL = %xFilial:CN1% AND
		CN1.CN1_CODIGO = CN9.CN9_TPCTO

LEFT 	JOIN %table:CNC% CNC ON
		CNC.%notDel% AND
		CNC.CNC_FILIAL = %xfilial:CNC% AND
		CNC.CNC_NUMERO = CN9.CN9_NUMERO AND
		CNC.CNC_REVISA = CN9.CN9_REVISA

LEFT	JOIN %table:CN6% CN6 ON
		CN6.%notDel% AND
		CN6.CN6_FILIAL = %xfilial:CN6% AND
		CN6.CN6_CODIGO = CN9.CN9_INDICE

WHERE 	CN9.CN9_FILIAL = %xfilial:CN9% AND
     	CN9.CN9_DTINIC >= %exp:dtos(mv_par03)% AND
     	CN9.CN9_DTFIM  <= %exp:dtos(mv_par04)% AND
     	CN9.%notDel% %exp:cPart%
GROUP BY
		CN9_FILIAL,
		CN9_NUMERO,
		CN9_REVISA,
		CN9_DTINIC,
		CN9_SITUAC,
		CN9_DTFIM,
		CN9_DTPROP,
		CN9_ASSINA,
		CN9_DTENCE,
		CN9_CONDPG,
		CN9_TPCTO,
		CN9_DTULST,
		CN9_VIGE,
		CN9_INDICE,
		CN9_FLGCAU,
		CN9_MINCAU,
		CN9_FLGREJ,
		CN9_REVATU,
		CN9_VLINI,
		CN9_VLATU,
		CN9_SALDO,
		CN9_CODOBJ,
		CN9_CODCLA,
		CN9_CODJUS,
		CN9_UNVIGE,
		CN9_CLIENT,
		CN9_LOJACL,
		CN9_DTREV,
		CN6_DESCRI
		%Exp:cCamp%

ORDER BY CN9_NUMERO, CN9_REVISA

EndSql

If mv_par14 == 1
	oSectCab:EndQuery({cContra,cRevisa,MV_PAR05,MV_PAR06})
Else
	oSectCab:EndQuery({cContra,cRevisa,MV_PAR05,MV_PAR10})
EndIf

//����������������������������������������������������Ŀ
//� Configura posicionamento das tabelas filhas        �
//������������������������������������������������������
TRPosition():New(oSectCab,"SE4",1,"xFilial('SE4')+QRYCN9->CN9_CONDPG")//Cond. Pagto
TRPosition():New(oSectCab,"CN1",1,"xFilial('CN1')+QRYCN9->CN9_TPCTO")//Tipo de Contrato
Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    �CR010ApC  � Autor � Israel.Escorizza     � Data � 28.11.16 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Configura sessao do cabecalho de Aprova��es                ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CNTR010Imp                                                 ���
�������������������������������������������������������������������������Ĵ��
���Parametros� oE\xp01 - Sessao do cabecalho - TRSection                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������*/
Static Function CR010ApC(oSectApC)
Local cTipApr := ""
Local nTamCtr := TAMSX3('CN9_NUMERO')[1]
local nTamRev := TAMSX3('CN9_REVISA')[1]
Local nDe	  := 0

If Trim(TcGetDb()) = 'DB2'
	nDe := 1
Endif

If mv_par15 == 1 .And. mv_par16 == 1
	cTipApr := "CT','IC','RV','IR"
ElseIf mv_par15 == 1
	cTipApr := "CT','RV"
ElseIf mv_par16 == 1
	cTipApr := "IC','IR"
EndIf

BEGIN REPORT QUERY oSectApC
BeginSQL Alias "QRYSCR"

SELECT
	CR_NUM,
	CR_TIPO,
	CR_NIVEL,
	CR_APROV,
	CR_USER,
	CR_USERLIB,
	CR_STATUS,
	CR_DATALIB,
	R_E_C_N_O_
FROM
	%TABLE:SCR% SCR
WHERE
	(
	SCR.CR_FILIAL = %report_param:QRYCN9->CN9_FILIAL%
	OR
	SCR.CR_FILIAL = %report_param:QRYCN9->CN9_FILCTR%
	)
	AND

	SCR.CR_TIPO in (%exp:cTipApr%) AND
	(
		(SCR.CR_TIPO in ('CT','IC') AND %report_param:QRYCN9->CN9_NUMERO% = SUBSTRING(CR_NUM,%exp:nDe%,%exp:nTamCtr%) AND %report_param:QRYCN9->CN9_REVISA% = %exp:space(nTamRev)% )
		OR
		(SCR.CR_TIPO in ('RV','IR') AND SUBSTRING(CR_NUM,%Exp:nDe%,%exp:nTamCtr+nTamRev%) = %report_param:QRYCN9->(CN9_NUMERO+CN9_REVISA)% )
	) AND
	SCR.%notDel%

ORDER BY CR_NUM,CR_NIVEL,CR_DATALIB

EndSQL
END REPORT QUERY oSectApC

Return
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    �CR010Pla  � Autor � Marcelo Custodio      � Data � 23.05.06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Configura sessao do cabecalho de planilhas                 ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CNTR010Imp                                                 ���
�������������������������������������������������������������������������Ĵ��
���Parametros� oE\xp01 - Sessao do cabecalho - TRSection                   ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���            �        �      �                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function CR010Pla(oSectPla)

//����������������������������������������������������Ŀ
//� Gera query de filtro das planilhas                 �
//������������������������������������������������������

// BK - 21/11/19 - Incluido o campo CNA_XXMOT e CAN_XXMUN
BEGIN REPORT QUERY oSectPla
BeginSQL Alias "QRYCNA"

SELECT CNA_NUMERO, CNA_FORNEC, CNA_LJFORN, CNA_CRONOG, CNA_DTINI, CNA_VLTOT, CNA_SALDO, CNA_TIPPLA,
		CNA_DTFIM, CNA_FLREAJ, CNA_CONTRA, CNA_REVISA, CNA_CRONCT, CNA_CLIENT, CNA_LOJACL, CNA_XXMOT, CNA_XXMUN
FROM %Table:CNA% CNA
WHERE CNA_FILIAL = %xfilial:CNA% AND
	CNA.CNA_CONTRA = %report_param:QRYCN9->CN9_NUMERO% AND
	CNA.CNA_REVISA = %report_param:QRYCN9->CN9_REVISA% AND
	CNA.%NotDel%
ORDER BY CNA_CONTRA, CNA_REVISA, CNA_NUMERO

EndSQL
END REPORT QUERY oSectPla


//����������������������������������������������������Ŀ
//� Configura posicionamento das tabelas filhas        �
//������������������������������������������������������
TRPosition():New(oSectPla,"CNL",1,"xFilial('CNL')+QRYCNA->CNA_TIPPLA")//Tipos de Tabelas

Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    �CR010Itm  � Autor � Marcelo Custodio      � Data � 23.05.06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Configura sessao dos itens de planilhas                    ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CNTR010Imp                                                 ���
�������������������������������������������������������������������������Ĵ��
���Parametros� oExp01 - Sessao dos itens - TRSection                      ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���            �        �      �                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function CR010Itm(oSectItm)

//����������������������������������������������������Ŀ
//� Gera query de filtro dos itens de planilhas        �
//������������������������������������������������������
BEGIN REPORT QUERY oSectItm
BeginSQL Alias "QRYCNB"
SELECT CNB.CNB_ITEM, CNB.CNB_PRODUT, CNB.CNB_QUANT, CNB.CNB_VLUNIT, CNB.CNB_VLTOT, CNB.CNB_VLTOT, CNB.CNB_DESC,
	CNB.CNB_VLDESC, CNB.CNB_QTDMED, CNB.CNB_SLDMED, CNB.CNB_CONTRA, CNB.CNB_REVISA, CNB.CNB_NUMERO
FROM %Table:CNB% CNB
WHERE CNB.CNB_FILIAL = %xFilial:CNB% AND
	CNB.CNB_CONTRA = %report_param:QRYCN9->CN9_NUMERO% AND
	CNB.CNB_REVISA = %report_param:QRYCN9->CN9_REVISA% AND
	CNB.CNB_NUMERO = %report_param:QRYCNA->CNA_NUMERO% AND
	CNB.%NotDel%
ORDER BY CNB.CNB_CONTRA, CNB.CNB_REVISA, CNB.CNB_NUMERO, CNB.CNB_ITEM

EndSQL
END REPORT QUERY oSectItm

Return


//--------------------------------------------------------------------------------------------------------------
Static Function CR010Agr(oSectAgr)

//- Gera query de filtro dos itens de planilhas        �
BEGIN REPORT QUERY oSectAgr
BeginSQL Alias "QRYCXM"

SELECT CXM.CXM_CONTRA,
		CXM.CXM_REVISA,
		CXM.CXM_NUMERO,
		CXM.CXM_ITEMID,
		CXM.CXM_AGRTIP,
		CXM.CXM_AGRGRP,
		CXM.CXM_AGRCAT,
		CXM.CXM_VLMAX,
		CXM.CXM_VLMED

FROM 	%Table:CXM% CXM

WHERE 	CXM.CXM_FILIAL = %xFilial:CXM% 							AND
		CXM.CXM_CONTRA = %report_param:QRYCN9->CN9_NUMERO% 	AND
		CXM.CXM_REVISA = %report_param:QRYCN9->CN9_REVISA% 	AND
		CXM.CXM_NUMERO = %report_param:QRYCNA->CNA_NUMERO% 	AND
		CXM.%NotDel%

ORDER BY CXM.CXM_CONTRA, CXM.CXM_REVISA, CXM.CXM_NUMERO, CXM.CXM_ITEMID

EndSQL
END REPORT QUERY oSectAgr

Return


/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    �CR010Cro  � Autor � Marcelo Custodio      � Data � 23.05.06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Configura sessao dos cronogramas                           ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CNTR010Imp                                                 ���
�������������������������������������������������������������������������Ĵ��
���Parametros� oExp01 - Sessao dos cronogramas - TRSection                ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���            �        �      �                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function CR010Cro(oSectCro)

//����������������������������������������������������Ŀ
//� Gera query de filtro dos cronogramas               �
//������������������������������������������������������
BEGIN REPORT QUERY oSectCro
BeginSQL Alias "QRYCNF"

SELECT CNF.*
FROM %Table:CNF% CNF
WHERE CNF.CNF_FILIAL = %xFilial:CNF% AND
	CNF.CNF_CONTRA = %report_param:QRYCN9->CN9_NUMERO% AND
	CNF.CNF_REVISA = %report_param:QRYCN9->CN9_REVISA% AND
	CNF.CNF_NUMERO = %report_param:QRYCNA->CNA_CRONOG% AND
	CNF.%NotDel%
ORDER BY CNF.CNF_CONTRA, CNF.CNF_REVISA, CNF.CNF_NUMERO, CNF.CNF_PARCEL

EndSQL
END REPORT QUERY oSectCro

Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    �CR010Cac  � Autor � Marcelo Custodio      � Data � 23.05.06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Configura sessao das caucoes                               ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CNTR010Imp                                                 ���
�������������������������������������������������������������������������Ĵ��
���Parametros� oExp01 - Sessao das caucoes  - TRSection                   ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���            �        �      �                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function CR010Cac(oSectCac)

//����������������������������������������������������Ŀ
//� Gera query de filtro das caucoes                   �
//������������������������������������������������������
BEGIN REPORT QUERY oSectCac
BeginSQL Alias "QRYCN8"

SELECT CN8.*
FROM %Table:CN8% CN8
WHERE CN8.CN8_FILIAL = %xFilial:CN8% AND
	CN8.CN8_CONTRA = %report_param:QRYCN9->CN9_NUMERO% AND
	CN8.CN8_REVISA = %report_param:QRYCN9->CN9_REVISA% AND
	CN8.%NotDel%
ORDER BY CN8.CN8_CONTRA, CN8.CN8_REVISA, CN8.CN8_CODIGO

EndSQL
END REPORT QUERY oSectCac

Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    �CR010Frn  � Autor � Marcelo Custodio      � Data � 23.05.06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Configura sessao dos fornecedores de contratos             ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CNTR010Imp                                                 ���
�������������������������������������������������������������������������Ĵ��
���Parametros� oExp01 - Sessao dos fornecedores - TRSection               ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���            �        �      �                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function CR010Frn(oSectFrn)

//����������������������������������������������������Ŀ
//� Gera query de filtro dos fornecedores              �
//������������������������������������������������������
BEGIN REPORT QUERY oSectFrn
BeginSQL Alias "QRYCNC"

SELECT CNC.CNC_NUMERO,CNC.CNC_REVISA,CNC.CNC_CODIGO,CNC.CNC_LOJA
FROM %Table:CNC% CNC
WHERE CNC.CNC_FILIAL = %xFilial:CNC% AND
	CNC.CNC_NUMERO = %report_param:QRYCN9->CN9_NUMERO% AND
	CNC.CNC_REVISA = %report_param:QRYCN9->CN9_REVISA% AND
	CNC.%NotDel%
ORDER BY CNC.CNC_NUMERO, CNC.CNC_REVISA, CNC.CNC_CODIGO, CNC.CNC_LOJA

EndSQL
END REPORT QUERY oSectFrn

//����������������������������������������������������Ŀ
//� Configura posicionamento das tabelas filhas        �
//������������������������������������������������������
TRPosition():New(oSectFrn,"SA2",1,"xFilial('SA2')+QRYCNC->(CNC_CODIGO+CNC_LOJA)")//Fornecedores

Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    �CR010Cli  � Autor � Felipe Bittar         � Data � 05.03.09 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Configura sessao do cliente do contrato                    ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CNTR010Imp                                                 ���
�������������������������������������������������������������������������Ĵ��
���Parametros� oExp01 - Sessao dos clientes - TRSection                   ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���            �        �      �                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function CR010Cli(oSectCli)

//����������������������������������������������������Ŀ
//� Gera query de filtro dos clientes	               �
//������������������������������������������������������
BEGIN REPORT QUERY oSectCli

BeginSQL Alias "QRYCLI"

SELECT CNC.CNC_NUMERO, CNC.CNC_REVISA, CNC.CNC_CLIENT, CNC.CNC_LOJACL
FROM %Table:CNC% CNC
WHERE CNC.CNC_FILIAL = %xFilial:CNC% AND
	CNC.CNC_NUMERO = %report_param:QRYCN9->CN9_NUMERO% AND
	CNC.CNC_REVISA = %report_param:QRYCN9->CN9_REVISA% AND
	CNC.%NotDel%
ORDER BY CNC_NUMERO, CNC_REVISA, CNC_CLIENT, CNC_LOJACL

EndSQL
END REPORT QUERY oSectCli

//����������������������������������������������������Ŀ
//� Configura posicionamento das tabelas filhas        �
//������������������������������������������������������
TRPosition():New(oSectCli,"SA1",1,"xFilial('SA1')+QRYCLI->(CNC_CLIENT+CNC_LOJACL)")//Cliente

Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    �CR010Mul  � Autor � Marcelo Custodio      � Data � 23.05.06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Configura sessao das multas de contratos                   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CNTR010Imp                                                 ���
�������������������������������������������������������������������������Ĵ��
���Parametros� oExp01 - Sessao dos multas - TRSection                     ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���            �        �      �                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function CR010Mul(oSectMul)

//����������������������������������������������������Ŀ
//� Gera query de filtro das multas                    �
//������������������������������������������������������
BEGIN REPORT QUERY oSectMul
BeginSQL Alias "QRYCNH"

SELECT CNH.*
FROM %Table:CNH% CNH
WHERE CNH_FILIAL = %xFilial:CNH% AND
	CNH.CNH_NUMERO = %report_param:QRYCN9->CN9_NUMERO% AND
	CNH.CNH_REVISA = %report_param:QRYCN9->CN9_REVISA% AND
	CNH.%NotDel%
ORDER BY CNH_NUMERO, CNH_CODIGO

EndSQL
END REPORT QUERY oSectMul

//����������������������������������������������������Ŀ
//� Configura posicionamento das tabelas filhas        �
//������������������������������������������������������
TRPosition():New(oSectMul,"CN4",1,"xFilial() + QRYCNH->CNH_CODIGO")//Tipos de Multas

Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    �CR010Med  � Autor � Marcelo Custodio      � Data � 23.05.06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Configura sessao dos cabecalhos de medicao                 ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CNTR010Imp                                                 ���
�������������������������������������������������������������������������Ĵ��
���Parametros� oExp01 - Sessao do cabecalho de medicao - TRSection        ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���            �        �      �                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function CR010Med(oSectMed)
Local cExpWhere := "%"

cExpWhere += "CND.CND_FILCTR = %report_param:QRYCN9->CN9_FILCTR% AND%"

//����������������������������������������������������Ŀ
//� Gera query de filtro das medicoes                  �
//������������������������������������������������������
BEGIN REPORT QUERY oSectMed
BeginSQL Alias "QRYCND"

SELECT CND.CND_FILIAL, CND.CND_NUMMED, CND.CND_NUMERO, CND.CND_CONTRA, CND.CND_REVISA, CND.CND_FORNEC, CND.CND_LJFORN,
	CND.CND_COMPET, CND.CND_DTVENC, CND.CND_VLMEAC, CND.CND_VLSALD, CND.CND_VLTOT
FROM %Table:CND% CND
WHERE %Exp:cExpWhere%
	CND.CND_CONTRA = %report_param:QRYCN9->CN9_NUMERO% AND
	CND.CND_REVISA = %report_param:QRYCN9->CN9_REVISA% AND
	CND.%NotDel%
ORDER BY CND.CND_CONTRA, CND.CND_REVISA, CND.CND_NUMMED

EndSQL
END REPORT QUERY oSectMed

Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    �CR010IMe  � Autor � Marcelo Custodio      � Data � 23.05.06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Configura sessao dos itens de medicoes                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CNTR010Imp                                                 ���
�������������������������������������������������������������������������Ĵ��
���Parametros� oExp01 - Sessao dos itens de medicoes - TRSection          ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���            �        �      �                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function CR010IMe(oSectIMe)

//����������������������������������������������������Ŀ
//� Gera query de filtro dos itens de medicoes         �
//������������������������������������������������������
BEGIN REPORT QUERY oSectIMe
BeginSQL Alias "QRYCNE"

SELECT CNE.CNE_ITEM, CNE.CNE_CONTRA, CNE.CNE_REVISA, CNE.CNE_NUMMED, CNE.CNE_PRODUT, CNE.CNE_QTDSOL,
	 CNE.CNE_QTAMED, CNE.CNE_QUANT, CNE.CNE_PERC, CNE.CNE_VLUNIT, CNE.CNE_VLTOT
FROM %Table:CNE% CNE
WHERE CNE.CNE_FILIAL = %report_param:QRYCND->CND_FILIAL% AND
	CNE.CNE_CONTRA = %report_param:QRYCN9->CN9_NUMERO% AND
	CNE.CNE_REVISA = %report_param:QRYCN9->CN9_REVISA% AND
	CNE.CNE_NUMMED = %report_param:QRYCND->CND_NUMMED% AND
	CNE.%NotDel%
ORDER BY CNE_CONTRA,CNE_REVISA,CNE_NUMMED,CNE_ITEM

EndSQL
END REPORT QUERY oSectIMe

Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    �CR010Ctb  � Autor � Marcelo Custodio      � Data � 27.02.07 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Configura sessao dos cronogramas contabeis                 ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CNTR010Imp                                                 ���
�������������������������������������������������������������������������Ĵ��
���Parametros� oExp01 - Sessao dos cronogramas contabeis - TRSection      ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���            �        �      �                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function CR010Ctb(oSectCtb)

//����������������������������������������������������Ŀ
//� Gera query de filtro dos cronogramas               �
//������������������������������������������������������
BEGIN REPORT QUERY oSectCtb
BeginSQL Alias "QRYCNW"

SELECT CNW.*
FROM %Table:CNW% CNW
WHERE CNW.CNW_FILIAL = %xFilial:CNW% AND
	CNW.CNW_CONTRA = %report_param:QRYCN9->CN9_NUMERO% AND
	CNW.CNW_REVISA = %report_param:QRYCN9->CN9_REVISA% AND
	CNW.CNW_NUMERO = %report_param:QRYCNA->CNA_CRONCT% AND
	CNW.%NotDel%
ORDER BY CNW.CNW_CONTRA, CNW.CNW_REVISA, CNW.CNW_NUMERO, CNW.CNW_PARCEL

EndSQL
END REPORT QUERY oSectCtb

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    � CNR010CroCtb| Autor �                    � Data �03/03/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Cronogramas							                             ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Codigo do Cronograma                               ���
���          � ExpC2 = Codigo do Contrato                                 ���
���          � ExpC3 = Codigo da Revisao                                  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CNTR010 / CNTR020                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
/*
Static Function CNR010CroCtb(cAliasCronCtb,cContrato,cRevisao)
Local aAreaAnt := GetArea()
Local cCron
//��������������������������������������������������������������Ŀ
//� Inicializa Fontes										              �
//����������������������������������������������������������������
Local oFont06  := TFont():New("Arial",06,08,,.T.,,,,.T.,.F.)
//��������������������������������������������������������������Ŀ
//� Recupera Picture dos Campos									        �
//����������������������������������������������������������������
Local cPtVLPREV := PesqPict("CNW","CNW_VLPREV")

dbSelectArea(cAliasCronCtb)

cCron := (cAliasCronCtb)->CNV_NUMERO

nLin += 50
CNRBox(050,2350,"CRONOGRAMA CONTABIL",,.T.,1) //-- Cabecalho CRONOGRAMA
//��������������������������������������������������������Ŀ
//� Cabecalho do Cronograma	Contabil    			        �
 //����������������������������������������������������������
CNRBox(0050,0280,RetTitle("CNW_NUMERO"),,.F.,2,oFont06)
CNRBox(0285,0400,RetTitle("CNW_PARCEL"),,.F.,2,oFont06)
CNRBox(0405,0600,RetTitle("CNW_COMPET"),,.F.,2,oFont06)
CNRBox(0605,0800,RetTitle("CNW_DTPREV"),,.F.,2,oFont06)
CNRBox(0805,1180,RetTitle("CNW_VLPREV"),,.F.,2,oFont06)
CNRBox(1185,1720,RetTitle("CNW_HIST"),,.F.,2,oFont06)
CNRBox(1725,1910,RetTitle("CNW_CC"),,.F.,2,oFont06)
CNRBox(1915,2120,RetTitle("CNW_ITEMCT"),,.F.,2,oFont06)
CNRBox(2125,2350,RetTitle("CNW_CLVL"),,.F.,2,oFont06)
nLin += 50
Do While !Eof() .And. (cAliasCronCtb)->CNV_NUMERO == cCron
   //��������������������������������������������������������Ŀ
	//� Impressao dos Itens do Cronograma					        �
   //����������������������������������������������������������
   //-- Num. Cronograma
	CNRBox(0050,0280,(cAliasCronCtb)->CNW_NUMERO,,.F.,2,oFont06)
   //-- Parcela
    CNRBox(0285,0400,(cAliasCronCtb)->CNW_PARCEL,,.F.,2,oFont06)
   //-- Competencia
	CNRBox(0405,0600,(cAliasCronCtb)->CNW_COMPET,,.F.,2,oFont06)
	//-- Data
	CNRBox(0605,0800,(cAliasCronCtb)->CNW_DTPREV,,.F.,2,oFont06,.T.)
	//-- Vl. Apropriado
	CNRBox(0805,1180,TransForm((cAliasCronCtb)->(C010xMoeda(.F.,cContrato,cRevisao,"CNW_VLPREV")),cPtVLPREV),,.F.,2,oFont06,.T.)
	//-- Hist
	CNRBox(1185,1720,AllTrim((cAliasCronCtb)->CNW_HIST),,.F.,2,oFont06,.F.)
	//-- Cc
	CNRBox(1725,1910,(cAliasCronCtb)->CNW_CC,,.F.,2,oFont06)
	//-- Item Ct
	CNRBox(1915,2120,(cAliasCronCtb)->CNW_ITEMCT,,.F.,2,oFont06)
	//-- Cls. Valor
	CNRBox(2125,2350,(cAliasCronCtb)->CNW_CLVL,,.T.,2,oFont06)
	(cAliasCronCtb)->(dbSkip())
EndDo
RestArea(aAreaAnt)
Return
*/

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    �CR010Des  � Autor � Felipe Bittar         � Data � 14.08.08 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Configura sessao de multas/bonificacoes de medicoes        ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CNTR010Imp                                                 ���
�������������������������������������������������������������������������Ĵ��
���Parametros� oExp01 - Sessao de multas/bonific de medicoes - TRSection  ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���            �        �      �                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function CR010Bon(oSectBon)

//����������������������������������������������������Ŀ
//� Gera query de filtro das bonificacoes de medicoes  �
//������������������������������������������������������
BEGIN REPORT QUERY oSectBon
BeginSQL Alias "QRYCNR"

SELECT CNR.CNR_NUMMED, CNR.CNR_TIPO, CNR.CNR_DESCRI, CNR.CNR_VALOR
FROM %Table:CNR% CNR
WHERE CNR.CNR_FILIAL = %report_param:QRYCND->CND_FILIAL% AND
	CNR.CNR_NUMMED = %report_param:QRYCND->CND_NUMMED% AND
	CNR.%NotDel%
ORDER BY CNR.CNR_NUMMED, CNR.CNR_TIPO

EndSQL
END REPORT QUERY oSectBon

Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    �CR010Des  � Autor � Felipe Bittar         � Data � 14.08.08 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Configura sessao dos descontos de medicoes                 ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CNTR010Imp                                                 ���
�������������������������������������������������������������������������Ĵ��
���Parametros� oExp01 - Sessao de descontos de medicoes - TRSection       ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���            �        �      �                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function CR010Des(oSectDes)

//����������������������������������������������������Ŀ
//� Gera query de filtro dos descontos de medicoes     �
//������������������������������������������������������
BEGIN REPORT QUERY oSectDes
BeginSQL Alias "QRYCNQ"

SELECT CNQ.CNQ_NUMMED, CNQ.CNQ_TPDESC, CNQ.CNQ_VALOR, CNP.CNP_DESCRI
FROM %Table:CNQ% CNQ
JOIN %Table:CNP% CNP ON
	CNP.CNP_FILIAL = %xFilial:CNP% AND
	CNP.%NotDel% AND
	CNP.CNP_CODIGO = CNQ.CNQ_TPDESC
WHERE CNQ.CNQ_FILIAL = %report_param:QRYCND->CND_FILIAL% AND
	CNQ.CNQ_NUMMED = %report_param:QRYCND->CND_NUMMED% AND
	CNQ.%NotDel%
ORDER BY CNQ.CNQ_NUMMED, CNQ.CNQ_TPDESC

EndSQL
END REPORT QUERY oSectDes

Return

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �CNR010ClFr� Autor � Aline Sebrian         � Data � 04.01.11 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Valida os parametro do Cliente e Fornecedor no relatorio.   ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �CNR010ClFr()                                                ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �CNR010ClFr()                                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
/*
Static Function CNR010ClFr(cCnr,cTipo)
Local aSaveArea	:= GetArea()

If cCnr=="CNR010"
	If cTipo=="1"
		If !Empty(mv_par09) .Or. (!Empty(mv_par10) .And. UPPER(mv_par10) != REPLICATE("Z",TamSx3("CNC_CODIGO")[1]))
			mv_par23	:= Space(6)
			mv_par24	:= REPLICATE("Z",TamSx3("A1_COD")[1])
		EndIf
	Else
		If !Empty(mv_par23) .Or. (!Empty(mv_par24) .And. UPPER(mv_par24) != REPLICATE("Z",TamSx3("A1_COD")[1]))
			MV_PAR09	:= Space(6)
			MV_PAR10	:= REPLICATE("Z",TamSx3("CNC_CODIGO")[1])
		EndIf
	EndIf
Else
	If cTipo=="1"
		If !Empty(MV_PAR06)
			MV_PAR10	:= Space(6)
		EndIf
	Else
		If !Empty(MV_PAR10)
			MV_PAR06	:= Space(6)
		EndIf
	EndIf
EndIf

RestArea(aSaveArea)

Return
*/

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �C010xMoeda�Autor  �Microsiga           � Data �  11/06/11   ���
�������������������������������������������������������������������������͹��
���Descricao � Realiza a conversao entre moedas de um determinado valor.  ���
�������������������������������������������������������������������������͹��
���Parametros� lTReport: indica se a impressao e em TReport.			  ���
���			 � cContra: numero do contrato que esta sendo impresso.		  ���
���			 � cRev: revisao do contrato que esta sendo impresso.		  ���
���			 � cCampo: nome do campo a ser convertido.					  ���
�������������������������������������������������������������������������͹��
���Retorno	 � nRet: valor apos conversao								  ���
�������������������������������������������������������������������������͹��
���Uso       � CNTR010													  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function C010xMoeda(lTReport,cContra,cRev,cCampo)
Local dDataRef  := If(lTReport,mv_par13,mv_par27)
Local nMoedaOri	:= 0
Local nMoedaDes := 0
Local nRet 		:= 0

If "CNTR020" $ FunName()
	//-- Impressao da planilha e itens da planilha no CNTR020
	nRet := C020xMoeda(lTReport,cContra,cRev,cCampo)
Else
	If Empty(dDataRef)
		dDataRef := dDataBase
	EndIf
	nMoedaOri := If(Substr(cCampo,1,3) == "CN8",CN8_MOEDA,Posicione("CN9",1,xFilial("CN9")+cContra+cRev,"CN9_MOEDA"))
	nMoedaDes := nMoedaOri
	nRet	  := &(cCampo)

	If lTReport
		If mv_par11 == 2
			nMoedaDes := mv_par12
		EndIf
	ElseIf mv_par25 == 2
		nMoedaDes := mv_par26
	EndIf

	nRet := Round(xMoeda(nRet,nMoedaOri,nMoedaDes,dDataRef,6),TamSX3(cCampo)[2])
EndIf

Return nRet

//- Fun��o para retornar Memo da SCR
Static Function C010GtMemo(nRecno)
Local aAreaSCR:= SCR->(GetArea())
Local cRet 	:= ""
SCR->(MsGoto(nRecno))
cRet := AllTrim(SCR->CR_OBS)
RestArea(aAreaSCR)
Return cRet

