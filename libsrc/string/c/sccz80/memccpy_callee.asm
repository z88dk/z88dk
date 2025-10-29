
; void *memccpy(void * restrict s1, const void * restrict s2, int c, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC memccpy_callee

EXTERN asm_memccpy

memccpy_callee:
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
   inc hl
   pop hl
   call asm_memccpy
 IF __CPU_GBZ80__
   ld d,h
   ld e,l
 ENDIF
   pop bc ; return value
   pop af ;dump arg
   pop af ;dump arg
   pop af ;dump arg
   pop af ;dump arg
   push bc
   ret
ELSE
   pop ix
   pop bc
   pop de
   ld a,e
   pop hl
   pop de
   push ix

   jp asm_memccpy
ENDIF

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _memccpy_callee
defc _memccpy_callee = memccpy_callee
ENDIF


; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___memccpy_callee
defc ___memccpy_callee = memccpy_callee
ENDIF

