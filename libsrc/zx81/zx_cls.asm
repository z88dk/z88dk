;
;	ZX81 libraries - Stefano
;
;----------------------------------------------------------------
;
;	$Id: zx_cls.asm,v 1.5 2012-01-09 16:02:36 stefano Exp $
;
;----------------------------------------------------------------
;
; ROM mode CLS.. useful to expand collapsed display file
;
;----------------------------------------------------------------

	XLIB   zx_cls
	
	LIB	   restore81
	LIB    zx_topleft

zx_cls:

	call  restore81
	call  $a2a
	jp    zx_topleft

