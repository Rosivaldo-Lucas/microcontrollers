;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICAÇÕES PARA USO COM 12F675                   *
;*                FEITAS PELO PROF. MARDSON                        *
;*                   SETEMBRO DE 2023                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       NOME DO PROJETO                           *
;*                           CLIENTE                               *
;*         DESENVOLVIDO PELA MOSAICO ENGENHARIA E CONSULTORIA      *
;*   VERSÃO: 1.0                           DATA: 17/06/03          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     DESCRIÇÃO DO ARQUIVO                        *
;*-----------------------------------------------------------------*
;*   MODELO PARA O PIC 12F675                                      *
;*                                                                 *
;*                                                                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ARQUIVOS DE DEFINIÇÕES                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#INCLUDE <p12f675.inc>	;ARQUIVO PADRÃO MICROCHIP PARA 12F675

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_OFF & _MCLRE_ON & _INTRC_OSC_NOCLKOUT

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    PAGINAÇÃO DE MEMÓRIA                         *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;DEFINIÇÃO DE COMANDOS DE USUÁRIO PARA ALTERAÇÃO DA PÁGINA DE MEMÓRIA
#DEFINE	BANK0	BCF STATUS,RP0	;SETA BANK 0 DE MEMÓRIA
#DEFINE	BANK1	BSF STATUS,RP0	;SETA BANK 1 DE MAMÓRIA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         VARIÁVEIS                               *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DOS NOMES E ENDEREÇOS DE TODAS AS VARIÁVEIS UTILIZADAS 
; PELO SISTEMA

	CBLOCK	0x20	;ENDEREÇO INICIAL DA MEMÓRIA DE
					;USUÁRIO
		W_TEMP		;REGISTRADORES TEMPORÁRIOS PARA USO
		STATUS_TEMP	;JUNTO ÀS INTERRUPÇÕES
		DADO		;ARMAZENA O DADO PARA A EEPROM

		;NOVAS VARIÁVEIS
		
		FLAG_CONT_PULSO_GP4
		CENTESIMO_SEGUNDO
		SEGUNDO
		FLAG_STOP
		FLAG

	ENDC			;FIM DO BLOCO DE MEMÓRIA
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        FLAGS INTERNOS                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS FLAGS UTILIZADOS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         CONSTANTES                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODAS AS CONSTANTES UTILIZADAS PELO SISTEMA
; INICIALIZAÇÃO DA EEPROM, DE ACORDO COM A DESCRIÇÃO NO ARQUIVO "Def_Rega_Formigas.inc"

;A PARTIR DO ENDEREÇO ZERO DA EEPROM, DADOS EM ORDEM ALEATÓRIA
	ORG 0x2100
	DE	0X89,0X1E,0X39,0X9F,0XC2,0X0C,0XAB,0X33,0X63,0XD3,0X95,0X7B,0X38,0XD6,0X1E,0X48
	DE	0XDB,0XD8,0X86,0XFD,0XA5,0XFC,0X0C,0XBE,0X68,0X9B,0XD9,0X10,0XD8,0XEC,0X90,0X91
	DE	0XAA,0XBB,0XCC,0XDD,0XEE,0XF1,0XC9,0X77

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           ENTRADAS                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS PINOS QUE SERÃO UTILIZADOS COMO ENTRADA
; RECOMENDAMOS TAMBÉM COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           SAÍDAS                                *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS PINOS QUE SERÃO UTILIZADOS COMO SAÍDA
; RECOMENDAMOS TAMBÉM COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       VETOR DE RESET                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	ORG	0x00			;ENDEREÇO INICIAL DE PROCESSAMENTO
	GOTO	INICIO
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    INÍCIO DA INTERRUPÇÃO                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; ENDEREÇO DE DESVIO DAS INTERRUPÇÕES. A PRIMEIRA TAREFA É SALVAR OS
; VALORES DE "W" E "STATUS" PARA RECUPERAÇÃO FUTURA

	ORG	0x04			;ENDEREÇO INICIAL DA INTERRUPÇÃO
	MOVWF	W_TEMP			;COPIA W PARA W_TEMP
	SWAPF	STATUS,W
	MOVWF	STATUS_TEMP		;COPIA STATUS PARA STATUS_TEMP

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    ROTINA DE INTERRUPÇÃO                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; AQUI SERÃO ESCRITAS AS ROTINAS DE RECONHECIMENTO E TRATAMENTO DAS
; INTERRUPÇÕES
	BTFSC	    GPIO,GP4			;SE GP4 FOR UM, A PRÓXIMA LINHA É EXECUATDA, SE NÃO, PULA A PRÓXIMA LINHA
	GOTO	    CRONOMETRO			;VAI PARA A LABEL QUE IRÁ INICIALIZAR O CRONOMETRO
	GOTO	    STOP_CRONOMETRO		;VAI PARA A LABEL QUE IRÁ FINALIZAR O CRONOMETRO
	
