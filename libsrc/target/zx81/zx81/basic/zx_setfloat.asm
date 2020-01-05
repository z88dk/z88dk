; int zx_setfloat(char *variable, int value)
; CALLER linkage for function pointers

SECTION code_clib
PUBLIC zx_setfloat
PUBLIC _zx_setfloat

EXTERN zx_setfloat_callee
EXTERN ASMDISP_zx_setfloat_CALLEE
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


   jp zx_setfloat_callee + ASMDISP_zx_setfloat_CALLEE

