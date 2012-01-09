;
;	ZX 81 specific routines
;	by Stefano Bodrato, Oct 2007
;
;	Goes in FAST mode
;
;	void zx_fast();
;
;
;	$Id: zx_fast.asm,v 1.4 2012-01-09 16:02:36 stefano Exp $
;	

XLIB	zx_fast
LIB		restore81

zx_fast:
	call	restore81
;	call	hrg_off
	jp	$F23		; FAST !
