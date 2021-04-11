; int zx_setfloat(char *variable, int value)
; CALLER linkage for function pointers

SECTION code_clib
PUBLIC zx_setfloat
PUBLIC _zx_setfloat

EXTERN asm_zx_setfloat
EXTERN fa

.zx_setfloat
._zx_setfloat

; enter : (FA) = float value
;         hl = char *variable

	ld	hl,8
	add	hl,sp

	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a		;  var name


   jp asm_zx_setfloat

