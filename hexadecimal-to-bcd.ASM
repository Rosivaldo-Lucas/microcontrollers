;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*		    HEXADECIMAL PARA BCD			   *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICA��ES PARA USO COM 12F675                   *
;*                FEITAS PELO PROF. MARDSON                        *
;*                     FEVEREIRO DE 2023                           *
;*                 BASEADO NO EXEMPLO DO LIVRO                     *
;*           Desbravando o PIC. David Jos� de Souza                *
;*-----------------------------------------------------------------*
;*   MODELO PARA O PIC 12F675                                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              UNIVERSIDADE FEDERAL DA PARA�BA			   *
;*		ENGENHARIA DE COMPUTA��O			   *
;*								   *
;*			MICROCONTROLADORES			   *
;*								   *
;*			 ROSIVALDO LUCAS			   *
;*-----------------------------------------------------------------*
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ARQUIVOS DE DEFINI��ES                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#INCLUDE <p12f675.inc>	;ARQUIVO PADR�O MICROCHIP PARA 12F675

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_OFF & _MCLRE_ON & _INTRC_OSC_NOCLKOUT

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    PAGINA��O DE MEM�RIA                         *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;DEFINI��O DE COMANDOS DE USU�RIO PARA ALTERA��O DA P�GINA DE MEM�RIA
#DEFINE	BANK0	BCF STATUS,RP0	;SETA BANK 0 DE MEM�RIA
#DEFINE	BANK1	BSF STATUS,RP0	;SETA BANK 1 DE MAM�RIA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         VARI�VEIS                               *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DOS NOMES E ENDERE�OS DE TODAS AS VARI�VEIS UTILIZADAS 
; PELO SISTEMA

	CBLOCK	0x20		;ENDERE�O INICIAL DA MEM�RIA DE USU�RIO
		W_TEMP		;REGISTRADORES TEMPOR�RIOS PARA USO
		STATUS_TEMP	;JUNTO �S INTERRUP��ES
		
		;COLOQUE AQUI SUAS NOVAS VARI�VEIS
		;N�O ESQUE�A COMENT�RIOS ESCLARECEDORES
		
		DADO			    ;VARI�VEL QUE IR� ARMAZENAR O VALOR CONVERTIDO
		AUX_1			    ;VARI�VEL AUX PARA AS CENTENAS
		AUX_2			    ;VARI�VEL AUX PARA AS DEZENAS
		QTD_SUBTRACOES_CENTENAS	    ;VARI�VEL PARA CONTAR QUANTAS VEZES FOI POSS�VEL SUBTRAIR POR 100
		QTD_SUBTRACOES_DEZENAS	    ;VARI�VEL PARA CONTAR QUNATAS VEZES FOI POSS�VEL SUBTRAIR POR 10
		
	ENDC			;FIM DO BLOCO DE DEFINI��O DE VARI�VEIS

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        FLAGS INTERNOS                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODOS OS FLAGS UTILIZADOS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         CONSTANTES                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODAS AS CONSTANTES UTILIZADAS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           ENTRADAS                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODOS OS PINOS QUE SER�O UTILIZADOS COMO ENTRADA
; RECOMENDAMOS TAMB�M COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           SA�DAS                                *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODOS OS PINOS QUE SER�O UTILIZADOS COMO SA�DA
; RECOMENDAMOS TAMB�M COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       VETOR DE RESET                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	ORG	0x00			;ENDERE�O INICIAL DE PROCESSAMENTO
	GOTO	INICIO
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    IN�CIO DA INTERRUP��O                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; ENDERE�O DE DESVIO DAS INTERRUP��ES. A PRIMEIRA TAREFA � SALVAR OS
; VALORES DE "W" E "STATUS" PARA RECUPERA��O FUTURA

	ORG	0x04			;ENDERE�O INICIAL DA INTERRUP��O
	MOVWF	W_TEMP		;COPIA W PARA W_TEMP
	SWAPF	STATUS,W
	MOVWF	STATUS_TEMP	;COPIA STATUS PARA STATUS_TEMP

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    ROTINA DE INTERRUP��O                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; AQUI SER�O ESCRITAS AS ROTINAS DE RECONHECIMENTO E TRATAMENTO DAS
; INTERRUP��ES

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                 ROTINA DE SA�DA DA INTERRUP��O                  *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; OS VALORES DE "W" E "STATUS" DEVEM SER RECUPERADOS ANTES DE 
; RETORNAR DA INTERRUP��O

