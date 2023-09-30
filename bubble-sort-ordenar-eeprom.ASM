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
		
		CONT_I
		CONT_J		
		AUX_1
		AUX_2

		;NOVAS VARIÁVEIS

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
	MOVWF	W_TEMP		;COPIA W PARA W_TEMP
	SWAPF	STATUS,W
	MOVWF	STATUS_TEMP	;COPIA STATUS PARA STATUS_TEMP

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    ROTINA DE INTERRUPÇÃO                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; AQUI SERÃO ESCRITAS AS ROTINAS DE RECONHECIMENTO E TRATAMENTO DAS
; INTERRUPÇÕES

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
	ANDLW	.127		;LIMITA ENDEREÇO MAX. 127
	BANK1				;ACESSO VIA BANK 1
	MOVWF	EEADR		;INDICA O END. DE LEITURA
	BSF		EECON1,RD	;INICIA O PROCESSO DE LEITURA
	MOVF	EEDATA,W	;COLOCA DADO LIDO EM W
	BANK0				;POSICIONA PARA BANK 0
	RETURN

GRAVA_EEPROM
;ESCREVE UM DADO NA EEPROM, CUJO ENDEREÇO É INDICADO EM W
;O DADO A SER ESCRITO DEVE ESTAR ARMAZENADO NA VARIÁVEL DADO
	ANDLW	.127		;LIMITA ENDEREÇO MAX. 127
	BANK1				;ACESSO VIA BANK 1
	MOVWF	EEADR
	MOVF	DADO,W
	MOVWF	EEDATA
	BSF		EECON1,WREN ;HABILITA ESCRITA
	BCF		INTCON,GIE	;DESLIGA INTERRUPÇÕES
	MOVLW	B'01010101'	;DESBLOQUEIA ESCRITA
	MOVWF	EECON2		;
	MOVLW	B'10101010'	;DESBLOQUEIA ESCRITA
	MOVWF	EECON2		;
	BSF		EECON1,WR ;INICIA A ESCRITA
