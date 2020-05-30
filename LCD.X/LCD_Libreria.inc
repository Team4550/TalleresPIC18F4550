CBLOCK
VARIABLE_CUENTA
GUARDA_DATO
CARACTER
ENDC
    
#DEFINE	    RS	LATC,0
#DEFINE	    E	LATC,1
    
LCD_Init:
    CLRF    TRISD
    BCF	    TRISC,0
    BCF	    TRISC,1
    CALL    Retardo_1ms
    BCF	    RS; MODO COMANDO
    MOVLW   0X30
    MOVWF   LATD
    CALL    ENABLE
    CALL    Retardo_1ms
    MOVLW   0X30
    MOVWF   LATD
    CALL    ENABLE
    CALL    Retardo_1ms
    MOVLW   0X30
    MOVWF   LATD
    CALL    ENABLE
    CALL    Retardo_1ms
    MOVLW   0X38
    MOVWF   LATD
    CALL    ENABLE
    MOVLW   0X0C
    MOVWF   LATD
    CALL    ENABLE
    MOVLW   0X01
    MOVWF   LATD
    CALL    ENABLE
    MOVLW   0X06
    MOVWF   LATD
    CALL    ENABLE
    RETURN
    
LCD_CARACTER:
    MOVWF   CARACTER
    BSF	    RS; CARACTER
    MOVF    CARACTER,W; CARACTER -> W
    MOVWF   LATD
    CALL    ENABLE
    RETURN
    
    
ENABLE:
    CALL    Retardo_1ms
    CALL    Retardo_1ms
    BSF	    E		    ; ENABLE
    CALL    Retardo_1ms
    BCF	    E
    Return

Retardo_1ms:
  MOVWF	    GUARDA_DATO
  MOVLW	    .249
  MOVWF	    VARIABLE_CUENTA
BUCLE_INTERNO:
  NOP
  DECFSZ    VARIABLE_CUENTA, F
  GOTO	    BUCLE_INTERNO
  MOVF	    GUARDA_DATO,W
  RETURN
