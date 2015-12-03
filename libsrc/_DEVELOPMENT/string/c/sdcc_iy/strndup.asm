
; char *strndup(const char *s, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC _strndup

EXTERN asm_strndup

_strndup:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   jp asm_strndup
