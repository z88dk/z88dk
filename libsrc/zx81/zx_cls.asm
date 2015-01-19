;
;	ZX81 libraries - Stefano
;
;----------------------------------------------------------------
;
;	$Id: zx_cls.asm,v 1.7 2015-01-19 01:33:26 pauloscustodio Exp $
;
;----------------------------------------------------------------
;
; ROM mode CLS.. useful to expand collapsed display file
;
;----------------------------------------------------------------

	PUBLIC   zx_cls
	
IF FORzx81
	EXTERN	   restore81
	EXTERN    zx_topleft
ELSE
	EXTERN    filltxt
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
