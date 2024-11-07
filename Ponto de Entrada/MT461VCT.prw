#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} MT461VCT
BK - Ponto de Entrada - Ponto-de-Entrada: MT461VCT - Altera��o no vencimento e valor do t�tulo (Somente Faturamento) 
Solicitado por Diego Oliveira - #0924545
@Return
@author  Marcos Bispo Abrah�o
@since 11/09/2024
@version P12
/*/
User Function MT461VCT()

Local _aVencto := PARAMIXB[1]
//Local _aTitulo := PARAMIXB[2]
Local dVencto                             

// Condicao especifica F10 com vencimento sempre dia 10 + 10 dias uteis
If SC5->C5_CONDPAG == "F10"
    // Somar + 10 dias uteis
    dVencto := DataValida(_aVencto[1][1]+1)
    dVencto := DataValida(dVencto+1)
    dVencto := DataValida(dVencto+1)
    dVencto := DataValida(dVencto+1)
    dVencto := DataValida(dVencto+1)
    dVencto := DataValida(dVencto+1)
    dVencto := DataValida(dVencto+1)
    dVencto := DataValida(dVencto+1)
    dVencto := DataValida(dVencto+1)
    dVencto := DataValida(dVencto+1)
   _aVencto[1][1] := dVencto

ElseIf SC5->C5_CONDPAG == "F20"
    // Solicitado por Jo�o Cordeiro em 05/11/24
    // Prodesp 239000635 e 305000554
    // 1. Prazo m�nimo de pagamento: Todas as notas fiscais ser�o pagas no m�nimo 30 dias ap�s a data de entrega. 
    // 2. Datas de entrega das notas fiscais e datas de pagamento:
    //    Notas entregues entre os dias 6 e 20 de cada m�s: ser�o pagas no dia 20 do m�s seguinte.
    //    O Notas entregues entre os dias 21 e 5 do m�s seguinte: ser�o pagas no dia 5 do m�s subsequente.
    // Se o dia 5 ou 20 cair em data n�o �til, o pagamento ser� prorrogado para a dia �til imediatamente subsequente.

    dVencto := dDataBase
    If Day(dVencto) >= 6 .AND. Day(dVencto) <= 20
        dVencto := DataValida(LastDay(dVencto) + 21)
    Else
        //If Date() > dDataBase
        //    dVencto := DataValida(LastDay(dVencto) + 1)
        //EndIf
        dVencto := DataValida(LastDay(dVencto) + 6)
    EndIf
    _aVencto[1][1] := dVencto

Endif

Return(_aVencto)


