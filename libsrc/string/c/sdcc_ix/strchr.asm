
; char *strchr(const char *s, int c)

SECTION code_clib
SECTION code_string

PUBLIC _strchr

EXTERN asm_strchr

_strchr:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af

   jp asm_strchr
