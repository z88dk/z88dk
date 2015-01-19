;
;	ZX 81 specific routines 
;	by Stefano Bodrato, 29/07/2008
;
;	Copy a variable from basic to integer
;	Float values are rounded authomatically
;
;	int __FASTCALL__ zx_getint(char *variable);
;
;
;	$Id: zx_getint.asm,v 1.3 2015-01-19 01:33:26 pauloscustodio Exp $
;	

PUBLIC	zx_getint
EXTERN	zx_locatenum

INCLUDE  "81fp.def"

; hl = char *variable

zx_getint:

	call	zx_locatenum
	jr	c,error
	
	ld	a,(hl)
	inc	hl
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	inc	hl
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
	
	call	ZXFP_STK_STORE
	call	ZXFP_FP_TO_BC
	
	ld	h,b
	ld	l,c
	ret

error:

	ld	hl,-1
	ret
