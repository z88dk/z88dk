; void vtrendition(attribute)
; 09.2017 stefano

SECTION code_clib
PUBLIC vtrendition
PUBLIC _vtrendition

EXTERN ansi_attr

.vtrendition
._vtrendition

	ld	a,l
	jp	ansi_attr
