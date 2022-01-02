; $Id: bit_noise_callee.asm $
;
; 1 bit sound functions
;
; void bit_noise(int duration, int period);
;
    SECTION    code_clib
    PUBLIC     bit_noise_callee
    PUBLIC     _bit_noise_callee
    EXTERN      noise

    EXTERN      bit_open_di
    EXTERN      bit_close_ei

;
; Stub by Stefano Bodrato - 13/01/2021
;


.bit_noise_callee
._bit_noise_callee
    call    bit_open_di
    pop     bc
    pop     hl
    pop     de
    push    bc

    call    noise
    jp      bit_close_ei

