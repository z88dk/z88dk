
; void *memset(void *s, int c, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC memset

EXTERN asm_memset

memset:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   
   jp asm_memset
