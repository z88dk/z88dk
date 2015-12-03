
; char *strlwr(char *s)

SECTION code_clib
SECTION code_string

PUBLIC _strlwr

EXTERN asm_strlwr

_strlwr:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_strlwr
