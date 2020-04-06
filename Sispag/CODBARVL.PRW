// Marcos B. Abrah�o - 29/01/15
#include "rwmake.ch"

/*/
34191090081040290094712500520007760860000127000 
34197608600001270001090010402900941250052000
23792716009000000306222001444409861170000122858
34191579086224312094620638270007461030000086089  

Boleto LD
23790326069000000002785004411204961300000055250



Vivo
846000000113400010299990999999990107001028014551
/*/


///--------------------------------------------------------------------------\
//| Fun��o: CODBAR                                          Data: 23/07/2007 |
//|--------------------------------------------------------------------------|
//| Essa Fun��o foi desenvolvida com base no Manual do Bco. Ita� e no RDMAKE:|
//| CODBARVL - Autor: Vicente Sementilli - Data: 26/02/1997.                 |
//|--------------------------------------------------------------------------|
//| Descri��o: Fun��o para Valida��o de C�digo de Barras (CB) e Representa��o|
//|            Num�rica do C�digo de Barras - Linha Digit�vel (LD).          |
//|                                                                          |
//|            A LD de Bloquetos possui tr�s Digitos Verificadores (DV) que  |
//|            s�o consistidos pelo M�dulo 10, al�m do D�gito Verificador    |
//|            Geral (DVG) que � consistido pelo M�dulo 11. Essa LD t�m 47   |
//|            D�gitos.                                                      |
//|                                                                          |
//|            A LD de T�tulos de Concession�rias do Servi�o P�blico e IPTU  |
//|            possui quatro Digitos Verificadores (DV) que s�o consistidos  |
//|            pelo M�dulo 10, al�m do Digito Verificador Geral (DVG) que    |
//|            tamb�m � consistido pelo M�dulo 10. Essa LD t�m 48 D�gitos.   |
//|                                                                          |
//|            O CB de Bloquetos e de T�tulos de Concession�rias do Servi�o  |
//|            P�blico e IPTU possui apenas o D�gito Verificador Geral (DVG) |
//|            sendo que a �nica diferen�a � que o CB de Bloquetos �         |
//|            consistido pelo M�dulo 11 enquanto que o CB de T�tulos de     |
//|            Concession�rias � consistido pelo M�dulo 10. Todos os CB�s    |
//|            t�m 44 D�gitos.                                               |
//|                                                                          |
//|            Para utiliza��o dessa Fun��o, deve-se criar o campo E2_CODBAR,|
//|            Tipo Caracter, Tamanho 48 e colocar na Valida��o do Usu�rio:  |
//|            EXECBLOCK("CODBAR",.T.).                                      |
//|                                                                          |
//|            Utilize tamb�m o gatilho com a Fun��o CONVLD() para converter |
//|            a LD em CB.                                                                                     |
//\--------------------------------------------------------------------------/

/*
	Fun��es Totvs padr�es dispon�veis para CNAB

	MOD10 - Calcula o digito verificado de uma seq��ncia de n�meros baseados no Ambiente 10. Utilizando
	para verificar o digito em linhas digit�veis e c�digo de barras de concession�rias de servi�os p�blicos.

	MOD11- Calculo o digito verificador de uma seq��ncia de n�meros baseando-se no Ambiente 11.
	Utilizado para verificar o digito em linhas digit�veis e c�digo de barras em geral.

	VLDCODBAR- Valida o c�digo de barras ou a linha digit�vel de t�tulos a pagar ou a receber;

	SOMAVALOR- Retorna o valor total dos t�tulos remetidos.

	INCREMENTA- Retorna o pr�ximo numero da seq��ncia de linhas para o CNAB modelo 1.

	INCREMENTAL- Retorna o pr�ximo numero da seq��ncia de linhas para o CNAB modelo 2.

	NOSSONUM- Retorna o pr�ximo numero dispon�vel para identifica��o do titulo de acordo com a faixa
	de numera��o fornecida pelo banco, utilizada quando os boletos s�o impressos pela empresa.

	NUMTITULO- Retorna a chave de localiza��o de um titulo somente para a carteira a pagar.

	GRAVADATA- Converte uma data no formato DD/MM/AAAA para um dos 6 formatos caracteres pr�-definidos.
*/

 
USER FUNCTION CodBarVl()
Local lRet := .T.
lRet := U_CodBarTVl(M->E2_CODBAR,M->E2_SALDO)
Return lRet



