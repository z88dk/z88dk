
; char *strnset_callee(char *s, int c, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC _strnset_callee

EXTERN asm_strnset

_strnset_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af
   
   jp asm_strnset
