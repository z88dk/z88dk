; $Id: bit_open.asm,v 1.1 2011-03-18 07:12:41 stefano Exp $
;
; Enterprise 64/128 1 bit sound functions
;
; void bit_open();
;
; Stefano Bodrato - 2011
;

    XLIB     bit_open

.bit_open

        ld      a,@00001000	; Set D/A mode on left channel
        out     ($A7),a

        ret
