
    INCLUDE "config_private.inc"

    SECTION code_driver
    SECTION code_driver_character_input

    PUBLIC asm_asci0_getc

    EXTERN asci0RxBuffer, asci0RxCount, asci0RxOut

    asm_asci0_getc:
        ; exit     : l = char received
        ;            carry reset if Rx buffer is empty
        ;
        ; modifies : af, hl
        
        ld a,(asci0RxCount)         ; get the number of bytes in the Rx buffer
        ld l,a                      ; and put it in hl
        or a                        ; see if there are zero bytes available
        ret Z                       ; if the count is zero, then return

        cp __ASCI0_RX_EMPTYISH      ; compare the count with the preferred empty size
        jr NZ,asm_asci0_getc_cont   ; if the buffer not emptyish, don't change the RTS

        in0 a,(CNTLA0)              ; get current value of control byte A
        and ~CNTLA0_RTS0            ; clear /RTS
        out0 (CNTLA0),a             ; write it back

    asm_asci0_getc_cont:
        ld hl,asci0RxCount
        di
        dec (hl)                    ; atomically decrement Rx count
        ld hl,(asci0RxOut)          ; get the pointer to place where we pop the Rx byte
        ei
        ld a,(hl)                   ; get the Rx byte

        inc l                       ; move the Rx pointer low byte along
IF __ASCI0_RX_SIZE != 0x100
        push af
        ld a,__ASCI0_RX_SIZE-1      ; load the buffer size, (n^2)-1
        and l                       ; range check
        or asci0RxBuffer&0xFF       ; locate base
        ld l,a                      ; return the low byte to l
        pop af
ENDIF
        ld (asci0RxOut),hl          ; write where the next byte should be popped

        ld l,a                      ; put the byte in hl
        scf                         ; indicate char received
        ret

    EXTERN asm_asci0_need
    defc NEED = asm_asci0_need

