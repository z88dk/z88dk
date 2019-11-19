; $Id: bit_open.asm,v 1.5 2016-06-16 20:23:51 dom Exp $
;
; Enterprise 64/128 1 bit sound functions
;
; void bit_open();
;
; Stefano Bodrato - 2011
;

    SECTION code_clib
    PUBLIC     bit_open
    PUBLIC     _bit_open
    EXTERN     __snd_tick

.bit_open
._bit_open

        ld      a,@00001000	; Set D/A mode on left channel
        out     ($A7),a
        ld  a,(__snd_tick)

        ret
