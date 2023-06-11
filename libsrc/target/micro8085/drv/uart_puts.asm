;-------------------------------------------------------------------------
; Native terminal i/o functionality for micro8085_cilb
; Functions below assumes support for INTEL 8085 "undocumented" opcodes

        SECTION code_clib

        EXTERN  puartd
        EXTERN  puartc

        PUBLIC  _uart_puts

;-------------------------------------------------------------------------
; extern void uart_puts(uint8 *pData);
_uart_puts:
        ld      de,sp+2         ;retreive the argument (ptr)
        ld      hl,(de)         ;from behind the ret addr
puts1:  ld      a,(hl)          ;get next char in string
        or      a               ;test if zero
        ret     z               ;quit on null
        ld      b,a             ;temporary storage
puts2:  in      a,(puartc)      ;uart status reg
        and     01H             ;tx data ready bit
        jp      z,puts2         ;wait for ready
        ld      a,b             ;get char back
        out     (puartd),a      ;uart data reg
        inc     hl              ;bump pointer
        jp      puts1

