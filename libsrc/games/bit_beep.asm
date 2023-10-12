; $Id: bit_beep.asm $
;
; 1 bit sound functions
;
; void bit_beep(int duration, int period);
;
        SECTION code_clib
        PUBLIC  bit_beep
        PUBLIC  _bit_beep
        EXTERN  beeper

        EXTERN  bit_open_di
        EXTERN  bit_close_ei

;
; Stub by Stefano Bodrato - 8/10/2001
;


bit_beep:
_bit_beep:
        call    bit_open_di
        pop     bc
        pop     hl
        pop     de
        push    de
        push    hl
        push    bc

        call    beeper
        jp      bit_close_ei
