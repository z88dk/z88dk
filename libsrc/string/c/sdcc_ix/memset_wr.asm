
; void *memset_wr(void *s, int c, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC _memset_wr

EXTERN asm_memset_wr

_memset_wr:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   jp asm_memset_wr
