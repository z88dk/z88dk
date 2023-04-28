; $Id: bit_open.asm $
;
; Sanyo MBC-200 - 1 bit sound functions
;
; void bit_open();
;
; Stefano Bodrato - 2023
;

    SECTION code_clib
    PUBLIC     bit_open
    PUBLIC    _bit_open
    EXTERN     __snd_tick

.bit_open
._bit_open

        ld   a,($E9)
        and  $FD
        ld   (__snd_tick),a
        ret