SAI_INT
	SWAPF	STATUS_TEMP,W
	MOVWF	STATUS		;MOVE STATUS_TEMP PARA STATUS
	SWAPF	W_TEMP,F
	SWAPF	W_TEMP,W	;MOVE W_TEMP PARA W
	RETFIE

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*	            	 ROTINAS E SUBROTINAS                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; CADA ROTINA OU SUBROTINA DEVE POSSUIR A DESCRI��O DE FUNCIONAMENTO
; E UM NOME COERENTE �S SUAS FUN��ES.

SUBROTINA1

	;CORPO DA ROTINA

	RETURN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANK1				;ALTERA PARA O BANCO 1
	MOVLW	B'00000000' ;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SA�DAS
	CLRF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000100'
	MOVWF	OPTION_REG	;DEFINE OP��ES DE OPERA��O
	MOVLW	B'00000000'
	MOVWF	INTCON		;DEFINE OP��ES DE INTERRUP��ES
	BANK0				;RETORNA PARA O BANCO
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERA��O DO COMPARADOR ANAL�GICO

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZA��O DAS VARI�VEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN
	;CORPO DA ROTINA PRINCIPAL

	MOVLW	0xFC		;CARREGA O VALOR HEXADECIMAL PARA O WORK
	MOVWF	AUX_1		;MOVE O VALOR DE WORK PARA AUX_1

;LOOP DE SUCESSIVAS SUBTRA��ES PARA AS CENTENAS DO N�MERO
LOOP_CENTENAS
	MOVFW   AUX_1			    ;MOVE O VOLOR AUX_1 PARA WORK
	MOVWF   AUX_2			    ;MOVE O VALOR DE WORK PARA AUX_2
	MOVLW   .100			    ;MOVE O VALOR 100 PARA O WORK
	SUBWF   AUX_1			    ;SUBTRAI 100 DE AUX_1
	BTFSS   STATUS,C		    ;COMPARA O BIT C DO REGISTRADOR STATUS, SE FOR ZERO EXECUTA A PR�XIMA LINHA, SE N�O, PULA A PR�XIMA LINHA
	GOTO    LOOP_DEZENAS		    ;PULA PARA A LABEL LOOP_DEZENAS, ISSO SIGNIFICA QUE O VALOR DE AUX_1 N�O PODE SER MAIS SUBTRAIDO POR 100
	INCF    QTD_SUBTRACOES_CENTENAS	    ;INCREMENTA QTD_SUBTRACOES_CENTENAS, CONTADOR QUE INDICA QUANTAS VEZES FOI POSS�VEL SUBTRAIR AUX_1 POR 100
	GOTO	LOOP_CENTENAS		    ;VOLTA AO IN�CIO PARA REALIZAR MAIS SUBTR��ES EM AUX_1
	
;LOOP DE SUCESSIVAS SUBTRA��ES PARA AS DEZENAS DO N�MERO
LOOP_DEZENAS
	MOVFW   AUX_2			    ;MOVE O VALOR AUX_2 PARA WORK
	MOVWF   DADO			    ;MOVE O VALOR DO WORK PARA O DADO
	MOVLW   .10			    ;MOVE O VALOR 10 NO WORK
	SUBWF   AUX_2			    ;SUBTRAI 10 DE AUX_2
	BTFSS   STATUS,C		    ;COMPARA O BIT C DO REGISTRADOR STATUS, SE FOR ZERO EXECUTA A PR�XIMA LINHA, SE N�O, PULA A PR�XIMA LINHA
	GOTO    LOOP_UNIDADES		    ;PULA PARA A LABEL LOOP_UNIDADES, ISSO SIGNIFICA QUE O VALOR DE AUX_2 N�O PODE SER MAIS SUBTRAIDO POR 10
	INCF    QTD_SUBTRACOES_DEZENAS	    ;INCREMENTA QTD_SUBTRACOES_DEZENAS, CONTADOR QUE INDICA QUANTAS VEZES FOI POSS�VEL SUBTRAIR AUX_2 POR 10
	GOTO	LOOP_DEZENAS		    ;VOLTA AO IN�CIO PARA REALIZAR MAIS SUBTR��ES EM AUX_2
	
LOOP_UNIDADES
	SWAPF	QTD_SUBTRACOES_DEZENAS	    ;REALIZA A TROCA DOS NIBBLES
	MOVFW	QTD_SUBTRACOES_DEZENAS	    ;MOVE QTD_SUBTRACOES_DEZENAS PARA WORK
	ADDWF	DADO			    ;ADICIONA WORK EM DADO
	MOVFW	QTD_SUBTRACOES_CENTENAS	    ;MOVE QTD_SUBTRACOES_CENTENAS PARA WORK
	
	GOTO	MAIN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
