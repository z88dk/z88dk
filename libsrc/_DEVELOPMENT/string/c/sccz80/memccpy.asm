
; void *memccpy(void * restrict s1, const void * restrict s2, int c, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC memccpy

EXTERN asm_memccpy

memccpy:

   pop ix
	pop bc
	pop de
	ld a,e
	pop hl
	pop de
	
	push de
	push hl
	push de
	push bc
	push ix

   jp asm_memccpy

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _memccpy
defc _memccpy = memccpy
ENDIF

