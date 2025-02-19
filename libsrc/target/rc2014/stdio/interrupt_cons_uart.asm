
INCLUDE "_DEVELOPMENT/target/rc2014/config_rc2014-8085_private.inc"

SECTION code_driver

PUBLIC uart_interrupt

EXTERN uartaRxCount, uartaRxIn, uartaRxBuffer
EXTERN uartaControl

EXTERN uartbRxCount, uartbRxIn, uartbRxBuffer
EXTERN uartbControl

.uart_interrupt
    push af
    push hl

.uarta
    ; check the UART A channel exists
    ld a,(uartaControl)         ; load the control flag
    or a                        ; check it is non-zero
    jp Z,uartb                  ; try UART B

    in a,(__IO_UARTA_IIR_REGISTER)  ; get the status of the UART A
    rrca                        ; check whether an interrupt was generated
    jp C,uartb                  ; if not, go check UART B

.rxa_get
    ; read the IIR to access the relevant interrupts
    in a,(__IO_UARTA_IIR_REGISTER)  ; get the status of the UART A
    and __IO_UART_IIR_DATA      ; Rx data is available
                                ; XXX To do handle line errors
    jp Z,uartb                  ; if not, go check UART B

    in a,(__IO_UARTA_DATA_REGISTER) ; Get the received byte from the UART A
    ld l,a                      ; move Rx byte to l

    ld a,(uartaRxCount)         ; Get the number of bytes in the Rx buffer
    cp __IO_UART_RX_SIZE-1      ; check whether there is space in the buffer
    jp NC,rxa_dtr               ; buffer full, check DTR

    ld a,l                      ; get Rx byte from l
    ld hl,(uartaRxIn)           ; get the pointer to where we poke
    ld (hl),a                   ; write the Rx byte to the uartaRxIn address

    inc l                       ; move the Rx pointer low byte along
IF __IO_UART_RX_SIZE != 0x100
    ld a,__IO_UART_RX_SIZE-1    ; load the buffer size, (n^2)-1
    and l                       ; range check
    or uartaRxBuffer&0xFF       ; locate base
    ld l,a                      ; return the low byte to l
ENDIF
    ld (uartaRxIn),hl           ; write where the next byte should be poked

    ld hl,uartaRxCount
    inc (hl)                    ; atomically increment Rx buffer count

.rxa_dtr
    ld a,(uartaRxCount)         ; get the current Rx count
    sub __IO_UART_RX_FULLISH    ; compare the count with the preferred full size
    jp C,rxa_check              ; leave the DTR low, and check for Rx/Tx possibility

    in a,(__IO_UARTA_MCR_REGISTER)              ; get the UART A MODEM Control Register
    and ~(__IO_UART_MCR_RTS|__IO_UART_MCR_DTR)  ; set RTS & DTR high
    out (__IO_UARTA_MCR_REGISTER),a             ; set the MODEM Control Register

.rxa_check
    in a,(__IO_UARTA_IIR_REGISTER)  ; get the status of the UART A
    rrca                        ; check whether an interrupt remains
    jp NC,rxa_get               ; another byte received, go get it

    ; now do the same with the UART B channel, because the interrupt is shared

.uartb
    ; check the UART B channel exists
    ld a,(uartbControl)         ; load the control flag
    or a                        ; check it is non-zero
    jp Z,end

    in a,(__IO_UARTB_IIR_REGISTER)  ; get the status of the UART B
    rrca                        ; check whether an interrupt was generated
    jp C,end                    ; if not, exit interrupt

.rxb_get
    ; read the IIR to access the relevant interrupts
    in a,(__IO_UARTB_IIR_REGISTER)  ; get the status of the UART B
    and __IO_UART_IIR_DATA      ; Rx data is available
                                ; XXX To do handle line errors
    jp Z,end                    ; if not exit

    in a,(__IO_UARTB_DATA_REGISTER) ; Get the received byte from the UART B
    ld l,a                      ; move Rx byte to l

    ld a,(uartbRxCount)         ; Get the number of bytes in the Rx buffer
    cp __IO_UART_RX_SIZE-1      ; check whether there is space in the buffer
    jp NC,rxb_dtr               ; buffer full, check DTR

    ld a,l                      ; get Rx byte from l
    ld hl,(uartbRxIn)           ; get the pointer to where we poke
    ld (hl),a                   ; write the Rx byte to the uartbRxIn address

    inc l                       ; move the Rx pointer low byte along
IF __IO_UART_RX_SIZE != 0x100
    ld a,__IO_UART_RX_SIZE-1    ; load the buffer size, (n^2)-1
    and l                       ; range check
    or uartbRxBuffer&0xFF       ; locate base
    ld l,a                      ; return the low byte to l
ENDIF
    ld (uartbRxIn),hl           ; write where the next byte should be poked

    ld hl,uartbRxCount
    inc (hl)                    ; atomically increment Rx buffer count

.rxb_dtr
    ld a,(uartbRxCount)         ; get the current Rx count
    sub __IO_UART_RX_FULLISH    ; compare the count with the preferred full size
    jp C,rxb_check              ; leave the DTR low, and check for Rx/Tx possibility

    in a,(__IO_UARTB_MCR_REGISTER)              ; get the UART B MODEM Control Register
    and ~(__IO_UART_MCR_RTS|__IO_UART_MCR_DTR)  ; set RTS & DTR high
    out (__IO_UARTB_MCR_REGISTER),a             ; set the MODEM Control Register

.rxb_check
    in a,(__IO_UARTB_IIR_REGISTER)  ; get the status of the UART B
    rrca                        ; check whether an interrupt remains
    jp NC,rxb_get               ; another byte received, go get it

.end
    pop hl
    pop af

    ei
    ret

