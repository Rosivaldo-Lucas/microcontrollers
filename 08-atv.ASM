;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICA��ES PARA USO COM 12F675                   *
;*                FEITAS PELO PROF. MARDSON                        *
;*                   SETEMBRO DE 2023                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       NOME DO PROJETO                           *
;*                           CLIENTE                               *
;*         DESENVOLVIDO PELA MOSAICO ENGENHARIA E CONSULTORIA      *
;*   VERS�O: 1.0                           DATA: 17/06/03          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     DESCRI��O DO ARQUIVO                        *
;*-----------------------------------------------------------------*
;*   MODELO PARA O PIC 12F675                                      *
;*                                                                 *
;*                                                                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ARQUIVOS DE DEFINI��ES                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#INCLUDE <p12f675.inc>	;ARQUIVO PADR�O MICROCHIP PARA 12F675

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_ON & _MCLRE_ON & _INTRC_OSC_NOCLKOUT

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
		DADO		;ARMAZENA O DADO PARA A EEPROM

		;NOVAS VARI�VEIS
		CONT_WTD
		CONT_FALHA

	ENDC			;FIM DO BLOCO DE MEM�RIA
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        FLAGS INTERNOS                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODOS OS FLAGS UTILIZADOS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         CONSTANTES                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODAS AS CONSTANTES UTILIZADAS PELO SISTEMA
; INICIALIZA��O DA EEPROM, DE ACORDO COM A DESCRI��O NO ARQUIVO "Def_Rega_Formigas.inc"

;A PARTIR DO ENDERE�O ZERO DA EEPROM, DADOS EM ORDEM ALEAT�RIA
	ORG 0x2100
	DE	0X89,0X1E,0X39,0X9F,0XC2,0X0C,0XAB,0X33,0X63,0XD3,0X95,0X7B,0X38,0XD6,0X1E,0X48
	DE	0XDB,0XD8,0X86,0XFD,0XA5,0XFC,0X0C,0XBE,0X68,0X9B,0XD9,0X10,0XD8,0XEC,0X90,0X91
	DE	0XAA,0XBB,0XCC,0XDD,0XEE,0XF1,0XC9,0X77

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
	MOVWF	W_TEMP			;COPIA W PARA W_TEMP
	SWAPF	STATUS,W
	MOVWF	STATUS_TEMP		;COPIA STATUS PARA STATUS_TEMP

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
LE_EEPROM
;LER DADO DA EEPROM, CUJO ENDERE�O � INDICADO EM W
;O DADO LIDO RETORNA EM W
	ANDLW	.127			;LIMITA ENDERE�O MAX. 127
	BANK1				;ACESSO VIA BANK 1
	MOVWF	EEADR			;INDICA O END. DE LEITURA
	BSF	EECON1,RD		;INICIA O PROCESSO DE LEITURA
	MOVF	EEDATA,W		;COLOCA DADO LIDO EM W
	BANK0				;POSICIONA PARA BANK 0
	RETURN

GRAVA_EEPROM
;ESCREVE UM DADO NA EEPROM, CUJO ENDERE�O � INDICADO EM W
;O DADO A SER ESCRITO DEVE ESTAR ARMAZENADO NA VARI�VEL DADO
	ANDLW	.127			;LIMITA ENDERE�O MAX. 127
	BANK1				;ACESSO VIA BANK 1
	MOVWF	EEADR
	MOVF	DADO,W
	MOVWF	EEDATA
	BSF	EECON1,WREN		;HABILITA ESCRITA
	BCF	INTCON,GIE		;DESLIGA INTERRUP��ES
	MOVLW	B'01010101'		;DESBLOQUEIA ESCRITA
	MOVWF	EECON2			;
	MOVLW	B'10101010'		;DESBLOQUEIA ESCRITA
	MOVWF	EECON2			;
	BSF	EECON1,WR		;INICIA A ESCRITA
AGUARDA
	BTFSC	EECON1,WR		;TERMINOU?
	GOTO	AGUARDA
	BSF	INTCON,GIE		;HABILITA INTERRUP��ES
	BANK0				;POSICIONA PARA BANK 0
	RETURN

