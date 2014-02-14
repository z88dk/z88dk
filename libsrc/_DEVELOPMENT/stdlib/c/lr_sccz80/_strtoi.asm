
; int _strtoi(const char *nptr, char **endptr, int base)

XLIB _strtoi

LIB asm__strtoi

_strtoi:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   
   jp asm__strtoi
