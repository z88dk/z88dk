; $Id: bit_noise.asm $
;
; 1 bit sound functions
;
; void bit_noise(int duration, int period);
;
        SECTION code_clib
        PUBLIC  bit_noise
        PUBLIC  _bit_noise
        EXTERN  noise

        EXTERN  bit_open_di
        EXTERN  bit_close_ei

;
; Stub by Stefano Bodrato - 8/10/2001
;


bit_noise:
_bit_noise:
        call    bit_open_di
        pop     bc
        pop     hl
        pop     de
        push    de
        push    hl
        push    bc

        call    noise
        jp      bit_close_ei
