; int zx_setfloat(char *variable, int value)
; CALLER linkage for function pointers

XLIB zx_setfloat

LIB zx_setfloat_callee
XREF ASMDISP_zx_setfloat_CALLEE
XREF fa

.zx_setfloat

; enter : (FA) = float value
;         hl = char *variable

	ld	hl,8
	add	hl,sp

	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a		;  var name


   jp zx_setfloat_callee + ASMDISP_zx_setfloat_CALLEE

