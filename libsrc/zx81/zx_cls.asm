;
;	ZX81 libraries - Stefano
;
;----------------------------------------------------------------
;
;	$Id: zx_cls.asm,v 1.6 2012-12-31 10:38:24 stefano Exp $
;
;----------------------------------------------------------------
;
; ROM mode CLS.. useful to expand collapsed display file
;
;----------------------------------------------------------------

	XLIB   zx_cls
	
IF FORzx81
	LIB	   restore81
	LIB    zx_topleft
ELSE
	LIB    filltxt
ENDIF

zx_cls:
IF FORzx81
	call  restore81
	call  $a2a
	jp    zx_topleft
ELSE
	ld	l,0
	jp	filltxt
ENDIF
