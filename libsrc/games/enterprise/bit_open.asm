; $Id: bit_open.asm,v 1.4 2016-06-16 19:33:59 dom Exp $
;
; Enterprise 64/128 1 bit sound functions
;
; void bit_open();
;
; Stefano Bodrato - 2011
;

    PUBLIC     bit_open
    EXTERN     __snd_tick

.bit_open

        ld      a,@00001000	; Set D/A mode on left channel
        out     ($A7),a
        ld  a,(__snd_tick)

        ret
