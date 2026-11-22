
; int _strtoi(const char *nptr, char **endptr, int base)

SECTION code_clib
SECTION code_stdlib

PUBLIC _strtoi_

EXTERN asm__strtoi

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

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC __strtoi_
defc __strtoi_ = _strtoi_
ENDIF

