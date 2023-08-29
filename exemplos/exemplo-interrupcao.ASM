;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICAÇÕES PARA USO COM 12F675                   *
;*                FEITAS PELO PROF. MARDSON                        *
;*                     FEVEREIRO DE 2023                           *
;*                 BASEADO NO EXEMPLO DO LIVRO                     *
;*           Desbravando o PIC. David José de Souza                *
;*-----------------------------------------------------------------*
;*   MODELO PARA O PIC 12F675                                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              UNIVERSIDADE FEDERAL DA PARAÍBA			   *
;*		ENGENHARIA DE COMPUTAÇÃO			   *
;*								   *
;*			MICROCONTROLADORES			   *
;*								   *
;*			 ROSIVALDO LUCAS			   *
;*-----------------------------------------------------------------*
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

	CBLOCK	0x20		;ENDEREÇO INICIAL DA MEMÓRIA DE USUÁRIO
		W_TEMP		;REGISTRADORES TEMPORÁRIOS PARA USO
		STATUS_TEMP	;JUNTO ÀS INTERRUPÇÕES

		;COLOQUE AQUI SUAS NOVAS VARIÁVEIS
		;NÃO ESQUEÇA COMENTÁRIOS ESCLARECEDORES

	ENDC			;FIM DO BLOCO DE DEFINIÇÃO DE VARIÁVEIS

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        FLAGS INTERNOS                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS FLAGS UTILIZADOS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         CONSTANTES                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODAS AS CONSTANTES UTILIZADAS PELO SISTEMA

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

;	BTFSS	    INTCON,T0IF		;TESTA T0IF E DESVIA SE FOR UM, SE FOR ZERO, A PRÓXIMA LINHA É EXECUTADA
;	GOTO	    SAI_INT		;VAI PARA A ROTINA DE SAIDA DA INTERRUPÇÃO
;	BCF	    INTCON,T0IF		;LIMPA A FLAG T0IF DO INTCON
;	MOVLW	    D'10'
;	MOVWF	    TMR0
;	COMF	    W,0		;COMPLEMENTA O W
	
	BTFSC	    INTCON,T0IF		;SE T0IF FOR ZERO, PULA PARA A PRÓXIMA LINHA, SE NÃO, T0IF É UM, EXECUTA A PRÓXIMA LINHA
	GOTO	    INT_TIMER_ZERO	;T0IF É UM, LOGO A INTERRUPÇÃO É DO TIMER0
	GOTO	    INT_GP2		;SE FOR ZERO, ENTÃO A INTERRUPÇÃO NÃO É A DO TIMER0, CHAMA A INTERRUPÇÃO DO GP2

	
	INT_TIMER_ZERO
	NOP				;EXECUTA O CÓDIGO PARA A INTERRUPÇÃO
	BCF	    INTCON,T0IF		;LIMPA FLAG DA INTERRUPÇÃO DO TIMER0
	GOTO	    SAI_INT		;SAI DA INTERRUPÇÃO
	
	INT_GP2
	;A INTERRUPÇÃO QUE CHAMOU FOI A DO TIMER ZERO, O TIMER0 ESTOUROU, T0IF COM VALOR 1
	BTFSS	    GPIO,GP5		;SE GP5 FOR UM, PULA PARA A PRÓXIMA LINHA, SE NÃO, GP5 É ZERO, EXECUTA A PRÓXIMA LINHA
	GOTO	    ALTO_GP5		;GP5 É ZERO, ENTÃO CHAMA LABEL ALTO_GP5
	GOTO	    BAIXO_GP5		;GP5 É UM, ENTÃO CHAMA LABEL BAIXO_GP5
	
	ALTO_GP5
	BSF	    GPIO,GP5		;COLOCA O VALOR DE GP5 PARA NÍVEL LÓGICO ALTO
	BCF	    INTCON,INTF		;LIMPA T0IF, ASSIM É ZERADA A FLAG DE INTERRUPÇÃO PARA O TIMER0
	GOTO	    SAI_INT		;CHAMA LABEL PARA SAIR DA INTERRUPÇÃO
	
	BAIXO_GP5
	BCF	    GPIO,GP5		;COLOCA VALOR DE GP5 PARA NÍVEL LÓGICO BAIXO
	BCF	    INTCON,INTF		;LIMPA T0IF, ASSIM É ZERADA A FLAG DE INTERRUPÇÃO PARA O TIMER0
	GOTO	    SAI_INT		;CHAMA LABEL PARA SAIR DA INTERRUPÇÃO
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                 ROTINA DE SAÍDA DA INTERRUPÇÃO                  *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; OS VALORES DE "W" E "STATUS" DEVEM SER RECUPERADOS ANTES DE 
; RETORNAR DA INTERRUPÇÃO

SAI_INT
	SWAPF	STATUS_TEMP,W
	MOVWF	STATUS			;MOVE STATUS_TEMP PARA STATUS
	SWAPF	W_TEMP,F
	SWAPF	W_TEMP,W		;MOVE W_TEMP PARA W
	RETFIE

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*	            	 ROTINAS E SUBROTINAS                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; CADA ROTINA OU SUBROTINA DEVE POSSUIR A DESCRIÇÃO DE FUNCIONAMENTO
; E UM NOME COERENTE ÀS SUAS FUNÇÕES.

SUBROTINA1

	;CORPO DA ROTINA

	RETURN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANK1				;ALTERA PARA O BANCO 1
	MOVLW	B'00001100'		;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO			;COMO SAÍDAS
	
	CLRF	ANSEL			;DEFINE PORTAS COMO Digital I/O
	
	MOVLW	B'11000010'		;10000000
	MOVWF	OPTION_REG		;DEFINE OPÇÕES DE OPERAÇÃO
	
	MOVLW	B'10110000'		;10100000
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
MAIN

	;CORPO DA ROTINA PRINCIPAL

	GOTO	MAIN	    ;2 CLICOS DE MÁQUINA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
