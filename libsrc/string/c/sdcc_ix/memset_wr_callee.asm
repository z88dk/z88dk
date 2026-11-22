
; void *memset_wr_callee(void *s, int c, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC _memset_wr_callee

EXTERN asm_memset_wr

_memset_wr_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af
   
   jp asm_memset_wr
