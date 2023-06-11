;-------------------------------------------------------------------------
; Native terminal i/o functionality for micro8085_cilb
; Functions below assumes support for INTEL 8085 "undocumented" opcodes

        SECTION code_clib

        EXTERN  puartd
        EXTERN  puartc

        PUBLIC  _uart_txput

;-------------------------------------------------------------------------
; extern void uart_txput(uint8 *pData, uint16 len);
_uart_txput:
        ld      de,sp+2         ;get arguments from stack
        ld      hl,(de)         ;last pushed is length
        ld      b,h             ;copy to bc
        ld      c,l             ;as loop counter
        inc     de              ;get to first
        inc     de              ;argument position
        ld      hl,(de)         ;first pushed is ptr
txbuf1: dec     bc              ;pre decr to use k flag
        jp      k,txbuf3        ;k true when done
txbuf2: in      a,(puartc)      ;uart status reg
        and     01H             ;tx data ready bit
        jp      z,txbuf2        ;wait for ready
        ld      a,(hl)          ;get next char in buf
        out     (puartd),a      ;uart data reg
        inc     hl              ;bump pointer
        jp      txbuf1
txbuf3: ret
