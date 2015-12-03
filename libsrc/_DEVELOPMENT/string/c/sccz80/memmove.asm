
; void *memmove(void *s1, const void *s2, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC memmove

EXTERN asm_memmove

memmove:

   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   push af
   
   jp asm_memmove
