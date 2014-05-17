    LIST p=12lf1571
    #include p12lf1571.inc

    ; CONFIG1
    ; __config 0xFF84
     __CONFIG _CONFIG1, _FOSC_INTOSC & _WDTE_OFF & _PWRTE_ON & _MCLRE_OFF & _CP_OFF & _BOREN_ON & _CLKOUTEN_OFF
    ; CONFIG2
    ; __config 0xFEFF
     __CONFIG _CONFIG2, _WRT_OFF & _PLLEN_OFF & _STVREN_ON & _BORV_LO & _LPBOREN_OFF & _LVP_ON


    org 0x0000
    goto SetUp

    cblock 0x20
        delayCounter
    endc

#define CMD_WALL B'10100010'

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
    movlw B'00000000'
    banksel PWM3CLKCON
    movwf PWM3CLKCON

    ; PR = 12 = - 12
    movlw B'00000000'
    banksel PWM3PRH
    movwf PWM3PRH
    movlw D'12'
    banksel PWM3PRL
    movwf PWM3PRL

    ; DC = 6 = - 6
    movlw B'00000000'
    banksel PWM3DCH
    movwf PWM3DCH
    movlw D'6'
    banksel PWM3DCL
    movwf PWM3DCL

    clrf PWM3PHH
    clrf PWM3PHL

MainLoop
    ; This is everything but scalable:
    bcf PORTA, 4
    call delay3ms
    bsf PORTA, 4
    call delay1ms

    bcf PORTA, 4
    call delay1ms
    bsf PORTA, 4
    call delay3ms

    bcf PORTA, 4
    call delay3ms
    bsf PORTA, 4
    call delay1ms

    bcf PORTA, 4
    call delay1ms
    bsf PORTA, 4
    call delay3ms

    bcf PORTA, 4
    call delay1ms
    bsf PORTA, 4
    call delay3ms

    bcf PORTA, 4
    call delay1ms
    bsf PORTA, 4
    call delay3ms

    bcf PORTA, 4
    call delay3ms
    bsf PORTA, 4
    call delay1ms

    bcf PORTA, 4
    call delay1ms
    bsf PORTA, 4
    call delay3ms

    goto MainLoop



; 6 cycles of fixed delay plus delayCounter*3
; Must be 500 cycles.
; 500-6 = 494
; 494/3=164.666...
; So, instead of that, we can do:
; If delayCounter=164:
; 164*3 = 492
; Plus 6 fixed cycles, 498.
; I only need to place now 2 extra cycles
delay1ms                    ; 2
    goto $+1                ; 2 These are the two extra cycles above
    movlw D'164'            ; 1
    movwf delayCounter      ; 1

delay1msLoop
    decfsz delayCounter, f  ; 1*delayCounter
    goto delay1msLoop       ; 2*delayCounter
    return                  ; 2

delay3ms
    call delay1ms
    call delay1ms
    call delay1ms
    return

    end
