
; size_t strnlen(const char *s, size_t maxlen)

SECTION code_clib
SECTION code_string

PUBLIC strnlen

EXTERN asm_strnlen

strnlen:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_strnlen
