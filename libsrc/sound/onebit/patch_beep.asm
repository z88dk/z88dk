; $Id: patch_beep.asm $
;
; 1 bit sound functions
;
; void patch_beep(int duration, int period, void *pattern);
;


IF !__CPU_GBZ80__ && !__CPU_INTEL__
    SECTION    code_clib
    PUBLIC     patch_beep
    PUBLIC     _patch_beep
    EXTERN      patch_beeper

    EXTERN      bit_open_di
    EXTERN      bit_close_ei

;
; Stub by Stefano Bodrato - Jan/2021
;


.patch_beep
._patch_beep
    call    bit_open_di
    pop     af
    pop     bc
    pop     hl
    pop     de
    push    de
    push    hl
    push    bc
    push    af
    call    patch_beeper
    jp      bit_close_ei
ENDIF