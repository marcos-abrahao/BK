#include "rwmake.ch"

// Filtra CNAB a pagar
//O ponto de entrada F240FILTC � utilizado para montar o filtro para
// Indregua ap�s o preenchimento da tela de dados do border� na gera��o do(s) arquivo(s)
// do SISPAG (FINA300). O filtro retornado pelo ponto de entrada ser� anexado ao filtro padr�o do programa.
User Function F240FILTC()
Local cRet := ".T."

IF SEA->EA_SITUANT == "X"
	cRet := ".F."
ENDIF

Return cRet



