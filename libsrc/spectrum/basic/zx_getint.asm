;
;	ZX Spectrum specific routines
;	by Stefano Bodrato, 28/06/2006
;
;	Copy a variable from basic to integer
;	Float values are rounded authomatically
;
;	int __FASTCALL__ zx_getint(char *variable);
;
;
;	$Id: zx_getint.asm,v 1.5 2016-06-10 20:02:04 dom Exp $
;	

SECTION code_clib
PUBLIC	zx_getint
PUBLIC	_zx_getint
EXTERN	zx_locatenum
EXTERN	call_rom3

INCLUDE  "zxfp.def"

; hl = char *variable

zx_getint:
_zx_getint:

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
	
	call    call_rom3
	defw	ZXFP_STK_STORE
	call    call_rom3
	defw	ZXFP_FP_TO_BC
	
	ld	h,b
	ld	l,c
	ret

error:

	ld	hl,-1
	ret
