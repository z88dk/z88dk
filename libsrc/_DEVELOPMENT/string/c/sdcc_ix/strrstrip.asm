
; char *strrstrip(char *s)

SECTION code_clib
SECTION code_string

PUBLIC _strrstrip

EXTERN asm_strrstrip

_strrstrip:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_strrstrip
