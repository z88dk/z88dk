;
;	ZX 81 specific routines
;	by Stefano Bodrato, Oct 2007
;
;	Goes in SLOW mode
;
;	void zx_slow();
;
;
;	$Id: zx_slow.asm,v 1.4 2012-01-09 16:02:36 stefano Exp $
;	

XLIB	zx_slow
LIB	hrg_on
LIB restore81

zx_slow:
	call restore81
	jp	hrg_on

