
; size_t strlen(const char *s)

SECTION code_clib
SECTION code_string

PUBLIC _strlen

EXTERN asm_strlen

_strlen:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_strlen
