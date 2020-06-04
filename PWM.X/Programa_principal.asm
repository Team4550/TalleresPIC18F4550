; PIC18F4550 Configuration Bit Settings

; Assembly source line config statements

#include "p18f4550.inc"

; CONFIG1L
  CONFIG  PLLDIV = 1            ; PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly))
  CONFIG  CPUDIV = OSC1_PLL2    ; System Clock Postscaler Selection bits ([Primary Oscillator Src: /1][96 MHz PLL Src: /2])
  CONFIG  USBDIV = 1            ; USB Clock Selection bit (used in Full-Speed USB mode only; UCFG:FSEN = 1) (USB clock source comes directly from the primary oscillator block with no postscale)

; CONFIG1H
  CONFIG  FOSC = HS         ; Oscillator Selection bits (XT oscillator (XT))
  CONFIG  FCMEN = OFF           ; Fail-Safe Clock Monitor Enable bit (Fail-Safe Clock Monitor disabled)
  CONFIG  IESO = OFF            ; Internal/External Oscillator Switchover bit (Oscillator Switchover mode disabled)

; CONFIG2L
  CONFIG  PWRT = OFF            ; Power-up Timer Enable bit (PWRT disabled)
  CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
  CONFIG  BORV = 3              ; Brown-out Reset Voltage bits (Minimum setting 2.05V)
  CONFIG  VREGEN = OFF          ; USB Voltage Regulator Enable bit (USB voltage regulator disabled)

; CONFIG2H
  CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
  CONFIG  WDTPS = 32768         ; Watchdog Timer Postscale Select bits (1:32768)

; CONFIG3H
  CONFIG  CCP2MX = OFF          ; CCP2 MUX bit (CCP2 input/output is multiplexed with RB3)
  CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
  CONFIG  LPT1OSC = OFF         ; Low-Power Timer 1 Oscillator Enable bit (Timer1 configured for higher power operation)
  CONFIG  MCLRE = ON            ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)

; CONFIG4L
  CONFIG  STVREN = OFF          ; Stack Full/Underflow Reset Enable bit (Stack full/underflow will not cause Reset)
  CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
  CONFIG  ICPRT = OFF           ; Dedicated In-Circuit Debug/Programming Port (ICPORT) Enable bit (ICPORT disabled)
  CONFIG  XINST = OFF           ; Extended Instruction Set Enable bit (Instruction set extension and Indexed Addressing mode disabled (Legacy mode))

; CONFIG5L
  CONFIG  CP0 = OFF             ; Code Protection bit (Block 0 (000800-001FFFh) is not code-protected)
  CONFIG  CP1 = OFF             ; Code Protection bit (Block 1 (002000-003FFFh) is not code-protected)
  CONFIG  CP2 = OFF             ; Code Protection bit (Block 2 (004000-005FFFh) is not code-protected)
  CONFIG  CP3 = OFF             ; Code Protection bit (Block 3 (006000-007FFFh) is not code-protected)

; CONFIG5H
  CONFIG  CPB = OFF             ; Boot Block Code Protection bit (Boot block (000000-0007FFh) is not code-protected)
  CONFIG  CPD = OFF             ; Data EEPROM Code Protection bit (Data EEPROM is not code-protected)

; CONFIG6L
  CONFIG  WRT0 = OFF            ; Write Protection bit (Block 0 (000800-001FFFh) is not write-protected)
  CONFIG  WRT1 = OFF            ; Write Protection bit (Block 1 (002000-003FFFh) is not write-protected)
  CONFIG  WRT2 = OFF            ; Write Protection bit (Block 2 (004000-005FFFh) is not write-protected)
  CONFIG  WRT3 = OFF            ; Write Protection bit (Block 3 (006000-007FFFh) is not write-protected)

; CONFIG6H
  CONFIG  WRTC = OFF            ; Configuration Register Write Protection bit (Configuration registers (300000-3000FFh) are not write-protected)
  CONFIG  WRTB = OFF            ; Boot Block Write Protection bit (Boot block (000000-0007FFh) is not write-protected)
  CONFIG  WRTD = OFF            ; Data EEPROM Write Protection bit (Data EEPROM is not write-protected)