SUBROTINA1

	;CORPO DA ROTINA

	RETURN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANK1				;ALTERA PARA O BANCO 1
	MOVLW	B'00001010'		;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO			;COMO SA�DAS
	
	MOVLW	B'00000010'
	MOVFW	ANSEL			;DEFINE PORTAS COMO Digital I/O
	
	MOVLW	B'00000100'
	MOVWF	OPTION_REG		;DEFINE OP��ES DE OPERA��O
	
	MOVLW	B'00000000'
	MOVWF	INTCON			;DEFINE OP��ES DE INTERRUP��ES
	
	MOVLW	B'10001011'		;COLOCA 1011 PARA A COMPARA��O - 2.96V COM N = 11
	MOVWF	VRCON
	
	BANK0				;RETORNA PARA O BANCO
	MOVLW	B'00010011'
	MOVWF	CMCON			;DEFINE O MODO DE OPERA��O DO COMPARADOR ANAL�GICO

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZA��O DAS VARI�VEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN

	;CORPO DA ROTINA PRINCIPAL
	BTFSC	    GPIO,GP4		;VERIFICA SE O GP4 � ZERO, SE FOR, PULA PARA A PR�XIMA INSTRU��O, SE N�O, VAI PARA O MODO ECONOMIA
	GOTO	    ECONOMIA		;VAI PARA O MODO ECONOMIA
	
	BANK1				;ALTERA PARA O BANCO 1
	MOVLW	    B'10001011'		;COLOCA 1011 PARA A COMPARA��O - 2.96V COM N = 11
	MOVWF	    VRCON
	
	BANK0				;RETORNA PARA O BANCO
	MOVLW	    B'00010011'
	MOVWF	    CMCON		;DEFINE O MODO DE OPERA��O DO COMPARADOR ANAL�GICO
	
	INCF	    CONT_WTD		;INCREMENTA O CONTADOR WTD
	MOVLW	    .30			;MOVE 30 PARA O WTD. SIGNIFICA QUE PARA BATER 0.5s TER� 30 REPETI��ES DO WTD - 17ms * 30 = 0.51s
	SUBWF	    CONT_WTD,W		;W = F - W. O BIT GP1 RECEBE A TENS�O QUE IR� SER VERIFICADA, SE ESTIVER ABAIXO DE 9V DISPARA ALARME, SE N�O, CONTINUA
	BTFSS	    STATUS,C		;VERIFICA A SUBTRACAO, SE O BIT C FOR ZERO, PULA PARA A PR�XIMA LINHA, SE N�O EXECUTA A PR�XIMA LINHA
	GOTO	    OPERACAO		;VAI PARA O MODO DE OPERA��O, AINDA N�O PASSOU 0.5s DE ATIVIDADE
	
	;J� PASSOU OS 0.5s ENT�O COLOCA EM MODO ESPERA
	CLRF	    CONT_WTD		;ZERA O CONTADOR DO WTD
	BCF	    GPIO,GP5		;DESLIGA O BIT GP5, INDICA QUE N�O EST� MAIS EM FUNCIONAMENTO
	
	BANK1				;ALTERA PARA O BANCO 1
	MOVLW	    B'00011010'		;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	    TRISIO		;COLOCA O GP4 COMO ENTRADA
	
	BANK0
	BSF	    GPIO,GP4		;AQUI ERA PARA SETAR O BIT GP4 PARA 1, E IR PARA ECONOMIA
					;E QUANDO RETORNAR PARA A MAIN IA VERIFICAR QUE EST� EM 1 E N�O PODE OPERAR E VAI PARA DESCANSO AT� O BIT GP4 FOR ZERO
					;MAS N�O EST� SETANDO O BIT GP4 PARA 1
	
	GOTO	    ECONOMIA		;VAI PARA O MODO DE ECONOMIA
	
OPERACAO
	BSF	    GPIO,GP5		;SETA O BIT GP5 PARA N�VEL ALTO, INDICA QUE EST� EM OPERA��O
	BTFSS	    CMCON,COUT		;VERIFICA SE O BIT COUT DO CMCON � UM, SE FOR, PULA A PR�XIMA LINHA, SE N�O, EXECUTA A PR�XIMA LINHA
	GOTO	    ALARME		;SE A TENS�O FOR MENOR QUE A ESPERADA, CHAMA O ALARME
	BCF	    GPIO,GP0		;SETA O BIT GP0 PARA N�VEL L�GICO BAIXO - BIT DE ALARME
	SLEEP				;TUDO EST� BEM, AGUARDA E RETORNAR PARA A MAIN
	GOTO	    MAIN		;RETORNA PARA A MAIN
	
ALARME
	BSF	    GPIO,GP0		;SETA O BIT GP0 PARA N�VEL ALTO, INDICA FALHA - BIT DE ALARME
	
	INCF	    CONT_FALHA		;INCREMENTA O CONTADOR DE FALHAS
	MOVFW	    CONT_FALHA		;MOVE O N�MERO DE FALHAS PARA WORK
	MOVWF	    DADO		;MOVE O N�MERO DE FALHAS PARA DADO, SER� ARMAZENADO NA EEPROM
	MOVLW	    0x1F		;ENDERE�O DA EEPROM QUE SER� ARMAZENADO A QUANTIDADE DE FALHAS
	CALL	    GRAVA_EEPROM	;CHAMA FUN��O QUE GRAVA NA EEPROM
	SLEEP				;AGUARDA E RETORNA PARA A MAIN
	GOTO	    MAIN		;RETORNA PARA A MAIN
	
ECONOMIA
	BANK1				;ALTERA PARA O BANCO1
	MOVLW	B'00000000'		;SETA TODOS OS BITS DO VRCON PARA ZERO
	MOVWF	VRCON			;DESLIGA VRCON
	
	BANK0				;RETORNA PARA O BANCO
	MOVLW	B'00000000'
	MOVWF	CMCON			;DESLIGA O COMPARADOR
	
	MOVLW	B'00000000'
	MOVWF	ADCON0			;DESLIGA O CONVERSOR A/D
	
	SLEEP				;AGUARDA AT� ACORDAR E RETORNAR PARA VERIFICAR SE PODE OPERAR OU N�O
	
	GOTO	    MAIN		;RETORNA PARA A MAIN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