AGUARDA
	BTFSC	EECON1,WR ;TERMINOU?
	GOTO	AGUARDA
	BSF		INTCON,GIE ;HABILITA INTERRUPÇÕES
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
	MOVLW	B'00001000'		;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO			;COMO SAÍDAS
	
	CLRF	ANSEL			;DEFINE PORTAS COMO Digital I/O
	
	MOVLW	B'00000100'
	MOVWF	OPTION_REG		;DEFINE OPÇÕES DE OPERAÇÃO
	
	MOVLW	B'00000000'
	MOVWF	INTCON			;DEFINE OPÇÕES DE INTERRUPÇÕES
	
	BANK0				;RETORNA PARA O BANCO
	MOVLW	B'00000111'
	MOVWF	CMCON			;DEFINE O MODO DE OPERAÇÃO DO COMPARADOR ANALÓGICO

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZAÇÃO DAS VARIÁVEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	;TEMPO DE EXECUÇÃO DO ALGORITMO: 6075516 (6,075516 s)
MAIN
	BSF	    GPIO,GP5	    ;SETA O BIT GP5 EM UM, INDICA QUE A ORDENAÇÃO COMEÇOU
	
	MOVLW	    .40		    ;MOVE O TAMANHO DA LISTA A SER ORDENADA PARA WORK
	MOVWF	    CONT_I	    ;INICIALIZA CONTADOR DO LOOP_I
	
	LOOP_I
	MOVLW	    .1		    ;MOVE O VALOR UM PARA O WORK. VALOR SERÁ SUBTRAIDO DE CONT_I
	SUBWF	    CONT_I,W	    ;W = CONT_I - W. DECREMENTA UMA UNIDADE DO TAMANHO DA LISTA
	BTFSC	    STATUS,C	    ;SE O BIT C FOR ZERO, PULA PARA O FIM, ORDENAÇÃO JÁ FOI REALIZADA
	GOTO	    ORDENACAO	    ;SE O BIT C FOR UM, VAI PARA A ORDENAÇÃO DA LISTA
	GOTO	    FIM_ORDENACAO   ;VAI PARA O FIM DA ORDENAÇÃO, LISTA JÁ FOI ORDENADA
	
	ORDENACAO
	MOVLW	    .0		    ;MOVE O VALOR ZERO PARA WORK
	MOVWF	    CONT_J	    ;INICIALIZA CONT_J COM O VALOR ZERO
	
	LOOP_J
	DECF	    CONT_I,W	    ;DECREMENTA EM UMA UNIDADE CONT_I E ARMAZENA O VALOR EM WORK. PASSO NECESSARIO PARA PEGAR A POSICAO ANTERIOR DA LISTA 
	SUBWF	    CONT_J,W	    ;W = CONT_J - W. SE CONT_J IGUAL A CONT_I, PULA PARA DEC_I E VAI REPETIR O LOOP_I, SE NÃO, CONTINUA NO LOOP_J
	BTFSC	    STATUS,C	    ;TESTA O BIT C, SE FOR ZERO, CONTINUA O LOOP_J, SE NÃO, VAI PARA O DEC_I E REPETE O LOOP_I
	GOTO	    DEC_I	    ;VAI PARA O DEC_I E REPETE O LOOP_I
	
	MOVFW	    CONT_J	    ;MOVE CONT_J PARA WORK, ENDEREÇO DA LISTA A SER LIDO
	CALL	    LE_EEPROM	    ;LE O ENDEREÇO EM WORK E ARMAZENA O RESULTADO EM WORK
	MOVWF	    AUX_1	    ;MOVE O VALOR LIDO PARA AUX_1
	INCF	    CONT_J,W	    ;INCREMENTA CONT_J PARA LER O PRÓXIMO ENDEREÇO DA LISTA, ARMAZENA O INCREMENTO EM WORK
	CALL	    LE_EEPROM	    ;LE O ENREDEÇO CONT_J + 1 E ARMAZENA O RESULTADO EM WORK
	MOVWF	    AUX_2	    ;MOVE O VALOR LIDO PARA AUX_2
	SUBWF	    AUX_1,W	    ;W = AUX_1 - AUX_2. FAZ A SUBTRAÇÃO DOS VALORES, SE AUX_2 > AUX_1, TROCA, SE NÃO, INC_J
	BTFSC	    STATUS,C	    ;TESTA O BIT C, SE FOR ZERO, VAI PARA TROCA DOS VALORES, SE NÃO, VAI PARA INC_J E REPERE O LOOP_J
	GOTO	    INC_J	    ;VAI PARA O INC_J E REPERE O LOOP_J
	
	MOVFW	    AUX_2	    ;MOVE AUX_2 PARA WORK
	MOVWF	    DADO	    ;MOVE AUX_2 PARA DADO
	MOVFW	    CONT_J	    ;MOVE O ENDEREÇO QUE AUX_2 IRÁ SER ARMAZENADO PARA WORK
	CALL	    GRAVA_EEPROM    ;GRAVA O VALOR DE AUX_2 NO ENDEREÇO CONT_J
	MOVFW	    AUX_1	    ;MOVE AUX_1 PARA WORK
	MOVWF	    DADO	    ;MOVE AUX_1 PARA DADO
	INCF	    CONT_J,W	    ;INCREMENTA CONT_J E ARMAZENA EM WORK. ENDEREÇO QUE AUX_1 IRÁ SER ARMAZENADO
	CALL	    GRAVA_EEPROM    ;GRAVA O VALOR DE AUX_1 NO ENDEREÇO CONT_J + 1
	GOTO	    INC_J	    ;VAI PARA INC_J E REPETE O LOOP_J
	
	DEC_I
	DECF	    CONT_I	    ;DECREMENTA CONT_I
	GOTO	    LOOP_I	    ;VAI PARA O LOOP_I
	
	INC_J
	INCF	    CONT_J	    ;INCREMENTA O CONT_J
	GOTO	    LOOP_J	    ;VAI PARA O LOOP_J
	
	FIM_ORDENACAO
	BCF	    GPIO,GP5	    ;SETA O BIT GP5 EM ZERO, ORDENAÇÃO FINALIZOU
	
	GOTO	    FIM_ORDENACAO   ;FICA EM LOOP
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
