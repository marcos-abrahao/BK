// Marcos B. Abrah�o - 31/10/14
#include "rwmake.ch" 

///--------------------------------------------------------------------------\
//| Fun��o: CONVLD          Autor: Daniel Gondran           Data: 23/07/2007 |
//|--------------------------------------------------------------------------|
//| Descri��o: Fun��o para Convers�o da Representa��o Num�rica do C�digo de  |
//|            Barras - Linha Digit�vel (LD) em C�digo de Barras (CB).       |
//|                                                                          |
//|            Para utiliza��o dessa Fun��o, deve-se criar um Gatilho para o |
//|            campo E2_CODBAR, Conta Dom�nio: E2_CODBAR, Tipo: Prim�rio,    |
//|            Regra: EXECBLOCK("CONVLD",.T.), Posiciona: N�o.               |
//|                                                                          |
//|            Utilize tamb�m a Valida��o do Usu�rio para o Campo E2_CODBAR  |
//|            EXECBLOCK("CODBAR",.T.) para Validar a LD ou o CB.            |
//\--------------------------------------------------------------------------/ 

USER FUNCTION ConvLD()
Local cStr := M->E2_CODBAR
cStr := U_ConvTLD(cStr)
RETURN(cStr)


USER FUNCTION ConvTLD(cStr)

IF VALTYPE(cStr) == NIL .OR. EMPTY(cStr) .OR. SUBSTR(cStr,1,1) $ "CT"
     // Se o Campo est� em Branco n�o Converte nada.
     //cStr := ""
     RETURN(cStr)
ENDIF

cStr := ALLTRIM(cStr)

// Se o Tamanho do String for menor que 44, completa com zeros at� 47 d�gitos. Isso �
// necess�rio para Bloquetos que N�O t�m o vencimento e/ou o valor informados na LD.
cStr := IF(LEN(cStr)<44,cStr+REPL("0",47-LEN(cStr)),cStr)

DO CASE
CASE LEN(cStr) == 47
     cStr := SUBSTR(cStr,1,4)+SUBSTR(cStr,33,15)+SUBSTR(cStr,5,5)+SUBSTR(cStr,11,10)+SUBSTR(cStr,22,10)
CASE LEN(cStr) == 48
     //cStr := SUBSTR(cStr,1,11)+SUBSTR(cStr,13,11)+SUBSTR(cStr,25,11)+SUBSTR(cStr,37,11)
OTHERWISE
     cStr := cStr+SPACE(48-LEN(cStr))
ENDCASE

RETURN(cStr)
