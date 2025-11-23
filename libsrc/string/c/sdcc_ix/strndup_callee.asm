
; char *strndup_callee(const char *s, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC _strndup_callee

EXTERN asm_strndup

_strndup_callee:

   pop af
   pop hl
   pop bc
   push af
   
   jp asm_strndup
