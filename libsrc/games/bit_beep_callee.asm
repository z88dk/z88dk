; $Id: bit_beep_callee.asm $
;
; 1 bit sound functions
;
; void bit_beep(int duration, int period);
;
        SECTION code_clib
        PUBLIC  bit_beep_callee
        PUBLIC  _bit_beep_callee
        EXTERN  beeper

        EXTERN  bit_open_di
        EXTERN  bit_close_ei

;
; Stub by Stefano Bodrato - 13/01/2021
;


bit_beep_callee:
_bit_beep_callee:
        call    bit_open_di
        pop     bc
        pop     hl
        pop     de
        push    bc

        call    beeper
        jp      bit_close_ei

