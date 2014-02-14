
; unsigned int _strtou(const char *nptr, char **endptr, int base)

XLIB _strtou

LIB asm__strtou

_strtou:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   
   jp asm__strtou
