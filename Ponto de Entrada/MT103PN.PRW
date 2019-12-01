#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT103PN �Autor  �Adilson do Prado       � Data �  03/11/15 ���
�������������������������������������������������������������������������͹��
���Desc.     � Este ponto de entrada pertence � rotina de manuten��o de   ���
���          � documentos de entrada, MATA103. � executada em A103NFISCAL,���
���          � na inclus�o de um documento de entrada. Ela permite ao     ���
���          � usu�rio decidir se a inclus�o ser� executada ou n�o.       ���
�������������������������������������������������������������������������͹��
���Uso       � BK                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

USER FUNCTION MT103PN
Local lRet	 := .T.
Local aUser:={},aGrupo:={}
Local cAlmox := ""
Local lAlmox := .F.
Local aAreaIni  := GetArea()
Local lClass := .T.

PswOrder(1) 
PswSeek(__CUSERID) 
aUser  := PswRet(1)
cAlmox := SuperGetMV("MV_XXGRALX",.F.,"000021") 
lAlmox := .F.
aGRUPO := {}
//AADD(aGRUPO,aUser[1,10])
//FOR i:=1 TO LEN(aGRUPO[1])
//	lAlmox := (aGRUPO[1,i] $ cAlmox)
//NEXT
//Ajuste nova rotina a antiga n�o funciona na nova lib MDI
aGRUPO := UsrRetGrp(aUser[1][2])
IF LEN(aGRUPO) > 0
	FOR i:=1 TO LEN(aGRUPO)
		lAlmox := (ALLTRIM(aGRUPO[i]) $ cAlmox )
	NEXT
ENDIF	
IF lAlmox 
    dbSelectArea("SD1")                   // * Itens da N.F. de Compra
    IF DbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
       DO WHILE !EOF() .AND. SD1->D1_FILIAL+SD1->D1_DOC+ SD1->D1_SERIE+ SD1->D1_FORNECE+ SD1->D1_LOJA  == 	xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA  
    		IF LEN(ALLTRIM(SD1->D1_PEDIDO)) == 0
				lClass := .F.
       		ENDIF				
          SD1->(dbSkip())
       ENDDO
    ENDIF
ENDIF 

IF !lClass
	MsgStop("Esse usu�rio n�o possui acesso para executar essa opera��o!!")
	lRet := .F.
ENDIF

RestArea(aAreaIni)

Return lRet