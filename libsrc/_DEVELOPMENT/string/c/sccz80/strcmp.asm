
; int strcmp(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

PUBLIC strcmp

EXTERN asm_strcmp

strcmp:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_strcmp
