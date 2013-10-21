; $Id: bit_open.asm,v 1.2 2013-10-21 14:23:45 stefano Exp $
;
; Enterprise 64/128 1 bit sound functions
;
; void bit_open();
;
; Stefano Bodrato - 2011
;

    XLIB     bit_open
    XREF     snd_tick

.bit_open

        ld      a,@00001000	; Set D/A mode on left channel
        out     ($A7),a
        ld  a,(snd_tick)

        ret