CRONOMETRO	
	BTFSC	    INTCON,GPIF			;SE GPIF EM UM, ENTÃO OCORREU MUDANÇA EM GP4, INICIA O CRONOMETRO, SE NÃO, NÃO FAZ NADA
	GOTO	    START_CRONOMETRO		;INICIA A CONTAGEM DO CRONOMETRO
	GOTO	    STOP_CRONOMETRO		;FINALIZA A CONTAGEM DO CRONOMETRO
	
START_CRONOMETRO
	MOVLW	    .132			;MOVE 132 PARA O WORK, VALOR PARA QUE O TMR0 ESTOURE E A VARIÁVEL CONTESIMO_SEGUNDO SEJA 100
	MOVWF	    TMR0			;MOVE WORK PARA O TMR0, VALOR INICIAL DA CONTAGEM
	MOVLW	    .0				;INICIALIZA A VARIÁVEL CENTESIMO_SEGUNDO COMO ZERO
	MOVWF	    CENTESIMO_SEGUNDO

REPETE_CONTA
	BTFSS	    GPIO,GP4			;SE GP4 FOR ZERO, A PRÓXIMA LINHA É EXECUTADA, SE NÃO, PULA A PRÓXIMA LINHA
	GOTO	    STOP_CRONOMETRO		;SE GP4 FOR ZERO, VAI PARA O STOP DO CRONOMETRO
	BTFSC	    INTCON,T0IF			;SE T0IF FOR ZERO, A PRÓXIMA LINHA É EXECUTADA, CONTAGEM ACABOU, SE NÃO, PULA A LINHA E CONTAGEM CONTINUA
	GOTO	    INCREMENTA_SEGUNDO		;VAI PARA A LABEL QUE IRÁ INCREMENTAR O VALOR DA VARIÁVEL SEGUNDO
	INCF	    CENTESIMO_SEGUNDO		;INCREMENTA A VARIÁVEL CENTESIMO_SEGUNDO
	GOTO	    REPETE_CONTA		;VAI PARA A LABEL REPETE_CONTA ATÉ A VARIÁVEL CENTESIMO_SEGUNDO CHEGAR A 100
	
	GOTO	    LIMPA_FLAG_INT_E_SAI_INT	;VAI PARA A LABEL LIMPA_FLAG_INT_E_SAI_INT

INCREMENTA_SEGUNDO
	BCF	    INTCON,T0IF			;SETA O BIT T0IF PARA ZERO, ASSIM INICIALIZA A FLAG DE ESTOURO DO TMR0
	INCF	    SEGUNDO			;INCREMENTA A VARIÁVEL SEGUNDO, INDICA QUE SE PASSOU 1 SEGUNDO
	MOVLW	    .99				;MOVE O VALOR MAXIMO PARA O CRONOMETRO PARA O WORK
	SUBWF	    SEGUNDO,W			;W = SEGUNDO - W, SE O RESULTADO FOR ZERO, SEGUNDO ATINGIU VALOR MAXIMO
	BTFSS	    STATUS,C			;SE O BIT C FOR ZERO, ENTÃO SEGUNDO CHEGOU NO LIMITE E PRÓXIMA LINHA É EXECUTADA
	GOTO	    START_CRONOMETRO		;SEGUNDO CHEGOU NO LIMITE DE 99, SAI DA INTERRUPÇÃO
	GOTO	    LIMPA_FLAG_INT_E_SAI_INT	;SE NÃO CHEGOU NO LIMITE DE SEGINDO, VOLTA PARA RETEPE_CONTA
	
STOP_CRONOMETRO
	MOVLW	    .1				;MOVE VALOR 1 PARA O WORK
	MOVWF	    FLAG_STOP			;MOVE VALOR DO WORK PARA A VARIÁVEL. ESSE VALOR IRÁ AJUDAR NA LÓGICA PARA UTILIZAR A EEPROM
	
	MOVLW	    .2				;MOVE VALOR 2 PARA O WORK
	MOVWF	    FLAG			;MOVE VALOR DO WORK PARA A VARIÁVEL. ESSE VALOR IRÁ AJUDAR NA LÓGICA PARA UTILIZAR A EEPROM
	GOTO	    LIMPA_FLAG_INT_E_SAI_INT	;VAI PARA A LABEL QUE IRÁ LIMPAR A FLAG DE INTERRUPÇÃO E SAIR DA INTERRUPÇÃO
	
LIMPA_FLAG_INT_E_SAI_INT
	BCF	    GPIO,GP4			;LIMPA O PINO GP4
	BCF	    INTCON,GPIF			;LIMPA A FLAG QUE INDICA QUE HOUVE MUDANÇA DE NÍVEL LÓGICO NA PORTA GP4
	GOTO	    SAI_INT			;VAI PARA A SAIDA DA INTERRUPÇÃO
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                 ROTINA DE SAÍDA DA INTERRUPÇÃO                  *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; OS VALORES DE "W" E "STATUS" DEVEM SER RECUPERADOS ANTES DE 
; RETORNAR DA INTERRUPÇÃO

