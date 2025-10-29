
; void *memset(void *s, int c, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC _memset

EXTERN asm_memset

_memset:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   jp asm_memset
