#include "protheus.ch"

/*/{Protheus.doc} CALLCHGXNU
    BK - Ponto de entrada que ser� executado toda vez que um menu for carregado

    Observa��o:
    Ele somente envia grupo de empresas e filial diferente da logada ao trocar de grupo de empresas no sistema (pela tela do MDI, por exemplo).
    N�o executa como administrador

    @type  Function
    @author Marcos Bispo Abrah�o
    @since 09/08/2021
    @version P12.1.25
    @param 
        ParamIXB[1] (Caracter) -> Usu�rio que est� conectado
        ParamIXB[2] (Caracter) -> Empresa atual
        ParamIXB[3] (Caracter) -> Filial atual
        ParamIXB[4] (Num�rico) -> N�mero do m�dulo que ser� aberto
        ParamIXB[5] (Caracter) -> Nome do menu do usu�rio.
        ParamIXB[6] (Caracter) -> Empresa selecionada de destino. (Na primeira carga do sistema ser� a mesma empresa do par�metro ParamIXB[2] )
        ParamIXB[7] (Caracter) -> Filial selecionada de destino.(Na primeira carga do sistema ser� a mesma filial do par�metro ParamIXB[3] )
    @return return_var, return_type, return_description
    /*/
Static nModAnt := 0

User Function CALLCHGXNU()

Local cId	  := ParamIXB[1]
Local cEmpAtu := ParamIXB[2] 
Local nModulo := ParamIXB[4]
Local cMenu   := ParamIXB[5]
Local cToken  := u_BKEnCode()

If nModulo <> nModAnt
    If nModulo = 5 .OR. nModulo = 69
        //        Vanderleia/Z� Mario/Teste/Xavier/Fabia/Bruno
        If cId $ "000056/000175/000038/000012/000023/000153"
            If MsgYesNo("Deseja abrir a libera��o de pedidos web?")
                If "TST" $ UPPER(GetEnvServer()) .OR. "TESTE" $ UPPER(GetEnvServer())
                    ShellExecute("open", "http://10.139.0.30:8081/rest/RestLibPV/v2?userlib="+cToken, "", "", 1)
                Else
                    ShellExecute("open", "http://10.139.0.30:8080/rest/RestLibPV/v2?userlib="+cToken, "", "", 1)
                EndIf
            EndIf
        EndIf
    EndIf
    nModAnt := nModulo
EndIf

Return cMenu
