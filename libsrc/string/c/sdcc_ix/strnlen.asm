
; size_t strnlen(const char *s, size_t maxlen)

SECTION code_clib
SECTION code_string

PUBLIC _strnlen

EXTERN asm_strnlen

_strnlen:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   jp asm_strnlen
