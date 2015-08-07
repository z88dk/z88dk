;
;	ZX81 libraries - Stefano
;
;----------------------------------------------------------------
;
;	$Id: zx_cls.asm,v 1.8 2015-08-07 06:23:58 stefano Exp $
;
;----------------------------------------------------------------
;
; ROM mode CLS.. useful to expand collapsed display file
;
;----------------------------------------------------------------

	PUBLIC   zx_cls
	
IF FORzx80
	EXTERN    filltxt
ELSE
	EXTERN    restore81
	EXTERN    zx_topleft
ENDIF

zx_cls:
IF FORzx80
	ld	l,0
	jp	filltxt
ENDIF
IF FORzx81
	call  restore81
	call  $A2A
	jp    zx_topleft
ENDIF
IF FORlambda
	call  restore81
	call  $1C7D
	jp    zx_topleft
ENDIF
