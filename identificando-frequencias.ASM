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

		PERIODO
		T
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

	;TMR0 ESTOUROU - GEROU INTERRUPÇÃO
	;VERIFICAR SE A FREQUÊNCIA FOI DE 5, 10, 20 OU 30 KHZ
	
	MOVLW	    .32			;MOVE PARA WORK VALOR QUE IDENTIFICA 5KHZ
	SUBWF	    T,W			;SUBTRRAI W = T - W, SE FOR ZERO, O PERIODO É DE 5KHZ SE NÃO, TESTA PARA AS PRÓXIMAS FREQUÊNCIAS
	BTFSS	    STATUS,Z		;SE O BIT Z FOR UM, A FREQUÊNCIA É DE 5KHZ, SE NÃO PULA PARA A FREQUÊNCIA DE 10KHZ
	GOTO	    FREQ_10KHZ		;CHAMA LABEL FREQ_10KHZ
	
	BSF	    GPIO,GP0		;SETA BIT GP0 PARA ALTO
	NOP				;NOP PARA DEIXAR O SINAL DO GP0 EM NÍVEL LÓGICO ALTO POR 5 CICLOS DE INSTRUÇÃO
	NOP
	NOP
	NOP
	NOP
	BCF	    GPIO,GP0		;SETA BIT GP0 PARA BAIXO
	
	BCF	    INTCON,T0IF		;LIMPA FLAG INTERRUPÇÃO TMR0
	MOVLW	    .1			;MOVE VALOR 1 PARA O WORK
	MOVWF	    T			;MOVE DE WORK PARA T. FAZ COM QUE A FREQ 5KHZ SAI DO LOOP NA FUNÇÃO E CHAME PRÓXIMA FUNÇÃO DE FREQUÊNCIA
	GOTO	    SAI_INT		;CHAMA SAIDA INTERRUPÇÃO
	
	FREQ_10KHZ
	MOVLW	    .15			;MOVE PARA WORK VALOR QUE IDENTIFICA 10KHZ
	SUBWF	    T,W			;SUBTRRAI W = T - W, SE FOR ZERO, O PERIODO É DE 5KHZ SE NÃO, TESTA PARA AS PRÓXIMAS FREQUÊNCIAS
	BTFSS	    STATUS,Z		;SE O BIT Z FOR UM, A FREQUÊNCIA É DE 10KHZ, SE NÃO PULA PARA A FREQUÊNCIA DE 20KHZ
	GOTO	    FREQ_20KHZ		;CHAMA LABEL FREQ_20KHZ
	
	BSF	    GPIO,GP1		;SETA BIT GP1 PARA ALTO
	NOP				;NOP PARA DEIXAR O SINAL DO GP1 EM NÍVEL LÓGICO ALTO POR 5 CICLOS DE INSTRUÇÃO
	NOP
	NOP
	NOP
	NOP
	BCF	    GPIO,GP1		;SETA BIT GP1 PARA BAIXO
	
	BCF	    INTCON,T0IF		;LIMPA FLAG INTERRUPÇÃO TMR0
	MOVLW	    .1			;MOVE VALOR 1 PARA O WORK
	MOVWF	    T			;MOVE DE WORK PARA T. FAZ COM QUE A FREQ 10KHZ SAI DO LOOP NA FUNÇÃO E CHAME PRÓXIMA FUNÇÃO DE FREQUÊNCIA
	GOTO	    SAI_INT		;CHAMA SAIDA INTERRUPÇÃO
	
	FREQ_20KHZ
	MOVLW	    .7			;MOVE PARA WORK VALOR QUE IDENTIFICA 20KHZ
	SUBWF	    T,W			;SUBTRRAI W = T - W, SE FOR ZERO, O PERIODO É DE 20KHZ SE NÃO, TESTA PARA AS PRÓXIMAS FREQUÊNCIAS
	BTFSS	    STATUS,Z		;SE O BIT Z FOR UM, A FREQUÊNCIA É DE 20KHZ, SE NÃO PULA PARA A FREQUÊNCIA DE 30KHZ
	GOTO	    FREQ_30KHZ		;CHAMA LABEL FREQ_30KHZ
	
	BSF	    GPIO,GP4		;SETA BIT GP4 PARA ALTO
	NOP				;NOP PARA DEIXAR O SINAL DO GP4 EM NÍVEL LÓGICO ALTO POR 5 CICLOS DE INSTRUÇÃO
	NOP
	NOP
	NOP
	NOP
	BCF	    GPIO,GP4		;SETA BIT GP4 PARA BAIXO
	
	BCF	    INTCON,T0IF		;LIMPA FLAG INTERRUPÇÃO TMR0
	MOVLW	    .1			;MOVE VALOR 1 PARA O WORK
	MOVWF	    T			;MOVE DE WORK PARA T. FAZ COM QUE A FREQ 20KHZ SAI DO LOOP NA FUNÇÃO E CHAME PRÓXIMA FUNÇÃO DE FREQUÊNCIA
	GOTO	    SAI_INT		;CHAMA SAIDA INTERRUPÇÃO

	FREQ_30KHZ
	MOVLW	    .4			;MOVE PARA WORK VALOR QUE IDENTIFICA 30KHZ
	SUBWF	    T,W			;SUBTRRAI W = T - W, SE FOR ZERO, O PERIODO É DE 30KHZ SE NÃO, TESTA PARA AS PRÓXIMAS FREQUÊNCIAS
	BTFSS	    STATUS,Z		;SE O BIT Z FOR UM, A FREQUÊNCIA É DE 30KHZ, SE NÃO PULA PARA A SAIDA DA INTERRUPÇÃO
	GOTO	    SAI_INT		;CHAMA SAIDA INTERRUPÇÃO
	
	BSF	    GPIO,GP5		;SETA BIT GP5 PARA ALTO
	NOP				;NOP PARA DEIXAR O SINAL DO GP5 EM NÍVEL LÓGICO ALTO POR 5 CICLOS DE INSTRUÇÃO
	NOP
	NOP
	NOP
	NOP
	BCF	    GPIO,GP5		;SETA BIT GP5 PARA BAIXO
	
	BCF	    INTCON,T0IF		;LIMPA FLAG INTERRUPÇÃO TMR0
	MOVLW	    .1			;MOVE VALOR 1 PARA O WORK
	MOVWF	    T			;MOVE DE WORK PARA T. FAZ COM QUE A FREQ 30KHZ SAI DO LOOP NA FUNÇÃO E CHAME PRÓXIMA FUNÇÃO DE FREQUÊNCIA
	GOTO	    SAI_INT		;CHAMA SAIDA INTERRUPÇÃO

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
	
