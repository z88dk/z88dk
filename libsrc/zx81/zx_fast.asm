;
;	ZX 81 specific routines
;	by Stefano Bodrato, Oct 2007
;
;	Goes in FAST mode
;
;	void zx_fast();
;
;
;	$Id: zx_fast.asm,v 1.1 2007-10-25 14:53:04 stefano Exp $
;	

XLIB	zx_fast
LIB	hrg_off

zx_fast:
	call	hrg_off
	jp	$F23		; FAST !
