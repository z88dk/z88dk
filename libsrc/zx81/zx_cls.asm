;
;	ZX81 libraries - Stefano
;
;----------------------------------------------------------------
;
;	$Id: zx_cls.asm,v 1.4 2011-12-01 17:46:45 stefano Exp $
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

