;
;       Page the graphics bank in/out - used by all gfx functions
;       (Doesn't really page on the Amstrad CPC.
;
;
;	$Id: swapgfxbk.asm,v 1.2 2001-06-18 10:46:31 stefano Exp $
;

                XLIB    swapgfxbk

		XDEF	swapgfxbk1

;.asave	defb	0

.swapgfxbk
;		ex	af,af
;		ld	(asave),a
;		ex	af,af
;		ret

.swapgfxbk1
;		ex	af,af
;		ld	a,(asave)
;		ex	af,af
                ret
