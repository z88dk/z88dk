;-------------------------------------------------------------------------
; Native terminal i/o functionality for micro8085_cilb
; Functions below assumes support for INTEL 8085 "undocumented" opcodes

        SECTION code_clib

        EXTERN  puartd
        EXTERN  puartc

        PUBLIC  _uart_putc

;-------------------------------------------------------------------------
; extern void uart_putc(uint8 data);
_uart_putc:
        in      a,(puartc)      ;uart status reg
        and     01H             ;tx data ready bit
        jp      z,_uart_putc    ;wait for ready
        ld      de,sp+2         ;retreive the argument
        ld      a,(de)          ;from behind return addr
        out     (puartd),a      ;write to uart
        ret
