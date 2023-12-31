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

		PERIODO
		T
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
	MOVWF	W_TEMP			;COPIA W PARA W_TEMP
	SWAPF	STATUS,W
	MOVWF	STATUS_TEMP		;COPIA STATUS PARA STATUS_TEMP
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    ROTINA DE INTERRUP��O                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; AQUI SER�O ESCRITAS AS ROTINAS DE RECONHECIMENTO E TRATAMENTO DAS
; INTERRUP��ES

	;TMR0 ESTOUROU - GEROU INTERRUP��O
	;VERIFICAR SE A FREQU�NCIA FOI DE 5, 10, 20 OU 30 KHZ
	
	MOVLW	    .32			;MOVE PARA WORK VALOR QUE IDENTIFICA 5KHZ
	SUBWF	    T,W			;SUBTRRAI W = T - W, SE FOR ZERO, O PERIODO � DE 5KHZ SE N�O, TESTA PARA AS PR�XIMAS FREQU�NCIAS
	BTFSS	    STATUS,Z		;SE O BIT Z FOR UM, A FREQU�NCIA � DE 5KHZ, SE N�O PULA PARA A FREQU�NCIA DE 10KHZ
	GOTO	    FREQ_10KHZ		;CHAMA LABEL FREQ_10KHZ
	
	BSF	    GPIO,GP0		;SETA BIT GP0 PARA ALTO
	NOP				;NOP PARA DEIXAR O SINAL DO GP0 EM N�VEL L�GICO ALTO POR 5 CICLOS DE INSTRU��O
	NOP
	NOP
	NOP
	NOP
	BCF	    GPIO,GP0		;SETA BIT GP0 PARA BAIXO
	
	BCF	    INTCON,T0IF		;LIMPA FLAG INTERRUP��O TMR0
	MOVLW	    .1			;MOVE VALOR 1 PARA O WORK
	MOVWF	    T			;MOVE DE WORK PARA T. FAZ COM QUE A FREQ 5KHZ SAI DO LOOP NA FUN��O E CHAME PR�XIMA FUN��O DE FREQU�NCIA
	GOTO	    SAI_INT		;CHAMA SAIDA INTERRUP��O
	
	FREQ_10KHZ
	MOVLW	    .15			;MOVE PARA WORK VALOR QUE IDENTIFICA 10KHZ
	SUBWF	    T,W			;SUBTRRAI W = T - W, SE FOR ZERO, O PERIODO � DE 5KHZ SE N�O, TESTA PARA AS PR�XIMAS FREQU�NCIAS
	BTFSS	    STATUS,Z		;SE O BIT Z FOR UM, A FREQU�NCIA � DE 10KHZ, SE N�O PULA PARA A FREQU�NCIA DE 20KHZ
	GOTO	    FREQ_20KHZ		;CHAMA LABEL FREQ_20KHZ
	
	BSF	    GPIO,GP1		;SETA BIT GP1 PARA ALTO
	NOP				;NOP PARA DEIXAR O SINAL DO GP1 EM N�VEL L�GICO ALTO POR 5 CICLOS DE INSTRU��O
	NOP
	NOP
	NOP
	NOP
	BCF	    GPIO,GP1		;SETA BIT GP1 PARA BAIXO
	
	BCF	    INTCON,T0IF		;LIMPA FLAG INTERRUP��O TMR0
	MOVLW	    .1			;MOVE VALOR 1 PARA O WORK
	MOVWF	    T			;MOVE DE WORK PARA T. FAZ COM QUE A FREQ 10KHZ SAI DO LOOP NA FUN��O E CHAME PR�XIMA FUN��O DE FREQU�NCIA
	GOTO	    SAI_INT		;CHAMA SAIDA INTERRUP��O
	
	FREQ_20KHZ
	MOVLW	    .7			;MOVE PARA WORK VALOR QUE IDENTIFICA 20KHZ
	SUBWF	    T,W			;SUBTRRAI W = T - W, SE FOR ZERO, O PERIODO � DE 20KHZ SE N�O, TESTA PARA AS PR�XIMAS FREQU�NCIAS
	BTFSS	    STATUS,Z		;SE O BIT Z FOR UM, A FREQU�NCIA � DE 20KHZ, SE N�O PULA PARA A FREQU�NCIA DE 30KHZ
	GOTO	    FREQ_30KHZ		;CHAMA LABEL FREQ_30KHZ
	
	BSF	    GPIO,GP4		;SETA BIT GP4 PARA ALTO
	NOP				;NOP PARA DEIXAR O SINAL DO GP4 EM N�VEL L�GICO ALTO POR 5 CICLOS DE INSTRU��O
	NOP
	NOP
	NOP
	NOP
	BCF	    GPIO,GP4		;SETA BIT GP4 PARA BAIXO
	
	BCF	    INTCON,T0IF		;LIMPA FLAG INTERRUP��O TMR0
	MOVLW	    .1			;MOVE VALOR 1 PARA O WORK
	MOVWF	    T			;MOVE DE WORK PARA T. FAZ COM QUE A FREQ 20KHZ SAI DO LOOP NA FUN��O E CHAME PR�XIMA FUN��O DE FREQU�NCIA
	GOTO	    SAI_INT		;CHAMA SAIDA INTERRUP��O

	FREQ_30KHZ
	MOVLW	    .4			;MOVE PARA WORK VALOR QUE IDENTIFICA 30KHZ
	SUBWF	    T,W			;SUBTRRAI W = T - W, SE FOR ZERO, O PERIODO � DE 30KHZ SE N�O, TESTA PARA AS PR�XIMAS FREQU�NCIAS
	BTFSS	    STATUS,Z		;SE O BIT Z FOR UM, A FREQU�NCIA � DE 30KHZ, SE N�O PULA PARA A SAIDA DA INTERRUP��O
	GOTO	    SAI_INT		;CHAMA SAIDA INTERRUP��O
	
	BSF	    GPIO,GP5		;SETA BIT GP5 PARA ALTO
	NOP				;NOP PARA DEIXAR O SINAL DO GP5 EM N�VEL L�GICO ALTO POR 5 CICLOS DE INSTRU��O
	NOP
	NOP
	NOP
	NOP
	BCF	    GPIO,GP5		;SETA BIT GP5 PARA BAIXO
	
	BCF	    INTCON,T0IF		;LIMPA FLAG INTERRUP��O TMR0
	MOVLW	    .1			;MOVE VALOR 1 PARA O WORK
	MOVWF	    T			;MOVE DE WORK PARA T. FAZ COM QUE A FREQ 30KHZ SAI DO LOOP NA FUN��O E CHAME PR�XIMA FUN��O DE FREQU�NCIA
	GOTO	    SAI_INT		;CHAMA SAIDA INTERRUP��O

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
	