FREQUENCIA_5KHZ
	MOVLW	    .0		;MOVE VALOR ZERO PRO WORK
	MOVWF	    TMR0	;MOVE DO WORK PRO TMR0, RESENTA CONTAGEM
	
	MOVLW	    .155	;MOVE O VALOR 155 PARA W, VALOR PARA A FREQ 5KHZ
	MOVWF	    TMR0	;MOVE DO WORK PARA O TMR0 - INICIO DA CONTAGEM
	MOVLW	    .100	;MOVE 100 PARA WORK
	MOVWF	    T		;MOVE DO WORK PARA T - VALOR PARA VERIFICAR A FREQUÊNCIA 5KHZ (255 - 155 = 100)
	
	LOOP_SINAL_FREQ_5KHZ
	DECFSZ	    T,1		;DECREMENTA 1 DE T. SE FOR ZERO, PULA E SAI DA FUNÇÃO, SE NÃO, CONTINUA PARA QUE O TMR0 ESTOURE E CHAME A INTERRUPÇÃO QUE TRATA A FREQ
	GOTO	    LOOP_SINAL_FREQ_5KHZ
	
	RETURN
	
FREQUENCIA_10KHZ
	MOVLW	    .0		;MOVE VALOR ZERO PRO WORK
	MOVWF	    TMR0	;MOVE DO WORK PRO TMR0, RESENTA CONTAGEM
	
	MOVLW	    .205	;MOVE O VALOR 205 PARA W, VALOR PARA A FREQ 10KHZ
	MOVWF	    TMR0	;MOVE DO WORK PARA O TMR0 - INICIO DA CONTAGEM
	MOVLW	    .50		;MOVE 50 PARA WORK
	MOVWF	    T		;MOVE DO WORK PARA T - VALOR PARA VERIFICAR A FREQUÊNCIA 5KHZ (255 - 205 = 50)
	
	LOOP_SINAL_FREQ_10KHZ
	DECFSZ	    T,1		;DECREMENTA 1 DE T. SE FOR ZERO, PULA E SAI DA FUNÇÃO, SE NÃO, CONTINUA PARA QUE O TMR0 ESTOURE E CHAME A INTERRUPÇÃO QUE TRATA A FREQ
	GOTO	    LOOP_SINAL_FREQ_10KHZ
	
	RETURN
	
