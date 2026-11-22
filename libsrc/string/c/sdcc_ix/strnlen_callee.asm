
; size_t strnlen_callee(const char *s, size_t maxlen)

SECTION code_clib
SECTION code_string

PUBLIC _strnlen_callee

EXTERN asm_strnlen

_strnlen_callee:

   pop af
   pop hl
   pop bc
   push af
   
   jp asm_strnlen
