
; int strcasecmp(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

PUBLIC _strcasecmp

EXTERN asm_strcasecmp

_strcasecmp:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_strcasecmp