FREQUENCIA_20KHZ
	MOVLW	    .0		;MOVE VALOR ZERO PRO WORK
	MOVWF	    TMR0	;MOVE DO WORK PRO TMR0, RESENTA CONTAGEM
	
	MOVLW	    .229	;MOVE O VALOR 229 PARA W, VALOR PARA A FREQ 20KHZ
	MOVWF	    TMR0	;MOVE DO WORK PARA O TMR0 - INICIO DA CONTAGEM
	MOVLW	    .26		;MOVE 26 PARA WORK
	MOVWF	    T		;MOVE DO WORK PARA T - VALOR PARA VERIFICAR A FREQUÊNCIA 5KHZ (255 - 229 = 26)
	
	LOOP_SINAL_FREQ_20KHZ
	DECFSZ	    T,1		;DECREMENTA 1 DE T. SE FOR ZERO, PULA E SAI DA FUNÇÃO, SE NÃO, CONTINUA PARA QUE O TMR0 ESTOURE E CHAME A INTERRUPÇÃO QUE TRATA A FREQ
	GOTO	    LOOP_SINAL_FREQ_20KHZ
	
	RETURN

FREQUENCIA_30KHZ
	MOVLW	    .0		;MOVE VALOR ZERO PRO WORK
	MOVWF	    TMR0	;MOVE DO WORK PRO TMR0, RESENTA CONTAGEM
	
	MOVLW	    .237	;MOVE O VALOR 237 PARA W, VALOR PARA A FREQ 20KHZ
	MOVWF	    TMR0	;MOVE DO WORK PARA O TMR0 - INICIO DA CONTAGEM
	MOVLW	    .18		;MOVE 18 PARA WORK
	MOVWF	    T		;MOVE DO WORK PARA T - VALOR PARA VERIFICAR A FREQUÊNCIA 5KHZ (255 - 237 = 18)
	
	LOOP_SINAL_FREQ_30KHZ
	DECFSZ	    T,1		;DECREMENTA 1 DE T. SE FOR ZERO, PULA E SAI DA FUNÇÃO, SE NÃO, CONTINUA PARA QUE O TMR0 ESTOURE E CHAME A INTERRUPÇÃO QUE TRATA A FREQ
	GOTO	    LOOP_SINAL_FREQ_30KHZ
	
	RETURN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	;GP0, GP1, GP4 E GP5 - CONFIGURADAS COMO SAÍDA - 0
	;GP2 - CONFIGURADA COMO ENTRADA - 1
	;GP3 - SEMPRE CONFIGURADA COMO ENTRADA - 1
	;PRESCALER 1:2
	
	BANK1				;ALTERA PARA O BANCO 1
	MOVLW	B'00001100'		;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO			;COMO SAÍDAS
	CLRF	ANSEL			;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'10000000'
	MOVWF	OPTION_REG		;DEFINE OPÇÕES DE OPERAÇÃO
	MOVLW	B'10100000'
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
	
	BTFSS	    GPIO,GP2		;TESTA SE GP2 É UM, SE FOR, PULA A PRÓXIMA LINHA, SE GP2 FOR ZERO, EXECUTA A PRÓXIMA LINHA
	GOTO	    RESETA_TMR0		;CHAMA RESETA_TMR0 ENQUANTO GP2 NÃO FOR ATIVADO COM SINAL
	
	CALL	    FREQUENCIA_5KHZ	;CHAMA FUNÇÃO PARA 5KHZ - GERA SINAL - 32
	CALL	    FREQUENCIA_10KHZ	;CHAMA FUNÇÃO PARA 10KHZ - GERA SINAL - 15
	CALL	    FREQUENCIA_20KHZ	;CHAMA FUNÇÃO PARA 20KHZ - GERA SINAL - 7
	CALL	    FREQUENCIA_30KHZ	;CHAMA FUNÇÃO PARA 30KHZ - GERA SINAL - 4
	
	GOTO	    MAIN

RESETA_TMR0
	MOVLW	    .0			;MOVE VALOR ZERO PARA O WORK
	MOVWF	    TMR0		;MOVE DO WORK PARA O TMR0 - RESETA CONTAGEM
	
	GOTO	    MAIN		;VOLTA PARA A MAIN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
