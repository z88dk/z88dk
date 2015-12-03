
; void *memmove_callee(void *s1, const void *s2, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC _memmove_callee

EXTERN asm_memmove

_memmove_callee:

   pop af
   pop de
   pop hl
   pop bc
   push af
   
   jp asm_memmove
