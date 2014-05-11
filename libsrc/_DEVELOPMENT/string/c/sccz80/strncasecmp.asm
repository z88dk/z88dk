
; int strncasecmp(const char *s1, const char *s2, size_t n)

PUBLIC strncasecmp
PUBLIC strnicmp

EXTERN asm_strncasecmp

strncasecmp:
strnicmp:

   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   push af
   
   jp asm_strncasecmp
