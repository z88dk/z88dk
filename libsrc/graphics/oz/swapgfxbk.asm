;
; Sharp OZ family port (graphics routines)
; Stefano Bodrato - Aug 2002
;
;       Page the graphics bank in/out - used by all gfx functions
;       Simply does a swap...
;
;
;	$Id: swapgfxbk.asm,v 1.1 2002-11-20 14:15:19 stefano Exp $
;

                XLIB    swapgfxbk
		XDEF	swapgfxbk1

		XREF	__ozactivepage

;.iysave		defw	0


.swapgfxbk
	        ld      bc,(__ozactivepage)
	        ld      a,c
	        out     (3),a
	        ld      a,b
	        out     (4),a
;	        ld	(iysave),iy
		ret

.swapgfxbk1
		ld      a,7
		out     (3),a
		ld      a,4
		out     (4),a   ;; page in proper second page
;		ld	iy,(iysave)
                ret



