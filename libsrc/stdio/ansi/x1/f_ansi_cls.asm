;
; 	ANSI Video handling for the Sharp X1
;	Karl Von Dyson (for X1s.org) - 24/10/2013
;
; 	CLS - Clear the screen
;	
;
;	$Id: f_ansi_cls.asm,v 1.2 2013-11-06 09:40:35 stefano Exp $
;

	XLIB	ansi_cls
	XREF	ATTR

ansi_cls:
        ld bc, $3000
        ;ld hl, $200F	; ' ' char and attribute
        ld de, $2028
clr1:   set 4, b
		ld	a,32
        out (c), a
        res 4, b
        ld	a,(ATTR+1)
        out (c), a
        inc bc
        dec e
        jp nz, clr1
        ld e, 40
        dec d 
        jp nz, clr1

        ret
