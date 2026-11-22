
; int ffsl(long i)

SECTION code_clib
SECTION code_string

PUBLIC _ffsl

EXTERN asm_ffsl

_ffsl:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_ffsl
