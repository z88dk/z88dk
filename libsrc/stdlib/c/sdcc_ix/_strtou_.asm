
; unsigned int _strtou_(const char *nptr, char **endptr, int base)

SECTION code_clib
SECTION code_stdlib

PUBLIC __strtou_

EXTERN asm__strtou

__strtou_:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   jp asm__strtou
