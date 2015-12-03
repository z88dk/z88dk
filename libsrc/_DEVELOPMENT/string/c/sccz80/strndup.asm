
; char *strndup(const char *s, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC strndup

EXTERN asm_strndup

strndup:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_strndup
