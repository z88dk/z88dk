;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
;
;	gfx functions
;
;	Videmo memory page handling
;
;
; ------
; $Id: ozswapactivedisplay.asm,v 1.1 2003-10-23 10:42:50 stefano Exp $
;

	XLIB	ozswapactivedisplay
	
	XREF	ozactivepage


ozswapactivedisplay:
        ld      hl,ozactivepage
        ld      b,(hl)
        in      a,(22h)
        ld      (hl),a
        ld      a,b
        out     (22h),a
        ret
