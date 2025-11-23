
IF __CPU_INTEL__
INCLUDE "newlib/target/rc2014/config_rc2014-8085_private.inc"
ELIF __CPU_Z80__
INCLUDE "config_private.inc"
ENDIF

SECTION code_driver

PUBLIC _uart_interrupt

EXTERN uartaRxCount, uartaRxIn, uartaRxBuffer
EXTERN uartaControl

EXTERN uartbRxCount, uartbRxIn, uartbRxBuffer
EXTERN uartbControl

._uart_interrupt
    push af
    push hl

.uarta
    ; check the UART A channel exists
    ld a,(uartaControl)         ; load the control flag
    or a                        ; check it is non-zero
    jr Z,uartb                  ; try UART B

    ; read the LSR to check for received data
    in a,(__IO_UARTA_LSR_REGISTER)  ; get the status of the UART A data
    rrca                        ; Rx data is available
                                ; XXX To do handle line errors
    jr NC,uartb                 ; if not, go check UART B

.rxa_get
    in a,(__IO_UARTA_DATA_REGISTER) ; Get the received byte from the UART A
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

    ld a,(uartaRxCount)         ; get the current Rx count
    cp __IO_UART_RX_FULLISH     ; compare the count with the preferred full size
    jp NZ,rxa_check             ; leave the RTS low, and check for Rx/Tx possibility

    in a,(__IO_UARTA_MCR_REGISTER)  ; get the UART A MODEM Control Register
    and ~(__IO_UART_MCR_RTS|__IO_UART_MCR_DTR)  ; set RTS and DTS high
    out (__IO_UARTA_MCR_REGISTER),a ; set the MODEM Control Register

.rxa_check
    ; read the LSR to check for additional received data
    in a,(__IO_UARTA_LSR_REGISTER)  ; get the status of the UART A data
    rrca                        ; Rx data is available
    jp C,rxa_get                ; another byte received, go get it

    ; now do the same with the UART B channel, because the interrupt is shared

.uartb
    ; check the UART B channel exists
    ld a,(uartbControl)         ; load the control flag
    or a                        ; check it is non-zero
    jr Z,end

    ; read the LSR to check for received data
    in a,(__IO_UARTB_LSR_REGISTER)  ; get the status of the UART B data
    rrca                        ; Rx data is available
                                ; XXX To do handle line errors
    jr NC,end                   ; if not exit

.rxb_get
    in a,(__IO_UARTB_DATA_REGISTER) ; Get the received byte from the UART B
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

    ld a,(uartbRxCount)         ; get the current Rx count
    cp __IO_UART_RX_FULLISH     ; compare the count with the preferred full size
    jp NZ,rxb_check             ; leave the RTS low, and check for Rx/Tx possibility

    in a,(__IO_UARTB_MCR_REGISTER)  ; get the UART B MODEM Control Register
    and ~(__IO_UART_MCR_RTS|__IO_UART_MCR_DTR)  ; set RTS and DTS high
    out (__IO_UARTB_MCR_REGISTER),a ; set the MODEM Control Register

.rxb_check
    ; read the LSR to check for additional received data
    in a,(__IO_UARTB_LSR_REGISTER)  ; get the status of the UART B data
    rrca                        ; Rx data is available
    jp C,rxb_get                ; another byte received, go get it

.end
    pop hl
    pop af

    ei
    ret

EXTERN _uart_need
defc NEED = _uart_need