FREQUENCIA_5KHZ
	MOVLW	    .0		;MOVE VALOR ZERO PRO WORK
	MOVWF	    TMR0	;MOVE DO WORK PRO TMR0, RESENTA CONTAGEM
	
	MOVLW	    .155	;MOVE O VALOR 155 PARA W, VALOR PARA A FREQ 5KHZ
	MOVWF	    TMR0	;MOVE DO WORK PARA O TMR0 - INICIO DA CONTAGEM
	MOVLW	    .100	;MOVE 100 PARA WORK
	MOVWF	    T		;MOVE DO WORK PARA T - VALOR PARA VERIFICAR A FREQU�NCIA 5KHZ (255 - 155 = 100)
	
	LOOP_SINAL_FREQ_5KHZ
	DECFSZ	    T,1		;DECREMENTA 1 DE T. SE FOR ZERO, PULA E SAI DA FUN��O, SE N�O, CONTINUA PARA QUE O TMR0 ESTOURE E CHAME A INTERRUP��O QUE TRATA A FREQ
	GOTO	    LOOP_SINAL_FREQ_5KHZ
	
	RETURN
	
FREQUENCIA_10KHZ
	MOVLW	    .0		;MOVE VALOR ZERO PRO WORK
	MOVWF	    TMR0	;MOVE DO WORK PRO TMR0, RESENTA CONTAGEM
	
	MOVLW	    .205	;MOVE O VALOR 205 PARA W, VALOR PARA A FREQ 10KHZ
	MOVWF	    TMR0	;MOVE DO WORK PARA O TMR0 - INICIO DA CONTAGEM
	MOVLW	    .50		;MOVE 50 PARA WORK
	MOVWF	    T		;MOVE DO WORK PARA T - VALOR PARA VERIFICAR A FREQU�NCIA 5KHZ (255 - 205 = 50)
	
	LOOP_SINAL_FREQ_10KHZ
	DECFSZ	    T,1		;DECREMENTA 1 DE T. SE FOR ZERO, PULA E SAI DA FUN��O, SE N�O, CONTINUA PARA QUE O TMR0 ESTOURE E CHAME A INTERRUP��O QUE TRATA A FREQ
	GOTO	    LOOP_SINAL_FREQ_10KHZ
	
	RETURN
	
