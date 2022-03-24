#Include "Protheus.ch"

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  � X01WFPAR � Autor � Thiago Menegocci    � Data � 15/08/2008  ���
��������������������������������������������������������������������������͹��
���Descricao � Rotina para manutencao dos paramentros                      ���
��������������������������������������������������������������������������͹��
���Uso       � BK                                                          ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
User Function X01WFPAR()

Local oTELA01
Private cDPTOLB

u_LogPrw("X01WFPAR")

cDPTOLB := Left(AllTrim(GetMV("MV_PARPIS")),4)
cDPTOLC := Left(AllTrim(GetMV("MV_PARCOF")),4)

Define MsDialog oTELA01 Title "Porcentagem de Apura��o PIS/COFINS" From 000,000 To 155,410 Of oTELA01 Pixel
@010,004 Say "Porcentagem PIS:" Size 070,025 Pixel Of oTELA01
@020,004 MsGet cDPTOLB Picture "@!" Size 040,007 Pixel Of oTELA01
@036,004 Say "Porcentagem COFINS:" Size 070,025 Pixel Of oTELA01
@046,004 MsGet cDPTOLC Picture "@!" Size 040,007 Pixel Of oTELA01
@056,004 Say "Exemplo: 1.65" Size 050,025 Pixel Of oTELA01
@025,110 Button "&Cancelar" Size 036,013 Pixel Action oTELA01:End()
@025,152 Button "&Ok" Size 036,013 Pixel Action (X01WFSX6(),oTELA01:End())
Activate MsDialog oTELA01 Centered

Return()

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  � X01WFSX6 � Autor � Thiago Menegocci    � Data � 15/08/2008  ���
��������������������������������������������������������������������������͹��
���Descricao � Rotina de gravacao dos paramentros.                         ���
��������������������������������������������������������������������������͹��
���Uso       � Audax                                                       ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
Static Function X01WFSX6()

DbSelectArea("SX6")															//SELECIONA TABELA DE PARAMENTROS
DbSetOrder(1)																//SELECIONA INDICE

////////////
//AJUSTA PARAMETROS
////////////  
If DbSeek(Space(2)+"MV_PARPIS")
	RecLock("SX6",.F.)
	SX6->X6_CONTEUD := AllTrim(cDPTOLB)
	Msunlock()
EndIf

If DbSeek(Space(2)+"MV_PARCOF")
	RecLock("SX6",.F.)
	SX6->X6_CONTEUD := AllTrim(cDPTOLC)
	Msunlock()
EndIf
                              
Return()
