
; int strcasecmp(const char *s1, const char *s2)

PUBLIC strcasecmp
PUBLIC stricmp

EXTERN asm_strcasecmp

strcasecmp:
stricmp:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_strcasecmp
