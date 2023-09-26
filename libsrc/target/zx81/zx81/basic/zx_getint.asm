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
;	$Id: zx_getint.asm $
;	

SECTION code_clib
PUBLIC	zx_getint
PUBLIC	_zx_getint
EXTERN	zx_locatenum

IF FORlambda
	INCLUDE  "target/lambda/def/lambdafp.def"
ELSE
	INCLUDE  "target/zx81/def/81fp.def"
ENDIF

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
	
IF FORlambda
	EXTERN  __lambda_stk_store
	call    __lambda_stk_store
ELSE
	call	ZXFP_STK_STORE
ENDIF

	call	ZXFP_FP_TO_BC
	
	ld	h,b
	ld	l,c
	ret

error:

	ld	hl,-1
	ret
