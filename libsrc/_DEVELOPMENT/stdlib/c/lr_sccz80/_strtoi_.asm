
; int _strtoi(const char *nptr, char **endptr, int base)

XLIB _strtoi_

LIB asm__strtoi

_strtoi_:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   
   jp asm__strtoi
