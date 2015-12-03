
; int strncmp(const char *s1, const char *s2, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC strncmp

EXTERN asm_strncmp

strncmp:

   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   push af
   
   jp asm_strncmp
