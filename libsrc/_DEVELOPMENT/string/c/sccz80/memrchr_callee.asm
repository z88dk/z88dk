
; void *memrchr(const void *s, int c, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC memrchr_callee, l0_memrchr_callee

EXTERN asm_memrchr

memrchr_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl

l0_memrchr_callee:

   ld a,e
   
   jp asm_memrchr
