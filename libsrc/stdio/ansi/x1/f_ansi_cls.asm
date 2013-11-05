;
; 	ANSI Video handling for the Sharp X1
;	Karl Von Dyson (for X1s.org) - 24/10/2013
;
; 	CLS - Clear the screen
;	
;
;	$Id: f_ansi_cls.asm,v 1.1 2013-11-05 16:02:43 stefano Exp $
;

	XLIB	ansi_cls

ansi_cls:
        ld bc, $3000
        ld hl, $2007
        ld de, $2028
clr1:   set 4, b
        out (c), h
        res 4, b
        out (c), l
        inc bc
        dec e
        jp nz, clr1
        ld e, 40
        dec d 
        jp nz, clr1

        ret
