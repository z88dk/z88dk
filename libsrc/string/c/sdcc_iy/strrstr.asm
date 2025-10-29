; char *strrstr(const char *s, const char *w)

SECTION code_clib
SECTION code_string

PUBLIC _strrstr

EXTERN asm_strrstr

_strrstr:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_strrstr
