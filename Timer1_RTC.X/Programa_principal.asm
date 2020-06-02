; PIC18F4550 Configuration Bit Settings

; Assembly source line config statements

#include "p18f4550.inc"

; CONFIG1L
  CONFIG  PLLDIV = 1            ; PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly))
  CONFIG  CPUDIV = OSC1_PLL2    ; System Clock Postscaler Selection bits ([Primary Oscillator Src: /1][96 MHz PLL Src: /2])
  CONFIG  USBDIV = 1            ; USB Clock Selection bit (used in Full-Speed USB mode only; UCFG:FSEN = 1) (USB clock source comes directly from the primary oscillator block with no postscale)

; CONFIG1H
  CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
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
  SEG
  SEG_D
  VALOR
  ENDC
  
	ORG 0
	GOTO	INICIO
	ORG	0X0008
	GOTO	INT_T1RTC
	ORG	0X0020
INICIO
	MOVLW	.5
	MOVWF	SEG_D
	MOVLW	.2
	MOVWF	SEG
;	CLRF	SEG
;	CLRF	VALOR
;	CLRF	SEG_D
	MOVLW	0X0F
	MOVWF	ADCON1; DIGITALES
	BCF	TRISB,0; SALIDA
	CALL	LCD_INIT
	MOVLW	.1
	CALL	LCD_LINEA1
	MOVLW	'H'; ASCII
	CALL	LCD_CARACTER
	MOVLW	'O'
	CALL	LCD_CARACTER
	MOVLW	'R'
	CALL	LCD_CARACTER
	MOVLW	'A'
	CALL	LCD_CARACTER
	MOVLW	':'
	CALL	LCD_CARACTER
	CALL	TIMER1_RTC
	MOVLW	.7
	CALL	LCD_LINEA1
	MOVLW	'0'
	CALL	LCD_CARACTER
	MOVLW	'0'
	CALL	LCD_CARACTER
START
	GOTO	START
	
TIMER1_RTC
	MOVLW	0X80
	MOVWF	TMR1H
	CLRF	TMR1L
	MOVLW	B'00001111'
	MOVWF	T1CON; 
	BSF	INTCON,GIE
	BSF	INTCON,PEIE
	BSF	PIE1,TMR1IE; HABILITAR
	BCF	PIR1,TMR1IF; FLAG
	BSF	IPR1,TMR1IP; PRIORIDAD ALTA
	BSF	RCON,7; 
	RETURN
	
INT_T1RTC
	BTFSC	TMR1L,0
	GOTO	$-2
	BTFSS	TMR1L,0
	GOTO	$-2
	BSF	TMR1H,7; 1000
	MOVLW	.8
	CALL	LCD_LINEA1
	INCF	SEG,F
	MOVLW	.10
	CPFSEQ	SEG
	GOTO	MUESTRO
	CLRF	SEG
	INCF	SEG_D,F
	MOVLW	.6
	CPFSEQ	SEG_D
	GOTO	MUESTRO
	CLRF	SEG_D
MUESTRO
	MOVLW	.8
	CALL	LCD_LINEA1
	MOVF	SEG,W
	ADDLW	'0'
	CALL	LCD_CARACTER
	MOVLW	.7
	CALL	LCD_LINEA1
	MOVF	SEG_D,W
	ADDLW	'0'
	CALL	LCD_CARACTER
	BTFSS	LATB,0
	GOTO	ENCENDER
	BCF	LATB,0
	GOTO	FIN_INT
ENCENDER
	BSF	LATB,0
FIN_INT
	BCF	PIR1,TMR1IF; FLAG
	RETFIE
	
#INCLUDE <LCD.INC>	
	END