USER FUNCTION CodBarTVl(cStr,nValor)
Local lRet:=.T.,cTipo:="",i:=0
Local nValPg,cValor

// Retorna .T. se o Campo estiver em Branco e tamb�m se 
//    SUBSTR(cStr,1,1) = "C" -> Credito em Conta Corrente
//    SUBSTR(cStr,1,1) = "T" -> Pagamento de Tributo sem codigos de barras

IF VALTYPE(cStr) == NIL .OR. EMPTY(cStr) .OR. SUBSTR(cStr,1,1) $ "CT"
     RETURN(.T.)
ENDIF

cStr := ALLTRIM(cStr)

// Se o Tamanho do String for 45 ou 46 est� errado! Retornar� .F.
lRet := IF(LEN(cStr)==45 .OR. LEN(cStr)==46,.F.,.T.)

// Se o Tamanho do String for menor que 44, completa com zeros at� 47 d�gitos. Isso �
// necess�rio para Bloquetos que N�O t�m o vencimento e/ou o valor informados na LD.
cStr := IF(LEN(cStr)<44,cStr+REPL("0",47-LEN(cStr)),cStr)

// Verifica se a LD � de (B)loquetos ou (C)oncession�rias/IPTU. Se for CB retorna (I)ndefinido.
cTipo := IF(LEN(cStr)==47,"B",IF(LEN(cStr)==48,"C","I"))

// Verifica se todos os d�gitos s�o num�rios.
FOR i := LEN(cStr) TO 1 STEP -1
     lRet := IF(SUBSTR(cStr,i,1) $ "0123456789",lRet,.F.)
NEXT

IF lRet
	lRet := VldCodBar(cStr)
ENDIF


IF LEN(cStr) == 47 .AND. lRet
/*
     // Consiste os tr�s DV�s de Bloquetos pelo M�dulo 10.
     nConta := 1
     WHILE nConta <= 3
          nMult := 2
          nVal   := 0
          nDV    := VAL(SUBSTR(cStr,IF(nConta==1,10,IF(nConta==2,21,32)),1))
          cCampo := SUBSTR(cStr,IF(nConta==1,1,IF(nConta==2,11,22)),IF(nConta==1,9,10))
          FOR i := LEN(cCampo) TO 1 STEP -1
               nMod := VAL(SUBSTR(cCampo,i,1)) * nMult
               nVal := nVal + IF(nMod>9,1,0) + (nMod-IF(nMod>9,10,0))
               nMult := IF(nMult==2,1,2)
          NEXT
          nDVCalc := 10-MOD(nVal,10)
          // Se o DV Calculado for 10 � assumido 0 (Zero).
          nDVCalc := IF(nDVCalc==10,0,nDVCalc)
          lRet    := IF(lRet,(nDVCalc==nDV),.F.)
          nConta := nConta + 1               
     ENDDO
*/
     // Se os DV�s foram consistidos com sucesso (lRet=.T.), converte o n�mero para CB para consistir o DVG. 
     cStr := IF(lRet,SUBSTR(cStr,1,4)+SUBSTR(cStr,33,15)+SUBSTR(cStr,5,5)+SUBSTR(cStr,11,10)+SUBSTR(cStr,22,10),cStr)
ENDIF

