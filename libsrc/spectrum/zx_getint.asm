;
;	ZX Spectrum specific routines
;	by Stefano Bodrato, 28/06/2006
;
;	Copy a variable from basic to integer
;	Float values are rounded authomatically
;
;	int zx_getint(char *variable);
;
;
;	$Id: zx_getint.asm,v 1.1 2006-06-28 22:21:26 stefano Exp $
;

	XLIB	zx_getint

	LIB	zx_locatenum
	
	INCLUDE  "#zxfp.def"


zx_getint:
	pop	bc
	pop	hl
	push	hl
	push	bc

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
