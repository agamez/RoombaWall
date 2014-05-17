    LIST p=12lf1571
    #include p12lf1571.inc

    ; CONFIG1
    ; __config 0xFF84
     __CONFIG _CONFIG1, _FOSC_INTOSC & _WDTE_OFF & _PWRTE_ON & _MCLRE_OFF & _CP_OFF & _BOREN_ON & _CLKOUTEN_OFF
    ; CONFIG2
    ; __config 0xFEFF
     __CONFIG _CONFIG2, _WRT_OFF & _PLLEN_OFF & _STVREN_ON & _BORV_LO & _LPBOREN_OFF & _LVP_ON


    org 0x0000

SetUp
    ; Configure clock
    movlw B'00111011'
    banksel OSCCON
    movwf OSCCON

    ; Porta A as digital output
    banksel TRISA
    clrf TRISA

    ; Enables PWM output pin
    movlw B'11100000'
    banksel PWM3CON
    movwf PWM3CON

    ; Disable interrupts
    clrf PWM3IE

    ; Prescale 128
    movlw B'01110000'
    banksel PWM3CLKCON
    movwf PWM3CLKCON

    ; PR = 39061 = 0b1001100010010101
    movlw B'10011000'
    banksel PWM3PRH
    movwf PWM3PRH
    movlw B'10010101'
    banksel PWM3PRL
    movwf PWM3PRL

    ; DC = (39061+1)/2 = 19531 = 0b100110001001011
    movlw B'01001100'
    banksel PWM3DCH
    movwf PWM3DCH
    movlw B'01001011'
    banksel PWM3DCL
    movwf PWM3DCL

    clrf PWM3PHH
    clrf PWM3PHL

MainLoop
    goto MainLoop

    end
