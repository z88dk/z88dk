; char *strrstr(const char *s, const char *w)

SECTION code_clib
SECTION code_string

PUBLIC _strrstr_callee

EXTERN asm_strrstr

_strrstr_callee:

   pop af
   pop hl
   pop de
   push af
   
   jp asm_strrstr
