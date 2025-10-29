
; void _ldivu_(ldivu_t *ld, unsigned long numer, unsigned long denom)

SECTION code_clib
SECTION code_stdlib

PUBLIC _ldivu__callee

EXTERN asm__ldivu

_ldivu__callee:

   pop af
   pop hl
   pop de
   exx
   pop hl
   pop de
   exx
   pop bc
   push af
   
   jp asm__ldivu

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC __ldivu__callee
defc __ldivu__callee = _ldivu__callee
ENDIF

