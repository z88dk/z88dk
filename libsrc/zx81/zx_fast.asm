;
;	ZX 81 specific routines
;	by Stefano Bodrato, Oct 2007
;
;	Goes in FAST mode
;
;	void zx_fast();
;
;
;	$Id: zx_fast.asm,v 1.2 2011-10-28 06:09:05 stefano Exp $
;	

XLIB	zx_fast

zx_fast:
		out ($fd),a  ; nmi off
		ret

;	call	hrg_off
;	jp	$F23		; FAST !
