;
;	ZX 81 specific routines
;	by Stefano Bodrato, Oct 2007
;
;	Goes in SLOW mode
;
;	void zx_slow();
;
;
;	$Id: zx_slow.asm,v 1.2 2011-10-28 06:09:05 stefano Exp $
;	

XLIB	zx_slow
LIB	hrg_on
LIB restore81

zx_slow:
	call restore81
	out ($fe),a  ; nmi on
	jp	hrg_on

