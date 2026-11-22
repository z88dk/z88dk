
; void _div_(div_t *d, int numer, int denom)

SECTION code_clib
SECTION code_stdlib

PUBLIC _div__callee

EXTERN asm__div

_div__callee:

   pop af
   pop de
   pop hl
   pop bc
   push af
   
   jp asm__div

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC __div__callee
defc __div__callee = _div__callee
ENDIF

