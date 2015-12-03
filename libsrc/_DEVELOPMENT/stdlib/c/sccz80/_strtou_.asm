
; unsigned int _strtou_(const char *nptr, char **endptr, int base)

SECTION code_clib
SECTION code_stdlib

PUBLIC _strtou_

EXTERN asm__strtou

_strtou_:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   
   jp asm__strtou
