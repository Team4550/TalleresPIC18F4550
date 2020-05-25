
; PIC18F4550 Configuration Bit Settings

; Assembly source line config statements

#include "p18f4550.inc"

; CONFIG1L
  CONFIG  PLLDIV = 1            ; PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly))
  CONFIG  CPUDIV = OSC1_PLL2    ; System Clock Postscaler Selection bits ([Primary Oscillator Src: /1][96 MHz PLL Src: /2])
  CONFIG  USBDIV = 1            ; USB Clock Selection bit (used in Full-Speed USB mode only; UCFG:FSEN = 1) (USB clock source comes directly from the primary oscillator block with no postscale)

; CONFIG1H
  CONFIG  FOSC = XT_XT             ; Oscillator Selection bits (HS oscillator (HS))
  CONFIG  FCMEN = OFF           ; Fail-Safe Clock Monitor Enable bit (Fail-Safe Clock Monitor disabled)
  CONFIG  IESO = OFF            ; Internal/External Oscillator Switchover bit (Oscillator Switchover mode disabled)

; CONFIG2L
  CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
  CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
  CONFIG  BORV = 3              ; Brown-out Reset Voltage bits (Minimum setting 2.05V)
  CONFIG  VREGEN = OFF          ; USB Voltage Regulator Enable bit (USB voltage regulator disabled)

; CONFIG2H
  CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
  CONFIG  WDTPS = 32768         ; Watchdog Timer Postscale Select bits (1:32768)

; CONFIG3H
  CONFIG  CCP2MX = ON           ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
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
  
CBLOCK 0X00
  VALOR
ENDC
  
  ORG	0; DIRECCION 0
  GOTO	INICIO
  ORG	0X0008; Direccion de la interrupcion
  GOTO	INT_2
  ORG	0X0018
  GOTO	INT_1
ORG	0X20  
INICIO
  CLRF	TRISD; PUERTO D -> SALIDA TRISD = 0;
  MOVLW	0XFF;	W = 0XFF
  MOVWF	TRISB;  TRISB = W -> PUERTO B ENTRADA
  MOVLW	0X0F
  MOVWF	ADCON1; TODOS PINES A DIGITALES
  BSF	INTCON3,7; INT2 -> ALTA PRIORIDAD -> 1US
  BCF	INTCON3,6; INT1 -> BAJA PRIORIDAD
  BSF	INTCON3,3; INT1 -> HABILITADA
  BSF	INTCON3,4; INT2 -> HABILITADA
  BCF	INTCON3,1
  BCF	INTCON3,0; FLAG LIMPIAMOS
  BSF	RCON,7; HABILITAMOS PRIORIDADES
  BCF	INTCON2,5
  BCF	INTCON2,4; 1 -> 0
  BSF	INTCON,7; GIEH -> ALTA PRIORIDAD
  BSF	INTCON,6; GIEL -> BAJA PRIORIDAD
START
  GOTO	START

INT_2
  BTFSS	PORTD,1; SI PORTD 1 == 1
  GOTO	ENCENDER_2
  BCF	LATD,1; LATD1 = 0
  GOTO	FIN_INT_2
ENCENDER_2
  BSF	LATD,1
FIN_INT_2
  BCF	INTCON3,1; INT2IF = 0; 
  RETFIE 
  
INT_1
  BTFSS	PORTD,2; PORTD2 == 0
  GOTO	ENCENDER_1
  BCF	LATD,2; LATD2 = 0
  GOTO	FIN_INT_1
ENCENDER_1
  BSF	LATD,2
FIN_INT_1
  BCF	INTCON3,0; INT1IF = 0; 
  RETFIE 

  
  
  
;ORG	0X20  
;INICIO
;  CLRF	TRISD; PUERTO D -> SALIDA TRISD = 0;
;  MOVLW	0XFF;	W = 0XFF
;  MOVWF	TRISB;  TRISB = W -> PUERTO B ENTRADA
;  MOVLW	0X0F
;  MOVWF	ADCON1; TODOS PINES A DIGITALES
;  BSF	INTCON,7; HABILITA INTERRUPCIONES GLOBALES
;  BSF	INTCON,6; HABILITAMOS PERIFERICOS
;  BSF	INTCON,4; HABILITAMOS INT0
;  BCF	INTCON,1; LIMPIAMOS EL FLAG 
;  BSF	INTCON2,6 
;  ;BSF = BIT DEL REGISTRO -> 1
;  ;BCF = BIT DEL REGISTRO -> 0 
;START
;  GOTO	START
;
;INT_EXT
;  BTFSS	PORTD,0; SI PORTD 0 == 1
;  GOTO	ENCENDER
;  BCF	LATD,0; LATD0 = 0
;  GOTO	FIN_INT
;ENCENDER
;  BSF	LATD,0
;FIN_INT
;  BCF	INTCON,1; INTOIF = 0; 
;  RETFIE 
  
  END
