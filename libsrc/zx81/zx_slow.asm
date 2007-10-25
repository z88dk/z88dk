;
;	ZX 81 specific routines
;	by Stefano Bodrato, Oct 2007
;
;	Goes in SLOW mode
;
;	void zx_slow();
;
;
;	$Id: zx_slow.asm,v 1.1 2007-10-25 14:53:04 stefano Exp $
;	

XLIB	zx_slow
LIB	hrg_on

zx_slow:
	jp	hrg_on

