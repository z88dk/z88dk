
; void *memccpy(void * restrict s1, const void * restrict s2, int c, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC memccpy

EXTERN asm_memccpy

memccpy:

IF __CPU_INTEL__ | __CPU_GBZ80__
   ld hl,sp+2
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

IF __CLASSIC && __CPU_GBZ80__
   call asm_memccpy
   ld d,h
   ld e,l
   ret
ELSE
   jp asm_memccpy
ENDIF

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _memccpy
defc _memccpy = memccpy
ENDIF


; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___memccpy
defc ___memccpy = memccpy
ENDIF

