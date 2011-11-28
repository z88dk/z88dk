;
;	ZX81 libraries - Stefano
;
;--------------------------------------------------------------
;
;	$Id: zx_cls.asm,v 1.3 2011-11-28 20:14:50 stefano Exp $
;
;----------------------------------------------------------------
;
; ROM mode CLS.. useful to expand collapsed display file
;
;----------------------------------------------------------------

	XLIB	zx_cls
	
	LIB		restore81

zx_cls:

	call	restore81
	jp	$a2a
