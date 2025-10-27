
; char *strrchr(const char *s, int c)

SECTION code_clib
SECTION code_string

PUBLIC _strrchr

EXTERN asm_strrchr

_strrchr:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   jp asm_strrchr