IF LEN(cStr) == 48 .AND. lRet
/*
     // Consiste os quatro DV�s de T�tulos de Concession�rias de Servi�o P�blico e IPTU pelo M�dulo 10.
     nConta := 1
     WHILE nConta <= 4
          nMult := 2
          nVal   := 0
          nDV    := VAL(SUBSTR(cStr,IF(nConta==1,12,IF(nConta==2,24,IF(nConta==3,36,48))),1))
          cCampo := SUBSTR(cStr,IF(nConta==1,1,IF(nConta==2,13,IF(nConta==3,25,37))),11)
          FOR i := 11 TO 1 STEP -1
               nMod := VAL(SUBSTR(cCampo,i,1)) * nMult
               nVal := nVal + IF(nMod>9,1,0) + (nMod-IF(nMod>9,10,0))
               nMult := IF(nMult==2,1,2)
          NEXT
          nDVCalc := 10-MOD(nVal,10)
          // Se o DV Calculado for 10 � assumido 0 (Zero).
          nDVCalc := IF(nDVCalc==10,0,nDVCalc)
          lRet    := IF(lRet,(nDVCalc==nDV),.F.)
          nConta := nConta + 1               
     ENDDO
*/
     // Se os DV�s foram consistidos com sucesso (lRet=.T.), converte o n�mero para CB para consistir o DVG. 
     cStr := IF(lRet,SUBSTR(cStr,1,11)+SUBSTR(cStr,13,11)+SUBSTR(cStr,25,11)+SUBSTR(cStr,37,11),cStr)
ENDIF

/*
IF LEN(cStr) == 44 .AND. lRet
     IF cTipo $ "BI"
          // Consiste o DVG do CB de Bloquetos pelo M�dulo 11.
          nMult := 2
          nVal   := 0
          nDV    := VAL(SUBSTR(cStr,5,1))
          cCampo := SUBSTR(cStr,1,4)+SUBSTR(cStr,6,39)
          FOR i := 43 TO 1 STEP -1
               nMod := VAL(SUBSTR(cCampo,i,1)) * nMult
               nVal := nVal + nMod
               nMult := IF(nMult==9,2,nMult+1)
          NEXT
          nDVCalc := 11-MOD(nVal,11)
          // Se o DV Calculado for 0,10 ou 11 � assumido 1 (Um).
          nDVCalc := IF(nDVCalc==0 .OR. nDVCalc==10 .OR. nDVCalc==11,1,nDVCalc)          
          lRet    := IF(lRet,(nDVCalc==nDV),.F.)
          // Se o Tipo � (I)ndefinido E o DVG N�O foi consistido com sucesso (lRet=.F.), tentar�
          // consistir como CB de T�tulo de Concession�rias/IPTU no IF abaixo. 
     ENDIF
     IF cTipo == "C" .OR. (cTipo == "I" .AND. !lRet)
          // Consiste o DVG do CB de T�tulos de Concession�rias pelo M�dulo 10.
          lRet   := .T.
          nMult := 2
          nVal   := 0
          nDV    := VAL(SUBSTR(cStr,4,1))
          cCampo := SUBSTR(cStr,1,3)+SUBSTR(cStr,5,40)
          FOR i := 43 TO 1 STEP -1
               nMod := VAL(SUBSTR(cCampo,i,1)) * nMult
               nVal := nVal + IF(nMod>9,1,0) + (nMod-IF(nMod>9,10,0))
               nMult := IF(nMult==2,1,2)
          NEXT
          nDVCalc := 10-MOD(nVal,10)
          // Se o DV Calculado for 10 � assumido 0 (Zero).
          nDVCalc := IF(nDVCalc==10,0,nDVCalc)
          lRet    := IF(lRet,(nDVCalc==nDV),.F.)
     ENDIF
ENDIF
*/

IF !lRet
     HELP(" ",1,"ONLYNUM")
ELSEIF nValor > 0
	nValPg := 0
	IF cTipo $ "BI"
		cValor := SUBSTR(cStr,10,10)
		nValPg := VAL(cValor)/100
		IF nValPg <> nValor
			lRet := MsgYesNo("Valor do boleto (R$ "+ALLTRIM(STR(nValPG,11,2))+") difere do saldo do t�tulo, aceitar assim mesmo?","CodBarTVl")
		ENDIF
	ELSEIF cTipo == "C"
		cValor := SUBSTR(cStr,5,11)   // Aqui o cStr est� sem os digitos verificadores
		nValPg := VAL(cValor)/100
		IF nValPg <> nValor
			lRet := MsgYesNo("Valor da fatura (R$ "+ALLTRIM(STR(nValPG,11,2))+") difere do saldo do t�tulo, aceitar assim mesmo?","CodBarTVl")
		ENDIF
	ENDIF	
ENDIF

RETURN(lRet) 

