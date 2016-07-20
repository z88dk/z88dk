;
; 	ANSI Video handling for the Sharp X1
;	Karl Von Dyson (for X1s.org) - 24/10/2013
;
; 	CLS - Clear the screen
;	
;
;	$Id: f_ansi_cls.asm,v 1.6 2016-07-20 05:45:02 stefano Exp $
;

        SECTION code_clib
	PUBLIC	ansi_cls
	EXTERN	ATTR
	EXTERN	ansicolumns	

ansi_cls:
        ld bc, $3000
        ;ld hl, $200F	; ' ' char and attribute
        ld	a,ansicolumns
        ld	d, $20
clr2:
        ld	e,a
		push af
clr1:   set 4, b
		ld	a,32
        out (c), a
        res 4, b
        ld	a,(ATTR+1)
        out (c), a
        inc bc
        dec e
        jp nz, clr1
        pop	af
        dec d 
        jp nz, clr2

        ret
