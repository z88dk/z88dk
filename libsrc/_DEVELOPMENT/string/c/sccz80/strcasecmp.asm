
; int strcasecmp(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

PUBLIC strcasecmp

EXTERN asm_strcasecmp

strcasecmp:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_strcasecmp
