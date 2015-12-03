
; int memcmp(const void *s1, const void *s2, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC memcmp

EXTERN asm_memcmp

memcmp:

   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   push af
   
   jp asm_memcmp
