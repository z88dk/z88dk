
; unsigned int _strtou__callee(const char *nptr, char **endptr, int base)

SECTION code_clib
SECTION code_stdlib

PUBLIC __strtou__callee

EXTERN asm__strtou

__strtou__callee:

   pop af
   pop hl
   pop de
   pop bc
   push af
   
   jp asm__strtou