; CONFIG7L
  CONFIG  EBTR0 = OFF           ; Table Read Protection bit (Block 0 (000800-001FFFh) is not protected from table reads executed in other blocks)
  CONFIG  EBTR1 = OFF           ; Table Read Protection bit (Block 1 (002000-003FFFh) is not protected from table reads executed in other blocks)
  CONFIG  EBTR2 = OFF           ; Table Read Protection bit (Block 2 (004000-005FFFh) is not protected from table reads executed in other blocks)
  CONFIG  EBTR3 = OFF           ; Table Read Protection bit (Block 3 (006000-007FFFh) is not protected from table reads executed in other blocks)

; CONFIG7H
  CONFIG  EBTRB = OFF           ; Boot Block Table Read Protection bit (Boot block (000000-0007FFh) is not protected from table reads executed in other blocks)
  
  CBLOCK 0X20
  CUENTA
  VALOR
  AUMENTO
  DECREMENTO
  VALOR_DECRE
  R_ContB
  R_ContA
  ENDC
  
	ORG 0
	GOTO	INICIO
	ORG	0X0008
	RETFIE
	ORG	0X0020
INICIO
	MOVLW	B'00000001'
	MOVWF	AUMENTO
	MOVLW	B'00000010'
	MOVWF	DECREMENTO
	MOVLW	B'000011111'
	MOVWF	VALOR
	MOVLW	B'00000000'
	MOVWF	VALOR_DECRE
	BSF	TRISD,1; ENTRADA 
	BSF	TRISD,0; ENTRADA
	MOVLW	.30
	MOVWF	PR2; PERIODO
	MOVLW	B'00000000'
	;MOVLW	B'00011111';00011111 01
	MOVWF	CCPR1L; DUTY CYCLE
	BCF	TRISC,2; SALIDA CCP1
	BCF	CCP1CON,4
	BSF	CCP1CON,5 
	BSF	T2CON,2; TMR2 ON
	BSF	T2CON,1; PRESCALER 16
	BSF	T2CON,0
	BSF	CCP1CON,3; MODO PWM
	BSF	CCP1CON,2
	BCF	CCP1CON,1
	BCF	CCP1CON,0
	BCF	LATC,2
START
	MOVF	PORTD,W; PUERTO D -> W
	ANDLW	B'00000001'; W AND
	CPFSEQ	AUMENTO
	GOTO	DECRE
	GOTO	AUMEN
DECRE:
	MOVF	PORTD,W
	ANDLW	B'00000010'
	CPFSEQ	DECREMENTO
	GOTO	NINGUNO
	DECF	CUENTA,F
	MOVF	CUENTA,W
	CPFSEQ	VALOR_DECRE
	GOTO	MUESTRO
	MOVLW	.1
	MOVWF	CUENTA
	GOTO	MUESTRO
	
NINGUNO:
	GOTO	START
AUMEN:	
	INCF	CUENTA,F
	MOVF	CUENTA,W
	CPFSEQ  VALOR; ¿VALOR == CUENTA?
	GOTO	MUESTRO
	MOVLW	B'00011110'
	MOVWF	CUENTA
MUESTRO	
	CALL	Retardo_100ms
	MOVF	CUENTA,W
	MOVWF	CCPR1L
	CALL	Retardo_100ms
	GOTO	START
	
Retardo_100ms				
	movlw	d'100'			
	goto	Retardos_ms		
Retardo_1ms				
	movlw	d'1'		
Retardos_ms
	movwf	R_ContB			
R1ms_BucleExterno
	movlw	d'249'			
	movwf	R_ContA			
R1ms_BucleInterno
	nop				
	decfsz	R_ContA,F		
	goto	R1ms_BucleInterno	
	decfsz	R_ContB,F		
	goto	R1ms_BucleExterno 	
	return				 		
	END