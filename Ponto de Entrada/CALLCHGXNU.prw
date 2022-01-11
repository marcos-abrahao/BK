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

/*

User Function CALLCHGXNU()
	
Return cMenu
*/