SAI_INT
	SWAPF	STATUS_TEMP,W
	MOVWF	STATUS		;MOVE STATUS_TEMP PARA STATUS
	SWAPF	W_TEMP,F
	SWAPF	W_TEMP,W	;MOVE W_TEMP PARA W
	RETFIE

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*	            	 ROTINAS E SUBROTINAS                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; CADA ROTINA OU SUBROTINA DEVE POSSUIR A DESCRIÇÃO DE FUNCIONAMENTO
; E UM NOME COERENTE ÀS SUAS FUNÇÕES.
LE_EEPROM
;LER DADO DA EEPROM, CUJO ENDEREÇO É INDICADO EM W
;O DADO LIDO RETORNA EM W
	ANDLW	.127			;LIMITA ENDEREÇO MAX. 127
	BANK1				;ACESSO VIA BANK 1
	MOVWF	EEADR			;INDICA O END. DE LEITURA
	BSF	EECON1,RD		;INICIA O PROCESSO DE LEITURA
	MOVF	EEDATA,W		;COLOCA DADO LIDO EM W
	BANK0				;POSICIONA PARA BANK 0
	RETURN

GRAVA_EEPROM
;ESCREVE UM DADO NA EEPROM, CUJO ENDEREÇO É INDICADO EM W
;O DADO A SER ESCRITO DEVE ESTAR ARMAZENADO NA VARIÁVEL DADO
	ANDLW	.127			;LIMITA ENDEREÇO MAX. 127
	BANK1				;ACESSO VIA BANK 1
	MOVWF	EEADR
	MOVF	DADO,W
	MOVWF	EEDATA
	BSF	EECON1,WREN		;HABILITA ESCRITA
	BCF	INTCON,GIE		;DESLIGA INTERRUPÇÕES
	MOVLW	B'01010101'		;DESBLOQUEIA ESCRITA
	MOVWF	EECON2			;
	MOVLW	B'10101010'		;DESBLOQUEIA ESCRITA
	MOVWF	EECON2			;
	BSF	EECON1,WR		;INICIA A ESCRITA
AGUARDA
	BTFSC	EECON1,WR		;TERMINOU?
	GOTO	AGUARDA
	BSF	INTCON,GIE		;HABILITA INTERRUPÇÕES
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
	MOVLW	B'00011000'		;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS) - SETA GP4 COMO ENTRADA
	MOVWF	TRISIO			;COMO SAÍDAS
	
	CLRF	ANSEL			;DEFINE PORTAS COMO Digital I/O
	
	MOVLW	B'10000001'
	MOVWF	OPTION_REG		;DEFINE OPÇÕES DE OPERAÇÃO
	
	MOVLW	B'10001000'
	MOVWF	INTCON			;DEFINE OPÇÕES DE INTERRUPÇÕES
	
	MOVLW	B'00010000'
	MOVWF	IOC
	
	BANK0				;RETORNA PARA O BANCO
	MOVLW	B'00000111'
	MOVWF	CMCON			;DEFINE O MODO DE OPERAÇÃO DO COMPARADOR ANALÓGICO

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZAÇÃO DAS VARIÁVEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN
	;CORPO DA ROTINA PRINCIPAL
	
	MOVFW	    FLAG		;MOVE O VALOR DE FLAG PARA O WORK, QUANTO O CRONOMETRO NÃO FOR ACIONADO FLAG = 0, QUANDO FOR ACIONADO FLAG = 2
	SUBWF	    FLAG_STOP,W		;W = FLAG_STOP - W. SE FOR ZERO, BIT C STATUS NÃO ALTERA, VAI PARA GOTO MAIN, SE NÃO FOR ZERO,
					;BIT C STATUS ALTERA E PULA PARA SALVAR NA EEPROM
	BTFSC	    STATUS,C		;SE FOR ZERO, NÃO PULA E VAI PARA A MAIN, SE NÃO FOR ZERO VAI PARA SALVAR NA EEPROM
	GOTO	    MAIN		;VOLTA PARA A MAIN E REPETE
	
	MOVFW	    CENTESIMO_SEGUNDO	;MOVE O VALOR CENTESIMO_SEGUNDO PARA WORK
	MOVWF	    DADO		;MOVE VALOR WORK PARA O DADO
	MOVLW	    .30			;MOVE VALOR ENDEREÇO SALVAMENTO EEPROM PARA WORK
	CALL	    GRAVA_EEPROM	;CHAMA FUNÇÃO PARA SALVAR CENTESIMO_SEGUNDO NA EEPROM
	CLRF	    DADO		;LIMPA VARIÁVEL DADO
	MOVFW	    SEGUNDO		;MOVE O VALOR SEGUNDO PARA WORK
	MOVWF	    DADO		;MOVE VALOR WORK PARA O DADO
	MOVLW	    .29			;MOVE VALOR ENDEREÇO SALVAMENTO EEPROM PARA WORK
	CALL	    GRAVA_EEPROM	;CHAMA FUNÇÃO PARA SALVAR SEGUNDO NA EEPROM
	
	CLRF	    FLAG		;LIMPA FLAG		
	CLRF	    FLAG_STOP		;LIMPA FLAG_STOP
	CLRF	    CENTESIMO_SEGUNDO	;LIMPA VARIÁVEL CENTESIMO_SEGUNDO
	CLRF	    SEGUNDO		;LIMPA VARIVÁVEL SEGUNDO
	
	GOTO MAIN			;VOLTA PARA MAIN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