FREQUENCIA_20KHZ
	MOVLW	    .0		;MOVE VALOR ZERO PRO WORK
	MOVWF	    TMR0	;MOVE DO WORK PRO TMR0, RESENTA CONTAGEM
	
	MOVLW	    .229	;MOVE O VALOR 229 PARA W, VALOR PARA A FREQ 20KHZ
	MOVWF	    TMR0	;MOVE DO WORK PARA O TMR0 - INICIO DA CONTAGEM
	MOVLW	    .26		;MOVE 26 PARA WORK
	MOVWF	    T		;MOVE DO WORK PARA T - VALOR PARA VERIFICAR A FREQU�NCIA 5KHZ (255 - 229 = 26)
	
	LOOP_SINAL_FREQ_20KHZ
	DECFSZ	    T,1		;DECREMENTA 1 DE T. SE FOR ZERO, PULA E SAI DA FUN��O, SE N�O, CONTINUA PARA QUE O TMR0 ESTOURE E CHAME A INTERRUP��O QUE TRATA A FREQ
	GOTO	    LOOP_SINAL_FREQ_20KHZ
	
	RETURN

FREQUENCIA_30KHZ
	MOVLW	    .0		;MOVE VALOR ZERO PRO WORK
	MOVWF	    TMR0	;MOVE DO WORK PRO TMR0, RESENTA CONTAGEM
	
	MOVLW	    .237	;MOVE O VALOR 237 PARA W, VALOR PARA A FREQ 20KHZ
	MOVWF	    TMR0	;MOVE DO WORK PARA O TMR0 - INICIO DA CONTAGEM
	MOVLW	    .18		;MOVE 18 PARA WORK
	MOVWF	    T		;MOVE DO WORK PARA T - VALOR PARA VERIFICAR A FREQU�NCIA 5KHZ (255 - 237 = 18)
	
	LOOP_SINAL_FREQ_30KHZ
	DECFSZ	    T,1		;DECREMENTA 1 DE T. SE FOR ZERO, PULA E SAI DA FUN��O, SE N�O, CONTINUA PARA QUE O TMR0 ESTOURE E CHAME A INTERRUP��O QUE TRATA A FREQ
	GOTO	    LOOP_SINAL_FREQ_30KHZ
	
	RETURN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	;GP0, GP1, GP4 E GP5 - CONFIGURADAS COMO SA�DA - 0
	;GP2 - CONFIGURADA COMO ENTRADA - 1
	;GP3 - SEMPRE CONFIGURADA COMO ENTRADA - 1
	;PRESCALER 1:2
	
	BANK1				;ALTERA PARA O BANCO 1
	MOVLW	B'00001100'		;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO			;COMO SA�DAS
	CLRF	ANSEL			;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'10000000'
	MOVWF	OPTION_REG		;DEFINE OP��ES DE OPERA��O
	MOVLW	B'10100000'
	MOVWF	INTCON			;DEFINE OP��ES DE INTERRUP��ES
	BANK0				;RETORNA PARA O BANCO
	MOVLW	B'00000111'
	MOVWF	CMCON			;DEFINE O MODO DE OPERA��O DO COMPARADOR ANAL�GICO

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZA��O DAS VARI�VEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN
	;CORPO DA ROTINA PRINCIPAL
	
	BTFSS	    GPIO,GP2		;TESTA SE GP2 � UM, SE FOR, PULA A PR�XIMA LINHA, SE GP2 FOR ZERO, EXECUTA A PR�XIMA LINHA
	GOTO	    RESETA_TMR0		;CHAMA RESETA_TMR0 ENQUANTO GP2 N�O FOR ATIVADO COM SINAL
	
	CALL	    FREQUENCIA_5KHZ	;CHAMA FUN��O PARA 5KHZ - GERA SINAL - 32
	CALL	    FREQUENCIA_10KHZ	;CHAMA FUN��O PARA 10KHZ - GERA SINAL - 15
	CALL	    FREQUENCIA_20KHZ	;CHAMA FUN��O PARA 20KHZ - GERA SINAL - 7
	CALL	    FREQUENCIA_30KHZ	;CHAMA FUN��O PARA 30KHZ - GERA SINAL - 4
	
	GOTO	    MAIN

RESETA_TMR0
	MOVLW	    .0			;MOVE VALOR ZERO PARA O WORK
	MOVWF	    TMR0		;MOVE DO WORK PARA O TMR0 - RESETA CONTAGEM
	
	GOTO	    MAIN		;VOLTA PARA A MAIN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
