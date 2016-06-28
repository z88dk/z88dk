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
; $Id: ozswapactivedisplay.asm,v 1.3 2016-06-28 14:48:17 dom Exp $
;

        SECTION code_clib
	PUBLIC	ozswapactivedisplay
	PUBLIC	_ozswapactivedisplay
	
	EXTERN	ozactivepage


ozswapactivedisplay:
_ozswapactivedisplay:
        ld      hl,ozactivepage
        ld      b,(hl)
        in      a,(22h)
        ld      (hl),a
        ld      a,b
        out     (22h),a
        ret
