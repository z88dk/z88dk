
; void *memset(void *s, int c, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC memset_callee

EXTERN asm_memset

memset_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl
   
   jp asm_memset
