
; int strcmp(const char *s1, const char *s2)

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
