
; char *strnchr(const char *s, size_t n, int c)

SECTION code_clib
SECTION code_string

PUBLIC strnchr

EXTERN asm_strnchr

strnchr:

   pop af
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push af
   
   jp asm_strnchr
