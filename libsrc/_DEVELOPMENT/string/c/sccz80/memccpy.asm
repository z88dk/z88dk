
; void *memccpy(void * restrict s1, const void * restrict s2, int c, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC memccpy

EXTERN asm_memccpy

memccpy:

IF __CPU_INTEL__ | __CPU_GBZ80__
	ld hl,2
        add hl,sp
        ld  c,(hl)
        inc hl
        ld  b,(hl)
        inc hl
        ld  a,(hl)
        inc hl
        inc hl
        ld  e,(hl)
        inc hl
        ld  d,(hl)
        inc hl
        push de
        ld  e,(hl)
        inc hl
        ld  d,(hl)
        pop hl
ELSE
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
ENDIF

   jp asm_memccpy

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _memccpy
defc _memccpy = memccpy
ENDIF

