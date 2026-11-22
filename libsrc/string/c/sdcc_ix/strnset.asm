
; char *strnset(char *s, int c, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC _strnset

EXTERN asm_strnset

_strnset:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   jp asm_strnset
