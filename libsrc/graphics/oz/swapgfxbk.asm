;
; Sharp OZ family port (graphics routines)
; Stefano Bodrato - Aug 2002
;
;       Page the graphics bank in/out - used by all gfx functions
;       Simply does a swap...
;
;
;	$Id: swapgfxbk.asm,v 1.3 2015-01-19 01:32:50 pauloscustodio Exp $
;

                PUBLIC    swapgfxbk
		PUBLIC	swapgfxbk1

		EXTERN	ozactivepage

;.iysave		defw	0


.swapgfxbk
		push	bc
	        ld      bc,(ozactivepage)
	        ld      a,c
	        out     (3),a
	        ld      a,b
	        out     (4),a
	        pop	bc
;	        ld	(iysave),iy
		ret

.swapgfxbk1
		ld      a,7
		out     (3),a
		ld      a,4
		out     (4),a   ;; page in proper second page
;		ld	iy,(iysave)
                ret



