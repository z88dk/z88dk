
; void *memrchr_callee(const void *s, int c, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC _memrchr_callee, l0_memrchr_callee

EXTERN asm_memrchr

_memrchr_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af

l0_memrchr_callee:

   ld a,e
   
   jp asm_memrchr
