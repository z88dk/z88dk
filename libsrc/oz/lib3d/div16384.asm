;
;	OZ-7xx DK emulation layer for Z88DK
;	by Stefano Bodrato - Oct. 2003
;
;	int div16384(long value);
;	divide by 16384
;
; ------
; $Id: div16384.asm,v 1.1 2003-10-29 11:37:11 stefano Exp $
;

	XLIB	div16384

div16384:
        pop     bc
        pop     de
        pop     hl
        push    hl
        push    de
        push    bc

;; HLDE holds value
        sla      d
        rl      l
        rl      h
        sla      d
        rl      l
        rl      h

        ret
